# Integritee dev docker image for worker

Usage:
```bash
$ git clone git@github.com:integritee-network/worker.git
$ cd worker
$ docker run --name integritee-dev-worker -it -v $(pwd):/home/ubuntu/worker -e MYUID=$(id -u) -e MYGUID=$(id -g) integritee/integritee-dev:0.2.1 /bin/bash
```

Inside docker:

```bash
$ cd worker
$ make 
$ exit
```

To continue your saved session:

```bash
$ docker start -a -i integritee-dev-worker
```

Should you want to test against a node inside the docker, you can use (check the relative directory) :
```
docker run --name integritee-dev-worker-and-node -it -p 9944:9944 -v $(pwd):/home/ubuntu/worker -v $(pwd)/../integritee-node:/home/ubuntu/integritee-node -e MYUID=$(id -u) -e MYGUID=$(id -g) integritee/integritee-dev:0.2.1 /bin/bash
```
Then, inside docker you can run
```
cd integritee-node
./target/release/integritee-node --dev --unsafe-ws-external --rpc-cors all 
```
and [locally access js/apps from the host](https://cloudflare-ipfs.com/ipns/dotapps.io/?rpc=ws%3A%2F%2F127.0.0.1%3A9944#/explorer
) (make sure to take down browser protections)

