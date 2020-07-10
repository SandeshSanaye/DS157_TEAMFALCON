function createmap {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p ../organizations/peerOrganizations/map.landrecord.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/map.landrecord.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-map --tls.certfiles ${PWD}/../organizations/fabric-ca/map/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-map.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-map.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-map.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-map.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/../organizations/peerOrganizations/map.landrecord.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-map --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/../organizations/fabric-ca/map/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-map --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/../organizations/fabric-ca/map/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-map --id.name mapadmin --id.secret mapadminpw --id.type admin --tls.certfiles ${PWD}/../organizations/fabric-ca/map/tls-cert.pem
  set +x

	mkdir -p ../organizations/peerOrganizations/map.landrecord.com/peers
  mkdir -p ../organizations/peerOrganizations/map.landrecord.com/peers/peer0.map.landrecord.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-map -M ${PWD}/../organizations/peerOrganizations/map.landrecord.com/peers/peer0.map.landrecord.com/msp --csr.hosts peer0.map.landrecord.com --tls.certfiles ${PWD}/../organizations/fabric-ca/map/tls-cert.pem
  set +x

  cp ${PWD}/../organizations/peerOrganizations/map.landrecord.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/map.landrecord.com/peers/peer0.map.landrecord.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-map -M ${PWD}/../organizations/peerOrganizations/map.landrecord.com/peers/peer0.map.landrecord.com/tls --enrollment.profile tls --csr.hosts peer0.map.landrecord.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/map/tls-cert.pem
  set +x


  cp ${PWD}/../organizations/peerOrganizations/map.landrecord.com/peers/peer0.map.landrecord.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/map.landrecord.com/peers/peer0.map.landrecord.com/tls/ca.crt
  cp ${PWD}/../organizations/peerOrganizations/map.landrecord.com/peers/peer0.map.landrecord.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/map.landrecord.com/peers/peer0.map.landrecord.com/tls/server.crt
  cp ${PWD}/../organizations/peerOrganizations/map.landrecord.com/peers/peer0.map.landrecord.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/map.landrecord.com/peers/peer0.map.landrecord.com/tls/server.key

  mkdir ${PWD}/../organizations/peerOrganizations/map.landrecord.com/msp/tlscacerts
  cp ${PWD}/../organizations/peerOrganizations/map.landrecord.com/peers/peer0.map.landrecord.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/map.landrecord.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../organizations/peerOrganizations/map.landrecord.com/tlsca
  cp ${PWD}/../organizations/peerOrganizations/map.landrecord.com/peers/peer0.map.landrecord.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/map.landrecord.com/tlsca/tlsca.map.landrecord.com-cert.pem

  mkdir ${PWD}/../organizations/peerOrganizations/map.landrecord.com/ca
  cp ${PWD}/../organizations/peerOrganizations/map.landrecord.com/peers/peer0.map.landrecord.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/map.landrecord.com/ca/ca.map.landrecord.com-cert.pem

  mkdir -p ../organizations/peerOrganizations/map.landrecord.com/users
  mkdir -p ../organizations/peerOrganizations/map.landrecord.com/users/User1@map.landrecord.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-map -M ${PWD}/../organizations/peerOrganizations/map.landrecord.com/users/User1@map.landrecord.com/msp --tls.certfiles ${PWD}/../organizations/fabric-ca/map/tls-cert.pem
  set +x

  mkdir -p ../organizations/peerOrganizations/map.landrecord.com/users/Admin@map.landrecord.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://mapadmin:mapadminpw@localhost:7054 --caname ca-map -M ${PWD}/../organizations/peerOrganizations/map.landrecord.com/users/Admin@map.landrecord.com/msp --tls.certfiles ${PWD}/../organizations/fabric-ca/map/tls-cert.pem
  set +x

  cp ${PWD}/../organizations/peerOrganizations/map.landrecord.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/map.landrecord.com/users/Admin@map.landrecord.com/msp/config.yaml

}


