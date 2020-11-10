FROM instrumenta/conftest:latest

ENV ORAS_VERSION=0.8.1
ENV TASK_VERSION=3.0.0
ENV HELM_VERSION=3.4.0

ENV POLICY_PATH=/usr/src/opa-kubernetes

RUN apk add -X http://dl-cdn.alpinelinux.org/alpine/edge/community curl py3-pip bats yq rsync git \
	&& pip3 install awscli

RUN curl --fail -sSL -o oras.tar.gz https://github.com/deislabs/oras/releases/download/v${ORAS_VERSION}/oras_${ORAS_VERSION}_linux_amd64.tar.gz \
	&& mkdir -p oras-install/ \
	&& tar -zxf oras.tar.gz -C oras-install \
	&& mv oras-install/oras /usr/local/bin \
	&& rm -rf oras.tar.gz oras-install

RUN curl --fail -sSL -o task.tar.gz https://github.com/go-task/task/releases/download/v${TASK_VERSION}/task_linux_386.tar.gz \
	&& mkdir -p task-install \
	&& tar -zxf task.tar.gz -C task-install \
	&& mv task-install/task /usr/local/bin \
	&& rm -rf task.tar.gz task-install

RUN curl --fail -sSL -o kubeval.tar.gz https://github.com/instrumenta/kubeval/releases/latest/download/kubeval-linux-amd64.tar.gz \
	&& mkdir -p kubeval-install \
	&& tar -zxf kubeval.tar.gz -C kubeval-install \
	&& mv kubeval-install/kubeval /usr/local/bin \
	&& rm -rf kubeval.tar.gz kubeval-install

RUN curl --fail -sSL -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.19.0/bin/linux/amd64/kubectl \
	&& chmod +x /usr/local/bin/kubectl

RUN curl --fail -sSL -o helm.tar.gz https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
	&& mkdir -p helm-install \
	&& tar -zxf helm.tar.gz -C helm-install \
	&& mv helm-install/linux-amd64/helm /usr/local/bin \
	&& rm -rf helm.tar.gz helm-install

RUN helm plugin install https://github.com/futuresimple/helm-secrets

RUN conftest --version \
	&& oras version \
	&& kubeval --version \
	&& aws --version \
	&& task --version \
	&& kubectl version --client \
	&& yq --version \
	&& helm version --client

COPY policy/ $POLICY_PATH
COPY bin/check-release /usr/local/bin

ENTRYPOINT [ ]
