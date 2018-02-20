FROM docker:stable-dind 

RUN apk add --no-cache \
 sudo \
 curl \
 git \
 grep \
 screen \
 htop \
 openssh \
 openssl \
 autossh \
 bash \
 bash-doc \
 bash-completion \
 nano \
 tcpdump \
 coreutils \
 py-pip

RUN pip install docker-compose && mkdir /data

# Install gcloud sdk and kubctl in the container and set default config file in /kube directory
VOLUME /root/.config/gcloud
VOLUME /root/.kube
ENV HOME /
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.zip && unzip google-cloud-sdk.zip && rm google-cloud-sdk.zip
RUN google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/.bashrc --additional-components app-engine-java app-engine-python app kubectl alpha beta gcd-emulator pubsub-emulator cloud-datastore-emulator app-engine-go bigtable
# Disable updater check for the whole installation.
# Users won't be bugged with notifications to update to the latest version of gcloud.
RUN google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true
RUN sed -i -- 's/\"disable_updater\": false/\"disable_updater\": true/g' /google-cloud-sdk/lib/googlecloudsdk/core/config.json

# Install helm utility
RUN curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh && \
		chmod 700 get_helm.sh && \
		./get_helm.sh && \
		rm ./get_helm.sh

# Install ctop utility for container monitoring 
RUN wget https://github.com/bcicen/ctop/releases/download/v0.7/ctop-0.7-linux-amd64 -O /bin/ctop && \
		chmod +x /bin/ctop

WORKDIR /data

CMD dockerd >/dev/null 2>/dev/null & bash
