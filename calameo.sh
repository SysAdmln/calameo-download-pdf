#!/bin/bash
#    usage: calameo.sh URL
#    Examples:
#      calameo.sh https://en.calameo.com/read/000509530867cd15f4709
BAR='####################################################################################################'
data=$(curl -s --insecure -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.0.0 Safari/537.36" -H "Accept-Language: ru" $1)
pages=$(echo $data | grep pages | awk -F'Length:' '/t=/ {print $2}' | awk '{print $1}')
name=$(echo $data | grep title | head -n1 | sed 's/\,//g' | sed 's/\/ //g' | awk -F'<title>' '{print $2}' | awk -F'</title>' '{print $1}' | sed 's/\ /_/g')
id=$(echo $data | grep -o "p.calameoassets.com[^&]\+" | head -n1 | sed 's/p.calameoassets.com//g' | sed 's/p1.jpg" //g' | cut -c 2-46)
for ((i=1; i <= $pages; i++))
do
        wget -q -U "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.0.0 Safari/537.36" --output-document=$i.jpg "https://p.calameoassets.com/$id/p$i.jpg"
	echo -ne "\r${BAR:0:$i}"
done
echo ""
echo "Мы скачали $pages страниц книги $name"
# jpg to pdf
ls *.jpg | sort --human-numeric-sort | tr '\n' ' ' | sed 's/$/\.\/'$name.pdf'/' | xargs convert
rm -f ./*.jpg
