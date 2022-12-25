resource "azurerm_linux_virtual_machine" "VMLUE01" {
  name                = "VMLUE01"
  resource_group_name = resource.azurerm_resource_group.azure_infra.name
  location            = resource.azurerm_resource_group.azure_infra.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.NICfe01.id,
    azurerm_network_interface.NICbe01.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  provisioner "file" {
        source      = "./ansible.yml"
        destination = "/tmp/ansible.yml"
  }

  provisioner "file" {
        source      = "~/ssh_keys/id_rsa"
        destination = "/home/adminuser/.ssh/id_rsa"
  }

  connection {
        host = self.public_ip_address
        type = "ssh"
        user = "adminuser"
        private_key = file("~/.ssh/id_rsa")
    }

  provisioner "remote-exec" {
        inline = [
            "sudo apt update && sudo apt install ansible -y && sudo chmod 600 ~/.ssh/id_rsa && ssh-keyscan ${azurerm_linux_virtual_machine.VMLU01.private_ip_address}, ${azurerm_linux_virtual_machine.VMLU02.private_ip_address} >> ~/.ssh/known_hosts && ansible-playbook -i ${azurerm_linux_virtual_machine.VMLU01.private_ip_address}, -i ${azurerm_linux_virtual_machine.VMLU02.private_ip_address}, /tmp/ansible.yml"
        ]
    }

  provisioner "remote-exec" {
        inline = [
            "sudo apt install docker.io -y && sudo docker run -d -p 21:21 -p 21000-21010:21000-21010 -e USERS='one|1234' -e ADDRESS=ftp.site.domain delfer/alpine-ftp-server"
        ]
    }
}

resource "azurerm_linux_virtual_machine" "VMLU01" {
  name                = "VMLU01"
  resource_group_name = azurerm_resource_group.azure_infra.name
  location            = azurerm_resource_group.azure_infra.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.NICbe02.id,
  ]

    admin_ssh_key {
    username   = "adminuser"
    public_key = file("/home/sergey/ssh_keys/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "VMLU02" {
  name                = "VMLU02"
  resource_group_name = azurerm_resource_group.azure_infra.name
  location            = azurerm_resource_group.azure_infra.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.NICbe03.id,
  ]

    admin_ssh_key {
    username   = "adminuser"
    public_key = file("/home/sergey/ssh_keys/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}