# Introduction 

This docker-compose environment sets out to prove you with a self contained developer environment within a single Docker container. The environments consists of a web based Clou9 IDE in an isolated 'docker host' with the following utilities: 

* gcloud
* gsutil
* kubectl 
* helm 


# Getting Started

Simply clone this repository and issued a `docker-compose up` command as shown in the following example. 

```bash
git clone https://github.com/MayankTahil/gcp-workspace.git
cd ./gcp-workspace
docker-compose up -d 
```

Now you may log on to your web IDE at [http://localhost](http://localhost)

# Restarting the Workspace

Note with this compose file, data is persistent in the local directory so even if you ran `docker-compose down` and then `docker-compose up -d` at a later time, the workspace should pick up where you left off. 


You can change volume mounts to else where and mount `workspace` directory else where on your local machine to pick up directories on your host. 