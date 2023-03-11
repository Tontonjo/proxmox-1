resource "proxmox_vm_qemu" "ct" {
  for_each    = var.vm
  hostname    = each.value.name
  target_node = each.value.node
  ostemplate  = var.os_template
  password    = each.value.password
  unprivileged= each.value.unprivileged
  cores       = each.value.cores
  memory      = each.value.mem
  onboot      = each.value.boot

  rootfs  {

    size     = each.value.rootfs_size
    storage  = each.value.rootfs_storage

  }

  dynamic "mountpoint" {

    for_each = each.value.mountpoint

    key  = mountpoint.value.key
    slot = mountpoint.value.slot
    storage = mountpoint.value.storage
    size = mountpoint.value.size
    mp   = mountpoint.value.mp
  }
  dynamic "network" {

    for_each = each.value.network

    name  = network.value.name
    bridge = network.value.bridge
    ip    = network.value.ip
  }

  nameserver = each.value.nameserver
  ssh_keys    = <<EOF
    ${var.ssh_key}
  EOF

}