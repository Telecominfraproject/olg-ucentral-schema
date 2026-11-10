# olg-ucentral-schema: Inventum proposal

This branch is Inventum's proposal for the OpenLAN Gateway (OLG) uCentral configuration schema, aimed at
embedded gateways (OpenWrt-based, B6 as the first target).

A configuration is the device's whole desired state. Every push carries the complete document; a section
left out means that function is off, and a field left out takes its default. `interfaces` is required
and must contain at least one `role: upstream` interface.

## What it covers

It keeps the uCentral/OpenWiFi sections gateways need (`unit`, `globals`, `definitions`, `ethernet`,
`switch`, `interfaces`, `services`, `metrics`, `timeouts`) and adds gateway sections:

| Section | Purpose |
| --- | --- |
| `firewall` | Stateful firewall: IPv4/IPv6 rule sets, zones and zone policies, address/network/port groups, flow offloading |
| `nat` | Source NAT for IPv4 and IPv6 |
| `routing` | Static routes, policy routing, BGP, OSPF/OSPFv3, RIP/RIPng, MPLS |
| `vpn` | IPsec and WireGuard tunnels |
| `pki` | CA certificates, certificates, DH parameters |
| `high-availability` | VRRP |
| `load-balancing` | WAN load balancing |
| `system` | Name servers |

## Layout

Same as `main`: one YAML file per section under `schema/`, starting at `schema/ucentral.yml`. File names
follow `main` wherever a section exists there. `ucentral.schema.json` (compact, with `$defs`) and
`ucentral.schema.pretty.json` are generated from the YAML with `main`'s `tools/merge-schema.py`:

```sh
./tools/merge-schema.py schema schema ucentral.yml ucentral.schema.json 1 1
./tools/merge-schema.py schema schema ucentral.yml ucentral.schema.pretty.json 0 1
```

Feedback is welcome as issues or review comments on this branch.
