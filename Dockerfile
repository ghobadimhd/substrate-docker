FROM ubuntu 

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
ARG APTPROXY_ADDR

RUN if [ "${APTPROXY_ADDR}" != "" ] ; \
        then echo "Acquire::http { Proxy \"http://$APTPROXY_ADDR\"; };" > /etc/apt/apt.conf.d/01proxy ; \
        echo "Using apt proxy: $APTPROXY_ADDR" ; \
    fi ; \
    apt-get update && \
    apt-get install -y curl && \
    curl https://getsubstrate.io -sSf | bash -s -- --fast && \
    apt clean

RUN	. /root/.cargo/env && \
    git clone https://github.com/substrate-developer-hub/recipes.git /opt/recipes && \
    cd /opt/recipes && \
    ./nodes/scripts/init.sh && \
	cargo build --release -p kitchen-node


CMD /opt/recipes/target/release/kitchen-node  --dev --ws-external --prometheus-external --rpc-external