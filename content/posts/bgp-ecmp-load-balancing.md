+++
title = "Bgp Ecmp Load Balancing"
date = 2022-02-07T15:35:08+07:00
draft = false
comments = true
+++

## 1. Introduction

We will build a Load balancer with [BGP](https://en.wikipedia.org/wiki/Border_Gateway_Protocol) and [Equal-Cost Multipath routing (ECMP)](https://en.wikipedia.org/wiki/Equal-cost_multi-path_routing) using both [Bird](https://bird.network.cz/) and [ExaBGP](https://github.com/Exa-Networks/exabgp).

References:

- [How to build a load balancer with BGP and ECMP using VyOS](https://gist.github.com/bufadu/0c3ba661c141a2176cd048f65430ae8d)
- [Multi-tier load balancer](https://vincent.bernat.ch/en/blog/2018-multi-tier-loadbalancer#first-tier-ecmp-routing)
- [Load balancing without Load balancers](https://blog.cloudflare.com/cloudflares-architecture-eliminating-single-p/)

## 2. Lab overview

- [EVE-NG](https://www.eve-ng.net/) version 2.0.3-112
- QEMU version 2.4.0

{{< figure src="/photos/bgp-ecmp-load-balancing/ecmp-bgp.png" >}}

- `AS 65000`: internet service provider. In this post, we will build a BGP session between EdgeRouter and ISP router.
- `ISPRouter` and `EdgeRouter` are [VyOS](https://vyos.io/) instances. You can use other routers as well.
- `Switch` is a Cisco switch.
- `client`, `lb1`, and `lb2` are Ubuntu server 18.04 instances. `lb1` and `lb2` will be in the `10.12.12.0/24` private LAN, we will install nginx (LB L7) on these. Both servers will announce the same public IP (10.13.13.1) to `EdgeRouter` using BGP. Incoming traffic from internet to this public IP will be routed to `lb1` or `lb2` depending of a hash.
- You need to download and install device virtual images. Follow [EVE-NG guide](https://www.eve-ng.net/index.php/documentation/howtos/howto-add-vyos-vyatta/).

## 3. Configure

### 3.1. ISPRouter

Follow the [VyOS Quickstart](https://docs.vyos.io/en/equuleus/quick-start.html) for the basic commands.

```
# interfaces configurations
set interfaces ethernet eth0 address 'dhcp'
set interfaces ethernet eth1 address '10.0.0.254/24'
set interfaces ethernet eth2 address '172.16.42.2/31'

# source nat to let 'client' instance reach internet (optional)
set nat source rule 100 outbound-interface 'eth0'
set nat source rule 100 source address '10.0.0.0/24'
set nat source rule 100 translation address 'masquerade'

# source nat let my network reach internet (optional)
set nat source rule 200 outbound-interface 'eth0'
set nat source rule 200 source address '172.16.42.3/31'
set nat source rule 200 translation address 'masquerade'

# Simple BGP configuration
set protocols bgp 65000 neighbor 172.16.42.3 remote-as '65500'
set protocols bgp 65000 neighbor 172.16.42.3 update-source '172.16.42.2'
set protocols bgp 65000 address-family ipv4-unicast network 0.0.0.0/0
set protocols bgp 65000 parameters router-id '172.16.42.2'

# DNS server for 'client instance'
set service dns forwarding cache-size '0'
set service dns forwarding listen-address '10.0.0.254'
set service dns forwarding allow-from '10.0.0.0/24'
set service dns forwarding name-server '8.8.8.8'
set service dns forwarding name-server '8.8.4.4'
```

### 3.2. EdgeRouter

```
set interfaces ethernet eth0 address '172.16.42.3/31'
set interfaces ethernet eth1 address '10.12.12.254/24'

set nat source rule 100 outbound-interface 'eth0'
set nat source rule 100 source address '10.12.12.0/24'
set nat source rule 100 translation address 'masquerade'

set protocols bgp 65500 address-family ipv4-unicast maximum-paths ibgp '2'
set protocols bgp 65500 neighbor 10.12.12.1 remote-as '65500'
set protocols bgp 65500 neighbor 10.12.12.1 update-source '10.12.12.254'
set protocols bgp 65500 neighbor 10.12.12.2 remote-as '65500'
set protocols bgp 65500 neighbor 10.12.12.2 update-source '10.12.12.254'
set protocols bgp 65500 neighbor 172.16.42.2 remote-as '65000'
set protocols bgp 65500 neighbor 172.16.42.2 update-source '172.16.42.3'
set protocols bgp 65500 parameters router-id '172.16.42.3'

set service dns forwarding cache-size '0'
set service dns forwarding listen-address '10.12.12.254'
set service dns forwarding name-server '8.8.8.8'
set service dns forwarding allow-from '10.12.12.0/24'
set service dns forwarding name-server '8.8.8.8'
set service dns forwarding name-server '8.8.4.4'
```

### 3.3. Switch

- Set up mode access.

### 3.4. Servers

- Configure `10.13.13.1` on the local loopback interface.

```bash
lb1$ sudo cat <<EOF > /etc/netplan/00-installer-config.yaml
network:
  ethernets:
    lo:
      addresses:
      - 10.13.13.1/24
    ens3:
      addresses:
      - 10.12.12.1/24 # change to 10.12.12.2 on lb2
      gateway4: 10.12.12.254
  version: 2
EOF
```

```bash
lb1$ sudo netplan apply
```

- Install nginx.

```bash
lb1$ sudo apt install nginx -y
```

- Configure nginx:

```bash
lb1$ sudo cat <<EOF > /etc/nginx/sites-enabled/default
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /tmp;
}
EOF

# In lb1
lb1$ echo lb1 > /tmp/file
# In lb2
lb2$ echo lb2 > /tmp/file

lb1$ sudo service nginx start
```

Choose one of the follow configurations (Bird or ExaBGP).

#### 3.4.1. Configure Bird

- We will use [Bird](https://github.com/CZ-NIC/bird).
- Install bird

```bash
lb1$ sudo apt install  bird -y
```

- Configure bird.

```bash
lb1$ sudo cat <<EOF > /etc/bird.conf
protocol kernel {
        persist;
        scan time 20;
        export all;
}

protocol device {
        scan time 10;
}

protocol static {
}

protocol static static_bgp {
        import all;
        route 10.13.13.1/32 reject;
}

protocol bgp {
        local as 65500;
        neighbor 10.12.12.254 as 65500;
        import none;
        export where proto = "static_bgp";
}
EOF
```

- Start bird.

```bash
lb1$ sudo service bird start
lb1$ sudo service bird status
_ bird.service - BIRD Internet Routing Daemon (IPv4)
   Loaded: loaded (/lib/systemd/system/bird.service; disabled; vendor preset: enabled)
   Active: inactive (dead)

Feb 07 08:11:13 lb2 systemd[1]: Starting BIRD Internet Routing Daemon (IPv4)...
Feb 07 08:11:13 lb2 systemd[1]: Started BIRD Internet Routing Daemon (IPv4).
Feb 07 08:11:13 lb2 bird[884]: Chosen router ID 10.12.12.2 according to interface ens3
Feb 07 08:11:13 lb2 bird[884]: Started
```

#### 3.4.2. Configure ExaBGP

- Instead of Bird, we can also use [ExaBGP](https://github.com/Exa-Networks/exabgp). ExaBGP provides a convenient way to implement Software Defined Networking by transforming BGP messages into friendly plain text or JSON, which can then be easily handled by simple scripts or your BSS/OSS.
- Install ExaBGP

```bash
lb1$ sudo apt install python3-pip python3-dev -y
lb1$ sudo pip3 install exabgp
lb1$ exabgp --run healthcheck --help
```

- Create `exabgp` user and group.

```bash
lb1$ sudo useradd exabgp
```

- Configure ExaBGP

```bash
lb1$ sudo cat <<EOF > /etc/exabgp/exabgp.conf
neighbor 10.12.12.254 {  # Remote neighbor to peer with
    router-id 10.12.12.254; # Local router-id
    local-address 10.12.12.1; # Local update-router, change to 10.12.12.2 on lb2
    local-as 65500; # Local AS
    peer-as 65500; # Peer AS

    family {
        ipv4 unicast;
    }
}

process watch-nginx {
    run python3 -m exabgp healthcheck --cmd "curl -sf http://127.0.0.1/file" --label nginx --ip 10.13.13.1/32;
    encoder json;
}
EOF
```

- Configure ExaBGP service file

```bash
lb1$ sudo cat <<EOF > /lib/systemd/system/exabgp.service
[Unit]
Description=ExaBGP
Documentation=man:exabgp(1)
Documentation=man:exabgp.conf(5)
Documentation=https://github.com/Exa-Networks/exabgp/wiki
After=network.target
ConditionPathExists=/etc/exabgp/exabgp.conf

[Service]
User=exabgp
Group=exabgp
Environment=exabgp_daemon_daemonize=false
RuntimeDirectory=exabgp
RuntimeDirectoryMode=0750
ExecStart=/usr/local/bin/exabgp /etc/exabgp/exabgp.conf
ExecReload=/bin/kill -USR1 $MAINPID
Restart=always
CapabilityBoundingSet=CAP_NET_ADMIN
AmbientCapabilities=CAP_NET_ADMIN

[Install]
WantedBy=multi-user.target
EOF

lb1$ sudo service exabgp start
lb1$ sudo service exabgp status
```

## 4. Validate

To make sure everything works as expected.

### 4.1. Scenario 1: Both servers are OK

- Client check.

```bash
client$ curl http://10.13.13.1/file
lb1
```

- Change client ip. The load balancing is working.

```bash
client$ curl http://10.13.13.1/file
lb2
```

- Check EdgeRouter and ISPRouter

```bash
# EdgeRouter
vyos@edgerouter:~$ show ip bgp
BGP table version is 36, local router ID is 172.16.42.3, vrf id 0
Default local pref 100, local AS 65500
Status codes:  s suppressed, d damped, h history, * valid, > best, = multipath,
               i internal, r RIB-failure, S Stale, R Removed
Nexthop codes: @NNN nexthop\'s vrf id, < announce-nh-self
Origin codes:  i - IGP, e - EGP, ? - incomplete

   Network          Next Hop            Metric LocPrf Weight Path
*> 0.0.0.0/0        172.16.42.2              0             0 65000 i
* i10.13.13.1/32    10.12.12.2            1000    100      0 i
*>i                 10.12.12.1             100    100      0 i

Displayed  2 routes and 3 total paths
```

```bash
# ISPRouter
vyos@isprouter:~$ show ip bgp
BGP table version is 12, local router ID is 172.16.42.2, vrf id 0
Default local pref 100, local AS 65000
Status codes:  s suppressed, d damped, h history, * valid, > best, = multipath,
               i internal, r RIB-failure, S Stale, R Removed
Nexthop codes: @NNN nexthop\'s vrf id, < announce-nh-self
Origin codes:  i - IGP, e - EGP, ? - incomplete

   Network          Next Hop            Metric LocPrf Weight Path
*> 0.0.0.0/0        0.0.0.0                  0         32768 i
*> 10.13.13.1/32    172.16.42.3                            0 65500 i

Displayed  2 routes and 2 total paths
```

### 4.2. Scenario 2: One lb is down

- Stop nginx on lb1 (ExaBGP only, Bird may require the complete shutdown) or stop lb1 physically.

```bash
lb1$ sudo service nginx stop
lb2$ sudo journalctl -fu exabgp
-- Logs begin at Thu 2022-01-27 12:07:29 UTC. --
Feb 07 11:12:11 lb1 healthcheck[13584]: send announces for UP state to ExaBGP
Feb 07 11:12:11 lb1 exabgp[13562]: api             route added to neighbor 10.12.12.254 local-ip 10.12.12.1 local-as 65500 peer-as 65500 router-id 10.12.12.254 family-allowed in-open : 10.13.13.1/32 next-hop self med 100
```

- Check client

```bash
client$ curl 10.13.13.1/file
lb2
```

- Check EdgeRouter, you may notice that the metric of 10.12.12.1 hop became 1000.

```bash
vyos@edgerouter:~$ show ip bgp
BGP table version is 42, local router ID is 172.16.42.3, vrf id 0
Default local pref 100, local AS 65500
Status codes:  s suppressed, d damped, h history, * valid, > best, = multipath,
               i internal, r RIB-failure, S Stale, R Removed
Nexthop codes: @NNN nexthop\'s vrf id, < announce-nh-self
Origin codes:  i - IGP, e - EGP, ? - incomplete

   Network          Next Hop            Metric LocPrf Weight Path
*> 0.0.0.0/0        172.16.42.2              0             0 65000 i
*>i10.13.13.1/32    10.12.12.2             100    100      0 i
* i                 10.12.12.1            1000    100      0 i

Displayed  2 routes and 3 total paths
```

- Bring it back, then check client and EdgeRouter.

```bash
vyos@edgerouter:~$ show ip bgp
BGP table version is 43, local router ID is 172.16.42.3, vrf id 0
Default local pref 100, local AS 65500
Status codes:  s suppressed, d damped, h history, * valid, > best, = multipath,
               i internal, r RIB-failure, S Stale, R Removed
Nexthop codes: @NNN nexthop\'s vrf id, < announce-nh-self
Origin codes:  i - IGP, e - EGP, ? - incomplete

   Network          Next Hop            Metric LocPrf Weight Path
*> 0.0.0.0/0        172.16.42.2              0             0 65000 i
*=i10.13.13.1/32    10.12.12.2             100    100      0 i
*>i                 10.12.12.1             100    100      0 i

Displayed  2 routes and 3 total paths

client$ curl 10.13.13.1/file
lb1
```
