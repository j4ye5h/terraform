terraform {
  required_providers {
    bigip = {
      source  = "F5Networks/bigip"
      version = "1.6.0"
    }
  }
}

provider "bigip" {
  address  = "10.10.10.10"
  username = var.usernamevar
  password = var.passwordvar
}

resource "bigip_command" "set-hostname" {
  commands = ["modify sys global-settings hostname f5london1.lab.local"]

}

resource "bigip_sys_ntp" "ntp1" {
  description = "/Common/NTP1"
  servers     = ["ntp.pool.org"]
  timezone    = "Europe/London"

}

resource "bigip_sys_dns" "dns1" {
  description  = "/Common/DNS1"
  name_servers = ["8.8.8.8"]

}

resource "bigip_net_vlan" "internal" {
  name = "/Common/Internal"
  tag  = 101
  interfaces {
    vlanport = 1.0
    tagged   = false
  }
}

resource "bigip_net_vlan" "external" {
  name = "/Common/external"
  tag  = 101
  interfaces {
    vlanport = 2.0
    tagged   = false
  }
}

resource "bigip_net_selfip" "internal_selfip" {
  name          = "/Common/internal_selfIP"
  ip            = "172.16.0.2/24"
  vlan          = "/Common/internal"
  traffic_group = "traffic-group-1"
  depends_on    = [bigip_net_vlan.internal]
}

resource "bigip_net_selfip" "external_selfip" {
  name          = "/Common/external_selfIP"
  ip            = "10.0.0.2/24"
  vlan          = "/Common/internal"
  traffic_group = "traffic-group-1"
  depends_on    = [bigip_net_vlan.external]
}

resource "bigip_net_selfip" "internal_floatIP" {
  name          = "/Common/internal_floatIP"
  ip            = "172.16.0.1/24"
  vlan          = "/Common/internal"
  traffic_group = "traffic-group-1"
  depends_on    = [bigip_net_selfip.internal_selfip]
}

resource "bigip_net_selfip" "external_floatIP" {
  name          = "/Common/external_floatIP"
  ip            = "10.0.0.1/24"
  vlan          = "/Common/internal"
  traffic_group = "traffic-group-1"
  depends_on    = [bigip_net_selfip.external_selfip]
}