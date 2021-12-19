%{ for d in droplets ~}
${d.name} ansible_port=22 ansible_user=root ansible_host=${d.ipv4_address}
%{ endfor ~}

%{ for i, t in tags ~}
[${t}]
%{ for d in droplets ~}
%{ if contains(d.tags, t) }${d.name}${"\n"}%{ endif ~}
%{ endfor ~}
%{ if (i < length(tags) - 1) }${"\n"}%{ endif ~}
%{ endfor ~}
