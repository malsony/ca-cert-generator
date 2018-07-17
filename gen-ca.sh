#!/bin/bash
clear

echo
echo "#############################################################"
echo "#                 CA  Certificate Generator                 #"
echo "#############################################################"
echo

echo "Please name your CA file: "
echo "Note: please omit the file extension names, like '.key' or '.crt', etc."
read -p "(Default filename: CA): " CAname
[ -z "${CAname}" ] && CAname="CA"

echo ""
read -p "CA Country Name (2 letter code) [US]: " Countryname
[ -z "${Countryname}" ] && Countryname="US"

echo ""
read -p "CA State or Province Name (full name) [Delaware]: " Provincename
[ -z "${Provincename}" ] && Provincename="Delaware"

echo ""
read -p "CA Locality Name eg, city [Georgetown]: " Localityname
[ -z "${Localityname}" ] && Localityname="Georgetown"

echo ""
read -p "CA Organization Name (eg, company) []: " Companyname
[ -z "${Companyname}" ] && Companyname="MyCompany"

echo ""
read -p "Organizational Unit Name (eg, section) []: " Organizationalunit

echo ""
read -p "CA Common Name (e.g. server FQDN or YOUR name) []: " Commonname

echo ""
read -p "CA Email address []: " Emailaddress

openssl genrsa -out ${CAname}.key 2048
openssl req -new -x509 -days 3653 -key ${CAname}.key -out ${CAname}.crt -subj /emailAddress=${Emailaddress}/CN=${Commonname}/O=${Companyname}/OU=${Organizationalunit}/C=${Countryname}/ST=${Provincename}/L=${Localityname}
