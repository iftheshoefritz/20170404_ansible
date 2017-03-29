output "host_ips" {
  value = "${map(
      "demo", aws_instance.demo.public_ip
  )}"
}

output "host_tags" {
  value = "${map(
      "demo", aws_instance.demo.tags
  )}"
}
