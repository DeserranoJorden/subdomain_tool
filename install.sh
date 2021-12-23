#!/bin/bash

echo "Installing Tools"

cd Tools

echo " -- Installing sublist3r"
git clone https://github.com/aboul3la/Sublist3r.git && cd Sublist3r
pip3 install -r requirements.txt
cd ..

echo " "
echo " -- Installing CTFR"
git clone https://github.com/UnaPibaGeek/ctfr.git && cd ctfr
pip3 install -r requirements.txt
cd ..

echo " "
echo " -- Installing assetfinder"
go get -u github.com/tomnomnom/assetfinder

echo " "
echo " -- Installing httprobe"
go get -u github.com/tomnomnom/httprobe

echo " "
echo " -- Installing subjack"
go get github.com/haccer/subjack

echo " "
echo " -- Installing Eyewitness"
git clone https://github.com/FortyNorthSecurity/EyeWitness.git && cd  EyeWitness/Python/setup
sudo bash setup.sh
cd ../../../../

echo " "
echo "Everything is installed"

