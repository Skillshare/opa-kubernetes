FROM instrumenta/conftest:latest

ENV ORAS_VERSION=0.8.1

RUN apk add curl py3-pip

RUN curl --fail -sSL -o oras.tar.gz https://github.com/deislabs/oras/releases/download/v${ORAS_VERSION}/oras_${ORAS_VERSION}_linux_amd64.tar.gz \
	&& mkdir -p oras-install/ \
	&& tar -zxf oras.tar.gz -C oras-install/ \
	&& mv oras-install/oras /usr/local/bin/ \
	&& rm -rf oras.tar.gz oras-install

RUN pip3 install awscli

RUN conftest --version && oras version && aws --version

ENTRYPOINT [ ]
