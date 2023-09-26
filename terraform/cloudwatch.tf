resource "aws_cloudwatch_metric_alarm" "pod_cpu_utilization" {
  alarm_name          = "cpu_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "pod_cpu_utilization"
  namespace           = "ContainerInsights"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"
  alarm_description   = "This metric checks pod_cpu_utilization"
  alarm_actions       = [aws_sns_topic.eks_util.arn]

  dimensions = {
    "ClusterName" = var.cluname
  }
}

resource "aws_cloudwatch_metric_alarm" "pod_memory_utilization" {
  alarm_name          = "memory_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "pod_memory_utilization"
  namespace           = "ContainerInsights"
  period              = "60"
  statistic           = "Average"
  threshold           = "2"
  alarm_description   = "This metric checks pod_memory_utilization"
  alarm_actions       = [aws_sns_topic.eks_util.arn]

  dimensions = {
    "ClusterName" = var.cluname
  }
}

# resource "aws_cloudtrail" "cpu_audit" {
#   name            = "example-cloudtrail-cpu"
#   s3_bucket_name  = aws_s3_bucket.audit-bucket.bucket
#   s3_key_prefix   = "${var.name}-cpu-audit"
#   event_selector {
#     read_write_type = "All"
#     include_management_events = true
#     data_resource {
#       type    = "AWS::CloudWatch::Alarm"
#       values  = ["arn:aws:cloudwatch:${var.region}::alarm/cpu_utilization_high"]
#     }
#   }
# }

# resource "aws_cloudtrail" "memory_audit" {
#   name            = "example-cloudtrail-memory"
#   s3_bucket_name  = aws_s3_bucket.audit-bucket.bucket
#   s3_key_prefix   = "${var.name}-memory-audit"
#   event_selector {
#     read_write_type = "All"
#     include_management_events = true
#     data_resource {
#       type    = "AWS::CloudWatch::Alarm"
#       values  = ["arn:aws:cloudwatch:${var.region}::alarm/memory_utilization_high"]
#     }
#   }
# }



resource "aws_sns_topic" "eks_util" {
  name = "pod_utilization_high"
}

resource "aws_sns_topic_subscription" "email-target" {
  count     = length(var.email_addresses)
  topic_arn = aws_sns_topic.eks_util.arn
  protocol  = "email"
  endpoint  = var.email_addresses[count.index]
}