#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -n "Enter the domain and press [ENTER]: "
read domainname
domain=$(awk -F. '{print $1}' <<< $domainname)
mkdir $domain

############################
##         sublist3r      ##
############################
# https://github.com/aboul3la/Sublist3r

echo " Scanning with Sublist3r "
python3 Tools/Sublist3r/sublist3r.py -d $domainname -o $domain'.txt' > /dev/null 2>&1

count=$(wc -l $domain'.txt' | awk '{ print $1 }')
echo -e "${GREEN} subdomains found: " $count "${NC}"


############################
##           CTFR         ##
############################
# https://github.com/UnaPibaGeek/ctfr

touch temp.txt
echo " Scanning with CTFR "
python3 Tools/ctfr/ctfr.py -d $domainname -o temp.txt > /dev/null 2>&1

cat $domain'.txt' temp.txt > $domain'togheter.txt'
rm temp.txt
rm $domain'.txt'

sort -o $domain'.txt' -u $domain'togheter.txt'
rm $domain'togheter.txt'

count=$(wc -l $domain'.txt' | awk '{ print $1 }')
echo -e "${GREEN} subdomains found: " $count "${NC}"


############################
##       assetfinder      ##
############################
# https://github.com/tomnomnom/assetfinder

echo " Scanning with assetfinder "
assetfinder --subs-only $domainname >> $domain'.txt'

sort -o $domain'_sorted.txt' -u $domain'.txt'

rm $domain'.txt'
mv $domain'_sorted.txt' $domain'.txt'

count=$(wc -l $domain'.txt' | awk '{ print $1 }')
echo -e "${GREEN} subdomains found: " $count "${NC}"



############################
##        httprobe        ##
############################
# https://github.com/tomnomnom/httprobe

echo -e "${RED} testing for valid http(s) servers with httprobe ${NC}"

cat $domain'.txt' | httprobe -prefer-https >> valid_temp.txt

rm $domain'.txt'
mv valid_temp.txt $domain'_with_protocol.txt'


touch $domain'.txt'
while read hosts; do
	echo "$hosts" | awk -F '//' '{print $2}' >> $domain'.txt'
done <$domain'_with_protocol.txt'


sort -u $domain'.txt' > /dev/null 2>&1
count=$(wc -l $domain'.txt' | awk '{ print $1 }')
echo -e "${GREEN} subdomains found with a web server accessable: " $count "${NC}"




############################
##        subjack         ##
############################
# https://github.com/haccer/subjack

echo " Scanning with subjack to find vulnerable subdomains "
subjack -w $domain'.txt' -timeout 30 -o 'resulsts_'$domain'.txt' -a -m -v

mv $domain'.txt' $domain/$domain'.txt'
mv $domain'_with_protocol.txt' $domain/$domain'_with_protocol.txt'
mv 'resulsts_'$domain'.txt' $domain/$domain'_results.txt'


############################
##  Eyewitness hosting    ##
############################
# https://github.com/FortyNorthSecurity/EyeWitness

touch $domain/Eyewitness.sh
echo "#!/bin/bash" >> $domain/Eyewitness.sh
echo "python3 ../Tools/EyeWitness/Python/EyeWitness.py -f "$domain"_with_protocol.txt --user-agent \"Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)\" --web --delay 5 --prepend-https -d "$domain" --timeout 20 --no-prompt > /dev/null 2>&1" >> $domain/Eyewitness.sh
echo "echo \"Hosting web server with results\"" >> $domain/Eyewitness.sh
echo "cd "$domain" && python -m SimpleHTTPServer 8000" >> $domain/Eyewitness.sh
chmod +x $domain/Eyewitness.sh

echo -e "${PURPLE} run the Eyewitness script in the "$domain" folder to have a look at the subdomains yourself! ${NC}"
