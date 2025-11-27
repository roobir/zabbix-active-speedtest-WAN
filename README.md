# Zabbix Speedtest application for Active Zabbix Agent

## Foreword
Thanks to pschmitt for the inspiration, applicaation, and guidelines over here: https://github.com/pschmitt/zabbix-template-speedtest
All the thanks goes to pschmitt and this is only an updated fork to the existing Speedtest WAN App, with an unique spin in different direction. The goal of this fork is to deploy multiple hosts that will intermittently perform speedtest-cli and share the results with a centralized Zabbix server (through active push updates).

## Dependencies

- Ubuntu 24.04 LTS
- Zabbix server 7.0 LTS
- [speedtest-cli](https://www.speedtest.net/apps/cli)

## Installation

- Install [speedtest-cli](https://www.speedtest.net/apps/cli) by means of `apt-get install speedtest-cli`
- Create `/etc/zabbix/script`: `mkdir -p /etc/zabbix/script`
- Copy `zbx-speedtest-debian.sh` to `/etc/zabbix/bin/zbx-speedtest.sh`
- Make it executable: `chmod +x /etc/zabbix/bin/zbx-speedtest.sh`
- Create crontab with scheduled speedtest function: `crontab -e` and then add at the bottom: `*/15 * * * * /etc/zabbix/script/speedtest.sh`
- Start and enable the timer: `systemctl enable --now zabbix-speedtest.timer`
- Import the zabbix-agent config: `cp zabbix_agentd.d/speedtest.conf /etc/zabbix/zabbix_agentd.conf.d`
- Restart zabbix-agent: `systemctl restart zabbix-agent`
- Import `template_speedtest.xml` on your Zabbix server