function createregistrar {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p ../organizations/peerOrganizations/registrar.landrecord.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-registrar --tls.certfiles ${PWD}/../organizations/fabric-ca/registrar/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-registrar.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-registrar.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-registrar.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-registrar.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-registrar --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/../organizations/fabric-ca/registrar/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-registrar --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/../organizations/fabric-ca/registrar/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-registrar --id.name registraradmin --id.secret registraradminpw --id.type admin --tls.certfiles ${PWD}/../organizations/fabric-ca/registrar/tls-cert.pem
  set +x

	mkdir -p ../organizations/peerOrganizations/registrar.landrecord.com/peers
  mkdir -p ../organizations/peerOrganizations/registrar.landrecord.com/peers/peer0.registrar.landrecord.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-registrar -M ${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/peers/peer0.registrar.landrecord.com/msp --csr.hosts peer0.registrar.landrecord.com --tls.certfiles ${PWD}/../organizations/fabric-ca/registrar/tls-cert.pem
  set +x

  cp ${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/peers/peer0.registrar.landrecord.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-registrar -M ${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/peers/peer0.registrar.landrecord.com/tls --enrollment.profile tls --csr.hosts peer0.registrar.landrecord.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/registrar/tls-cert.pem
  set +x


  cp ${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/peers/peer0.registrar.landrecord.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/peers/peer0.registrar.landrecord.com/tls/ca.crt
  cp ${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/peers/peer0.registrar.landrecord.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/peers/peer0.registrar.landrecord.com/tls/server.crt
  cp ${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/peers/peer0.registrar.landrecord.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/peers/peer0.registrar.landrecord.com/tls/server.key

  mkdir ${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/msp/tlscacerts
  cp ${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/peers/peer0.registrar.landrecord.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/tlsca
  cp ${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/peers/peer0.registrar.landrecord.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/tlsca/tlsca.registrar.landrecord.com-cert.pem

  mkdir ${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/ca
  cp ${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/peers/peer0.registrar.landrecord.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/ca/ca.registrar.landrecord.com-cert.pem

  mkdir -p ../organizations/peerOrganizations/registrar.landrecord.com/users
  mkdir -p ../organizations/peerOrganizations/registrar.landrecord.com/users/User1@registrar.landrecord.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-registrar -M ${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/users/User1@registrar.landrecord.com/msp --tls.certfiles ${PWD}/../organizations/fabric-ca/registrar/tls-cert.pem
  set +x

  mkdir -p ../organizations/peerOrganizations/registrar.landrecord.com/users/Admin@registrar.landrecord.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://registraradmin:registraradminpw@localhost:8054 --caname ca-registrar -M ${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/users/Admin@registrar.landrecord.com/msp --tls.certfiles ${PWD}/../organizations/fabric-ca/registrar/tls-cert.pem
  set +x

  cp ${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/users/Admin@registrar.landrecord.com/msp/config.yaml

}

function createrevenue {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p ../organizations/peerOrganizations/revenue.landrecord.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca-revenue --tls.certfiles ${PWD}/../organizations/fabric-ca/revenue/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-revenue.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-revenue.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-revenue.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-revenue.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-revenue --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/../organizations/fabric-ca/revenue/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-revenue --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/../organizations/fabric-ca/revenue/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-revenue --id.name revenueadmin --id.secret revenueadminpw --id.type admin --tls.certfiles ${PWD}/../organizations/fabric-ca/revenue/tls-cert.pem
  set +x

	mkdir -p ../organizations/peerOrganizations/revenue.landrecord.com/peers
  mkdir -p ../organizations/peerOrganizations/revenue.landrecord.com/peers/peer0.revenue.landrecord.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca-revenue -M ${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/peers/peer0.revenue.landrecord.com/msp --csr.hosts peer0.revenue.landrecord.com --tls.certfiles ${PWD}/../organizations/fabric-ca/revenue/tls-cert.pem
  set +x

  cp ${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/peers/peer0.revenue.landrecord.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca-revenue -M ${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/peers/peer0.revenue.landrecord.com/tls --enrollment.profile tls --csr.hosts peer0.revenue.landrecord.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/revenue/tls-cert.pem
  set +x


  cp ${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/peers/peer0.revenue.landrecord.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/peers/peer0.revenue.landrecord.com/tls/ca.crt
  cp ${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/peers/peer0.revenue.landrecord.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/peers/peer0.revenue.landrecord.com/tls/server.crt
  cp ${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/peers/peer0.revenue.landrecord.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/peers/peer0.revenue.landrecord.com/tls/server.key

  mkdir ${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/msp/tlscacerts
  cp ${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/peers/peer0.revenue.landrecord.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/tlsca
  cp ${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/peers/peer0.revenue.landrecord.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/tlsca/tlsca.revenue.landrecord.com-cert.pem

  mkdir ${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/ca
  cp ${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/peers/peer0.revenue.landrecord.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/ca/ca.revenue.landrecord.com-cert.pem

  mkdir -p ../organizations/peerOrganizations/revenue.landrecord.com/users
  mkdir -p ../organizations/peerOrganizations/revenue.landrecord.com/users/User1@revenue.landrecord.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:10054 --caname ca-revenue -M ${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/users/User1@revenue.landrecord.com/msp --tls.certfiles ${PWD}/../organizations/fabric-ca/revenue/tls-cert.pem
  set +x

  mkdir -p ../organizations/peerOrganizations/revenue.landrecord.com/users/Admin@revenue.landrecord.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://revenueadmin:revenueadminpw@localhost:10054 --caname ca-revenue -M ${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/users/Admin@revenue.landrecord.com/msp --tls.certfiles ${PWD}/../organizations/fabric-ca/revenue/tls-cert.pem
  set +x

  cp ${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/users/Admin@revenue.landrecord.com/msp/config.yaml

}

function createwelfare {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p ../organizations/peerOrganizations/welfare.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/welfare.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:11054 --caname ca-welfare --tls.certfiles ${PWD}/../organizations/fabric-ca/welfare/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-welfare.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-welfare.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-welfare.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-welfare.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/../organizations/peerOrganizations/welfare.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-welfare --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/../organizations/fabric-ca/welfare/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-welfare --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/../organizations/fabric-ca/welfare/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-welfare --id.name welfareadmin --id.secret welfareadminpw --id.type admin --tls.certfiles ${PWD}/../organizations/fabric-ca/welfare/tls-cert.pem
  set +x

	mkdir -p ../organizations/peerOrganizations/welfare.com/peers
  mkdir -p ../organizations/peerOrganizations/welfare.com/peers/peer0.welfare.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-welfare -M ${PWD}/../organizations/peerOrganizations/welfare.com/peers/peer0.welfare.com/msp --csr.hosts peer0.welfare.com --tls.certfiles ${PWD}/../organizations/fabric-ca/welfare/tls-cert.pem
  set +x

  cp ${PWD}/../organizations/peerOrganizations/welfare.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/welfare.com/peers/peer0.welfare.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-welfare -M ${PWD}/../organizations/peerOrganizations/welfare.com/peers/peer0.welfare.com/tls --enrollment.profile tls --csr.hosts peer0.welfare.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/welfare/tls-cert.pem
  set +x


  cp ${PWD}/../organizations/peerOrganizations/welfare.com/peers/peer0.welfare.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/welfare.com/peers/peer0.welfare.com/tls/ca.crt
  cp ${PWD}/../organizations/peerOrganizations/welfare.com/peers/peer0.welfare.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/welfare.com/peers/peer0.welfare.com/tls/server.crt
  cp ${PWD}/../organizations/peerOrganizations/welfare.com/peers/peer0.welfare.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/welfare.com/peers/peer0.welfare.com/tls/server.key

  mkdir ${PWD}/../organizations/peerOrganizations/welfare.com/msp/tlscacerts
  cp ${PWD}/../organizations/peerOrganizations/welfare.com/peers/peer0.welfare.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/welfare.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../organizations/peerOrganizations/welfare.com/tlsca
  cp ${PWD}/../organizations/peerOrganizations/welfare.com/peers/peer0.welfare.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/welfare.com/tlsca/tlsca.welfare.com-cert.pem

  mkdir ${PWD}/../organizations/peerOrganizations/welfare.com/ca
  cp ${PWD}/../organizations/peerOrganizations/welfare.com/peers/peer0.welfare.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/welfare.com/ca/ca.welfare.com-cert.pem

  mkdir -p ../organizations/peerOrganizations/welfare.com/users
  mkdir -p ../organizations/peerOrganizations/welfare.com/users/User1@welfare.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ca-welfare -M ${PWD}/../organizations/peerOrganizations/welfare.com/users/User1@welfare.com/msp --tls.certfiles ${PWD}/../organizations/fabric-ca/welfare/tls-cert.pem
  set +x

  mkdir -p ../organizations/peerOrganizations/welfare.com/users/Admin@welfare.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://welfareadmin:welfareadminpw@localhost:11054 --caname ca-welfare -M ${PWD}/../organizations/peerOrganizations/welfare.com/users/Admin@welfare.com/msp --tls.certfiles ${PWD}/../organizations/fabric-ca/welfare/tls-cert.pem
  set +x

  cp ${PWD}/../organizations/peerOrganizations/welfare.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/welfare.com/users/Admin@welfare.com/msp/config.yaml

}

function createOrderer {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p ../organizations/ordererOrganizations/landrecord.com

	export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/ordererOrganizations/landrecord.com
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/../organizations/fabric-ca/orderer/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/../organizations/ordererOrganizations/landrecord.com/msp/config.yaml


  echo
	echo "Register orderer"
  echo
  set -x
	fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/../organizations/fabric-ca/orderer/tls-cert.pem
    set +x

  echo
  echo "Register the orderer admin"
  echo
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/../organizations/fabric-ca/orderer/tls-cert.pem
  set +x

	mkdir -p ../organizations/ordererOrganizations/landrecord.com/orderers
  mkdir -p ../organizations/ordererOrganizations/landrecord.com/orderers/landrecord.com

  mkdir -p ../organizations/ordererOrganizations/landrecord.com/orderers/orderer.landrecord.com

  echo
  echo "## Generate the orderer msp"
  echo
  set -x
	fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../organizations/ordererOrganizations/landrecord.com/orderers/orderer.landrecord.com/msp --csr.hosts orderer.landrecord.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/orderer/tls-cert.pem
  set +x

  cp ${PWD}/../organizations/ordererOrganizations/landrecord.com/msp/config.yaml ${PWD}/../organizations/ordererOrganizations/landrecord.com/orderers/orderer.landrecord.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../organizations/ordererOrganizations/landrecord.com/orderers/orderer.landrecord.com/tls --enrollment.profile tls --csr.hosts orderer.landrecord.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/orderer/tls-cert.pem
  set +x

  cp ${PWD}/../organizations/ordererOrganizations/landrecord.com/orderers/orderer.landrecord.com/tls/tlscacerts/* ${PWD}/../organizations/ordererOrganizations/landrecord.com/orderers/orderer.landrecord.com/tls/ca.crt
  cp ${PWD}/../organizations/ordererOrganizations/landrecord.com/orderers/orderer.landrecord.com/tls/signcerts/* ${PWD}/../organizations/ordererOrganizations/landrecord.com/orderers/orderer.landrecord.com/tls/server.crt
  cp ${PWD}/../organizations/ordererOrganizations/landrecord.com/orderers/orderer.landrecord.com/tls/keystore/* ${PWD}/../organizations/ordererOrganizations/landrecord.com/orderers/orderer.landrecord.com/tls/server.key

  mkdir ${PWD}/../organizations/ordererOrganizations/landrecord.com/orderers/orderer.landrecord.com/msp/tlscacerts
  cp ${PWD}/../organizations/ordererOrganizations/landrecord.com/orderers/orderer.landrecord.com/tls/tlscacerts/* ${PWD}/../organizations/ordererOrganizations/landrecord.com/orderers/orderer.landrecord.com/msp/tlscacerts/tlsca.landrecord.com-cert.pem

  mkdir ${PWD}/../organizations/ordererOrganizations/landrecord.com/msp/tlscacerts
  cp ${PWD}/../organizations/ordererOrganizations/landrecord.com/orderers/orderer.landrecord.com/tls/tlscacerts/* ${PWD}/../organizations/ordererOrganizations/landrecord.com/msp/tlscacerts/tlsca.landrecord.com-cert.pem

  mkdir -p ../organizations/ordererOrganizations/landrecord.com/users
  mkdir -p ../organizations/ordererOrganizations/landrecord.com/users/Admin@landrecord.com

  echo
  echo "## Generate the admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/../organizations/ordererOrganizations/landrecord.com/users/Admin@landrecord.com/msp --tls.certfiles ${PWD}/../organizations/fabric-ca/orderer/tls-cert.pem
  set +x

  cp ${PWD}/../organizations/ordererOrganizations/landrecord.com/msp/config.yaml ${PWD}/../organizations/ordererOrganizations/landrecord.com/users/Admin@landrecord.com/msp/config.yaml


}
