# uisp-backup

A cron-friendly image to download UISP backups at regular intervals.

Requirements:
- UISP installation
- UISP API token

## Usage
Configure cron job in `cronjobs`:
```shell
0 */4 * * * /uisp_backup.sh

```

Build image:
```shell
docker build uisp-backup:latest .
```

Run container:
```shell
docker run \
-e UISP_DOMAIN=<uisp_domain> \
-e UISP_API_TOKEN=<api_token> \
uisp-backup:latest
```

Docker Compose:
```shell
docker-compose up -d
```
