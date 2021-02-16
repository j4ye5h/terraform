output "hostname_result" {
  value       = bigip_command.set-hostteename.command_result
  description = "Output from setting hostname"
}