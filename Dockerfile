FROM ubuntu:latest
ENV  TZ=Utc
ENV  GOROOT=/usr/local/go
ENV  GOPATH=$HOME/go
ENV  PATH=$GOPATH/bin:$GOROOT/bin:$PATH
ENV  DEBIAN_FRONTEND=noninteractive

COPY . /root/.

RUN apt-get update -y && apt-get install awscli curl wget git -y


#Install AWS EKS
RUN curl -O https://amazon-eks.s3-us-west-2.amazonaws.com/2018-04-04/eks-2017-11-01.normal.json
RUN aws configure add-model --service-model file://eks-2017-11-01.normal.json --service-name eks

#Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN mv kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl

# install golang
RUN wget https://dl.google.com/go/go1.10.1.linux-amd64.tar.gz
RUN tar -xvf go1.10.1.linux-amd64.tar.gz
RUN mv go /usr/local


# Install helm
RUN mv /root/linux-amd64/helm /usr/local/bin/helm

#Install heptio authenticator
RUN go get -u -v github.com/heptio/authenticator/cmd/heptio-authenticator-aws

CMD ["bash"]