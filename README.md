# Zabbix Speedtest application for Active Zabbix Agent

## Foreword

Thanks to @zkassab for the inspiration, the application testing, and thanks to @pschmitt for providing guidelines how to use main application over here: https://github.com/pschmitt/zabbix-template-speedtest
This is an updated fork to the existing Speedtest WAN App, with an unique spin in a different direction. The goal of this fork is to deploy multiple hosts that will intermittently perform speedtest-cli and share the results with a centralized Zabbix server (through active push updates). Templates and guidelines provided will allow your setup to poll, graph, and trigger alerts based on the utilization results of ping, upload bandwidth and download bandwidth on Zabbix 7.0 LTS.

## Dependencies

- Ubuntu 24.04 LTS
- Zabbix server 7.0 LTS
- Zabbix agent (for ubuntu 24.04)
- [speedtest-cli](https://www.speedtest.net/apps/cli)

## Installation

- Update the Ubuntu host by means of `apt-get update` and `apt-get upgrade -y`
- Install [speedtest-cli](https://www.speedtest.net/apps/cli) by means of `apt-get install speedtest-cli`
- Download the Zabbix Agent repo: `wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.0+ubuntu24.04_all.deb`
- Install the Zabbix Agent repo: `dpkg -i zabbix-release_latest_7.0+ubuntu24.04_all.deb`
- Update apt: `apt update `
- Install the Zabbix Agent: `apt-get install zabbix-agent`
- Restart Zabbix Agent: `systemctl restart zabbix-agent`
- Enable Zabbix Agent: `systemctl enable zabbix-agent`
- Create `/etc/zabbix/script`: `mkdir -p /etc/zabbix/script`
- Create `/tmp/speedtest.json`: `mkdir -p /tmp/` and `touch /tmp/speedtest.json`
- Copy `speedtest.sh` to `/etc/zabbix/script/speedtest.sh`
- Make it executable: `chmod +x /etc/zabbix/script/speedtest.sh`
- Create crontab with scheduled speedtest function: `crontab -e` and then add at the bottom: `*/15 * * * * /etc/zabbix/script/speedtest.sh`
- Import the zabbix-agent config: `zabbix_agentd.conf` to `/etc/zabbix/zabbix_agentd.conf`
- Change the `Server=`, `ServerActive=` to the IP address or FQDN of your Zabbix server
- Restart zabbix-agent: `systemctl restart zabbix-agent`
- Import `Zabbix Active Speedtest WAN Application.yml` on your Zabbix server
- Create new host and select template "Zabbix Active Speedtest WAN Application"
