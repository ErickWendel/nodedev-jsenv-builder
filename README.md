# Running it

This repo was meant to save time when working on the Node.js project. 

The idea is to avoid compiling the project all the time locally (which takes hours) by just downloading a docker container image with the given tag.

The example below will pull a `v16.x-staging` branch and you can check the pipeline on [Dockerfile](./Dockerfile).

To make things work, you'll need two terminal instances. Just for the first setup. 

## in the first terminal 
```sh
docker pull erickwendel/node-devjs-builder:v16.x-staging

# spin up the instance so we can copy files to our machine
docker run -it --name node-devjs-builder erickwendel/node-devjs-builder:v16.x-staging bash
```

## in the second terminal
```sh

# copy all files from the container to an empty local folder
time docker cp node-devjs-builder:/node node

# stop the current container
docker stop node-devjs-builder && docker rm node-devjs-builder

# start a new container instance linking the local env with the container env
docker run --name node-devjs-builder -v $(pwd)/node:/node -it node-devjs-builder bash

# now you should make some changes locally 

# such as adding a console log on the first line of a file

# on test/parallel/test-stream-duplex-from.js 
```

Now, inside the container shell do:
```sh
./node -v
# v16.15.2-pre

./node test/parallel/test-stream-duplex-from.js

# it should print your changes
```


## The whole idea

Well, this is just the first PoC. The idea is whenever we have a new relese on the Node.js core on  `main`, `canary`, `v[0-9]+.x-staging` or `v[0-9]+.x` branches it be added as a workflow on the github action platform to build those images on the Dockerhub.

Now, insted of fetching the latest code on the Github repo, you'd pull the docker image with everything already cached and ready to work without worrying about compiling all the source again and again.



