# Eternal

![GitHub License](https://img.shields.io/github/license/Magnetkopf/Eternal)

Eternal is a lightweight and flexible Linux process manager

## Get started

### Download

Download the latest binary from [releases](https://github.com/Magnetkopf/Eternal/releases).

> Or build manually:

```bash
bash build.sh <arch>
```
### Install

#### Normal
```bash
sudo mv eternal eternal-daemon /usr/local/bin/

sudo cp eternal-daemon.service /etc/systemd/system/
sudo systemctl enable eternal-daemon
sudo systemctl start eternal-daemon
```

#### Container

Here is an example of a Dockerfile:

```Dockerfile
COPY eternal eternal-daemon /usr/local/bin/

RUN chmod +x /usr/local/bin/eternal /usr/local/bin/eternal-daemon

CMD ["/usr/local/bin/eternal-daemon"]
```

## Usage

Eternal supports CLI and API access.

### CLI

```bash
cat <<EOF > ~/.eternal/services/example.yaml
exec: /bin/sleep 100
dir: /tmp
EOF

# create service
eternal new example
# delete service
eternal delete example

# enable auto start
eternal enable example
# start now
eternal start example
# disable auto start
eternal disable example
# stop now
eternal stop example
# restart now
eternal restart example
```

### API

Check [api.md](docs/api.md) for API usage and testing.

### Configuration

Services are stored in `~/.eternal/services/`, add a YAML file for each service.

- `exec`: The command to run
- `dir`: The directory to run the command in

Example:

```yaml
exec: /bin/sleep 100
dir: /tmp
```

Check [configuration.md](docs/configuration.md) for more information.
