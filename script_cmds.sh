# get lines with repeat occurances 
awk -F '\t' '{print $3} cargo_volume_at_us_ports.tsv | sort | uniq -d | grep -f - cargo_volume_at_us_ports.tsv

awk -F '\t' '{print $3} cargo_volume_at_us_ports.tsv | sort | uniq -d | grep -f - cargo_volume_at_us_ports.tsv | tail -n +2 | awk -F '\t' '{print $4}' | jq -s 'add'
