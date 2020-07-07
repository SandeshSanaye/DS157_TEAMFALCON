cd ../config/docker

FILES="./*.yaml
./*.yml
"
ARGUMENTS=""
for file in $FILES
    do
    if [ -f $file ]; then
        docker-compose -f $file stop
        echo "1"
    fi
done

echo
echo 'Fabric DEV environment stopped - DO NOT Clean the containers :)'