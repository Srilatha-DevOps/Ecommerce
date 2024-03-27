resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_subnet" "subnets" {
  count           = length(var.subnet_cidr_blocks)
  vpc_id          = aws_vpc.main_vpc.id
  cidr_block      = var.subnet_cidr_blocks[count.index]
}


resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = tolist(aws_subnet.subnets)[0].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = tolist(aws_subnet.subnets)[1].id
  route_table_id = aws_route_table.public_route_table.id
}

# Create VPC endpoints
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id            = aws_vpc.main_vpc.id
  service_name      = "com.amazonaws.us-east-1.s3"
  route_table_ids   = [aws_vpc.main_vpc.main_route_table_id]
}

resource "aws_vpc_endpoint" "dynamodb_endpoint" {
  vpc_id            = aws_vpc.main_vpc.id
  service_name      = "com.amazonaws.us-east-1.dynamodb"
  route_table_ids   = [aws_vpc.main_vpc.main_route_table_id]
}

# Create interface endpoints

resource "aws_vpc_endpoint" "interface_endpoints" {

  for_each = toset([
    "com.amazonaws.us-east-1.ecr.dkr", 
    "com.amazonaws.us-east-1.ecr.api", 
    "com.amazonaws.us-east-1.sqs", 
    "com.amazonaws.us-east-1.logs"
  ])
  vpc_id            = aws_vpc.main_vpc.id
  service_name      = each.key
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    var.security_group
  ]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint_subnet_association" "public_subnet_1_association" {
  for_each = toset([
    "com.amazonaws.us-east-1.ecr.dkr", 
    "com.amazonaws.us-east-1.ecr.api", 
    "com.amazonaws.us-east-1.sqs", 
    "com.amazonaws.us-east-1.logs"
  ])
  vpc_endpoint_id = aws_vpc_endpoint.interface_endpoints[each.key].id
  subnet_id       = tolist(aws_subnet.subnets)[0].id
}

resource "aws_vpc_endpoint_subnet_association" "public_subnet_2_association" {
  for_each = toset([
    "com.amazonaws.us-east-1.ecr.dkr", 
    "com.amazonaws.us-east-1.ecr.api", 
    "com.amazonaws.us-east-1.sqs", 
    "com.amazonaws.us-east-1.logs"
  ])
  vpc_endpoint_id = aws_vpc_endpoint.interface_endpoints[each.key].id
  subnet_id       = tolist(aws_subnet.subnets)[1].id
}
