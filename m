From: Christopher Caruk <caruk@computer.org>
Subject: Please assist with missing RAID 5 array.
Date: Sun, 16 Jun 2013 11:20:36 +0000
Message-ID: <E1156523F009E84DA3511789DCE62C8D018D8B76B3@EXCHANGE.paulalima.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

I've experienced a catastrophic RAID-5 failure and while researching what to do about it I came across the raid.wiki.kernel.org page and will immediately encouraged by the first recommendation: don't panic.

I have tried the basic diagnostic steps on that page and attempted a -force to reassemble the array but it's not worked for me.  Rather than stumble about in the dark I thought it might be better to follow the recommendations on that page and request the assistance of the kind folk on this list.

I am running Centos 6.2 on an HP Proliant N36L.  The array was pretty straight forward and was created by Webmin.  Last night I discovered that the array was degraded and I wis in the process of reintroducing sdb (I think that it was sdb).

MDADM.CONF 
------------------
# mdadm.conf written out by anaconda
MAILADDR root
AUTO +imsm +1.x -all
DEVICE /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdb
ARRAY /dev/md0 level=raid5 devices=/dev/sdb,/dev/sdc,/dev/sdd,/dev/sde,/dev/sdb

...Strangely /dev/sdb shows twice.

DMESG
----------
Seems to show that all the RAID drives (ata3,4,5,6) are there:

scsi0 : pata_atiixp
scsi1 : pata_atiixp
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
ata1.01: ATA-8: VB0250EAVER, HPG0, max UDMA/100
ata1.01: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.01: limited to UDMA/33 due to 40-wire cable
ata1.01: configured for UDMA/33
scsi 0:0:1:0: Direct-Access     ATA      VB0250EAVER      HPG0 PQ: 0 ANSI: 5
Refined TSC clocksource calibration: 1297.838 MHz.
Switching to clocksource tsc
ahci 0000:00:11.0: version 3.0
  alloc irq_desc for 19 on node 0
  alloc kstat_irqs on node 0
ahci 0000:00:11.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
  alloc irq_desc for 25 on node 0
  alloc kstat_irqs on node 0
ahci 0000:00:11.0: irq 25 for MSI/MSI-X
ahci 0000:00:11.0: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum partscsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata3: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffd00 irq 25
ata4: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffd80 irq 25
ata5: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffe00 irq 25
ata6: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffe80 irq 25
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata6.00: ATA-7: SAMSUNG HD154UI, 1AG01118, max UDMA7
ata6.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata5.00: ATA-7: SAMSUNG HD154UI, 1AG01118, max UDMA7
ata5.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata4.00: ATA-7: SAMSUNG HD154UI, 1AG01118, max UDMA7
ata3.00: ATA-7: SAMSUNG HD154UI, 1AG01118, max UDMA7
ata3.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata4.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata4.00: configured for UDMA/133
ata6.00: configured for UDMA/133
ata5.00: configured for UDMA/133
ata3.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD154UI  1AG0 PQ: 0 ANSI: 5
scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD154UI  1AG0 PQ: 0 ANSI: 5
scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG HD154UI  1AG0 PQ: 0 ANSI: 5
scsi 5:0:0:0: Direct-Access     ATA      SAMSUNG HD154UI  1AG0 PQ: 0 ANSI: 5
sd 0:0:1:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:1:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdc] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
sd 4:0:0:0: [sdd] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
sd 3:0:0:0: [sdc] Write Protect is off
sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sde] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
sd 4:0:0:0: [sdd] Write Protect is off
sd 4:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
sd 3:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 5:0:0:0: [sde] Write Protect is off
sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 4:0:0:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sde:
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sdd:
sdb:
sda:
sdc: sda1 sda2
sd 0:0:1:0: [sda] Attached SCSI disk
sd 2:0:0:0: [sdb] Attached SCSI disk
sd 3:0:0:0: [sdc] Attached SCSI disk
sd 5:0:0:0: [sde] Attached SCSI disk
sd 4:0:0:0: [sdd] Attached SCSI disk

MESSAGES 
--------------
I can see that errors were being generated last night:

