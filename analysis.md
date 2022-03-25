
### 1) Dockerfile
While the application is simple, it's still broken and the implementation can be improved further:  
* The python script for this application was implemented using python 2 which is deprecated since a few months and doesn't run with the provided `Dockerfile`. To fix this raw_input should be changed with input and `print ""`  should be changed with `print ("")`.  
* The base image `python:3` used by the `Dockerfile` is a debian based docker image and it's better to replace with `python:3-alpine` image. It's prefered generally to use alpine based image if not needed otherwise. Alpine images are proven to be more lightweight, more secure and only have a minimal system which is more than enough to run our application.  
* While the application itself don't make any external changes to the working directory, It's a good practice to always create a new folder and copy the application inside instead of working on root folder.  
* `RUN pip install flask` is not needed and can be removed from the dockerfile because `magic_ball.py` script is not using flask framework.
### 2) WordPress with `docker-compose`
Below is a list explaining the changes and addition done to complete this task:
* A new `.env` file was created containing sensitive data which were removed from the `docker-compose.yml` file. This file was added to `.gitignore` and `.dockerignore` files to avoid copying them to git repository and docker images.  
* A new `nginx-conf/nginx.conf` file was created containing specific configuration. This file will be used in the first stage to allow nginx to listen to port 80, which will allow us to use Certbot’s webroot plugin for our certificate requests.  
* After succesfully obtaining the SSL certificate `nginx-conf/nginx.conf` file should be removed and replaced with `nginx-ssl.conf` file which will allow nginx to configure SSL certificates and listen on port 443  
* 2 new services were added to the `docker-compose.yml` file. The first one is nginx, this is our webserver
### 3) GitHub Actions
Github actions is a tool made by Github that helps us to automate tasks.  
Before github actions, we had to push the code, run the tests manually, fix the bugs, test again, fix more bugs.... Github actions help us to automate this workflow.  
The `.github` folder contains 2 files:  
* `pull_request_template.md`: as the file name says, this file defines a template using Markdown format which will be used by github to pre-populate the description field of a new pull request with content that's inside `pull_request_template.md` file. This file contains usually details about the type of changes, the tests that were done and several other useful information.
* `workflows/cicd.yml`: This file basically defines the pipeline for the project's CI/CD workflow which will do the following:
    1.  Triggers on creating a pull request to the `main` branch or the `development` branch  
    2.  Executes 1 job named `build_docker_images`. This job will run these steps:  
       * **Checkout (actions/checkout@v2):** This action allows the runner to access your code by cloning it  
       * **Docker meta (crazy-max/ghaction-docker-meta@v1):** This action extracts metadata (tags, labels) for Docker.  
       * **Set up QEMU (docker/setup-qemu-action@v1):** This action installs QEMU static binaries, which are used to run builders for architectures other than the host.  
       * **Set up Docker Buildx (docker/setup-buildx-action@v1):** This action will create and boot a builder that can be used in the following steps of your workflow  
       * **Login to GitHub Container Registry (docker/login-action@v1):** This action will log in to ghcr.io Docker registry.  
       * **Build and push MLFlow image (docker/build-push-action@v2):** This action builds and pushes the Docker image defined inside the mlflow directory with Buildx  