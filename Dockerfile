FROM ubuntu 

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN echo "Acquire::http { Proxy \"http://192.168.11.1:3142\"; };" > /etc/apt/apt.conf.d/01proxy && \
    apt-get update && \
    apt-get install -y curl && \
    curl https://getsubstrate.io -sSf | bash -s -- --fast 
RUN . $HOME/.cargo/env && \
    cd /opt/ && \
	git clone https://github.com/substrate-developer-hub/recipes.git && \
	cd recipes && \
	./nodes/scripts/init.sh && \
	cargo build --release -p kitchen-node
RUN echo ". /root/.cargo/env >> /etc/profile"
CMD /recipes/target/release/kitchen-node  --dev --ws-external --prometheus-external --rpc-external