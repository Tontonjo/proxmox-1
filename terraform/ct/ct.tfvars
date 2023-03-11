ct = {
    1 = {
        node      = "pve"
        name      = "ct1"
        mem       = 2048
        cores     = 1
        boot      = true
        password  = "mypassword"
        unprivileged = true
        rootfs_storage = "mystorage"
        rootfs_size = "8G"
        mountpoint = {
            1 = {
                slot = 0
                mp = "/mnt/container/device-mount-point"
                storage = "/dev/sdg"
                size = "32G"
                volume = "/dev/sdg"
                key = "0"
            }
        }
        network = {
            1 = {
                bridge = "vimbr0"
                name  = "eth0"
                ip   = "192.168.1.2/24"
            }
        }
        nameserver = "8.8.8.8"
    }
}

ssh_key = "my_key"
proxmox_host = "my_host"
os_template = "my_template"
pm_api_token_id = "my_id"
pm_api_token_secret = "my_token"
pm_api_url = "my_url"