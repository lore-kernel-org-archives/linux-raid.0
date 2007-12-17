From: "Daniel L. Miller" <dmiller@amfes.com>
Subject: Re: Raid-10 mount at startup always has problem
Date: Mon, 17 Dec 2007 06:58:21 -0800
Message-ID: <47668E8D.2060806@amfes.com>
References: <46E4A39C.8040509@amfes.com> <46E4A5F0.9090407@sauce.co.nz>	 <46E4A7C3.1040902@amfes.com> <471F5542.3020504@amfes.com>	 <471FA485.6010705@tmr.com> <47202D17.3040000@amfes.com>	 <1193294406.10336.76.camel@firewall.xsintricity.com>	 <472576A5.3030603@amfes.com> <20071029081802.GB15475@percy.comedia.it>	 <1193672839.10336.443.camel@firewall.xsintricity.com>	 <20071029212927.GA24635@percy.comedia.it> <1193699701.10336.508.camel@firewall.xsintricity.com> <472674D6.5030703@amfes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <472674D6.5030703@amfes.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Daniel L. Miller wrote:
> Doug Ledford wrote:
>> Nah.  Even if we had concluded that udev was to blame here, I'm not
>> entirely certain that we hadn't left Daniel with the impression that we
>> suspected it versus blamed it, so reiterating it doesn't hurt.  And I'm
>> sure no one has given him a fix for the problem (although Neil did
>> request a change that will give debug output, but not solve the
>> problem), so not dropping it entirely would seem appropriate as well.
>>   
> I've opened a bug report on Ubuntu's Launchpad.net.  Scott James 
> Remnant asked me to cc him on Neil's incremental reference - we'll see 
> what happens from here.
>
> Thanks for the help guys.  At the moment, I've changed my mdadm.conf 
> to explicitly list the drives, instead of the auto=partition 
> parameter.  We'll see what happens on the next reboot.
>
> I don't know if it means anything, but I'm using a self-compiled 
> 2.6.22 kernel - with initrd.  At least I THINK I'm using initrd - I 
> have an image, but I don't see an initrd line in my grub config.  
> Hmm....I'm going to add a stanza that includes the initrd and see what 
> happens also.
>
Wow.  Been a while since I asked about this - I just realized a reboot 
or two has come and gone.  I checked my md status - everything was 
online!  Cool.

My current dmesg output:
sata_nv 0000:00:07.0: version 3.4
ACPI: PCI Interrupt Link [LTID] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [LTID] -> GSI 23 (level, 
high) -> IR                                                        Q 23
sata_nv 0000:00:07.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:07.0 to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0xffffc20001428480 ctl 0xffffc200014284a0 
bmdma 0x00                                                        
00000000011410 irq 23
ata2: SATA max UDMA/133 cmd 0xffffc20001428580 ctl 0xffffc200014285a0 
bmdma 0x00                                                        
00000000011418 irq 23
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: ST3160811AS, 3.AAE, max UDMA/133
ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-7: ST3160811AS, 3.AAE, max UDMA/133
ata2.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST3160811AS      3.AA PQ: 0 ANSI: 5
ata1: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw 
segs 61
scsi 1:0:0:0: Direct-Access     ATA      ST3160811AS      3.AA PQ: 0 ANSI: 5
ata2: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw 
segs 61
ACPI: PCI Interrupt Link [LSI1] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LSI1] -> GSI 22 (level, 
high) -> IR                                                        Q 22
sata_nv 0000:00:08.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:08.0 to 64
scsi2 : sata_nv
scsi3 : sata_nv
ata3: SATA max UDMA/133 cmd 0xffffc2000142a480 ctl 0xffffc2000142a4a0 
bmdma 0x00                                                        
00000000011420 irq 22
ata4: SATA max UDMA/133 cmd 0xffffc2000142a580 ctl 0xffffc2000142a5a0 
bmdma 0x00                                                        
00000000011428 irq 22
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-7: ST3160811AS, 3.AAE, max UDMA/133
ata3.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/133
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ATA-7: ST3160811AS, 3.AAE, max UDMA/133
ata4.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata4.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      ST3160811AS      3.AA PQ: 0 ANSI: 5
ata3: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw 
segs 61
scsi 3:0:0:0: Direct-Access     ATA      ST3160811AS      3.AA PQ: 0 ANSI: 5
ata4: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw 
segs 61
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO                                                         or FUA
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO                                                         or FUA
 sda: unknown partition table
