sudo truncate -s 0 $(docker inspect --format='{{.LogPath}}' peer0.map.landrecord.com)
