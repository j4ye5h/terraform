terraform {
  required_providers {
    bigip = {
      source = "F5Networks/bigip"
      version = "1.6.0"
    }
  }
}




provider "bigip" {
    address = "10.10.10.10"
    username = "admin"
    password = "P4ssw0rd@123"
}