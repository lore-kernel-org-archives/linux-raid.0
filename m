From: Gavin Flower <gavinflower@yahoo.com>
Subject: mdadm: recovering from an aborted reshape op: selected log entries
Date: Sun, 13 Feb 2011 15:55:27 -0800 (PST)
Message-ID: <941377.12907.qm@web65106.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is the /var/log/messages from shortly after coming up after hibernation, note that the last entries are Friday - as since then the filing system has been read only.

I have filtered out entries associated with:
named
dhcp
NetworkManager
ntpd

Feb 11 04:36:31 saturn kernel: [112405.427525] ata5.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
Feb 11 04:36:31 saturn kernel: [112405.427529] ata5.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES) filtered out
Feb 11 04:36:31 saturn kernel: [112405.427532] ata5.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Feb 11 04:36:31 saturn kernel: [112405.427857] ata6.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
Feb 11 04:36:31 saturn kernel: [112405.427860] ata6.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
Feb 11 04:36:31 saturn kernel: [112405.427862] ata6.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Feb 11 04:36:31 saturn kernel: [112405.433452] ata5.00: configured for UDMA/33
Feb 11 04:36:31 saturn kernel: [112405.461471] HDA Intel 0000:01:05.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Feb 11 04:36:31 saturn kernel: [112405.461490] ATL1E 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Feb 11 04:36:31 saturn kernel: [112405.502503] ata6.00: configured for UDMA/100
Feb 11 04:36:31 saturn kernel: [112405.512030] ata4: softreset failed (device not ready)
Feb 11 04:36:31 saturn kernel: [112405.512033] ata1: softreset failed (device not ready)
Feb 11 04:36:31 saturn kernel: [112405.512036] ata4: applying SB600 PMP SRST workaround and retrying
Feb 11 04:36:31 saturn kernel: [112405.512038] ata1: applying SB600 PMP SRST workaround and retrying
Feb 11 04:36:31 saturn kernel: [112405.512057] ata3: softreset failed (device not ready)
Feb 11 04:36:31 saturn kernel: [112405.512060] ata3: applying SB600 PMP SRST workaround and retrying
Feb 11 04:36:31 saturn kernel: [112405.512062] ata2: softreset failed (device not ready)
Feb 11 04:36:31 saturn kernel: [112405.512065] ata2: applying SB600 PMP SRST workaround and retrying
Feb 11 04:36:31 saturn kernel: [112405.522058] firewire_core: skipped bus generations, destroying all nodes
Feb 11 04:36:31 saturn kernel: [112405.526548] serial 00:09: activated
Feb 11 04:36:31 saturn kernel: [112405.667039] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Feb 11 04:36:31 saturn kernel: [112405.667056] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Feb 11 04:36:31 saturn kernel: [112405.667069] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Feb 11 04:36:31 saturn kernel: [112405.667085] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Feb 11 04:36:31 saturn kernel: [112405.669351] ata3.00: configured for UDMA/133
Feb 11 04:36:31 saturn kernel: [112405.733598] ata2.00: configured for UDMA/133
Feb 11 04:36:31 saturn kernel: [112405.733660] ata1.00: configured for UDMA/133
Feb 11 04:36:31 saturn kernel: [112405.733706] ata4.00: configured for UDMA/133
Feb 11 04:36:31 saturn kernel: [112406.023036] firewire_core: rediscovered device fw0
Feb 11 04:36:31 saturn kernel: [112407.090029] usb 1-4: reset high speed USB device using ehci_hcd and address 5
Feb 11 04:36:31 saturn kernel: [112407.341394] snd-usb-audio 1-4:1.2: no reset_resume for driver snd-usb-audio?
Feb 11 04:36:31 saturn kernel: [112407.341397] snd-usb-audio 1-4:1.3: no reset_resume for driver snd-usb-audio?
Feb 11 04:36:31 saturn kernel: [112407.614035] usb 3-1: reset low speed USB device using ohci_hcd and address 2
Feb 11 04:36:31 saturn kernel: [112407.915468] sd 0:0:0:0: [sda] Starting disk
Feb 11 04:36:31 saturn kernel: [112407.924908] sd 1:0:0:0: [sdb] Starting disk
Feb 11 04:36:31 saturn kernel: [112407.935249] sd 2:0:0:0: [sdc] Starting disk
Feb 11 04:36:31 saturn kernel: [112407.949675] sd 3:0:0:0: [sdd] Starting disk
Feb 11 04:36:31 saturn kernel: [112408.236035] usb 3-2: reset low speed USB device using ohci_hcd and address 3
Feb 11 04:36:31 saturn kernel: [112408.533547] sd 5:0:0:0: [sde] Starting disk
Feb 11 04:36:31 saturn kernel: [112408.666031] usb 3-3: reset full speed USB device using ohci_hcd and address 4
Feb 11 04:36:31 saturn kernel: [112408.812474] usblp 3-3:1.0: no reset_resume for driver usblp?
Feb 11 04:36:31 saturn kernel: [112408.812588] usblp0: removed
Feb 11 04:36:31 saturn kernel: [112408.812614] PM: restore of devices complete after 3760.064 msecs
Feb 11 04:36:31 saturn kernel: [112408.818602] usblp0: USB Bidirectional printer dev 4 if 0 alt 0 proto 2 vid 0x04F9 pid 0x0028
Feb 11 04:36:31 saturn kernel: [112409.146196] Restarting tasks ... done.
Feb 11 04:36:41 saturn rtkit-daemon[3408]: Recovering from system lockup, not allowing further RT threads.
Feb 11 04:36:41 saturn rtkit-daemon[3408]: Recovering from system lockup, not allowing further RT threads.
Feb 11 04:36:44 saturn kernel: [112424.567629] ADDRCONF(NETDEV_UP): eth0: link is not ready
Feb 11 04:36:44 saturn kernel: [112424.571848] r8169 0000:04:05.0: eth1: link up
Feb 11 04:36:44 saturn kernel: [112424.571882] r8169 0000:04:05.0: eth1: link up
Feb 11 04:36:44 saturn dnsmasq[3143]: no servers found in /etc/resolv.conf, will retry
Feb 11 04:36:44 saturn avahi-daemon[1658]: Joining mDNS multicast group on interface eth1.IPv4 with address 192.168.1.204.
Feb 11 04:36:44 saturn avahi-daemon[1658]: New relevant interface eth1.IPv4 for mDNS.
Feb 11 04:36:44 saturn avahi-daemon[1658]: Registering new address record for 192.168.1.204 on eth1.IPv4.
Feb 11 04:36:46 saturn avahi-daemon[1658]: Registering new address record for fe80::208:54ff:fe55:e1e7 on eth1.*.
Feb 11 04:36:46 saturn kernel: [112426.092986] ATL1E 0000:02:00.0: eth0: NIC Link is Up <100 Mbps Full Duplex>
Feb 11 04:36:46 saturn kernel: [112426.097195] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
Feb 11 04:36:46 saturn dnsmasq[3143]: reading /etc/resolv.conf
Feb 11 04:36:46 saturn dnsmasq[3143]: using nameserver 192.168.1.204#53
Feb 11 04:36:46 saturn avahi-daemon[1658]: Joining mDNS multicast group on interface eth0.IPv4 with address 10.1.1.3.
Feb 11 04:36:46 saturn avahi-daemon[1658]: New relevant interface eth0.IPv4 for mDNS.
Feb 11 04:36:46 saturn avahi-daemon[1658]: Registering new address record for 10.1.1.3 on eth0.IPv4.
Feb 11 04:36:46 saturn kernel: [112426.207274] INPUT DROP/REJECT IN=eth0 OUT= MAC= SRC=10.1.1.3 DST=224.0.0.251 LEN=105 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=85 
Feb 11 04:36:46 saturn kernel: [112426.357331] INPUT DROP/REJECT IN=eth0 OUT= MAC= SRC=10.1.1.3 DST=224.0.0.251 LEN=461 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=441 
Feb 11 04:36:46 saturn kernel: [112426.407047] INPUT DROP/REJECT IN=eth0 OUT= MAC= SRC=10.1.1.3 DST=224.0.0.251 LEN=334 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=314 
Feb 11 04:36:46 saturn kernel: [112426.607294] INPUT DROP/REJECT IN=eth0 OUT= MAC= SRC=10.1.1.3 DST=224.0.0.251 LEN=461 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=441 
Feb 11 04:36:46 saturn kernel: [112426.857553] INPUT DROP/REJECT IN=eth0 OUT= MAC= SRC=10.1.1.3 DST=224.0.0.251 LEN=461 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=441 
Feb 11 04:36:47 saturn kernel: [112427.057905] INPUT DROP/REJECT IN=eth0 OUT= MAC= SRC=10.1.1.3 DST=224.0.0.251 LEN=270 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=250 
Feb 11 04:36:47 saturn kernel: [112427.059407] INPUT DROP/REJECT IN=eth0 OUT= MAC= SRC=10.1.1.3 DST=224.0.0.251 LEN=206 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=186 
Feb 11 04:36:47 saturn kernel: [112427.206919] INPUT DROP/REJECT IN=eth0 OUT= MAC= SRC=10.1.1.3 DST=224.0.0.251 LEN=105 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=85 
Feb 11 04:36:47 saturn avahi-daemon[1658]: Registering new address record for fe80::224:8cff:fe44:49bc on eth0.*.
Feb 11 04:36:47 saturn kernel: [112427.607571] INPUT DROP/REJECT IN=eth0 OUT= MAC= SRC=10.1.1.3 DST=224.0.0.251 LEN=522 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=502 
Feb 11 04:36:47 saturn kernel: [112427.803272] INPUT DROP/REJECT IN=eth0 OUT= MAC= SRC=10.1.1.3 DST=224.0.0.251 LEN=178 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=158 
Feb 11 04:36:48 saturn kernel: [112428.053484] INPUT DROP/REJECT IN=eth0 OUT= MAC= SRC=10.1.1.3 DST=224.0.0.251 LEN=178 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=158 
Feb 11 04:36:48 saturn kernel: [112428.258502] INPUT DROP/REJECT IN=eth0 OUT= MAC= SRC=10.1.1.3 DST=224.0.0.251 LEN=286 TOS=0x00 PREC=0x00 TTL=255 ID=
--
All Adults share the Responsibility
to help Raise Today's Children,
for they are Tomorrow's Society!


      
