output "secret_value" {

    value = data.azurerm_key_vault_secret.key_vault_secret.value
    sensitive = true
  
}