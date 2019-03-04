FROM linkyard/docker-helm:2.9.1

# COMMENT IN IF BUILDING LOCAL BECAUSE ZSCALER YEA..
# ENV https_proxy=http://10.55.1.11:9400/
# ENV http_proxy=http://10.55.1.11:9400/
# ENV no_proxy=localhost,127.0.0.1,insim.biz

RUN apk add --update --upgrade --no-cache jq bash curl

ADD assets /opt/resource
ADD test /opt/test
RUN chmod +x /opt/resource/*

ENTRYPOINT [ "/bin/bash" ]
