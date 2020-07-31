#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ../organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ../organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n        /g'
}

ORG=map
P0PORT=7051
CAPORT=7054
PEERPEM=../organizations/peerOrganizations/map.landrecord.com/tlsca/tlsca.map.landrecord.com-cert.pem
CAPEM=../organizations/peerOrganizations/map.landrecord.com/ca/ca.map.landrecord.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ../organizations/peerOrganizations/map.landrecord.com/connection-map.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ../organizations/peerOrganizations/map.landrecord.com/connection-map.yaml

ORG=registrar
P0PORT=9051
CAPORT=8054
PEERPEM=../organizations/peerOrganizations/registrar.landrecord.com/tlsca/tlsca.registrar.landrecord.com-cert.pem
CAPEM=../organizations/peerOrganizations/registrar.landrecord.com/ca/ca.registrar.landrecord.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ../organizations/peerOrganizations/registrar.landrecord.com/connection-registrar.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ../organizations/peerOrganizations/registrar.landrecord.com/connection-registrar.yaml

ORG=revenue
P0PORT=10051
CAPORT=10054
PEERPEM=../organizations/peerOrganizations/revenue.landrecord.com/tlsca/tlsca.revenue.landrecord.com-cert.pem
CAPEM=../organizations/peerOrganizations/revenue.landrecord.com/ca/ca.revenue.landrecord.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ../organizations/peerOrganizations/revenue.landrecord.com/connection-revenue.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ../organizations/peerOrganizations/revenue.landrecord.com/connection-revenue.yaml

ORG=welfare
P0PORT=11051
CAPORT=11054
PEERPEM=../organizations/peerOrganizations/welfare.com/tlsca/tlsca.welfare.com-cert.pem
CAPEM=../organizations/peerOrganizations/welfare.com/ca/ca.welfare.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ../organizations/peerOrganizations/welfare.com/connection-welfare.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ../organizations/peerOrganizations/welfare.com/connection-welfare.yaml
