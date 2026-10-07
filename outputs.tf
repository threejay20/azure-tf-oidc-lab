output "vnet_id" {
  value = azurerm_virtual_network.lab.id
}

output "chatbot_identity_client_id" {
  value = azurerm_user_assigned_identity.chatbot.client_id
}
