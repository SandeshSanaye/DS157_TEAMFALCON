# Check if crypto file exist
if [ ! -d "../organizations/peerOrganizations" ]; then
  echo "Bringing up network"
  ./network.sh
fi

#Default Settings
CHANNEL_NAME='landrecords'
#Delat between commands
CLI_DELAY=3
# another container before giving up
MAX_RETRY=5
./createchannel.sh $CHANNEL_NAME $CLI_DELAY $MAX_RETRY $VERBOSE

if [ $? -ne 0 ]; then
  echo "Error !!! Create channel failed"
  exit 1
fi
