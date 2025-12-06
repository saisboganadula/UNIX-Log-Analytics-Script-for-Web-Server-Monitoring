if [ -p /dev/stdin ]; then
  file="./thttpd.log"
else
  file="${!#}"
fi



while getopts ":L:c2rFt" opt; do
  case $opt in
  L)
	
  	l="$OPTARG">&2
       ;;
c)
if [ -z "$l" ]
then
grep -o -E '([0-9]{1,3}\.){3}[0-9]{1,3}' thttpd.log|sort|uniq -c|sort -nr|awk '{print $2"   "$1}' 
else
grep -o -E '([0-9]{1,3}\.){3}[0-9]{1,3}' thttpd.log|sort|uniq -c|sort -nr|head -n $l|awk '{print $2"   "$1}'
fi
;;
2)
if [ -z "$l" ]
then
grep ' 200 ' thttpd.log|cut -d " " -f1,1|sort|uniq -c|sort -nr|awk '{print $2"\t"$1}'
else
grep ' 200 ' thttpd.log|cut -d " " -f1,1|sort|uniq -c|sort -nr| head -n 5|awk '{print $2"\t"$1}'
fi
;;

r)
if [ -z "$l" ]
then


grep ' 404 ' thttpd.log|cut -d " " -f1,1|sort|uniq -c|sort -n|awk '{print "404\t"$2}'
echo"  "
grep ' 200 ' thttpd.log|cut -d " " -f1,1|sort|uniq -c|sort -nr|awk '{print "200\t"$2}'
echo ""
grep ' 401 ' thttpd.log|cut -d " " -f1,1|sort|uniq -c|sort -nr|awk '{print 401"\t"$2}'
echo ""
grep ' 304 ' thttpd.log|cut -d " " -f1,1|sort|uniq -c|sort -nr|awk '{print "304\t"$2}'
echo ""
grep ' 403 ' thttpd.log|cut -d " " -f1,1|sort|uniq -c|sort -nr|awk '{print "403\t"$2}'
echo ""
grep ' 302 ' thttpd.log|cut -d " " -f1,1|sort|uniq -c|sort -nr|awk '{print "302\t"$2}'


else
echo ""
grep ' 404 ' thttpd.log|cut -d " " -f1,1|sort|uniq -c|sort -nr| head -n $l|awk '{print "404\t"$2}'
echo ""
grep ' 200 ' thttpd.log|cut -d " " -f1,1|sort|uniq -c|sort -nr| head -n $l|awk '{print "200\t"$2}'
echo ""
grep ' 401 ' thttpd.log|cut -d " " -f1,1|sort|uniq -c|sort -nr| head -n $l|awk '{print 401"\t"$2}'
echo ""
grep ' 304 ' thttpd.log|cut -d " " -f1,1|sort|uniq -c|sort -nr| head -n $l|awk '{print "304\t"$2}'
echo ""
grep ' 403 ' thttpd.log|cut -d " " -f1,1|sort|uniq -c|sort -nr| head -n $l|awk '{print "403\t"$2}'
echo ""
grep ' 302 ' thttpd.log|cut -d " " -f1,1|sort|uniq -c|sort -nr| head -n $l|awk '{print "302\t"$2}'

fi
;;
F)
if [ -z "$l" ]
then
grep ' 404 ' thttpd.log|cut -d " " -f1,1|sort|uniq -c|sort -n|awk '{print "404\t"$2}'
echo ""
grep ' 401 ' thttpd.log|cut -d " " -f1,1|sort|uniq -c|sort -nr|awk '{print 401"\t"$2}'
echo ""
grep ' 403 ' thttpd.log|cut -d " " -f1,1|sort|uniq -c|sort -nr|awk '{print "403\t"$2}'
else
grep ' 404 ' thttpd.log|cut -d " " -f1,1|sort|uniq -c|sort -nr| head -n $l|awk '{print "404\t"$2}'
echo ""
grep ' 401 ' thttpd.log|cut -d " " -f1,1|sort|uniq -c|sort -nr| head -n $l|awk '{print 401"\t"$2}'
echo ""
grep ' 403 ' thttpd.log|cut -d " " -f1,1|sort|uniq -c|sort -nr| head -n $l|awk '{print "403\t"$2}'
fi
;;
t)
if [ -z "$l" ]
then
grep -oE '\b[0-9]{1,3}(\.[0-9]{3}){3}\b' thttpd.log > ips.txt 
grep -oE '\b[0-9]+\b' thttpd.log > bytes.txt

# Join data
paste -d' ' ips.txt bytes.txt > ips_bytes.txt

# Sum bytes per IP
sort ips_bytes.txt | uniq -c | while read count ip bytes; do
   echo "$ip $bytes"
done > sorted.txt 

# Sort and print top 10
sort -nrk2 sorted.txt 
else
grep -oE '\b[0-9]{1,3}(\.[0-9]{3}){3}\b' thttpd.log > ips.txt 
grep -oE '\b[0-9]+\b' thttpd.log > bytes.txt

# Join data
paste -d' ' ips.txt bytes.txt > ips_bytes.txt

# Sum bytes per IP
sort ips_bytes.txt | uniq -c | while read count ip bytes; do
   echo "$ip $bytes"
done > sorted.txt 

# Sort and print top 10
sort -nrk2 sorted.txt | head -n $LIMIT 
fi
;;

*)
echo "Not a valid command"
;;
esac
done
