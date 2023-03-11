terraform {
  required_version = ">= 1.1"

  cloud {
    hostname     = "app.terraform.io"
    organization = "myorganization"

    workspaces {
      name = "myworkspace"
    }
  }

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.13"
    }
  }
}
