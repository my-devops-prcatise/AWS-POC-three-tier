resource "aws_route_table" "public_rt"{
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "Public-Route-Table"
    }
}

resource "aws_route" "public_internet_access"{
    route_table_id     = aws_route_table.public_rt
    destination_cidr_block = "0.0.0.0/0"
    gateway_id         = aws_internet_gateway.igw.id

}

resource "aws_route_table_association" "public_rt_assoc_1"{
    subnet_id      = aws_subnet.public_1.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_assoc_2"{
    subnet_id      = aws_subnet.public_2.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt"{
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "Private-Route-Table"
    }
}

resource "aws_route" "private_nat_access"{
    route_table_id     = aws_route_table.private_rt.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id    = aws_nat_gateway.nat_gw.id
}

resource "aws_route_table_association" "private_rt_assoc_db_1"{
    subnet_id      = aws_subnet.private_db_1.id
    route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_assoc_db_2"{
    subnet_id      = aws_subnet.private_db_2.id
    route_table_id = aws_route_table.private_rt.id
}
