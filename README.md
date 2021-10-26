# Satisfactory Docker Image

## Docker Compose Example

```yaml
version: '2'
services:
  server:
    image: ghcr.io/vilsol/satisfactory-docker:latest
    ports:
      - "15777:15777/udp"
      - "15000:15000/udp"
      - "7777:7777/udp"
    volumes:
      - ./data/:/steamcmd/fg
```

## Docker Run Example

```bash
docker run -p 15777:15777/udp -p 15000:15000/udp -p 7777:7777/udp -v $(pwd)/data:/steamcmd/fg -d ghcr.io/vilsol/satisfactory-docker:latest
```