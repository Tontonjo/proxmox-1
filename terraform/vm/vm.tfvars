vm = {
    1 = {
        node      = "pve"
        name      = "vm1"
        mem       = 2048
        cpu       = 1
        sockets   = 1
        boot      = true
        agent     = 1
#        order     = 110
        disk = {
            1 = {
                size = "32G"
                type = "scsi"
                storage = "my_storage"
#                iothread = 0
#                ssd = 1
#                discard = ""
            }
        }
        network = {
            1 = {
                bridge = "vimbr0"
                model  = "virtio"
#                tag    = 90
            }
        }
        gateway = "192.168.1.1"
        ip      = "192.168.1.2/24"
        nameserver = "8.8.8.8"
    }
}

ssh_key = "my_key"
proxmox_host = "my_host"
template_name = "my_template"
pm_api_token_id = "my_id"
pm_api_token_secret = "my_token"
pm_api_url = "my_url"