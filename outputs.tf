output "public_subnet_id" {
  value = "${azurerm_public_ip.web_test_ip.id}"
}
