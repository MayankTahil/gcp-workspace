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
 py-pip \
 build-base \
 g++ \
 make \
 curl \
 wget \
 openssl-dev \
 apache2-utils \
 libxml2-dev \
 sshfs \
 nodejs \
 tmux \
 supervisor

RUN pip install docker-compose && mkdir /data

# Install gcloud sdk and kubctl in the container and set default config file in /kube directory
VOLUME /.config/gcloud
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

# Install Cloud9 IDE
RUN apk --update add build-base g++ make curl wget openssl-dev apache2-utils git libxml2-dev sshfs nodejs bash tmux supervisor \
 && rm -f /var/cache/apk/*\
 && git clone https://github.com/c9/core.git /cloud9 \
 && curl -s -L https://raw.githubusercontent.com/c9/install/master/link.sh | bash \
 && /cloud9/scripts/install-sdk.sh \
 && sed -i -e 's_127.0.0.1_0.0.0.0_g' /cloud9/configs/standalone.js \
 && mkdir /workspace \
 && mkdir -p /var/log/supervisor

ADD ./supervisord.conf /etc/supervisor/supervisord.conf

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]