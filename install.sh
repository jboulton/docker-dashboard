
#!/bin/bash
PWD=`pwd`
PYTHON=`which python3`
SERVICE_FILE=docker-dashboard.service
DEBUG=2
cat <<EOT > $SERVICE_FILE
[Unit]
Description=A python script for monitoring Docker containers to a DashIO Dashboard
After=syslog.target network.target

[Service]
WorkingDirectory=$PWD/docker-dashboard
ExecStart=$PYTHON $PWD/docker-dashboard/main.py -i $PWD/docker-dashboard/docker-dashboard.ini -l $PWD/docker-dashboard/docker-dashboard.log -v$DEBUG

Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOT

pip3 install -r requirements.txt

if [ -f /etc/systemd/system/$SERVICE_FILE ]; then
    systemctl stop $SERVICE_FILE
    systemctl disable $SERVICE_FILE
fi
\cp -f ./$SERVICE_FILE /etc/systemd/system/$SERVICE_FILE
systemctl enable $SERVICE_FILE
systemctl start $SERVICE_FILE
