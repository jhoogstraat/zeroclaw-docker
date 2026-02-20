# zeroclaw-docker

Container image for running `zeroclaw` with persistent workspace data at `/zeroclaw-data`.

## Onboard (first-time setup)

Run interactive onboarding and persist data by mounting `/zeroclaw-data`:

```bash
docker run --rm -it -v zeroclaw-data:/zeroclaw-data \
  ghcr.io/jhoogstraat/zeroclaw-docker:latest \
  onboard --interactive
```

Notes:
- The image entrypoint is `zeroclaw`, so `onboard --interactive` is passed as arguments to it.
- Use the same volume (`zeroclaw-data`) for future runs so config/state is reused.
- The volume can also be a local directory (like `./zeroclaw`)

## Start

```bash
docker run -d --name zeroclaw \
  -v zeroclaw-data:/zeroclaw-data \
  ghcr.io/jhoogstraat/zeroclaw-docker:latest
```

## Executing commands

It is necessary to access the `zeroclaw` cli to approve channels.
With zeroclaw running in a container, execute:

```bash
docker exec -it zeroclaw zeroclaw
```

## Docker Compose

A ready example is included at `compose.yaml`.

Set your GHCR owner once:

```bash
export GHCR_OWNER=<github-owner>
```

Run onboarding:

```bash
docker compose run --rm zeroclaw-onboard
```

Start service:

```bash
docker compose up -d zeroclaw
```

## Podman Quadlet

A ready example is included at `examples/zeroclaw.container`.

1. Copy it to your user Quadlet directory:

```bash
mkdir -p ~/.config/containers/systemd
cp examples/zeroclaw.container ~/.config/containers/systemd/zeroclaw.container
```

2. Edit the `Image=` line and replace `<github-owner>`.
3. Run onboarding once with the same volume:

```bash
podman run --rm -it \
  -v zeroclaw-data:/zeroclaw-data \
  ghcr.io/jhoogstraat/zeroclaw-docker:latest \
  onboard --interactive
```

4. Enable and start the Quadlet service:

```bash
systemctl --user daemon-reload
systemctl --user enable --now zeroclaw.service
```
