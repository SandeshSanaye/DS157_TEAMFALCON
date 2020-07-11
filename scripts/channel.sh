#Default Settingsdoc
CHANNEL_NAME='landrecords'
#Delat between commands
CLI_DELAY=3
# another container before giving up
MAX_RETRY=5
./createchannel.sh $CHANNEL_NAME $CLI_DELAY $MAX_RETRY $VERBOSE

if [ $? -ne 0 ]; then
  echo -e "\e[91mError !!! Create channel failed\e[39m"
  exit 1
fi
