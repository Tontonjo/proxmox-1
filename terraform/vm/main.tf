resource "proxmox_vm_qemu" "vm" {
  for_each    = var.vm
  name        = each.value.name
  target_node = each.value.node
  clone       = var.template_name
  agent       = each.value.agent
  cores       = each.value.cpu
  sockets     = each.value.sockets
  memory      = each.value.mem
  onboot      = each.value.boot
  startup     = each.value.order

  dynamic "disk"  {

    for_each = each.value.disk 

    size     = disk.value.size
    type     = disk.value.type
    storage  = disk.value.storage
    iothread = disk.value.iothread
    ssd      = disk.value.ssd
    discard  = disk.value.discard

  }

  dynamic "network" {

    for_each = each.value.network

    model  = network.value.model
    bridge = network.value.bridge
    tag    = network.value.tag
  }

  ipconfig0  = "ip=${each.value.ip},gw=${each.value.gateway}"
  nameserver = each.value.nameserver
  sshkeys    = <<EOF
    ${var.ssh_key}
  EOF

}