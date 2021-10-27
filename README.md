# Satisfactory Docker Image

The save files are stored in `/app/.config/Epic` and server itself at `/steamcmd/fg`

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
      - ./server:/steamcmd/fg
      - ./data:/app/.config/Epic
```

## Docker Run Example

```bash
docker run -p 15777:15777/udp -p 15000:15000/udp -p 7777:7777/udp -v $(pwd)/server:/steamcmd/fg -v $(pwd)/data:/app/.config/Epic -d ghcr.io/vilsol/satisfactory-docker:latest
```
