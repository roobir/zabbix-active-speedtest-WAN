# Zabbix Speedtest application for Active Zabbix Agent

## Foreword
Thanks to pschmitt for the inspiration, the application itself, and providing guidelines how to use the application over here: https://github.com/pschmitt/zabbix-template-speedtest
All the thanks goes to pschmitt and this is only an updated fork to the existing Speedtest WAN App, with an unique spin in different direction. The goal of this fork is to deploy multiple hosts that will intermittently perform speedtest-cli and share the results with a centralized Zabbix server (through active push updates).

## Dependencies

- Ubuntu 24.04 LTS
- Zabbix server 7.0 LTS
- [speedtest-cli](https://www.speedtest.net/apps/cli)

## Installation

- Update the Ubuntu host by means of `apt-get update` and `apt-get upgrade -y`
- Install [speedtest-cli](https://www.speedtest.net/apps/cli) by means of `apt-get install speedtest-cli`
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
