module "metadata" {
  source = "git::https://github.com/Wills287/terraform-modules//aws/general/metadata?ref=v0.0.5"

  enabled = var.enabled
  namespace = var.namespace
  environment = var.environment
  name = var.name
  service = var.service
  delimiter = var.delimiter
  attributes = var.attributes
  tags = var.tags
}

locals {
  tags = merge(
  var.tags,
  {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  },
  {
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
  },
  {
    "k8s.io/cluster-autoscaler/enabled" = var.enable_cluster_autoscaler
  }
  )
}

data "aws_iam_policy_document" "assume_role" {
  count = var.enabled ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "amazon_eks_worker_node_autoscaler_policy" {
  count = (var.enabled && var.enable_cluster_autoscaler) ? 1 : 0
  statement {
    sid = "AllowToScaleEKSNodeGroupAutoScalingGroup"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "amazon_eks_worker_node_autoscaler_policy" {
  count = (var.enabled && var.enable_cluster_autoscaler) ? 1 : 0
  name = "${module.metadata.id}-autoscaler"
  path = "/"
  policy = join("", data.aws_iam_policy_document.amazon_eks_worker_node_autoscaler_policy.*.json)
}

resource "aws_iam_role" "default" {
  count = var.enabled ? 1 : 0
  name = module.metadata.id
  assume_role_policy = join("", data.aws_iam_policy_document.assume_role.*.json)
  tags = module.metadata.tags
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  count = var.enabled ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = join("", aws_iam_role.default.*.name)
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_autoscaler_policy" {
  count = (var.enabled && var.enable_cluster_autoscaler) ? 1 : 0
  policy_arn = join("", aws_iam_policy.amazon_eks_worker_node_autoscaler_policy.*.arn)
  role = join("", aws_iam_role.default.*.name)
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  count = var.enabled ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = join("", aws_iam_role.default.*.name)
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  count = var.enabled ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = join("", aws_iam_role.default.*.name)
}

resource "aws_iam_role_policy_attachment" "existing_policies_for_eks_workers_role" {
  count = var.enabled ? var.existing_workers_role_policy_arns_count : 0
  policy_arn = var.existing_workers_role_policy_arns[count.index]
  role = join("", aws_iam_role.default.*.name)
}

resource "aws_eks_node_group" "default" {
  count = var.enabled ? 1 : 0
  cluster_name = var.cluster_name
  node_group_name = module.metadata.id
  node_role_arn = join("", aws_iam_role.default.*.arn)
  subnet_ids = var.subnet_ids
  ami_type = var.ami_type
  disk_size = var.disk_size
  instance_types = var.instance_types
  labels = var.kubernetes_labels
  release_version = var.ami_release_version
  version = var.kubernetes_version

  tags = module.metadata.tags

  scaling_config {
    desired_size = var.desired_size
    max_size = var.max_size
    min_size = var.min_size
  }

  dynamic "remote_access" {
    for_each = var.ec2_ssh_key != null && var.ec2_ssh_key != "" ? [
      "true"
    ] : []
    content {
      ec2_ssh_key = var.ec2_ssh_key
      source_security_group_ids = var.source_security_group_ids
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_worker_node_autoscaler_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
    var.module_depends_on
  ]
}
