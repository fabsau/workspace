# Todo
## General
1. Change Hostname
2. Properly implement host setup and test the tasks
3. Fix Cronjobs not curling ping URL
4. Create schedule for Docker_prune.yml
5. Properly include Prometheus for automatic monitoring
6. Template the LibrespeedExporter Backends
7. Add tags to the roles
8. Do docker-compose up -d --force-recreate if files from templates have been changed
9. Fix broken Unifi install, czwaka, librespeedexporter, adguardsync

## Create proper tasks from Linux Documentation

### Plex optimizations
sudo sh
echo  fs.inotify.max_user_watches=262144  >> /etc/sysctl.conf
sysctl -p

### Wireguard
sudo nano /etc/systemd/system/wg-quick@.service

	[Interface]
	PrivateKey = SECRET
	Address = 192.168.251.4/32
	#DNS = 192.168.251.1

	[Peer]
	PublicKey = SECRET
	PresharedKey = SECRET
	AllowedIPs = 192.168.0.0/16
	Endpoint = vpn.sauna.re:51820

sudo systemctl daemon-reload
sudo systemctl enable wg-quick@wg0.service
sudo systemctl start wg-quick@wg0.service
sudo systemctl status wg-quick@wg0.service

### Proxmox Backup Client
wget https://enterprise.proxmox.com/debian/proxmox-release-bullseye.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg
wget https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg
nano /etc/apt/sources.list.d/pbs-client.list
deb http://download.proxmox.com/debian/pbs-client bullseye main
wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb
dpkg -i libssl1.1_1.1.0g-2ubuntu4_amd64.deb
apt update
apt install proxmox-backup-client
proxmox-backup-client key create
 nano /etc/environment

### Proxmox Backup Client
PBS_PASSWORD=agent user password bitwarden
PBS_ENCRYPTION_PASSWORD=Bitwarden Encryption Key from earlier creation
crontab -e
	30 22 * * * proxmox-backup-client backup azure.img:/dev/sda --repository agent@pbs@192.168.100.4:8007:NFS && curl -fsS -m 10 --retry 5 -o /dev/null https://uptime.oiba.de/api/push/hPfSvgJlko?status=up&msg=OK&ping=

