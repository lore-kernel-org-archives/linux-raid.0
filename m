From: "lrhorer@satx.rr.com" <lrhorer@satx.rr.com>
Subject: Spurious HD convictions
Date: Sat, 12 Dec 2009 20:02:44 -0600
Message-ID: <200912122002.45031.lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	What's happening here?  Suddenly, my backup server is suffering apparently 
spurious hard drive convictions.  The server is running RAID5 on 7 disks 
under md.  It has been running well for months, but suddenly it has started 
kicking drives from the array when under moderately heavy read or write 
loads.  The thing is, it isn't convicting any particular drive repeatedly, 
and the drives are not showing any errors under SMART.  This is a PM system, 
and I have tried changing the drive adapters, changing the PMs, changing 
cables, moving the drives around, and moving them out of the CPU enclosure to 
a new external chassis.  The convictions are not occurring on any one 
channel, over any one particular PM, or over any particular cable.  Since 
this started happening, I have been unable to get all the way through a 
resync before the array dumps at least one of the drives.  Here is a sample 
from the kernel log during one of the convictions:

Dec 12 13:03:39 Backup kernel: [56319.397992] ata6.00: failed to read SCR 1 
(Emask=0x40) Dec 12 13:03:39 Backup kernel: [56319.397999] ata6.01: failed to 
read SCR 1 (Emask=0x40) Dec 12 13:03:39 Backup kernel: [56319.398001] 
ata6.02: failed to read SCR 1 (Emask=0x40) Dec 12 13:03:39 Backup kernel: 
[56319.398006] ata6.03: failed to read SCR 1 (Emask=0x40) Dec 12 13:03:39 
Backup kernel: [56319.398008] ata6.04: failed to read SCR 1 (Emask=0x40) Dec 
12 13:03:39 Backup kernel: [56319.398010] ata6.05: failed to read SCR 1 
(Emask=0x40) Dec 12 13:03:39 Backup kernel: [56319.398014] ata6.15: exception 
Emask 0x4 SAct 0x0 SErr 0x0 action 0x6 frozen Dec 12 13:03:39 Backup kernel: 
[56319.398018] ata6.00: exception Emask 0x100 SAct 0x0 SErr 0x0 action 0x6 
frozen Dec 12 13:03:39 Backup kernel: [56319.398022] ata6.00: cmd 
ea/00:00:00:00:00/00:00:00:00:00/a0 tag 2
Dec 12 13:03:39 Backup kernel: [56319.398023]          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Dec 12 13:03:39 Backup kernel: [56319.398025] ata6.00: status: { DRDY } Dec 12 
13:03:39 Backup kernel: [56319.398028] ata6.01: exception Emask 0x100 SAct 
0x0 SErr 0x0 action 0x6 frozen Dec 12 13:03:39 Backup kernel: [56319.398031] 
ata6.02: exception Emask 0x100 SAct 0x0 SErr 0x0 action 0x6 frozen Dec 12 
13:03:39 Backup kernel: [56319.398034] ata6.03: exception Emask 0x100 SAct 
0x0 SErr 0x0 action 0x6 frozen Dec 12 13:03:39 Backup kernel: [56319.398037] 
ata6.04: exception Emask 0x100 SAct 0x0 SErr 0x0 action 0x6 frozen Dec 12 
13:03:39 Backup kernel: [56319.398040] ata6.05: exception Emask 0x100 SAct 
0x0 SErr 0x0 action 0x6 frozen Dec 12 13:03:39 Backup kernel: [56319.398044] 
ata6.15: hard resetting link Dec 12 13:03:41 Backup kernel: [56321.597384] 
ata6.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0) Dec 12 13:03:41 
Backup kernel: [56321.597864] ata6.00: hard resetting link Dec 12 13:03:42 
Backup kernel: [56321.933843] ata6.00: SATA link up 3.0 Gbps (SStatus 123 
SControl 320) Dec 12 13:03:42 Backup kernel: [56321.933849] ata6.01: hard 
resetting link Dec 12 13:03:42 Backup kernel: [56322.294048] ata6.01: SATA 
link up 3.0 Gbps (SStatus 123 SControl 300) Dec 12 13:03:42 Backup kernel: 
[56322.294055] ata6.02: hard resetting link Dec 12 13:03:42 Backup kernel: 
[56322.642243] ata6.02: SATA link down (SStatus 0 SControl 320) Dec 12 
13:03:42 Backup kernel: [56322.646087] ata6.03: hard resetting link Dec 12 
13:03:43 Backup kernel: [56323.006393] ata6.03: SATA link up 3.0 Gbps 
(SStatus 123 SControl 300) Dec 12 13:03:43 Backup kernel: [56323.006400] 
ata6.04: hard resetting link Dec 12 13:03:43 Backup kernel: [56323.354708] 
ata6.04: SATA link up 1.5 Gbps (SStatus 113 SControl 300) Dec 12 13:03:43 
Backup kernel: [56323.354714] ata6.05: hard resetting link Dec 12 13:03:43 
Backup kernel: [56323.690211] ata6.05: SATA link up 1.5 Gbps (SStatus 113 
SControl 320) Dec 12 13:03:43 Backup kernel: [56323.694555] ata6.00: 
configured for UDMA/100 Dec 12 13:03:43 Backup kernel: [56323.695732] 
ata6.01: configured for UDMA/100 Dec 12 13:03:44 Backup kernel: 
[56323.703212] ata6.03: configured for UDMA/100 Dec 12 13:03:44 Backup 
kernel: [56323.803119] ata6.04: configured for UDMA/100 Dec 12 13:03:44 
Backup kernel: [56323.803188] ata6: EH complete Dec 12 13:03:44 Backup 
kernel: [56323.803119] sd 5:0:0:0: [sde] 2930277168 512-byte hardware sectors 
(1500302 MB) Dec 12 13:03:44 Backup kernel: [56323.803119] sd 5:0:0:0: [sde] 
Write Protect is off Dec 12 13:03:44 Backup kernel: [56323.803119] sd 
5:0:0:0: [sde] Mode Sense: 00 3a 00 00 Dec 12 13:03:44 Backup kernel: 
[56323.803119] sd 5:0:0:0: [sde] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA Dec 12 13:03:44 Backup kernel: [56323.803119] sd 
5:1:0:0: [sdf] 2930277168 512-byte hardware sectors (1500302 MB) Dec 12 
13:03:44 Backup kernel: [56323.803119] sd 5:1:0:0: [sdf] Write Protect is off 
Dec 12 13:03:44 Backup kernel: [56323.803119] sd 5:1:0:0: [sdf] Mode Sense: 
00 3a 00 00 Dec 12 13:03:44 Backup kernel: [56323.803119] sd 5:1:0:0: [sdf] 
Write cache: enabled, read cache: enabled, doesn't support DPO or FUA Dec 12 
13:03:44 Backup kernel: [56323.803119] sd 5:3:0:0: [sdg] 2930277168 512-byte 
hardware sectors (1500302 MB) Dec 12 13:03:44 Backup kernel: [56323.803119] 
sd 5:3:0:0: [sdg] Write Protect is off Dec 12 13:03:44 Backup kernel: 
[56323.803119] sd 5:3:0:0: [sdg] Mode Sense: 00 3a 00 00 Dec 12 13:03:44 
Backup kernel: [56323.803119] sd 5:3:0:0: [sdg] Write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA Dec 12 13:03:44 Backup kernel: 
[56323.803119] sd 5:4:0:0: [sdh] 625142448 512-byte hardware sectors (320073 
MB) Dec 12 13:03:44 Backup kernel: [56323.803119] sd 5:4:0:0: [sdh] Write 
Protect is off Dec 12 13:03:44 Backup kernel: [56323.803119] sd 5:4:0:0: 
[sdh] Mode Sense: 00 3a 00 00 Dec 12 13:03:44 Backup kernel: [56323.803119] 
sd 5:4:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA Dec 12 13:03:44 Backup kernel: [56323.803119] sd 5:0:0:0: [sde] 
2930277168 512-byte hardware sectors (1500302 MB) Dec 12 13:03:44 Backup 
kernel: [56323.803119] sd 5:0:0:0: [sde] Write Protect is off Dec 12 13:03:44 
Backup kernel: [56323.803119] sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00 Dec 
12 13:03:44 Backup kernel: [56323.803119] sd 5:0:0:0: [sde] Write cache: 
enabled, read cache: enabled, doesn't support DPO or FUA Dec 12 13:03:44 
Backup kernel: [56323.803119] sd 5:1:0:0: [sdf] 2930277168 512-byte hardware 
sectors (1500302 MB) Dec 12 13:03:44 Backup kernel: [56323.803119] sd 
5:1:0:0: [sdf] Write Protect is off Dec 12 13:03:44 Backup kernel: 
[56323.803119] sd 5:1:0:0: [sdf] Mode Sense: 00 3a 00 00 Dec 12 13:03:44 
Backup kernel: [56323.803119] sd 5:1:0:0: [sdf] Write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA Dec 12 13:03:44 Backup kernel: 
[56323.803119] sd 5:3:0:0: [sdg] 2930277168 512-byte hardware sectors 
(1500302 MB) Dec 12 13:03:44 Backup kernel: [56323.803119] sd 5:3:0:0: [sdg] 
Write Protect is off Dec 12 13:03:44 Backup kernel: [56323.803119] sd 
5:3:0:0: [sdg] Mode Sense: 00 3a 00 00 Dec 12 13:03:44 Backup kernel: 
[56323.803119] sd 5:3:0:0: [sdg] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA Dec 12 13:03:44 Backup kernel: [56323.803119] sd 
5:4:0:0: [sdh] 625142448 512-byte hardware sectors (320073 MB) Dec 12 
13:03:44 Backup kernel: [56323.803119] sd 5:4:0:0: [sdh] Write Protect is off 
Dec 12 13:03:44 Backup kernel: [56323.803119] sd 5:4:0:0: [sdh] Mode Sense: 
00 3a 00 00 Dec 12 13:03:44 Backup kernel: [56323.807115] sd 5:4:0:0: [sdh] 
Write cache: enabled, read cache: enabled, doesn't support DPO or FUA Dec 12 
13:03:44 Backup kernel: [56323.839100] end_request: I/O error, dev sde, 
sector 10 Dec 12 13:03:44 Backup kernel: [56323.839100] md: super_written 
gets error=-5, uptodate=0 Dec 12 13:03:44 Backup kernel: [56323.839100] 
raid5: Disk failure on sde, disabling device.
Dec 12 13:03:44 Backup kernel: [56323.839100] raid5: Operation continuing on 6 
devices.
