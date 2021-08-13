#!/bin/sh
echo '******************************************************'

echo
echo 'Start install DeepCyto - Intelligent analysis system of cell morphology'
echo

# usage:
#   curl -fsSL http://demo.deepcyto.cn:8080/web/cell/install.sh | sh
#   bash <(curl http://demo.deepcyto.cn:8080/web/cell/install.sh)

#
# set local port
#
read -p 'Please set the port number of the web server (Default: 80): ' localport

if [ -z $localport ]; then
  localport=80
fi

if [ `echo $localport| awk '{print($0~/^[-]?([0-9])+[.]?([0-9])+$/)?"number":"string"}'` = 'string' ]; then
  echo 'Port must be numeric!'
  exit 0
fi
echo

#
# set service name
#
read -p 'Please set the local mapping path (Default: demo): ' servicename
if [ -z $servicename ]; then
  servicename="demo"
fi
echo

#
# set local path
#
read -p 'Please set the local mapping path (Default: /data/cell.'$localport'.'$servicename'''): ' localpath
if [ -z $localpath ]; then
  localpath='/data/cell.'$localport'.'$servicename
fi

if [ -d "$localpath" ]; then
  if [ "$(ls -A $localpath)" ]; then
    echo "$localpath is not Empty!"
    exit 0
  fi
fi
echo

#
# get last version package
#
xml=`curl http://demo.deepcyto.cn:8080/web/cell/linux/ -s`
data=$(sed -n -e 's/.*zip">\(.*\)<\/a>.*/\1/p' <<< $xml)
latest=""
arr=(${data})
for v in ${arr[@]}
do
  latest=$v
done

if [ -z $latest ]; then
  echo "Failed to query the latest version of the installation package! Please contact the developer!"
  exit 0
fi

#
# set install version package
#
read -p 'Please select the version of the installation package (Default：The latest version is '$latest'): ' version
if [ -z $version ]; then
  version=$latest
fi
echo

docker run -itd --name cell.$localport.$servicename -v $localpath:/cell -p $localport:80 --restart=always eshax/cell
docker exec -w /update cell.$localport.$servicename /bin/bash /update/setup.sh http://demo.deepcyto.cn:8080/web/cell/linux/$latest
docker restart cell.$localport.$servicename

echo
echo 'Installation is complete!'
echo
echo 'http://localhost:'$localport
echo

echo '******************************************************'