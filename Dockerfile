FROM alpine/helm:3.4.0

ENV YQ_VERSION=3.4.1
ENV TASK_VERSION=3.0.0
ENV CONFTEST_VERSION=0.22.0
ENV HELM_SECRETS_VERSION=3.3.5
ENV HELM_SECRETS_SOPS_DRIVER_VERSION=0.1.0
ENV HELM_CONFTEST_VERSION=0.1.3

ENV POLICY_PATH=/usr/src/opa-kubernetes
ENV DATA_PATH=/usr/share/opa-kubernetes

RUN apk add curl bats rsync git

RUN curl --fail -sSL -o /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 \
	&& chmod +x /usr/local/bin/yq

RUN curl --fail -sSL -o task.tar.gz https://github.com/go-task/task/releases/download/v${TASK_VERSION}/task_linux_386.tar.gz \
	&& mkdir -p task-install \
	&& tar -zxf task.tar.gz -C task-install \
	&& mv task-install/task /usr/local/bin \
	&& rm -rf task.tar.gz task-install

RUN curl --fail -sSL -o conftest.tar.gz https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz \
	&& mkdir -p conftest-install \
	&& tar -zxf conftest.tar.gz -C conftest-install \
	&& mv conftest-install/conftest /usr/local/bin \
	&& rm -rf conftest.tar.gz conftest-install

RUN curl --fail -sSL -o kubeval.tar.gz https://github.com/instrumenta/kubeval/releases/latest/download/kubeval-linux-amd64.tar.gz \
	&& mkdir -p kubeval-install \
	&& tar -zxf kubeval.tar.gz -C kubeval-install \
	&& mv kubeval-install/kubeval /usr/local/bin \
	&& rm -rf kubeval.tar.gz kubeval-install

RUN curl --fail -sSL -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.19.0/bin/linux/amd64/kubectl \
	&& chmod +x /usr/local/bin/kubectl

RUN helm plugin install https://github.com/jkroepke/helm-secrets --version "v${HELM_SECRETS_VERSION}"
RUN helm plugin install https://github.com/skillshare/helm-secrets-sops-driver --version "v${HELM_SECRETS_SOPS_DRIVER_VERSION}"
RUN helm plugin install https://github.com/skillshare/helm-conftest --version "v${HELM_CONFTEST_VERSION}"

RUN kubeval --version \
	&& kubectl version --client \
	&& task --version \
	&& conftest --version \
	&& yq --version

RUN helm plugin ls | grep secrets | grep -qF "${HELM_SECRETS_VERSION}"
RUN helm plugin ls | grep secrets-sops-driver | grep -qF "${HELM_SECRETS_SOPS_DRIVER_VERSION}"
RUN helm plugin ls | grep conftest | grep -qF "${HELM_CONFTEST_VERSION}"

COPY policy $POLICY_PATH
COPY data $DATA_PATH
COPY bin/check-release /usr/local/bin

ENTRYPOINT [ ]
