%{ for vm_index, vm in vms ~}
${identifier}-${vm_index + 1} ansible_port=22 ansible_user=${user} ansible_host=${vm.network_interface[0].access_config[0].nat_ip}
%{ endfor ~}

%{ for tag_index, tag in tags ~}
[${tag}]
%{ for vm_index, vm in vms ~}
%{ if contains(vm.tags, tag) }${identifier}-${vm_index + 1}${"\n"}%{ endif ~}
%{ endfor ~}
%{ if (tag_index < length(tags) - 1) }${"\n"}%{ endif ~}
%{ endfor ~}
