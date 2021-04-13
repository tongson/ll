package.path = '/__ll/modules/?.lua'

local UNIT = [==[
[Unit]
Description=MariaDB Container

[Service]
RestartSec=5
KillMode=none
Restart=always
SystemCallArchitectures=native
MemoryDenyWriteExecute=yes
LockPersonality=yes
NoNewPrivileges=yes
RemoveIPC=yes
DevicePolicy=closed
PrivateTmp=yes
PrivateNetwork=false
PrivateDevices=yes
ProtectKernelModules=yes
ProtectSystem=full
ProtectHome=yes
#ProtectKernelTunables=yes
ProtectKernelLogs=yes
ProtectClock=yes
RestrictRealtime=yes
#RestrictSUIDSGID=yes
RestrictAddressFamilies=AF_INET AF_UNIX
SystemCallFilter=~bpf process_vm_writev process_vm_readv perf_event_open kcmp lookup_dcookie move_pages swapon swapoff userfaultfd unshare
SystemCallFilter=~@cpu-emulation @debug @module @obsolete @keyring @clock @raw-io @clock @swap @reboot
LimitMEMLOCK=infinity
LimitNOFILE=infinity
LimitNPROC=infinity
ExecStartPre=-/usr/bin/mkdir -p /srv/podman/mariadb/data
ExecStartPre=-/usr/bin/chown -R 999:999 /srv/podman/mariadb/data
ExecStartPre=-/usr/bin/chmod 0600 /srv/podman/mariadb/password
ExecStartPre=-/usr/bin/podman stop -i mariadb
ExecStartPre=-/usr/bin/podman rm -i -v -f mariadb
ExecStop=/usr/bin/podman stop -t 12 mariadb
ExecStopPost=-/usr/bin/podman rm -i -v -f mariadb
ExecStart=/usr/bin/podman run --name mariadb \
--hostname mariadb --network host \
--cap-drop all \
--cap-add setgid \
--cap-add setuid \
--cap-add dac_read_search \
-e "MYSQL_ROOT_PASSWORD_FILE=/etc/mysql/password" \
-e MALLOC_ARENA_MAX=1 \
--ulimit memlock=-1:-1 \
--ulimit nofile=65536:65536 \
--ulimit nproc=65536:65536 \
--memory 0 \
--cpuset-cpus __CPUS__ \
-v /srv/podman/mariadb/data:/var/lib/mysql:rw \
-v /srv/podman/mariadb/password:/etc/mysql/password \
__ID__ --character-set-server=utf8mb4, --collation-server=utf8mb4_unicode_ci --wait_timeout=28800 --log-warnings=0 --port=3306

[Install]
WantedBy=multi-user.target
]==]
local env = {
  NAME = 'mariadb';
  URL  = 'docker://docker.io/library/mariadb';
  TAG  = '10.5';
  CPUS = '1';
  UNIT = UNIT;
  FILE = '/srv/podman/mariadb/password';
  always_update = false;
}
local podman = require 'podman'
podman(env)
podman:pull_image()
podman:generate_password()
podman:start_unit()
