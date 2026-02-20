FROM debian:13-slim

RUN <<EOR
	apt update
	apt install -y --no-install-recommends curl git build-essential ca-certificates zsh tini
EOR

RUN <<EOR
	touch /.dockerenv
	CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo >> /root/.bashrc
	echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"' >> /root/.bashrc
EOR

ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"

RUN <<EOR
	brew install agent-browser
	agent-browser install
EOR

RUN mkdir /zeroclaw-data

# This env tells zeroclaw to look in this directory
# ZEROCLAW_WORKSPACE/.zeroclaw -> config.toml
# ZEROCLAW_WORKSPACE/workspace -> workspace/
#
ENV ZEROCLAW_WORKSPACE=/zeroclaw-data/workspace
ENV SHELL=/usr/bin/zsh
ENV HOME=/openclaw-data

WORKDIR /zeroclaw-data

COPY --from=ghcr.io/zeroclaw-labs/zeroclaw:latest /usr/local/bin/zeroclaw /usr/local/bin/zeroclaw

EXPOSE 3000

ENTRYPOINT ["tini", "--"]
CMD ["zeroclaw", "daemon"]
