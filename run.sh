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

echo "starting containers"
trap on_exit SIGINT SIGTERM
docker-compose up
