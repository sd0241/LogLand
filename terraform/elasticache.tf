resource "aws_elasticache_cluster" "ssac-elasticache" {
  cluster_id         = "${var.name}-elasticache"
  engine             = "redis"                                     # or "memcached" (can be changed as needed)
  node_type          = "cache.t3.small"                            # Adjust node type as needed
  num_cache_nodes    = 1                                           # Number of cache nodes in the cluster
  subnet_group_name  = aws_elasticache_subnet_group.elasticache.id # Use an existing subnet group
  security_group_ids = [aws_security_group.elasticache_secu.id]    # Specify security group ID

  tags = {
    Name = "${var.name}-elasticache"
  }
}
