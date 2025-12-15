resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "three_tier_igw"
    }
}

resource "aws_eip" "nat_eip"{
    domain = "vpc"

    tags = {
        Name = "three_tier_nat_eip"
    }
}

resource "aws_nat_gateway" "nat_gw"{
    allocation_id = aws_eip.nat_eip.id
    subnet_id     = aws_subnet.public_1.id # NAT lives in public subnet

    tags = {
        name = "three_tier_nat_gateway"
    }
}

