FROM alpine/helm:3.4.0

ENV TASK_VERSION=3.0.0

ENV POLICY_PATH=/usr/src/opa-kubernetes

RUN apk add -X http://dl-cdn.alpinelinux.org/alpine/edge/community curl bats yq rsync git

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

RUN helm plugin install https://github.com/jkroepke/helm-secrets
RUN helm plugin install https://github.com/skillshare/helm-conftest

RUN kubeval --version \
	&& task --version \
	&& kubectl version --client \
	&& yq --version

COPY policy $POLICY_PATH
COPY bin/check-release /usr/local/bin

ENTRYPOINT [ ]
