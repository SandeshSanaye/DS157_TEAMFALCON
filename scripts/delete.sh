docker stop $(docker ps -qa)
docker rm $(docker ps -qa)
docker volume rm $(docker volume ls -q)
rm -rf ../channel-artifacts
rm -rf ../organizations
rm -rf ../system-genesis-block