sd 0:0:0:0: [sda] Attached SCSI disk
sd 1:0:0:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO                                                         or FUA
sd 1:0:0:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO                                                         or FUA
 sdb: unknown partition table
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 2:0:0:0: [sdc] 312581808 512-byte hardware sectors (160042 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't 
support DPO                                                         or FUA
sd 2:0:0:0: [sdc] 312581808 512-byte hardware sectors (160042 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't 
support DPO                                                         or FUA
 sdc: unknown partition table
sd 2:0:0:0: [sdc] Attached SCSI disk
sd 3:0:0:0: [sdd] 312581808 512-byte hardware sectors (160042 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't 
support DPO                                                         or FUA
sd 3:0:0:0: [sdd] 312581808 512-byte hardware sectors (160042 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't 
support DPO                                                         or FUA
 sdd: unknown partition table
sd 3:0:0:0: [sdd] Attached SCSI disk
Adding 8000328k swap on /dev/hda5.  Priority:-1 extents:1 across:8000328k
EXT3 FS on hda1, internal journal
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: 
dm-devel@redhat.com
md: md0 stopped.
md: bind<sdb>
md: bind<sdc>
md: bind<sdd>
md: bind<sda>
md: md0: raid array is not clean -- starting background reconstruction
raid10: raid set md0 active with 4 out of 4 devices
md: resync of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 
KB/sec)                                                         for resync.
md: using 128k window, over a total of 312581632 blocks.
tg3: eth0: Link is up at 1000 Mbps, full duplex.
tg3: eth0: Flow control is on for TX and on for RX.
Filesystem "md0": Disabling barriers, not supported by the underlying device
XFS mounting filesystem md0
Starting XFS recovery on filesystem: md0 (logdev: internal)
Ending XFS recovery on filesystem: md0 (logdev: internal)
XFS mounting filesystem hda2
Starting XFS recovery on filesystem: hda2 (logdev: internal)
Ending XFS recovery on filesystem: hda2 (logdev: internal)
XFS mounting filesystem hda3
Starting XFS recovery on filesystem: hda3 (logdev: internal)
Ending XFS recovery on filesystem: hda3 (logdev: internal)
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
PM: Writing back config space on device 0000:0a:09.1 at offset b (was 
164814e4,                                                         
writing 164414e4)
PM: Writing back config space on device 0000:0a:09.1 at offset 3 (was 
804000, wr                                                        iting 
804010)
PM: Writing back config space on device 0000:0a:09.1 at offset 2 (was 
2000000, w                                                        riting 
2000003)
PM: Writing back config space on device 0000:0a:09.1 at offset 1 (was 
2b00000, w                                                        riting 
2b00106)
ADDRCONF(NETDEV_UP): eth1: link is not ready
Bridge firewalling registered
device eth1 entered promiscuous mode
audit(1197159016.060:2): dev=eth1 prom=256 old_prom=0 auid=4294967295
device tap1 entered promiscuous mode
audit(1197159016.060:3): dev=tap1 prom=256 old_prom=0 auid=4294967295
br1: starting userspace STP failed, staring kernel STP
br1: port 2(tap1) entering listening state
tg3: eth1: Link is up at 1000 Mbps, full duplex.
tg3: eth1: Flow control is on for TX and on for RX.
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
br1: port 1(eth1) entering listening state
br1: port 2(tap1) entering learning state
br1: port 1(eth1) entering learning state
eth0: no IPv6 routers present
br1: topology change detected, propagating
br1: port 2(tap1) entering forwarding state
tap1: no IPv6 routers present
br1: no IPv6 routers present
br1: topology change detected, propagating
br1: port 1(eth1) entering forwarding state
eth1: no IPv6 routers present
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (8192 buckets, 65536 max)
tun0: Disabled Privacy Extensions
parport_pc 00:0c: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 
[PCSPP,TRISTATE,COMPAT,EPP,ECP                                                        
,DMA]
lp0: using parport0 (interrupt-driven).
NET: Registered protocol family 17
vmmon: module license 'unspecified' taints kernel.
/dev/vmmon[4622]: VMCI: Driver initialized.
/dev/vmmon[4622]: Module vmmon: registered with major=10 minor=165
/dev/vmmon[4622]: Module vmmon: initialized
/dev/vmnet: open called by PID 4649 (vmnet-bridge)
/dev/vmnet: hub 0 does not exist, allocating memory.
/dev/vmnet: port on hub 0 successfully opened
bridge-br1: enabling the bridge
bridge-br1: up
bridge-br1: already up
bridge-br1: attached
/dev/vmnet: open called by PID 4663 (vmnet-natd)
/dev/vmnet: hub 8 does not exist, allocating memory.
/dev/vmnet: port on hub 8 successfully opened
/dev/vmnet: open called by PID 4668 (vmnet-netifup)
/dev/vmnet: port on hub 8 successfully opened
/dev/vmnet: open called by PID 4679 (vmnet-dhcpd)
/dev/vmnet: port on hub 8 successfully opened
vmnet8: no IPv6 routers present
/dev/vmnet: open called by PID 4798 (vmware-vmx)
device br1 entered promiscuous mode
audit(1197159105.109:4): dev=br1 prom=256 old_prom=0 auid=4294967295
bridge-br1: enabled promiscuous mode
/dev/vmnet: port on hub 0 successfully opened
/dev/vmmon[4864]: host clock rate change request 0 -> 19
/dev/vmmon[4864]: host clock rate change request 19 -> 83
device br1 left promiscuous mode
audit(1197159183.647:5): dev=br1 prom=0 old_prom=256 auid=4294967295
bridge-br1: disabled promiscuous mode
/dev/vmnet: open called by PID 4864 (vmware-vmx)
device br1 entered promiscuous mode
audit(1197159183.647:6): dev=br1 prom=256 old_prom=0 auid=4294967295
bridge-br1: enabled promiscuous mode
/dev/vmnet: port on hub 0 successfully opened
/dev/vmnet: open called by PID 4945 (vmware-vmx)
/dev/vmnet: port on hub 0 successfully opened
/dev/vmnet: open called by PID 4983 (vmware-vmx)
/dev/vmnet: port on hub 0 successfully opened
md: md0: resync done.
RAID10 conf printout:
 --- wd:4 rd:4
 disk 0, wo:0, o:1, dev:sda
 disk 1, wo:0, o:1, dev:sdb
 disk 2, wo:0, o:1, dev:sdc
 disk 3, wo:0, o:1, dev:sdd
/dev/vmnet: open called by PID 4983 (vmware-vmx)
/dev/vmnet: port on hub 0 successfully opened
vmmon: Had to deallocate locked 118026 pages from vm driver ffff810123e5a000
vmmon: Had to deallocate AWE 3437 pages from vm driver ffff810123e5a000


-- 
Daniel
