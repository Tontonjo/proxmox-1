variable "vm" {
  description = "Map of Virtual Machine"
  type        = map(object(
    {
      node      = string
      name      = string
      mem       = number
      cpu       = number
      sockets   = number
      boot      = bool
      agent     = number
      order     = optional(string)
      disk      = map(object({
        size    = string
        type    = string
        storage = string
        iothread= optional(number)
        ssd     = optional(number)
        discard = optional(string)
      }))
      network   = map(object({
        bridge  = string
        model   = string
        tag     = optional(number)
      }))
      gateway   = string
      ip        = string
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

variable "template_name" {
  type = string
}

