#!/bin/bash

on_exit(){
	echo "ending processes"

	trap - SIGINT SIGTERM

	docker-compose down

	message="\"updated db $(date)\""
	echo $message

	sudo chmod -R 777 data/

	echo creating tar file
	tar -cf data.tar data

	echo gzipping
	gzip -fv data.tar



	kill -- $$
}

big_enough(){
	size=$(du -s data | awk '{print "", $1}')
	if [ $size -gt 150000 ]; then
		echo "big enough"
		return 1
	else
		return 0
	fi
}

unpack(){
	rm -r data
	tar -xvf data.tar.gz
}

if [ -d "data" ]; then
	echo "exists"
	if big_enough; then
		echo corrupt/broken, refreshing from gz file
		unpack
	fi
else
	echo "missing"
	unpack
fi

echo "starting containers"
trap on_exit SIGINT SIGTERM
docker-compose up
