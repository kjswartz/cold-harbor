# get lines with repeat occurances 
awk -F '\t' '{print $3} cargo_volume_at_us_ports.tsv | sort | uniq -d | grep -f - cargo_volume_at_us_ports.tsv

awk -F '\t' '{print $3} cargo_volume_at_us_ports.tsv | sort | uniq -d | grep -f - cargo_volume_at_us_ports.tsv | tail -n +2 | awk -F '\t' '{print $4}' | sed 's/,//g' | jq -s 'add'

awk -F '\t' '{print $3} cargo_volume_at_us_ports.tsv | sort | uniq -d | grep -f - cargo_volume_at_us_ports.tsv | tail -n +2 | sed 's/,//g' | awk -F '\t' '{s+=$4} END '{print s}'

awk -F '\t' '{print $3}' cargo_volume_at_us_ports.tsv | sort | uniq -d | grep -f - cargo_volume_at_us_ports.tsv | sed 's/,//g' | sort -nr -k4 -t '\t' -o tmp-file.tsv

(head -n 1 tmp-file.csv && tail -n +2 tmp-file.csv | sort -nr -k4 -t ',') > tmp-file-sorted.csv
