#!/bin/bash
clear

echo
echo "#############################################################"
echo "#             Certificate  Certificate Generator            #"
echo "#############################################################"
echo

if [ -e CA.crt ]; then
    CAname=CA
else
    echo "Please specify file name of CA or create one using command 'bash gen-ca.sh' first: "
	read -p "CA filename: " CAname
	    if [ ! -e ${CAname}.crt ]; then
		echo "PLEASE make sure the specified CA exist in the same directory before next step."
		exit;
		fi
		
fi

echo ""
echo "Please name your client certificate file:"
echo "Note: please omit the file extension names, like '.key' or '.crt', etc."
read -p "(Default filename: [MyWebsite]): " Clientname
[ -z "${Clientname}" ] && Clientname="MyWebsite"

echo ""
#echo "Please enter Client's country name:"
read -p "Default client Country Name (2 letter code) [same as CAs']: " ClientCountryname
[ -z "${ClientCountryname}" ] && ClientCountryname="US"

echo ""
#echo "Please enter Client's province name:"
read -p "Default client's State or Province Name (full name) [same as CAs']: " ClientProvincename
[ -z "${ClientProvincename}" ] && ClientProvincename="California"

echo ""
#echo "Please enter Client's Locality name:"
read -p "Default client's Locality Name eg, city [same as CA's]: " ClientLocalityname
[ -z "${ClientLocalityname}" ] && ClientLocalityname="Los Angeles"

echo ""
read -p "Client's Organization Name (eg, company) []: " ClientCompanyname

echo ""
read -p "Client's Organizational Unit Name (eg, section) []: " ClientOrganizationalunit

echo ""
read -p "Client's Common Name (e.g. server FQDN or YOUR name) []: " ClientCommonname

echo ""
read -p "Client's Email address []: " ClientEmailaddress

openssl genrsa -out ${Clientname}.key 2048
openssl req -new -days 365 -key ${Clientname}.key -out ${Clientname}.csr -sha256 -subj /emailAddress=${ClientEmailaddress}/CN=${ClientCommonname}/O=${ClientCompanyname}/OU=${ClientOrganizationalunit}/C=${ClientCountryname}/ST=${ClientProvincename}/L=${ClientLocalityname}

cat >> ${Clientname}.ext <<-EOF

[ req ]
default_bits        = 2048
distinguished_name  = req_distinguished_name
req_extensions      = san
extensions          = san
[ req_distinguished_name ]
countryName         = ${ClientCountryname}
stateOrProvinceName = ${ClientProvincename}
localityName        = ${ClientLocalityname}
organizationName    = ${ClientCompanyname}

[SAN]
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = DNS:${ClientCommonname}

[ v3_req ]
# Extensions to add to a certificate request
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = ${ClientCommonname}
DNS.2 = *.${ClientCommonname}

EOF

openssl x509 -req -in ${Clientname}.csr -CA ${CAname}.crt -CAkey ${CAname}.key -CAcreateserial -days 365 -out ${Clientname}.crt -extfile ${Clientname}.ext -extensions v3_req