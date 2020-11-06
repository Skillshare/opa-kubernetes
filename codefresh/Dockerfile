FROM instrumenta/conftest:latest

ENV ORAS_VERSION=0.8.1
ENV TASK_VERSION=3.0.0

RUN apk add -X http://dl-cdn.alpinelinux.org/alpine/edge/community curl py3-pip bats yq coreutils \
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

RUN conftest --version \
	&& oras version \
	&& kubeval --version \
	&& aws --version \
	&& task --version \
	&& kubectl version --client \
	&& yq --version

ENTRYPOINT [ ]
