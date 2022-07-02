%{ for droplet_index, droplet in droplets ~}
${name_prefix}${droplet_index + 1} ansible_port=22 ansible_user=root ansible_host=${droplet.ipv4_address}
%{ endfor ~}

%{ for tag_index, tag in tags ~}
[${tag}]
%{ for droplet_index, droplet in droplets ~}
%{ if contains(droplet.tags, tag) }${name_prefix}${droplet_index + 1}${"\n"}%{ endif ~}
%{ endfor ~}
%{ if (tag_index < length(tags) - 1) }${"\n"}%{ endif ~}
%{ endfor ~}
