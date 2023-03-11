variable "vm" {
  description = "Map of Virtual Machine"
  type        = map(object(
    {
      node      = string
      name      = string
      mem       = number
      cores     = number
      password  = string
      boot      = bool
      unprivileged = bool
      rootfs_size = string
      rootfs_storage = string
      mountpoint= map(object({
        size    = string
        volume  = string
        mp      = string
        key     = string
        slot    = number
        storage = string
      }))
      network   = map(object({
        bridge  = string
        name    = string
        ip      = string
      }))
      nameserver= string
    }
   )
  )
}

variable "pm_api_url" {
  type = string
}

variable "pm_api_token_id" {
  type = string
}

variable "pm_api_token_secret" {
  type = string
}

variable "ssh_key" {
  type = string
}

variable "ssh_key_file" {
  type = string
  default = "~/.ssh/id_rsa.pub"
}

variable "proxmox_host" {
  type = string
}

variable "os_template" {
  type = string
}

