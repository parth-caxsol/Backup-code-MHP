vpc_cidr = "10.0.0.0/16"

subnets = {
  public1 = {
    cidr         = "10.0.1.0/24"
    az           = "ap-south-1a"
    name         = "RP-TF-Public-Subnet-1"
    route_table  = "public"
  },
  public2 = {
    cidr         = "10.0.4.0/24"
    az           = "ap-south-1b"
    name         = "RP-TF-Public-Subnet-2"
    route_table  = "public"
  },
  private1 = {
    cidr         = "10.0.2.0/24"
    az           = "ap-south-1a"
    name         = "RP-TF-Private-Subnet-1"
    route_table  = "private"
  },
  private2 = {
    cidr         = "10.0.3.0/24"
    az           = "ap-south-1b"
    name         = "RP-TF-Private-Subnet-2"
    route_table  = "private"
  }
}

region = "ap-south-1"