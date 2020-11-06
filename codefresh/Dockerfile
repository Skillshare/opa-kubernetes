FROM instrumenta/conftest:latest

ENV ORAS_VERSION=0.8.1
ENV TASK_VERSION=3.0.0

RUN apk add curl py3-pip bats

RUN curl --fail -sSL -o oras.tar.gz https://github.com/deislabs/oras/releases/download/v${ORAS_VERSION}/oras_${ORAS_VERSION}_linux_amd64.tar.gz \
	&& mkdir -p oras-install/ \
	&& tar -zxf oras.tar.gz -C oras-install \
	&& mv oras-install/oras /usr/local/bin \
	&& rm -rf oras.tar.gz oras-install

RUN curl --fail -sSL -o task.tar.gz https://github.com/go-task/task/releases/download/v${TASK_VERSION}/task_linux_386.tar.gz \
	&& mkdir -p task-install \
	&& tar -vzxf task.tar.gz -C task-install \
	&& mv task-install/task /usr/local/bin \
	&& rm -rf task.tar.gz task-install

RUN pip3 install awscli

RUN conftest --version && oras version && aws --version && task --version

ENTRYPOINT [ ]
