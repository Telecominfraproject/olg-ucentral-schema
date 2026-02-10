# Changes
Still under development, the current content of this repo might differ. Future development will follow the plan listed below.

BASE: wlan-ucentral-schema

## interface
- interface: reworked
To support setup bridge/ethernet/pppoe on physical port
- interface.ssid: removed
- interface.tunnel: removed
## metrics
- metrics: reused

## radio
Completely removed

## service
- admin-ui: removed
- airtime-fairness: removed
- captive.*: removed
- dhcp-inject: removed
- dhcp-relay: removed (different from tip version for vyos build in)
- facebook-wifi: removed
- fingerprint: unused for now
- gps: unused for now
- http: removed
- 8021x: removed
- igmp: reuse
- lldp: reuse
- log: reuse
- mdns: reuse
- ntp: reuse
- qos: reworked

# Added feature
- firewall
- high-availibility (virtual server/vrrp)
- nat
- routing (bgp/ospf/rip)
- load-balancing (wan_lb/haproxy)