Jun 16 03:47:03 localhost kernel: imklog 4.6.2, log source = /proc/kmsg started.
Jun 16 03:47:03 localhost rsyslogd: [origin software="rsyslogd" swVersion="4.6.2" x-pid="1142" x-info="http://www.rsyslog.c
om"] (re)start
Jun 16 03:47:07 localhost kernel: Buffer I/O error on device md0, logical block 2
Jun 16 03:47:07 localhost abrt[25955]: saved core dump of pid 25954 (/sbin/reiserfstune) to /var/spool/abrt/ccpp-2013-06-16
-03:47:07-25954.new/coredump (356352 bytes)
Jun 16 03:47:07 localhost abrtd: Directory 'ccpp-2013-06-16-03:47:07-25954' creation detected
Jun 16 03:47:07 localhost abrtd: Package 'reiserfs-utils' isn't signed with proper key
Jun 16 03:47:07 localhost abrtd: Corrupted or bad dump /var/spool/abrt/ccpp-2013-06-16-03:47:07-25954 (res:2), deleting
Jun 16 03:49:11 localhost kernel: Buffer I/O error on device md0, logical block 740407384
Jun 16 03:49:11 localhost kernel: lost page write due to I/O error on md0
Jun 16 03:49:51 localhost kernel: Buffer I/O error on device md0, logical block 747934221
Jun 16 03:49:51 localhost kernel: lost page write due to I/O error on md0
Jun 16 03:50:16 localhost kernel: Buffer I/O error on device md0, logical block 537630240
Jun 16 03:50:16 localhost kernel: lost page write due to I/O error on md0
Jun 16 03:52:17 localhost kernel: Buffer I/O error on device md0, logical block 2
Jun 16 03:52:17 localhost abrt[26268]: saved core dump of pid 26267 (/sbin/reiserfstune) to /var/spool/abrt/ccpp-2013-06-16
-03:52:17-26267.new/coredump (356352 bytes)
Jun 16 03:52:17 localhost abrtd: Directory 'ccpp-2013-06-16-03:52:17-26267' creation detected
Jun 16 03:52:17 localhost abrtd: Package 'reiserfs-utils' isn't signed with proper key
Jun 16 03:52:17 localhost abrtd: Corrupted or bad dump /var/spool/abrt/ccpp-2013-06-16-03:52:17-26267 (res:2), deleting
Jun 16 03:53:21 localhost kernel: Buffer I/O error on device md0, logical block 740407385
Jun 16 03:53:21 localhost kernel: lost page write due to I/O error on md0
Jun 16 03:53:42 localhost smbd[1827]: [2013/06/16 03:53:42.395701,  0] smbd/server.c:281(remove_child_pid)
Jun 16 03:53:42 localhost smbd[1827]:   Could not find child 26390 -- ignoring
Jun 16 03:54:06 localhost kernel: Buffer I/O error on device md0, logical block 747934222
Jun 16 03:54:06 localhost kernel: lost page write due to I/O error on md0
Jun 16 03:54:26 localhost kernel: Buffer I/O error on device md0, logical block 537630241
Jun 16 03:54:26 localhost kernel: lost page write due to I/O error on md0
Jun 16 03:57:08 localhost ntpd[1683]: synchronized to 176.28.47.159, stratum 2
Jun 16 03:57:28 localhost kernel: Buffer I/O error on device md0, logical block 2
Jun 16 03:57:28 localhost abrt[26439]: saved core dump of pid 26438 (/sbin/reiserfstune) to /var/spool/abrt/ccpp-2013-06-16
-03:57:28-26438.new/coredump (356352 bytes)
Jun 16 03:57:28 localhost abrtd: Directory 'ccpp-2013-06-16-03:57:28-26438' creation detected
Jun 16 03:57:28 localhost abrtd: Package 'reiserfs-utils' isn't signed with proper key
Jun 16 03:57:28 localhost abrtd: Corrupted or bad dump /var/spool/abrt/ccpp-2013-06-16-03:57:28-26438 (res:2), deleting
Jun 16 03:57:31 localhost kernel: Buffer I/O error on device md0, logical block 740407386
Jun 16 03:57:31 localhost kernel: lost page write due to I/O error on md0
Jun 16 03:58:16 localhost kernel: Buffer I/O error on device md0, logical block 747941238
Jun 16 03:58:16 localhost kernel: lost page write due to I/O error on md0
Jun 16 03:58:36 localhost kernel: Buffer I/O error on device md0, logical block 537630242
Jun 16 03:58:36 localhost kernel: lost page write due to I/O error on md0
.
.
.
Jun 16 09:22:57 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:57 localhost smbd[2116]: [2013/06/16 09:22:57.792001,  0] smbd/service.c:988(make_connection_snum)
Jun 16 09:22:57 localhost smbd[2116]:   canonicalize_connect_path failed for service backuppc, path /volume1/backuppc
Jun 16 09:22:57 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:57 localhost smbd[2116]: [2013/06/16 09:22:57.797038,  0] smbd/service.c:988(make_connection_snum)
Jun 16 09:22:57 localhost smbd[2116]:   canonicalize_connect_path failed for service backuppc, path /volume1/backuppc
Jun 16 09:22:57 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:57 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost smbd[2116]: [2013/06/16 09:22:58.463427,  0] smbd/service.c:988(make_connection_snum)
Jun 16 09:22:58 localhost smbd[2116]:   canonicalize_connect_path failed for service backuppc, path /volume1/backuppc
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost smbd[2116]: [2013/06/16 09:22:58.466450,  0] smbd/service.c:988(make_connection_snum)
Jun 16 09:22:58 localhost smbd[2116]:   canonicalize_connect_path failed for service backuppc, path /volume1/backuppc
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost smbd[2116]: [2013/06/16 09:22:58.470470,  0] smbd/service.c:988(make_connection_snum)
Jun 16 09:22:58 localhost smbd[2116]:   canonicalize_connect_path failed for service mit-configuration-management, path /volume1/mit-configuration-management
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost smbd[2116]: [2013/06/16 09:22:58.474207,  0] smbd/service.c:988(make_connection_snum)
Jun 16 09:22:58 localhost smbd[2116]:   canonicalize_connect_path failed for service mit-configuration-management, path /volume1/mit-configuration-management
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost smbd[2116]: [2013/06/16 09:22:58.480450,  0] smbd/service.c:988(make_connection_snum)
Jun 16 09:22:58 localhost smbd[2116]:   canonicalize_connect_path failed for service mit-configuration-management, path /volume1/mit-configuration-management
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost smbd[2116]: [2013/06/16 09:22:58.483835,  0] smbd/service.c:988(make_connection_snum)
Jun 16 09:22:58 localhost smbd[2116]:   canonicalize_connect_path failed for service mit-configuration-management, path /volume1/mit-configuration-management
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost smbd[2116]: [2013/06/16 09:22:58.487533,  0] smbd/service.c:988(make_connection_snum)
Jun 16 09:22:58 localhost smbd[2116]:   canonicalize_connect_path failed for service backuppc, path /volume1/backuppc
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost smbd[2116]: [2013/06/16 09:22:58.491026,  0] smbd/service.c:988(make_connection_snum)
Jun 16 09:22:58 localhost smbd[2116]:   canonicalize_connect_path failed for service backuppc, path /volume1/backuppc
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost smbd[2116]: [2013/06/16 09:22:58.496553,  0] smbd/service.c:988(make_connection_snum)
Jun 16 09:22:58 localhost smbd[2116]:   canonicalize_connect_path failed for service mit-configuration-management, path /volume1/mit-configuration-management
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost smbd[2116]: [2013/06/16 09:22:58.499747,  0] smbd/service.c:988(make_connection_snum)
Jun 16 09:22:58 localhost smbd[2116]:   canonicalize_connect_path failed for service mit-configuration-management, path /volume1/mit-configuration-management
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost smbd[2116]: [2013/06/16 09:22:58.502720,  0] smbd/service.c:988(make_connection_snum)
Jun 16 09:22:58 localhost smbd[2116]:   canonicalize_connect_path failed for service backuppc, path /volume1/backuppc
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost smbd[2116]: [2013/06/16 09:22:58.507890,  0] smbd/service.c:988(make_connection_snum)
Jun 16 09:22:58 localhost smbd[2116]:   canonicalize_connect_path failed for service backuppc, path /volume1/backuppc
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost smbd[2116]: [2013/06/16 09:22:58.511862,  0] smbd/service.c:988(make_connection_snum)
Jun 16 09:22:58 localhost smbd[2116]:   canonicalize_connect_path failed for service mit-configuration-management, path /volume1/mit-configuration-management
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost smbd[2116]: [2013/06/16 09:22:58.514615,  0] smbd/service.c:988(make_connection_snum)
Jun 16 09:22:58 localhost smbd[2116]:   canonicalize_connect_path failed for service mit-configuration-management, path /volume1/mit-configuration-management
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost kernel: REISERFS error (device md0): zam-7001 reiserfs_find_entry: io error
Jun 16 09:22:58 localhost smbd[2116]: [2013/06/16 09:22:58.517137,  0] smbd/service.c:988(make_connection_snum)

... etc for each directory on the array

So....
-------

The first thing I attempted was a reboot.

.
.
.
Jun 16 09:27:23 localhost kernel: dracut: rd_NO_DM: removing DM RAID activation
Jun 16 09:27:23 localhost kernel: dracut: rd_NO_MD: removing MD RAID activation
Jun 16 09:27:23 localhost kernel: pata_atiixp 0000:00:14.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Jun 16 09:27:23 localhost kernel: scsi0 : pata_atiixp
Jun 16 09:27:23 localhost kernel: scsi1 : pata_atiixp
Jun 16 09:27:23 localhost kernel: ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
Jun 16 09:27:23 localhost kernel: ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
Jun 16 09:27:23 localhost kernel: ata1.01: ATA-8: VB0250EAVER, HPG0, max UDMA/100
Jun 16 09:27:23 localhost kernel: ata1.01: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
Jun 16 09:27:23 localhost kernel: ata1.01: limited to UDMA/33 due to 40-wire cable
Jun 16 09:27:23 localhost kernel: ata1.01: configured for UDMA/33
Jun 16 09:27:23 localhost kernel: scsi 0:0:1:0: Direct-Access     ATA      VB0250EAVER      HPG0 PQ: 0 ANSI: 5
Jun 16 09:27:23 localhost kernel: Refined TSC clocksource calibration: 1297.838 MHz.
Jun 16 09:27:23 localhost kernel: Switching to clocksource tsc
Jun 16 09:27:23 localhost kernel: ahci 0000:00:11.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Jun 16 09:27:23 localhost kernel: ahci 0000:00:11.0: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0xf impl SATA mode
Jun 16 09:27:23 localhost kernel: ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part
Jun 16 09:27:23 localhost kernel: scsi2 : ahci
Jun 16 09:27:23 localhost kernel: scsi3 : ahci
Jun 16 09:27:23 localhost kernel: scsi4 : ahci
Jun 16 09:27:23 localhost kernel: scsi5 : ahci
Jun 16 09:27:23 localhost kernel: ata3: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffd00 irq 25
Jun 16 09:27:23 localhost kernel: ata4: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffd80 irq 25
Jun 16 09:27:23 localhost kernel: ata5: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffe00 irq 25
Jun 16 09:27:23 localhost kernel: ata6: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffe80 irq 25
Jun 16 09:27:23 localhost kernel: ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jun 16 09:27:23 localhost kernel: ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jun 16 09:27:23 localhost kernel: ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jun 16 09:27:23 localhost kernel: ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jun 16 09:27:23 localhost kernel: ata3.00: ATA-7: SAMSUNG HD154UI, 1AG01118, max UDMA7
Jun 16 09:27:23 localhost kernel: ata3.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Jun 16 09:27:23 localhost kernel: ata4.00: ATA-7: SAMSUNG HD154UI, 1AG01118, max UDMA7
Jun 16 09:27:23 localhost kernel: ata4.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Jun 16 09:27:23 localhost kernel: ata5.00: ATA-7: SAMSUNG HD154UI, 1AG01118, max UDMA7
Jun 16 09:27:23 localhost kernel: ata5.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Jun 16 09:27:23 localhost kernel: ata6.00: ATA-7: SAMSUNG HD154UI, 1AG01118, max UDMA7
Jun 16 09:27:23 localhost kernel: ata6.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Jun 16 09:27:23 localhost kernel: ata3.00: configured for UDMA/133
Jun 16 09:27:23 localhost kernel: ata4.00: configured for UDMA/133
Jun 16 09:27:23 localhost kernel: ata5.00: configured for UDMA/133
Jun 16 09:27:23 localhost kernel: ata6.00: configured for UDMA/133
Jun 16 09:27:23 localhost kernel: scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD154UI  1AG0 PQ: 0 ANSI: 5
Jun 16 09:27:23 localhost kernel: scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD154UI  1AG0 PQ: 0 ANSI: 5
Jun 16 09:27:23 localhost kernel: scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG HD154UI  1AG0 PQ: 0 ANSI: 5
Jun 16 09:27:23 localhost kernel: scsi 5:0:0:0: Direct-Access     ATA      SAMSUNG HD154UI  1AG0 PQ: 0 ANSI: 5
Jun 16 09:27:23 localhost kernel: sd 0:0:1:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
Jun 16 09:27:23 localhost kernel: sd 0:0:1:0: [sda] Write Protect is off
Jun 16 09:27:23 localhost kernel: sd 0:0:1:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Jun 16 09:27:23 localhost kernel: sda:
Jun 16 09:27:23 localhost kernel: sd 2:0:0:0: [sdb] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
Jun 16 09:27:23 localhost kernel: sd 2:0:0:0: [sdb] Write Protect is off
Jun 16 09:27:23 localhost kernel: sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Jun 16 09:27:23 localhost kernel: sd 3:0:0:0: [sdc] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
Jun 16 09:27:23 localhost kernel: sd 3:0:0:0: [sdc] Write Protect is off
Jun 16 09:27:23 localhost kernel: sd 3:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Jun 16 09:27:23 localhost kernel: sdb:
Jun 16 09:27:23 localhost kernel: sdc:
Jun 16 09:27:23 localhost kernel: sd 4:0:0:0: [sdd] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
Jun 16 09:27:23 localhost kernel: sd 4:0:0:0: [sdd] Write Protect is off
Jun 16 09:27:23 localhost kernel: sd 4:0:0:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Jun 16 09:27:23 localhost kernel: sdd:
Jun 16 09:27:23 localhost kernel: sd 5:0:0:0: [sde] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
Jun 16 09:27:23 localhost kernel: sd 5:0:0:0: [sde] Write Protect is off
Jun 16 09:27:23 localhost kernel: sd 5:0:0:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Jun 16 09:27:23 localhost kernel: sde: sda1 sda2
Jun 16 09:27:23 localhost kernel: sd 0:0:1:0: [sda] Attached SCSI disk
Jun 16 09:27:23 localhost kernel: unknown partition table
Jun 16 09:27:23 localhost kernel: sd 3:0:0:0: [sdc] Attached SCSI disk
Jun 16 09:27:23 localhost kernel: unknown partition table
Jun 16 09:27:23 localhost kernel: sd 5:0:0:0: [sde] Attached SCSI disk
Jun 16 09:27:23 localhost kernel: unknown partition table
Jun 16 09:27:23 localhost kernel: sd 4:0:0:0: [sdd] Attached SCSI disk
Jun 16 09:27:23 localhost kernel: unknown partition table
Jun 16 09:27:23 localhost kernel: sd 2:0:0:0: [sdb] Attached SCSI disk
Jun 16 09:27:23 localhost kernel: dracut: Scanning devices sda2  for LVM logical volumes vg_martinfile/lv_root vg_martinfile/lv_swap
Jun 16 09:27:23 localhost kernel: dracut: inactive '/dev/vg_martinfile/lv_root' [50.00 GiB] inherit
Jun 16 09:27:23 localhost kernel: dracut: inactive '/dev/vg_martinfile/lv_home' [172.63 GiB] inherit
Jun 16 09:27:23 localhost kernel: dracut: inactive '/dev/vg_martinfile/lv_swap' [9.77 GiB] inherit
Jun 16 09:27:23 localhost kernel: EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts:
Jun 16 09:27:23 localhost kernel: dracut: Mounted root filesystem /dev/mapper/vg_martinfile-lv_root
Jun 16 09:27:23 localhost kernel: SELinux:  Disabled at runtime.
Jun 16 09:27:23 localhost kernel: type=1404 audit(1371371235.071:2): selinux=0 auid=4294967295 ses=4294967295
Jun 16 09:27:23 localhost kernel: dracut:
Jun 16 09:27:23 localhost kernel: dracut: Switching root
Jun 16 09:27:23 localhost kernel: readahead: starting
Jun 16 09:27:23 localhost kernel: udev: starting version 147
Jun 16 09:27:23 localhost kernel: shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Jun 16 09:27:23 localhost kernel: piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
Jun 16 09:27:23 localhost kernel: tg3.c:v3.119 (May 18, 2011)
Jun 16 09:27:23 localhost kernel: tg3 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jun 16 09:27:23 localhost kernel: tg3 0000:02:00.0: eth0: Tigon3 [partno(BCM95723) rev 5784100] (PCI Express) MAC address 3c:4a:92:79:c4:68
Jun 16 09:27:23 localhost kernel: tg3 0000:02:00.0: eth0: attached PHY is 5784 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
Jun 16 09:27:23 localhost kernel: tg3 0000:02:00.0: eth0: RXcsums[0] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
Jun 16 09:27:23 localhost kernel: tg3 0000:02:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
Jun 16 09:27:23 localhost kernel: MCE: In-kernel MCE decoding enabled.
Jun 16 09:27:23 localhost kernel: EDAC MC: Ver: 2.1.0 Apr 17 2012
Jun 16 09:27:23 localhost kernel: AMD64 EDAC driver v3.4.0
Jun 16 09:27:23 localhost kernel: EDAC amd64: DRAM ECC enabled.
Jun 16 09:27:23 localhost kernel: EDAC amd64: F10h detected (node 0).
Jun 16 09:27:23 localhost kernel: EDAC amd64: MC: 0:  2048MB 1:  2048MB
Jun 16 09:27:23 localhost kernel: EDAC amd64: MC: 2:     0MB 3:     0MB
Jun 16 09:27:23 localhost kernel: EDAC amd64: MC: 4:     0MB 5:     0MB
Jun 16 09:27:23 localhost kernel: EDAC amd64: MC: 6:     0MB 7:     0MB
Jun 16 09:27:23 localhost kernel: EDAC amd64: MC: 0:     0MB 1:     0MB
Jun 16 09:27:23 localhost kernel: EDAC amd64: MC: 2:     0MB 3:     0MB
Jun 16 09:27:23 localhost kernel: EDAC amd64: MC: 4:     0MB 5:     0MB
Jun 16 09:27:23 localhost kernel: EDAC amd64: MC: 6:     0MB 7:     0MB
Jun 16 09:27:23 localhost kernel: EDAC amd64: using x4 syndromes.
Jun 16 09:27:23 localhost kernel: EDAC amd64: MCT channel count: 1
Jun 16 09:27:23 localhost kernel: EDAC amd64: CS0: Unbuffered DDR3 RAM
Jun 16 09:27:23 localhost kernel: EDAC amd64: CS1: Unbuffered DDR3 RAM
Jun 16 09:27:23 localhost kernel: EDAC MC0: Giving out device to 'amd64_edac' 'F10h': DEV 0000:00:18.2
Jun 16 09:27:23 localhost kernel: EDAC PCI0: Giving out device to module 'amd64_edac' controller 'EDAC PCI controller': DEV '0000:00:18.2' (POLLED)
Jun 16 09:27:23 localhost kernel: platform microcode: firmware: requesting amd-ucode/microcode_amd.bin
Jun 16 09:27:23 localhost kernel: microcode: CPU0: patch_level=0x10000c8
Jun 16 09:27:23 localhost kernel: microcode: CPU1: patch_level=0x10000c8
Jun 16 09:27:23 localhost kernel: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Jun 16 09:27:23 localhost kernel: sd 0:0:1:0: Attached scsi generic sg0 type 0
Jun 16 09:27:23 localhost kernel: sd 2:0:0:0: Attached scsi generic sg1 type 0
Jun 16 09:27:23 localhost kernel: sd 3:0:0:0: Attached scsi generic sg2 type 0
Jun 16 09:27:23 localhost kernel: sd 4:0:0:0: Attached scsi generic sg3 type 0
Jun 16 09:27:23 localhost kernel: sd 5:0:0:0: Attached scsi generic sg4 type 0
Jun 16 09:27:23 localhost kernel: microcode: AMD microcode update via /dev/cpu/microcode not supported
Jun 16 09:27:23 localhost kernel: microcode: AMD microcode update via /dev/cpu/microcode not supported
Jun 16 09:27:23 localhost kernel: microcode: AMD microcode update via /dev/cpu/microcode not supported
Jun 16 09:27:23 localhost kernel: md: bind<sdd>
Jun 16 09:27:23 localhost kernel: md: bind<sdb>
Jun 16 09:27:23 localhost kernel: md: bind<sdc>
Jun 16 09:27:23 localhost kernel: md: bind<sde>
Jun 16 09:27:23 localhost kernel: md: kicking non-fresh sdd from array!
Jun 16 09:27:23 localhost kernel: md: unbind<sdd>
Jun 16 09:27:23 localhost kernel: md: export_rdev(sdd)
Jun 16 09:27:23 localhost kernel: async_tx: api initialized (async)
Jun 16 09:27:23 localhost kernel: xor: automatically using best checksumming function: generic_sse
Jun 16 09:27:23 localhost kernel:   generic_sse:  4228.000 MB/sec
Jun 16 09:27:23 localhost kernel: xor: using function: generic_sse (4228.000 MB/sec)
Jun 16 09:27:23 localhost kernel: raid6: int64x1   1097 MB/s
Jun 16 09:27:23 localhost kernel: raid6: int64x2   1546 MB/s
Jun 16 09:27:23 localhost kernel: raid6: int64x4   1160 MB/s
Jun 16 09:27:23 localhost kernel: raid6: int64x8   1007 MB/s
Jun 16 09:27:23 localhost kernel: raid6: sse2x1    1656 MB/s
Jun 16 09:27:23 localhost kernel: raid6: sse2x2    2113 MB/s
Jun 16 09:27:23 localhost kernel: raid6: sse2x4    2246 MB/s
Jun 16 09:27:23 localhost kernel: raid6: using algorithm sse2x4 (2246 MB/s)
Jun 16 09:27:23 localhost kernel: md: raid6 personality registered for level 6
Jun 16 09:27:23 localhost kernel: md: raid5 personality registered for level 5
Jun 16 09:27:23 localhost kernel: md: raid4 personality registered for level 4
Jun 16 09:27:23 localhost kernel: bio: create slab <bio-1> at 1
Jun 16 09:27:23 localhost kernel: md/raid:md0: device sde operational as raid disk 3
Jun 16 09:27:23 localhost kernel: md/raid:md0: device sdc operational as raid disk 1
Jun 16 09:27:23 localhost kernel: md/raid:md0: allocated 4282kB
Jun 16 09:27:23 localhost kernel: md/raid:md0: not enough operational devices (2/4 failed)
Jun 16 09:27:23 localhost kernel: md/raid:md0: failed to run raid set.
Jun 16 09:27:23 localhost kernel: md: pers->run() failed ...
Jun 16 09:27:23 localhost kernel: EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts:
Jun 16 09:27:23 localhost kernel: EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts:
Jun 16 09:27:23 localhost kernel: REISERFS warning (device md0): sh-2006 read_super_block: bread failed (dev md0, block 2, size 4096)
Jun 16 09:27:23 localhost kernel: REISERFS warning (device md0): sh-2006 read_super_block: bread failed (dev md0, block 16, size 4096)
Jun 16 09:27:23 localhost kernel: REISERFS warning (device md0): sh-2021 reiserfs_fill_super: can not find reiserfs on md0
Jun 16 09:27:23 localhost kernel: Adding 10239992k swap on /dev/mapper/vg_martinfile-lv_swap.  Priority:-1 extents:1 across:10239992k

... note: 
   Jun 16 09:27:23 localhost kernel: md: kicking non-fresh sdd from array! 
   Jun 16 09:27:23 localhost kernel: md: unbind<sdd>

Ok... so it's marked /dev/sdd as non-fresh and booted it from the array.. thus there are not enough drives to create the array.

So...
------

I powered down and unplugged and re inserted all the cables to see if there was a connection problem and restarted.  This time the drives came up but the array didn't

Jun 16 09:31:04 localhost kernel: dracut: rd_NO_DM: removing DM RAID activation
Jun 16 09:31:04 localhost kernel: dracut: rd_NO_MD: removing MD RAID activation
Jun 16 09:31:04 localhost kernel: pata_atiixp 0000:00:14.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Jun 16 09:31:04 localhost kernel: scsi0 : pata_atiixp
Jun 16 09:31:04 localhost kernel: scsi1 : pata_atiixp
Jun 16 09:31:04 localhost kernel: ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
Jun 16 09:31:04 localhost kernel: ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
Jun 16 09:31:04 localhost kernel: ata1.01: ATA-8: VB0250EAVER, HPG0, max UDMA/100
Jun 16 09:31:04 localhost kernel: ata1.01: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
Jun 16 09:31:04 localhost kernel: ata1.01: limited to UDMA/33 due to 40-wire cable
Jun 16 09:31:04 localhost kernel: ata1.01: configured for UDMA/33
Jun 16 09:31:04 localhost kernel: scsi 0:0:1:0: Direct-Access     ATA      VB0250EAVER      HPG0 PQ: 0 ANSI: 5
Jun 16 09:31:04 localhost kernel: Refined TSC clocksource calibration: 1297.838 MHz.
Jun 16 09:31:04 localhost kernel: Switching to clocksource tsc
Jun 16 09:31:04 localhost kernel: ahci 0000:00:11.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Jun 16 09:31:04 localhost kernel: ahci 0000:00:11.0: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0xf impl SATA mode
Jun 16 09:31:04 localhost kernel: ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part
Jun 16 09:31:04 localhost kernel: scsi2 : ahci
Jun 16 09:31:04 localhost kernel: scsi3 : ahci
Jun 16 09:31:04 localhost kernel: scsi4 : ahci
Jun 16 09:31:04 localhost kernel: scsi5 : ahci
Jun 16 09:31:04 localhost kernel: ata3: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffd00 irq 25
Jun 16 09:31:04 localhost kernel: ata4: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffd80 irq 25
Jun 16 09:31:04 localhost kernel: ata5: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffe00 irq 25
Jun 16 09:31:04 localhost kernel: ata6: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffe80 irq 25
Jun 16 09:31:04 localhost kernel: ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jun 16 09:31:04 localhost kernel: ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jun 16 09:31:04 localhost kernel: ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jun 16 09:31:04 localhost kernel: ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jun 16 09:31:04 localhost kernel: ata5.00: ATA-7: SAMSUNG HD154UI, 1AG01118, max UDMA7
Jun 16 09:31:04 localhost kernel: ata5.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Jun 16 09:31:04 localhost kernel: ata4.00: ATA-7: SAMSUNG HD154UI, 1AG01118, max UDMA7
Jun 16 09:31:04 localhost kernel: ata4.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Jun 16 09:31:04 localhost kernel: ata3.00: ATA-7: SAMSUNG HD154UI, 1AG01118, max UDMA7
Jun 16 09:31:04 localhost kernel: ata3.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Jun 16 09:31:04 localhost kernel: ata6.00: ATA-7: SAMSUNG HD154UI, 1AG01118, max UDMA7
Jun 16 09:31:04 localhost kernel: ata6.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Jun 16 09:31:04 localhost kernel: ata3.00: configured for UDMA/133
Jun 16 09:31:04 localhost kernel: ata4.00: configured for UDMA/133
Jun 16 09:31:04 localhost kernel: ata5.00: configured for UDMA/133
Jun 16 09:31:04 localhost kernel: ata6.00: configured for UDMA/133
Jun 16 09:31:04 localhost kernel: scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD154UI  1AG0 PQ: 0 ANSI: 5
Jun 16 09:31:04 localhost kernel: scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD154UI  1AG0 PQ: 0 ANSI: 5
Jun 16 09:31:04 localhost kernel: scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG HD154UI  1AG0 PQ: 0 ANSI: 5
Jun 16 09:31:04 localhost kernel: scsi 5:0:0:0: Direct-Access     ATA      SAMSUNG HD154UI  1AG0 PQ: 0 ANSI: 5
Jun 16 09:31:04 localhost kernel: sd 0:0:1:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
Jun 16 09:31:04 localhost kernel: sd 0:0:1:0: [sda] Write Protect is off
Jun 16 09:31:04 localhost kernel: sd 0:0:1:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Jun 16 09:31:04 localhost kernel: sd 3:0:0:0: [sdc] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
Jun 16 09:31:04 localhost kernel: sd 4:0:0:0: [sdd] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
Jun 16 09:31:04 localhost kernel: sd 4:0:0:0: [sdd] Write Protect is off
Jun 16 09:31:04 localhost kernel: sd 3:0:0:0: [sdc] Write Protect is off
Jun 16 09:31:04 localhost kernel: sd 5:0:0:0: [sde] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
Jun 16 09:31:04 localhost kernel: sd 4:0:0:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Jun 16 09:31:04 localhost kernel: sd 5:0:0:0: [sde] Write Protect is off
Jun 16 09:31:04 localhost kernel: sd 5:0:0:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Jun 16 09:31:04 localhost kernel: sd 3:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Jun 16 09:31:04 localhost kernel: sde:
Jun 16 09:31:04 localhost kernel: sd 2:0:0:0: [sdb] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
Jun 16 09:31:04 localhost kernel: sd 2:0:0:0: [sdb] Write Protect is off
Jun 16 09:31:04 localhost kernel: sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Jun 16 09:31:04 localhost kernel: sdc:
Jun 16 09:31:04 localhost kernel: sdb:
Jun 16 09:31:04 localhost kernel: sdd:
Jun 16 09:31:04 localhost kernel: sda: sda1 sda2
Jun 16 09:31:04 localhost kernel: sd 0:0:1:0: [sda] Attached SCSI disk
Jun 16 09:31:04 localhost kernel:
Jun 16 09:31:04 localhost kernel: sd 3:0:0:0: [sdc] Attached SCSI disk
Jun 16 09:31:04 localhost kernel:
Jun 16 09:31:04 localhost kernel:
Jun 16 09:31:04 localhost kernel: sd 5:0:0:0: [sde] Attached SCSI disk
Jun 16 09:31:04 localhost kernel: sd 2:0:0:0: [sdb] Attached SCSI disk
Jun 16 09:31:04 localhost kernel:
Jun 16 09:31:04 localhost kernel: sd 4:0:0:0: [sdd] Attached SCSI disk
Jun 16 09:31:04 localhost kernel: dracut: Scanning devices sda2  for LVM logical volumes vg_martinfile/lv_root vg_martinfile/lv_swap
Jun 16 09:31:04 localhost kernel: dracut: inactive '/dev/vg_martinfile/lv_root' [50.00 GiB] inherit
Jun 16 09:31:04 localhost kernel: dracut: inactive '/dev/vg_martinfile/lv_home' [172.63 GiB] inherit
Jun 16 09:31:04 localhost kernel: dracut: inactive '/dev/vg_martinfile/lv_swap' [9.77 GiB] inherit
Jun 16 09:31:04 localhost kernel: EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts:
Jun 16 09:31:04 localhost kernel: dracut: Mounted root filesystem /dev/mapper/vg_martinfile-lv_root
Jun 16 09:31:04 localhost kernel: SELinux:  Disabled at runtime.
Jun 16 09:31:04 localhost kernel: type=1404 audit(1371371456.184:2): selinux=0 auid=4294967295 ses=4294967295
Jun 16 09:31:04 localhost kernel: dracut:
Jun 16 09:31:04 localhost kernel: dracut: Switching root
Jun 16 09:31:04 localhost kernel: readahead: starting
Jun 16 09:31:04 localhost kernel: udev: starting version 147
Jun 16 09:31:04 localhost kernel: tg3.c:v3.119 (May 18, 2011)
Jun 16 09:31:04 localhost kernel: tg3 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jun 16 09:31:04 localhost kernel: tg3 0000:02:00.0: eth0: Tigon3 [partno(BCM95723) rev 5784100] (PCI Express) MAC address 3c:4a:92:79:c4:68
Jun 16 09:31:04 localhost kernel: tg3 0000:02:00.0: eth0: attached PHY is 5784 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
Jun 16 09:31:04 localhost kernel: tg3 0000:02:00.0: eth0: RXcsums[0] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
Jun 16 09:31:04 localhost kernel: tg3 0000:02:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
Jun 16 09:31:04 localhost kernel: piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
Jun 16 09:31:04 localhost kernel: shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Jun 16 09:31:04 localhost kernel: MCE: In-kernel MCE decoding enabled.
Jun 16 09:31:04 localhost kernel: EDAC MC: Ver: 2.1.0 Apr 17 2012
Jun 16 09:31:04 localhost kernel: AMD64 EDAC driver v3.4.0
Jun 16 09:31:04 localhost kernel: EDAC amd64: DRAM ECC enabled.
Jun 16 09:31:04 localhost kernel: EDAC amd64: F10h detected (node 0).
Jun 16 09:31:04 localhost kernel: EDAC amd64: MC: 0:  2048MB 1:  2048MB
Jun 16 09:31:04 localhost kernel: EDAC amd64: MC: 2:     0MB 3:     0MB
Jun 16 09:31:04 localhost kernel: EDAC amd64: MC: 4:     0MB 5:     0MB
Jun 16 09:31:04 localhost kernel: EDAC amd64: MC: 6:     0MB 7:     0MB
Jun 16 09:31:04 localhost kernel: EDAC amd64: MC: 0:     0MB 1:     0MB
Jun 16 09:31:04 localhost kernel: EDAC amd64: MC: 2:     0MB 3:     0MB
Jun 16 09:31:04 localhost kernel: EDAC amd64: MC: 4:     0MB 5:     0MB
Jun 16 09:31:04 localhost kernel: EDAC amd64: MC: 6:     0MB 7:     0MB
Jun 16 09:31:04 localhost kernel: EDAC amd64: using x4 syndromes.
Jun 16 09:31:04 localhost kernel: EDAC amd64: MCT channel count: 1
Jun 16 09:31:04 localhost kernel: EDAC amd64: CS0: Unbuffered DDR3 RAM
Jun 16 09:31:04 localhost kernel: EDAC amd64: CS1: Unbuffered DDR3 RAM
Jun 16 09:31:04 localhost kernel: EDAC MC0: Giving out device to 'amd64_edac' 'F10h': DEV 0000:00:18.2
Jun 16 09:31:04 localhost kernel: EDAC PCI0: Giving out device to module 'amd64_edac' controller 'EDAC PCI controller': DEV '0000:00:18.2' (POLLED)
Jun 16 09:31:04 localhost kernel: platform microcode: firmware: requesting amd-ucode/microcode_amd.bin
Jun 16 09:31:04 localhost kernel: microcode: CPU0: patch_level=0x10000c8
Jun 16 09:31:04 localhost kernel: microcode: CPU1: patch_level=0x10000c8
Jun 16 09:31:04 localhost kernel: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Jun 16 09:31:04 localhost kernel: microcode: AMD microcode update via /dev/cpu/microcode not supported
Jun 16 09:31:04 localhost kernel: microcode: AMD microcode update via /dev/cpu/microcode not supported
Jun 16 09:31:04 localhost kernel: sd 0:0:1:0: Attached scsi generic sg0 type 0
Jun 16 09:31:04 localhost kernel: sd 2:0:0:0: Attached scsi generic sg1 type 0
Jun 16 09:31:04 localhost kernel: sd 3:0:0:0: Attached scsi generic sg2 type 0
Jun 16 09:31:04 localhost kernel: sd 4:0:0:0: Attached scsi generic sg3 type 0
Jun 16 09:31:04 localhost kernel: sd 5:0:0:0: Attached scsi generic sg4 type 0
.
.
.
... note that this time the drives were recognized as standard drives not md array components.

SUPERBLOCKS
------------------
I've tried to preserve but I do not seem to be getting anything.

[root@localhost ~]# mdadm --examine /dev/sd[bcde]
/dev/sdb:
   MBR Magic : aa55
Partition[0] :   2930277167 sectors at            1 (type ee)
/dev/sdc:
   MBR Magic : aa55
Partition[0] :   2930277167 sectors at            1 (type ee)
/dev/sdd:
   MBR Magic : aa55
Partition[0] :   2930277167 sectors at            1 (type ee)
/dev/sde:
   MBR Magic : aa55
Partition[0] :   2930277167 sectors at            1 (type ee)

Which does not seem right to me.

Likewise checking the event count did not result in anything useful.

[root@localhost ~]# mdadm --examine /dev/sd[a-z] | egrep 'Event|/dev/sd'
/dev/sda:
/dev/sdb:
/dev/sdc:
/dev/sdd:
/dev/sde:


Where NEXT?
-----------------
This is where I read that I could really mess things up by attempting a recreation so I thought that I should ask here first.

Assistance would be greatly appreciated!

Thanks in advance 
Chris





