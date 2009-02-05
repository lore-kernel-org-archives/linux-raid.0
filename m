From: Vladimir Ivashchenko <hazard@francoudi.com>
Subject: Re: sun x4500 soft lockup during raid creation
Date: Thu, 05 Feb 2009 18:10:07 +0200
Message-ID: <1233850207.13374.35.camel@hazard2.francoudi.com>
References: <1233174633.7008.34.camel@hazard2.francoudi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1233174633.7008.34.camel@hazard2.francoudi.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Ok, further updates:

I have installed a 64-bit CentOS5 and put x86_64  2.6.26.8-57.fc8 Fedora
kernel on it.

The RAID creation was mostly quiet, apart from a few softluckups as
described below.

Then we tried inserting and removing a HDD. As expected, it didn't fully
work properly, but at least the machine have not crashed. The arrays
didn't have any load though. From being /dev/sdat the disk
became /dev/sdax. For some reason mdadm was reporting the array and the
disk itself to be healthy, but the device entry for the removed hard
drive #19 was empty with wrong major/minor numbers.

Reading about sata_mv driver, it seems that hotplug is known to be
problematic, so we're going to try OpenSolaris. However I have another
X4500 for a few days, and if any developers would like me to check
something, I will try to do it.

*** HOT PLUG ***

Feb  5 15:48:21 SunSTG kernel: ata46: exception Emask 0x10 SAct 0x0 SErr
0x180000 action 0x6 frozen
Feb  5 15:48:21 SunSTG kernel: ata46: edma_err_cause=02000020
pp_flags=00000002, SError=00180000
Feb  5 15:48:21 SunSTG kernel: ata46: SError: { 10B8B Dispar }
Feb  5 15:48:21 SunSTG kernel: ata46: hard resetting link
Feb  5 15:48:21 SunSTG kernel: ata46: SATA link down (SStatus 0 SControl
300)
Feb  5 15:48:21 SunSTG kernel: ata46: failed to recover some devices,
retrying in 5 secs
Feb  5 15:48:26 SunSTG kernel: ata46: hard resetting link
Feb  5 15:48:27 SunSTG kernel: ata46: SATA link down (SStatus 0 SControl
300)
Feb  5 15:48:27 SunSTG kernel: ata46: failed to recover some devices,
retrying in 5 secs
Feb  5 15:48:32 SunSTG kernel: ata46: hard resetting link
Feb  5 15:48:32 SunSTG kernel: ata46: SATA link down (SStatus 0 SControl
300)
Feb  5 15:48:32 SunSTG kernel: ata46.00: disabled
Feb  5 15:48:32 SunSTG kernel: ata46: EH complete
Feb  5 15:48:32 SunSTG kernel: ata46.00: detaching (SCSI 45:0:0:0)
Feb  5 15:48:32 SunSTG kernel: sd 45:0:0:0: [sdat] Stopping disk
Feb  5 15:48:32 SunSTG kernel: sd 45:0:0:0: [sdat] START_STOP FAILED
Feb  5 15:48:32 SunSTG kernel: sd 45:0:0:0: [sdat] Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Feb  5 15:51:05 SunSTG kernel: ata46: exception Emask 0x10 SAct 0x0 SErr
0x4010000 action 0xe frozen
Feb  5 15:51:05 SunSTG kernel: ata46: edma_err_cause=00000010
pp_flags=00000002, dev connect
Feb  5 15:51:05 SunSTG kernel: ata46: SError: { PHYRdyChg DevExch }
Feb  5 15:51:05 SunSTG kernel: ata46: hard resetting link
Feb  5 15:51:11 SunSTG kernel: ata46: link is slow to respond, please be
patient (ready=0)
Feb  5 15:51:12 SunSTG kernel: ata46: SATA link up 3.0 Gbps (SStatus 123
SControl 300)
Feb  5 15:51:12 SunSTG kernel: ata46.00: HPA detected: current
488390625, native 488397168
Feb  5 15:51:12 SunSTG kernel: ata46.00: ATA-7: SEAGATE ST32500NSSUN250G
0830B85CNR,     3AZQ, max UDMA/133
Feb  5 15:51:12 SunSTG kernel: ata46.00: 488390625 sectors, multi 0:
LBA48 NCQ (depth 31/32)
Feb  5 15:51:12 SunSTG kernel: ata46.00: max_sectors limited to 256 for
NCQ
Feb  5 15:51:12 SunSTG kernel: ata46.00: max_sectors limited to 256 for
NCQ
Feb  5 15:51:12 SunSTG kernel: ata46.00: configured for UDMA/133
Feb  5 15:51:12 SunSTG kernel: ata46: EH complete
Feb  5 15:51:12 SunSTG kernel: scsi 45:0:0:0: Direct-Access     ATA
SEAGATE ST32500N n/a  PQ: 0 ANSI: 5
Feb  5 15:51:12 SunSTG kernel: sd 45:0:0:0: [sdax] 488390625 512-byte
hardware sectors (250056 MB)
Feb  5 15:51:12 SunSTG kernel: sd 45:0:0:0: [sdax] Write Protect is off
Feb  5 15:51:12 SunSTG kernel: sd 45:0:0:0: [sdax] Write cache:
disabled, read cache: enabled, doesn't support DPO or FUA
Feb  5 15:51:12 SunSTG kernel: sd 45:0:0:0: [sdax] 488390625 512-byte
hardware sectors (250056 MB)
Feb  5 15:51:12 SunSTG kernel: sd 45:0:0:0: [sdax] Write Protect is off
Feb  5 15:51:12 SunSTG kernel: sd 45:0:0:0: [sdax] Write cache:
disabled, read cache: enabled, doesn't support DPO or FUA
Feb  5 15:51:12 SunSTG kernel:  sdax:
Feb  5 15:51:12 SunSTG kernel: sd 45:0:0:0: [sdax] Attached SCSI disk
Feb  5 15:51:12 SunSTG kernel: sd 45:0:0:0: Attached scsi generic sg45
type 0
Feb  5 16:08:49 SunSTG smartd[12928]: Device: /dev/sdat, No such device,
open() failed
Feb  5 16:08:49 SunSTG smartd[12928]: Sending warning via mail to
root ...

mdadm output after the event:

[root@SunSTG ~]# mdadm --detail /dev/md3
/dev/md3:
        Version : 00.90.03
  Creation Time : Wed Feb  4 21:43:12 2009
     Raid Level : raid6
     Array Size : 5372294400 (5123.42 GiB 5501.23 GB)
  Used Dev Size : 244195200 (232.88 GiB 250.06 GB)
   Raid Devices : 24
  Total Devices : 24
Preferred Minor : 3
    Persistence : Superblock is persistent

    Update Time : Thu Feb  5 03:22:46 2009
          State : active
 Active Devices : 24
Working Devices : 24
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 64K

           UUID : 5f7531f9:6a512ed6:b82261e1:e67c5c29
         Events : 0.7

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1      65      160        1      active sync   /dev/sdaa
       2      65      176        2      active sync   /dev/sdab
       3      65      208        3      active sync   /dev/sdad
       4      65      224        4      active sync   /dev/sdae
       5      65      240        5      active sync   /dev/sdaf
       6       8      160        6      active sync   /dev/sdk
       7       8      176        7      active sync   /dev/sdl
       8       8      192        8      active sync   /dev/sdm
       9       8      208        9      active sync   /dev/sdn
      10      66        0       10      active sync   /dev/sdag
      11      66       16       11      active sync   /dev/sdah
      12      66       32       12      active sync   /dev/sdai
      13      66      112       13      active sync   /dev/sdan
      14      66      128       14      active sync   /dev/sdao
      15      66      144       15      active sync   /dev/sdap
      16      66      160       16      active sync   /dev/sdaq
      17      66      176       17      active sync   /dev/sdar
      18      66      192       18      active sync   /dev/sdas
      19      66      208       19      active sync
      20      65       96       20      active sync   /dev/sdw
      21      65      112       21      active sync   /dev/sdx
      22      65      144       22      active sync   /dev/sdz
      23      66      240       23      active sync   /dev/sdav


*** SOFT LOCKUPS: ****

Feb  5 02:36:51 SunSTG kernel: BUG: soft lockup - CPU#2 stuck for 61s!
[md4_raid5:13198]
Feb  5 02:36:51 SunSTG kernel: Modules linked in: raid456 async_xor
async_memcpy async_tx xor autofs4 hidp rfcomm l2cap bluetooth sunrpc
dm_mirror dm_log dm_multipath dm_mod wmi video output sbs sbshc battery
ac ipv6 parport_pc lp parport sr_mod cdrom joydev sg e1000 serio_raw
pata_amd pata_acpi i2c_amd8111 i2c_amd756 pcspkr ata_generic i2c_core
shpchp k8temp amd_rng hwmon usb_storage sata_mv libata sd_mod scsi_mod
raid1 ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded:
freq_table]
Feb  5 02:36:51 SunSTG kernel: CPU 2:
Feb  5 02:36:51 SunSTG kernel: Modules linked in: raid456 async_xor
async_memcpy async_tx xor autofs4 hidp rfcomm l2cap bluetooth sunrpc
dm_mirror dm_log dm_multipath dm_mod wmi video output sbs sbshc battery
ac ipv6 parport_pc lp parport sr_mod cdrom joydev sg e1000 serio_raw
pata_amd pata_acpi i2c_amd8111 i2c_amd756 pcspkr ata_generic i2c_core
shpchp k8temp amd_rng hwmon usb_storage sata_mv libata sd_mod scsi_mod
raid1 ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded:
freq_table]
Feb  5 02:36:51 SunSTG kernel: Pid: 13198, comm: md4_raid5 Not tainted
2.6.26.8-57.fc8 #1
Feb  5 02:36:51 SunSTG kernel: RIP: 0010:[<ffffffffa0299468>]
[<ffffffffa0299468>] :raid456:raid6_sse24_gen_syndrome+0x184/0x210
Feb  5 02:36:51 SunSTG kernel: RSP: 0018:ffff8101f2881bd8  EFLAGS:
00000286
Feb  5 02:36:51 SunSTG kernel: RAX: ffff8101f2c7b000 RBX:
ffff8101f2881c10 RCX: ffff8101f2c7baa0
Feb  5 02:36:51 SunSTG kernel: RDX: ffff8101f2c7ba80 RSI:
0000000000000a80 RDI: ffff8101f2c7aa80
Feb  5 02:36:51 SunSTG kernel: RBP: 000000008005003b R08:
ffff8101f2c79a80 R09: 00000000ffffffff
Feb  5 02:36:51 SunSTG kernel: R10: ffff8101f2881c18 R11:
000000008005003b R12: ffff8101f2881bc8
Feb  5 02:36:51 SunSTG kernel: R13: ffffffff8107e9d7 R14:
ffff8101f2881b40 R15: ffff8103fd859eb0
Feb  5 02:36:51 SunSTG kernel: FS:  00007f7d08c696e0(0000)
GS:ffff8103ff039300(0000) knlGS:0000000000000000
Feb  5 02:36:51 SunSTG kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
0000000080050033
Feb  5 02:36:51 SunSTG kernel: CR2: 00007fc464d4e000 CR3:
00000003fdd03000 CR4: 00000000000006e0
Feb  5 02:36:51 SunSTG kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Feb  5 02:36:51 SunSTG kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Feb  5 02:36:51 SunSTG kernel:
Feb  5 02:36:51 SunSTG kernel: Call Trace:
Feb  5 02:36:51 SunSTG kernel:
[<ffffffffa0299362>] ? :raid456:raid6_sse24_gen_syndrome+0x7e/0x210
Feb  5 02:36:51 SunSTG kernel:
[<ffffffffa0295f6a>] ? :raid456:compute_parity6+0x24f/0x2e2
Feb  5 02:36:51 SunSTG kernel:
[<ffffffffa0296146>] ? :raid456:compute_block_1+0x149/0x1b2
Feb  5 02:36:51 SunSTG kernel:
[<ffffffffa0296d8f>] ? :raid456:handle_stripe+0x9eb/0xf1b
Feb  5 02:36:51 SunSTG kernel:  [<ffffffff811ee616>] ? md_wakeup_thread
+0x24/0x26
Feb  5 02:36:51 SunSTG kernel:  [<ffffffffa029769d>] ? :raid456:raid5d
+0x3de/0x3ee
Feb  5 02:36:51 SunSTG kernel:  [<ffffffff81297b98>] ? schedule_timeout
+0x22/0xb4
Feb  5 02:36:51 SunSTG kernel:  [<ffffffff811f687a>] ? md_thread
+0xd6/0xee
Feb  5 02:36:51 SunSTG kernel:  [<ffffffff810492dc>] ?
autoremove_wake_function+0x0/0x38
Feb  5 02:36:51 SunSTG kernel:  [<ffffffff811f67a4>] ? md_thread
+0x0/0xee
Feb  5 02:36:52 SunSTG kernel:  [<ffffffff810491a5>] ? kthread+0x49/0x78
Feb  5 02:36:52 SunSTG kernel:  [<ffffffff8100d188>] ? child_rip
+0xa/0x12
Feb  5 02:36:52 SunSTG kernel:  [<ffffffff8104915c>] ? kthread+0x0/0x78
Feb  5 02:36:52 SunSTG kernel:  [<ffffffff8100d17e>] ? child_rip
+0x0/0x12
Feb  5 02:36:52 SunSTG kernel:
Feb  5 02:37:55 SunSTG kernel: BUG: soft lockup - CPU#2 stuck for 61s!
[md4_raid5:13198]
Feb  5 02:37:55 SunSTG kernel: Modules linked in: raid456 async_xor
async_memcpy async_tx xor autofs4 hidp rfcomm l2cap bluetooth sunrpc
dm_mirror dm_log dm_multipath dm_mod wmi video output sbs sbshc battery
ac ipv6 parport_pc lp parport sr_mod cdrom joydev sg e1000 serio_raw
pata_amd pata_acpi i2c_amd8111 i2c_amd756 pcspkr ata_generic i2c_core
shpchp k8temp amd_rng hwmon usb_storage sata_mv libata sd_mod scsi_mod
raid1 ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded:
freq_table]
Feb  5 02:37:55 SunSTG kernel: CPU 2:
Feb  5 02:37:55 SunSTG kernel: Modules linked in: raid456 async_xor
async_memcpy async_tx xor autofs4 hidp rfcomm l2cap bluetooth sunrpc
dm_mirror dm_log dm_multipath dm_mod wmi video output sbs sbshc battery
ac ipv6 parport_pc lp parport sr_mod cdrom joydev sg e1000 serio_raw
pata_amd pata_acpi i2c_amd8111 i2c_amd756 pcspkr ata_generic i2c_core
shpchp k8temp amd_rng hwmon usb_storage sata_mv libata sd_mod scsi_mod
raid1 ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded:
freq_table]
Feb  5 02:37:55 SunSTG kernel: Pid: 13198, comm: md4_raid5 Not tainted
2.6.26.8-57.fc8 #1
Feb  5 02:37:55 SunSTG kernel: RIP: 0010:[<ffffffffa027eb63>]
[<ffffffffa027eb63>] :xor:xor_sse_5+0x3d0/0x3d7
Feb  5 02:37:55 SunSTG kernel: RSP: 0018:ffff8101f2881c70  EFLAGS:
00000246
Feb  5 02:37:55 SunSTG kernel: RAX: 0000000000000100 RBX:
ffff8101f2881cc0 RCX: 0000000000000000
Feb  5 02:37:55 SunSTG kernel: RDX: ffff8101f3401000 RSI:
ffff8101f33fd000 RDI: 0000000000000010
Feb  5 02:37:55 SunSTG kernel: RBP: 000000000000000f R08:
ffff8101f33ff000 R09: ffff8101f33fc000
Feb  5 02:37:55 SunSTG kernel: R10: ffff8101f2881c70 R11:
000000008005003b R12: 0000000000000003
Feb  5 02:37:55 SunSTG kernel: R13: 0000000000001000 R14:
ffffffffa02994e7 R15: ffff8101f2881c10
Feb  5 02:37:55 SunSTG kernel: FS:  00007f7d08c696e0(0000)
GS:ffff8103ff039300(0000) knlGS:0000000000000000
Feb  5 02:37:56 SunSTG kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
000000008005003b
Feb  5 02:37:56 SunSTG kernel: CR2: 00007fc464d4e000 CR3:
00000003fdd03000 CR4: 00000000000006e0
Feb  5 02:37:56 SunSTG kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Feb  5 02:37:56 SunSTG kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Feb  5 02:37:56 SunSTG kernel:
Feb  5 02:37:56 SunSTG kernel: Call Trace:
Feb  5 02:37:56 SunSTG kernel:  [<ffffffffa027ebd3>] ? :xor:xor_blocks
+0x69/0x6b
Feb  5 02:37:56 SunSTG kernel:
[<ffffffffa0296146>] ? :raid456:compute_block_1+0x149/0x1b2
Feb  5 02:37:56 SunSTG kernel:
[<ffffffffa0296c8c>] ? :raid456:handle_stripe+0x8e8/0xf1b
Feb  5 02:37:56 SunSTG kernel:  [<ffffffffa029769d>] ? :raid456:raid5d
+0x3de/0x3ee
Feb  5 02:37:56 SunSTG kernel:  [<ffffffff81297b98>] ? schedule_timeout
+0x22/0xb4
Feb  5 02:37:56 SunSTG kernel:  [<ffffffff811f687a>] ? md_thread
+0xd6/0xee
Feb  5 02:37:56 SunSTG kernel:  [<ffffffff810492dc>] ?
autoremove_wake_function+0x0/0x38
Feb  5 02:37:56 SunSTG kernel:  [<ffffffff811f67a4>] ? md_thread
+0x0/0xee
Feb  5 02:37:56 SunSTG kernel:  [<ffffffff810491a5>] ? kthread+0x49/0x78
Feb  5 02:37:56 SunSTG kernel:  [<ffffffff8100d188>] ? child_rip
+0xa/0x12
Feb  5 02:37:56 SunSTG kernel:  [<ffffffff8104915c>] ? kthread+0x0/0x78
Feb  5 02:37:56 SunSTG kernel:  [<ffffffff8100d17e>] ? child_rip
+0x0/0x12
Feb  5 02:37:56 SunSTG kernel:
Feb  5 02:38:09 SunSTG yum-updatesd-helper: error getting update info:
Cannot retrieve repository metadata (repomd.xml) for repository: base.
Please verify its path and try again
Feb  5 02:43:30 SunSTG kernel: BUG: soft lockup - CPU#3 stuck for 61s!
[md4_raid5:13198]
Feb  5 02:43:30 SunSTG kernel: Modules linked in: raid456 async_xor
async_memcpy async_tx xor autofs4 hidp rfcomm l2cap bluetooth sunrpc
dm_mirror dm_log dm_multipath dm_mod wmi video output sbs sbshc battery
ac ipv6 parport_pc lp parport sr_mod cdrom joydev sg e1000 serio_raw
pata_amd pata_acpi i2c_amd8111 i2c_amd756 pcspkr ata_generic i2c_core
shpchp k8temp amd_rng hwmon usb_storage sata_mv libata sd_mod scsi_mod
raid1 ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded:
freq_table]
Feb  5 02:43:30 SunSTG kernel: CPU 3:
Feb  5 02:43:30 SunSTG kernel: Modules linked in: raid456 async_xor
async_memcpy async_tx xor autofs4 hidp rfcomm l2cap bluetooth sunrpc
dm_mirror dm_log dm_multipath dm_mod wmi video output sbs sbshc battery
ac ipv6 parport_pc lp parport sr_mod cdrom joydev sg e1000 serio_raw
pata_amd pata_acpi i2c_amd8111 i2c_amd756 pcspkr ata_generic i2c_core
shpchp k8temp amd_rng hwmon usb_storage sata_mv libata sd_mod scsi_mod
raid1 ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded:
freq_table]
Feb  5 02:43:30 SunSTG kernel: Pid: 13198, comm: md4_raid5 Not tainted
2.6.26.8-57.fc8 #1
Feb  5 02:43:30 SunSTG kernel: RIP: 0010:[<ffffffff810204c1>]
[<ffffffff810204c1>] native_read_cr0+0x0/0x9
Feb  5 02:43:30 SunSTG kernel: RSP: 0018:ffff8101f2881bd0  EFLAGS:
00000246
Feb  5 02:43:30 SunSTG kernel: RAX: ffff8101f315c000 RBX:
ffff8101f2881c10 RCX: ffff8101f315cfe0
Feb  5 02:43:30 SunSTG kernel: RDX: ffff8101f315cfc0 RSI:
0000000000001000 RDI: ffff8101f315c000
Feb  5 02:43:30 SunSTG kernel: RBP: 000000008005003b R08:
ffff8101f315b000 R09: 00000000ffffffff
Feb  5 02:43:30 SunSTG kernel: R10: ffff8101f2881c18 R11:
000000008005003b R12: ffff8101f2881bc8
Feb  5 02:43:30 SunSTG kernel: R13: ffffffff8107e9d7 R14:
ffff8101f2881b40 R15: ffff8103fd858330
Feb  5 02:43:30 SunSTG kernel: FS:  00007fdaeea3a6e0(0000)
GS:ffff8103ff039700(0000) knlGS:0000000000000000
Feb  5 02:43:30 SunSTG kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
0000000080050033
Feb  5 02:43:30 SunSTG kernel: CR2: 00007fadb1a4d170 CR3:
00000003f996e000 CR4: 00000000000006e0
Feb  5 02:43:30 SunSTG kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Feb  5 02:43:30 SunSTG kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Feb  5 02:43:30 SunSTG kernel:
Feb  5 02:43:30 SunSTG kernel: Call Trace:
Feb  5 02:43:30 SunSTG kernel:
[<ffffffffa02994d7>] ? :raid456:raid6_sse24_gen_syndrome+0x1f3/0x210
Feb  5 02:43:30 SunSTG kernel:
[<ffffffffa0295f6a>] ? :raid456:compute_parity6+0x24f/0x2e2
Feb  5 02:43:31 SunSTG kernel:
[<ffffffffa0296146>] ? :raid456:compute_block_1+0x149/0x1b2
Feb  5 02:43:31 SunSTG kernel:
[<ffffffffa0296d8f>] ? :raid456:handle_stripe+0x9eb/0xf1b
Feb  5 02:43:31 SunSTG kernel:  [<ffffffff811ee616>] ? md_wakeup_thread
+0x24/0x26
Feb  5 02:43:31 SunSTG kernel:  [<ffffffffa029769d>] ? :raid456:raid5d
+0x3de/0x3ee
Feb  5 02:43:31 SunSTG kernel:  [<ffffffff81297b98>] ? schedule_timeout
+0x22/0xb4
Feb  5 02:43:31 SunSTG kernel:  [<ffffffff811f687a>] ? md_thread
+0xd6/0xee
Feb  5 02:43:31 SunSTG kernel:  [<ffffffff810492dc>] ?
autoremove_wake_function+0x0/0x38
Feb  5 02:43:31 SunSTG kernel:  [<ffffffff811f67a4>] ? md_thread
+0x0/0xee
Feb  5 02:43:31 SunSTG kernel:  [<ffffffff810491a5>] ? kthread+0x49/0x78
Feb  5 02:43:31 SunSTG kernel:  [<ffffffff8100d188>] ? child_rip
+0xa/0x12
Feb  5 02:43:31 SunSTG kernel:  [<ffffffff8104915c>] ? kthread+0x0/0x78
Feb  5 02:43:31 SunSTG kernel:  [<ffffffff8100d17e>] ? child_rip
+0x0/0x12
Feb  5 02:43:31 SunSTG kernel:
Feb  5 02:44:36 SunSTG kernel: BUG: soft lockup - CPU#3 stuck for 61s!
[md4_raid5:13198]
Feb  5 02:44:36 SunSTG kernel: Modules linked in: raid456 async_xor
async_memcpy async_tx xor autofs4 hidp rfcomm l2cap bluetooth sunrpc
dm_mirror dm_log dm_multipath dm_mod wmi video output sbs sbshc battery
ac ipv6 parport_pc lp parport sr_mod cdrom joydev sg e1000 serio_raw
pata_amd pata_acpi i2c_amd8111 i2c_amd756 pcspkr ata_generic i2c_core
shpchp k8temp amd_rng hwmon usb_storage sata_mv libata sd_mod scsi_mod
raid1 ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded:
freq_table]
Feb  5 02:44:36 SunSTG kernel: CPU 3:
Feb  5 02:44:36 SunSTG kernel: Modules linked in: raid456 async_xor
async_memcpy async_tx xor autofs4 hidp rfcomm l2cap bluetooth sunrpc
dm_mirror dm_log dm_multipath dm_mod wmi video output sbs sbshc battery
ac ipv6 parport_pc lp parport sr_mod cdrom joydev sg e1000 serio_raw
pata_amd pata_acpi i2c_amd8111 i2c_amd756 pcspkr ata_generic i2c_core
shpchp k8temp amd_rng hwmon usb_storage sata_mv libata sd_mod scsi_mod
raid1 ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded:
freq_table]
Feb  5 02:44:36 SunSTG kernel: Pid: 13198, comm: md4_raid5 Not tainted
2.6.26.8-57.fc8 #1
Feb  5 02:44:36 SunSTG kernel: RIP: 0010:[<ffffffffa027e953>]
[<ffffffffa027e953>] :xor:xor_sse_5+0x1c0/0x3d7
Feb  5 02:44:36 SunSTG kernel: RSP: 0018:ffff8101f2881c70  EFLAGS:
00000202
Feb  5 02:44:36 SunSTG kernel: RAX: 0000000000000100 RBX:
ffff8101f2881cc0 RCX: 0000000000000008
Feb  5 02:44:36 SunSTG kernel: RDX: ffff8101f3342800 RSI:
ffff8101f3347800 RDI: 0000000000000010
Feb  5 02:44:36 SunSTG kernel: RBP: 0000000000000012 R08:
ffff8101f3340800 R09: ffff8101f333f800
Feb  5 02:44:36 SunSTG kernel: R10: ffff8101f2881c70 R11:
000000008005003b R12: 0000000000000003
Feb  5 02:44:36 SunSTG kernel: R13: 0000000000001000 R14:
ffffffffa02994e7 R15: ffff8101f2881c10
Feb  5 02:44:36 SunSTG kernel: FS:  00007fdaeea3a6e0(0000)
GS:ffff8103ff039700(0000) knlGS:0000000000000000
Feb  5 02:44:36 SunSTG kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
0000000080050033
Feb  5 02:44:36 SunSTG kernel: CR2: 00007fadb1a4d170 CR3:
00000003f996e000 CR4: 00000000000006e0
Feb  5 02:44:36 SunSTG kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Feb  5 02:44:36 SunSTG kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Feb  5 02:44:36 SunSTG kernel:
Feb  5 02:44:36 SunSTG kernel: Call Trace:
Feb  5 02:44:36 SunSTG kernel:  [<ffffffffa027ebd3>] ? :xor:xor_blocks
+0x69/0x6b
Feb  5 02:44:36 SunSTG kernel:
[<ffffffffa0296146>] ? :raid456:compute_block_1+0x149/0x1b2
Feb  5 02:44:36 SunSTG kernel:
[<ffffffffa0296c8c>] ? :raid456:handle_stripe+0x8e8/0xf1b
Feb  5 02:44:36 SunSTG kernel:  [<ffffffff811ee616>] ? md_wakeup_thread
+0x24/0x26
Feb  5 02:44:36 SunSTG kernel:  [<ffffffffa029769d>] ? :raid456:raid5d
+0x3de/0x3ee
Feb  5 02:44:36 SunSTG kernel:  [<ffffffff81297b98>] ? schedule_timeout
+0x22/0xb4
Feb  5 02:44:36 SunSTG kernel:  [<ffffffff811f687a>] ? md_thread
+0xd6/0xee
Feb  5 02:44:36 SunSTG kernel:  [<ffffffff810492dc>] ?
autoremove_wake_function+0x0/0x38
Feb  5 02:44:36 SunSTG kernel:  [<ffffffff811f67a4>] ? md_thread
+0x0/0xee
Feb  5 02:44:36 SunSTG kernel:  [<ffffffff810491a5>] ? kthread+0x49/0x78
Feb  5 02:44:36 SunSTG kernel:  [<ffffffff8100d188>] ? child_rip
+0xa/0x12
Feb  5 02:44:36 SunSTG kernel:  [<ffffffff8104915c>] ? kthread+0x0/0x78
Feb  5 02:44:36 SunSTG kernel:  [<ffffffff8100d17e>] ? child_rip
+0x0/0x12
Feb  5 02:44:36 SunSTG kernel:
Feb  5 02:45:41 SunSTG kernel: BUG: soft lockup - CPU#3 stuck for 61s!
[md4_raid5:13198]
Feb  5 02:45:41 SunSTG kernel: Modules linked in: raid456 async_xor
async_memcpy async_tx xor autofs4 hidp rfcomm l2cap bluetooth sunrpc
dm_mirror dm_log dm_multipath dm_mod wmi video output sbs sbshc battery
ac ipv6 parport_pc lp parport sr_mod cdrom joydev sg e1000 serio_raw
pata_amd pata_acpi i2c_amd8111 i2c_amd756 pcspkr ata_generic i2c_core
shpchp k8temp amd_rng hwmon usb_storage sata_mv libata sd_mod scsi_mod
raid1 ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded:
freq_table]
Feb  5 02:45:41 SunSTG kernel: CPU 3:
Feb  5 02:45:41 SunSTG kernel: Modules linked in: raid456 async_xor
async_memcpy async_tx xor autofs4 hidp rfcomm l2cap bluetooth sunrpc
dm_mirror dm_log dm_multipath dm_mod wmi video output sbs sbshc battery
ac ipv6 parport_pc lp parport sr_mod cdrom joydev sg e1000 serio_raw
pata_amd pata_acpi i2c_amd8111 i2c_amd756 pcspkr ata_generic i2c_core
shpchp k8temp amd_rng hwmon usb_storage sata_mv libata sd_mod scsi_mod
raid1 ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded:
freq_table]
Feb  5 02:45:41 SunSTG kernel: Pid: 13198, comm: md4_raid5 Not tainted
2.6.26.8-57.fc8 #1
Feb  5 02:45:41 SunSTG kernel: RIP: 0010:[<ffffffffa00b4465>]
[<ffffffffa00b4465>] :sata_mv:mv_process_crpb_entries+0x60/0x15e
Feb  5 02:45:41 SunSTG kernel: RSP: 0018:ffff8101ff10be58  EFLAGS:
00000202
Feb  5 02:45:41 SunSTG kernel: RAX: 0000000000000002 RBX:
ffff8101ff10be88 RCX: ffffc200025a2000
Feb  5 02:45:41 SunSTG kernel: RDX: 0000000000002000 RSI:
ffff8101fe1c0828 RDI: ffff8101fe290000
Feb  5 02:45:41 SunSTG kernel: RBP: ffff8101ff10bdd0 R08:
0000000000000202 R09: 0000000000000008
Feb  5 02:45:41 SunSTG kernel: R10: 0000000000000002 R11:
000000008005003b R12: ffffffff8100cf52
Feb  5 02:45:41 SunSTG kernel: R13: ffff8101ff10bdd0 R14:
ffff8101fe290000 R15: 0000000000000018
Feb  5 02:45:41 SunSTG kernel: FS:  00007fdaeea3a6e0(0000)
GS:ffff8103ff039700(0000) knlGS:0000000000000000
Feb  5 02:45:41 SunSTG kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
0000000080050033
Feb  5 02:45:41 SunSTG kernel: CR2: 00007fadb1a4d170 CR3:
00000003f996e000 CR4: 00000000000006e0
Feb  5 02:45:41 SunSTG kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Feb  5 02:45:41 SunSTG kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Feb  5 02:45:41 SunSTG kernel:
Feb  5 02:45:41 SunSTG kernel: Call Trace:
Feb  5 02:45:41 SunSTG kernel:  <IRQ>
[<ffffffffa00b4fdf>] ? :sata_mv:mv_interrupt+0x28b/0x64b
Feb  5 02:45:41 SunSTG kernel:  [<ffffffff8112d332>] ? blk_done_softirq
+0x71/0x80
Feb  5 02:45:41 SunSTG kernel:  [<ffffffff81075689>] ? handle_IRQ_event
+0x2e/0x65
Feb  5 02:45:41 SunSTG kernel:  [<ffffffff81076cce>] ?
handle_fasteoi_irq+0x95/0xd0
Feb  5 02:45:41 SunSTG kernel:  [<ffffffff8100f00f>] ? do_IRQ+0xf7/0x16c
Feb  5 02:45:41 SunSTG kernel:  [<ffffffff8100c6cd>] ? ret_from_intr
+0x0/0x19
Feb  5 02:45:42 SunSTG kernel:  <EOI>
[<ffffffffa027e8d8>] ? :xor:xor_sse_5+0x145/0x3d7
Feb  5 02:45:42 SunSTG kernel:  [<ffffffffa027ebd3>] ? :xor:xor_blocks
+0x69/0x6b
Feb  5 02:45:42 SunSTG kernel:
[<ffffffffa0296146>] ? :raid456:compute_block_1+0x149/0x1b2
Feb  5 02:45:42 SunSTG kernel:
[<ffffffffa0296c8c>] ? :raid456:handle_stripe+0x8e8/0xf1b
Feb  5 02:45:42 SunSTG kernel:  [<ffffffffa029769d>] ? :raid456:raid5d
+0x3de/0x3ee
Feb  5 02:45:42 SunSTG kernel:  [<ffffffff81297b98>] ? schedule_timeout
+0x22/0xb4
Feb  5 02:45:42 SunSTG kernel:  [<ffffffff811f687a>] ? md_thread
+0xd6/0xee
Feb  5 02:45:42 SunSTG kernel:  [<ffffffff810492dc>] ?
autoremove_wake_function+0x0/0x38
Feb  5 02:45:42 SunSTG kernel:  [<ffffffff811f67a4>] ? md_thread
+0x0/0xee
Feb  5 02:45:42 SunSTG kernel:  [<ffffffff810491a5>] ? kthread+0x49/0x78
Feb  5 02:45:42 SunSTG kernel:  [<ffffffff8100d188>] ? child_rip
+0xa/0x12
Feb  5 02:45:42 SunSTG kernel:  [<ffffffff8104915c>] ? kthread+0x0/0x78
Feb  5 02:45:42 SunSTG kernel:  [<ffffffff8100d17e>] ? child_rip
+0x0/0x12
Feb  5 02:45:42 SunSTG kernel:
Feb  5 02:46:47 SunSTG kernel: BUG: soft lockup - CPU#3 stuck for 61s!
[md4_raid5:13198]
Feb  5 02:46:47 SunSTG kernel: Modules linked in: raid456 async_xor
async_memcpy async_tx xor autofs4 hidp rfcomm l2cap bluetooth sunrpc
dm_mirror dm_log dm_multipath dm_mod wmi video output sbs sbshc battery
ac ipv6 parport_pc lp parport sr_mod cdrom joydev sg e1000 serio_raw
pata_amd pata_acpi i2c_amd8111 i2c_amd756 pcspkr ata_generic i2c_core
shpchp k8temp amd_rng hwmon usb_storage sata_mv libata sd_mod scsi_mod
raid1 ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded:
freq_table]
Feb  5 02:46:47 SunSTG kernel: CPU 3:
Feb  5 02:46:47 SunSTG kernel: Modules linked in: raid456 async_xor
async_memcpy async_tx xor autofs4 hidp rfcomm l2cap bluetooth sunrpc
dm_mirror dm_log dm_multipath dm_mod wmi video output sbs sbshc battery
ac ipv6 parport_pc lp parport sr_mod cdrom joydev sg e1000 serio_raw
pata_amd pata_acpi i2c_amd8111 i2c_amd756 pcspkr ata_generic i2c_core
shpchp k8temp amd_rng hwmon usb_storage sata_mv libata sd_mod scsi_mod
raid1 ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded:
freq_table]
Feb  5 02:46:47 SunSTG kernel: Pid: 13198, comm: md4_raid5 Not tainted
2.6.26.8-57.fc8 #1
Feb  5 02:46:47 SunSTG kernel: RIP: 0010:[<ffffffffa027e7f5>]
[<ffffffffa027e7f5>] :xor:xor_sse_5+0x62/0x3d7
Feb  5 02:46:47 SunSTG kernel: RSP: 0018:ffff8101f2881c70  EFLAGS:
00000202
Feb  5 02:46:47 SunSTG kernel: RAX: 0000000000000100 RBX:
ffff8101f2881cc0 RCX: 000000000000000d
Feb  5 02:46:47 SunSTG kernel: RDX: ffff8101ef5a2300 RSI:
ffff8101ef5a9300 RDI: 0000000000000010
Feb  5 02:46:47 SunSTG kernel: RBP: 000000000000000c R08:
ffff8101ef5a0300 R09: ffff8101ef59f300
Feb  5 02:46:47 SunSTG kernel: R10: ffff8101f2881c70 R11:
000000008005003b R12: 0000000000000003
Feb  5 02:46:47 SunSTG kernel: R13: 0000000000001000 R14:
ffffffffa02994e7 R15: ffff8101f2881c10
Feb  5 02:46:47 SunSTG kernel: FS:  00007fdaeea3a6e0(0000)
GS:ffff8103ff039700(0000) knlGS:0000000000000000
Feb  5 02:46:47 SunSTG kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
0000000080050033
Feb  5 02:46:47 SunSTG kernel: CR2: 00007fadb1a4d170 CR3:
00000003f996e000 CR4: 00000000000006e0
Feb  5 02:46:47 SunSTG kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Feb  5 02:46:47 SunSTG kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Feb  5 02:46:47 SunSTG kernel:
Feb  5 02:46:47 SunSTG kernel: Call Trace:
Feb  5 02:46:47 SunSTG kernel:  [<ffffffffa027ebd3>] ? :xor:xor_blocks
+0x69/0x6b
Feb  5 02:46:47 SunSTG kernel:
[<ffffffffa0296146>] ? :raid456:compute_block_1+0x149/0x1b2
Feb  5 02:46:47 SunSTG kernel:
[<ffffffffa0296c8c>] ? :raid456:handle_stripe+0x8e8/0xf1b
Feb  5 02:46:47 SunSTG kernel:  [<ffffffff811ee616>] ? md_wakeup_thread
+0x24/0x26
Feb  5 02:46:47 SunSTG kernel:  [<ffffffffa029769d>] ? :raid456:raid5d
+0x3de/0x3ee
Feb  5 02:46:47 SunSTG kernel:  [<ffffffff81297b98>] ? schedule_timeout
+0x22/0xb4
Feb  5 02:46:47 SunSTG kernel:  [<ffffffff811f687a>] ? md_thread
+0xd6/0xee
Feb  5 02:46:47 SunSTG kernel:  [<ffffffff810492dc>] ?
autoremove_wake_function+0x0/0x38
Feb  5 02:46:47 SunSTG kernel:  [<ffffffff811f67a4>] ? md_thread
+0x0/0xee
Feb  5 02:46:47 SunSTG kernel:  [<ffffffff810491a5>] ? kthread+0x49/0x78
Feb  5 02:46:47 SunSTG kernel:  [<ffffffff8100d188>] ? child_rip
+0xa/0x12
Feb  5 02:46:47 SunSTG kernel:  [<ffffffff8104915c>] ? kthread+0x0/0x78
Feb  5 02:46:47 SunSTG kernel:  [<ffffffff8100d17e>] ? child_rip
+0x0/0x12
Feb  5 02:46:47 SunSTG kernel:
Feb  5 02:48:52 SunSTG kernel: BUG: soft lockup - CPU#3 stuck for 61s!
[md4_raid5:13198]
Feb  5 02:48:52 SunSTG kernel: Modules linked in: raid456 async_xor
async_memcpy async_tx xor autofs4 hidp rfcomm l2cap bluetooth sunrpc
dm_mirror dm_log dm_multipath dm_mod wmi video output sbs sbshc battery
ac ipv6 parport_pc lp parport sr_mod cdrom joydev sg e1000 serio_raw
pata_amd pata_acpi i2c_amd8111 i2c_amd756 pcspkr ata_generic i2c_core
shpchp k8temp amd_rng hwmon usb_storage sata_mv libata sd_mod scsi_mod
raid1 ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded:
freq_table]
Feb  5 02:48:52 SunSTG kernel: CPU 3:
Feb  5 02:48:52 SunSTG kernel: Modules linked in: raid456 async_xor
async_memcpy async_tx xor autofs4 hidp rfcomm l2cap bluetooth sunrpc
dm_mirror dm_log dm_multipath dm_mod wmi video output sbs sbshc battery
ac ipv6 parport_pc lp parport sr_mod cdrom joydev sg e1000 serio_raw
pata_amd pata_acpi i2c_amd8111 i2c_amd756 pcspkr ata_generic i2c_core
shpchp k8temp amd_rng hwmon usb_storage sata_mv libata sd_mod scsi_mod
raid1 ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded:
freq_table]
Feb  5 02:48:52 SunSTG kernel: Pid: 13198, comm: md4_raid5 Not tainted
2.6.26.8-57.fc8 #1
Feb  5 02:48:52 SunSTG kernel: RIP: 0010:[<ffffffffa0299416>]
[<ffffffffa0299416>] :raid456:raid6_sse24_gen_syndrome+0x132/0x210
Feb  5 02:48:52 SunSTG kernel: RSP: 0018:ffff8101f2881bd8  EFLAGS:
00000202
Feb  5 02:48:52 SunSTG kernel: RAX: ffff8101f78c0000 RBX:
ffff8101f2881c10 RCX: ffff8101f78c0260
Feb  5 02:48:52 SunSTG kernel: RDX: ffff8101f78c0240 RSI:
0000000000000240 RDI: ffff8101f78af240
Feb  5 02:48:52 SunSTG kernel: RBP: 000000008005003b R08:
ffff8101f78ae240 R09: 0000000000000010
Feb  5 02:48:52 SunSTG kernel: R10: ffff8101f2881ca0 R11:
000000008005003b R12: ffff8101f2881bc8
Feb  5 02:48:52 SunSTG kernel: R13: ffffffff8107e9d7 R14:
ffff8101f2881b40 R15: ffff8103fd858970
Feb  5 02:48:52 SunSTG kernel: FS:  00007fdaeea3a6e0(0000)
GS:ffff8103ff039700(0000) knlGS:0000000000000000
Feb  5 02:48:52 SunSTG kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
0000000080050033
Feb  5 02:48:52 SunSTG kernel: CR2: 00007fadb1a4d170 CR3:
00000003f996e000 CR4: 00000000000006e0
Feb  5 02:48:52 SunSTG kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Feb  5 02:48:52 SunSTG kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Feb  5 02:48:52 SunSTG kernel:
Feb  5 02:48:52 SunSTG kernel: Call Trace:
Feb  5 02:48:52 SunSTG kernel:
[<ffffffffa0299362>] ? :raid456:raid6_sse24_gen_syndrome+0x7e/0x210
Feb  5 02:48:52 SunSTG kernel:
[<ffffffffa0295f6a>] ? :raid456:compute_parity6+0x24f/0x2e2
Feb  5 02:48:52 SunSTG kernel:
[<ffffffffa0296146>] ? :raid456:compute_block_1+0x149/0x1b2
Feb  5 02:48:52 SunSTG kernel:
[<ffffffffa0296d8f>] ? :raid456:handle_stripe+0x9eb/0xf1b
Feb  5 02:48:52 SunSTG kernel:  [<ffffffffa029769d>] ? :raid456:raid5d
+0x3de/0x3ee
Feb  5 02:48:52 SunSTG kernel:  [<ffffffff81297b98>] ? schedule_timeout
+0x22/0xb4
Feb  5 02:48:52 SunSTG kernel:  [<ffffffff811f687a>] ? md_thread
+0xd6/0xee
Feb  5 02:48:52 SunSTG kernel:  [<ffffffff810492dc>] ?
autoremove_wake_function+0x0/0x38
Feb  5 02:48:52 SunSTG kernel:  [<ffffffff811f67a4>] ? md_thread
+0x0/0xee
Feb  5 02:48:52 SunSTG kernel:  [<ffffffff810491a5>] ? kthread+0x49/0x78
Feb  5 02:48:52 SunSTG kernel:  [<ffffffff8100d188>] ? child_rip
+0xa/0x12
Feb  5 02:48:52 SunSTG kernel:  [<ffffffff8104915c>] ? kthread+0x0/0x78
Feb  5 02:48:52 SunSTG kernel:  [<ffffffff8100d17e>] ? child_rip
+0x0/0x12
Feb  5 02:48:52 SunSTG kernel:
Feb  5 02:49:55 SunSTG kernel: BUG: soft lockup - CPU#3 stuck for 61s!
[md4_raid5:13198]
Feb  5 02:49:55 SunSTG kernel: Modules linked in: raid456 async_xor
async_memcpy async_tx xor autofs4 hidp rfcomm l2cap bluetooth sunrpc
dm_mirror dm_log dm_multipath dm_mod wmi video output sbs sbshc battery
ac ipv6 parport_pc lp parport sr_mod cdrom joydev sg e1000 serio_raw
pata_amd pata_acpi i2c_amd8111 i2c_amd756 pcspkr ata_generic i2c_core
shpchp k8temp amd_rng hwmon usb_storage sata_mv libata sd_mod scsi_mod
raid1 ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded:
freq_table]
Feb  5 02:49:55 SunSTG kernel: CPU 3:
Feb  5 02:49:55 SunSTG kernel: Modules linked in: raid456 async_xor
async_memcpy async_tx xor autofs4 hidp rfcomm l2cap bluetooth sunrpc
dm_mirror dm_log dm_multipath dm_mod wmi video output sbs sbshc battery
ac ipv6 parport_pc lp parport sr_mod cdrom joydev sg e1000 serio_raw
pata_amd pata_acpi i2c_amd8111 i2c_amd756 pcspkr ata_generic i2c_core
shpchp k8temp amd_rng hwmon usb_storage sata_mv libata sd_mod scsi_mod
raid1 ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded:
freq_table]
Feb  5 02:49:55 SunSTG kernel: Pid: 13198, comm: md4_raid5 Not tainted
2.6.26.8-57.fc8 #1
Feb  5 02:49:55 SunSTG kernel: RIP: 0010:[<ffffffffa008ced4>]
[<ffffffffa008ced4>] :libata:__ata_qc_complete+0x53/0xb1
Feb  5 02:49:55 SunSTG kernel: RSP: 0018:ffff8101ff10bdf8  EFLAGS:
00000246
Feb  5 02:49:55 SunSTG kernel: RAX: 0000000000000000 RBX:
ffff8101ff10be18 RCX: 0000000000000000
Feb  5 02:49:55 SunSTG kernel: RDX: 0000000000001000 RSI:
ffffffffa006031d RDI: ffff8101f2838140
Feb  5 02:49:55 SunSTG kernel: RBP: ffff8101ff10bd70 R08:
0000000000000202 R09: 0000000000000008
Feb  5 02:49:55 SunSTG kernel: R10: 0000000000000002 R11:
000000008005003b R12: ffffffff8100cf52
Feb  5 02:49:55 SunSTG kernel: R13: ffff8101ff10bd70 R14:
ffff8101fe290000 R15: ffff8101fe2900d0
Feb  5 02:49:55 SunSTG kernel: FS:  00007fdaeea3a6e0(0000)
GS:ffff8103ff039700(0000) knlGS:0000000000000000
Feb  5 02:49:56 SunSTG kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
0000000080050033
Feb  5 02:49:56 SunSTG kernel: CR2: 00007fadb1a4d170 CR3:
00000003f996e000 CR4: 00000000000006e0
Feb  5 02:49:56 SunSTG kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Feb  5 02:49:56 SunSTG kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Feb  5 02:49:56 SunSTG kernel:
Feb  5 02:49:56 SunSTG kernel: Call Trace:
Feb  5 02:49:56 SunSTG kernel:  <IRQ>
[<ffffffffa008cec0>] ? :libata:__ata_qc_complete+0x3f/0xb1
Feb  5 02:49:56 SunSTG kernel:
[<ffffffffa008de32>] ? :libata:ata_qc_complete+0x12f/0x143
Feb  5 02:49:56 SunSTG kernel:
[<ffffffffa00b4554>] ? :sata_mv:mv_process_crpb_entries+0x14f/0x15e
Feb  5 02:49:56 SunSTG kernel:
[<ffffffffa00b4fdf>] ? :sata_mv:mv_interrupt+0x28b/0x64b
Feb  5 02:49:56 SunSTG kernel:  [<ffffffff8112d332>] ? blk_done_softirq
+0x71/0x80
Feb  5 02:49:56 SunSTG kernel:  [<ffffffff81075689>] ? handle_IRQ_event
+0x2e/0x65
Feb  5 02:49:56 SunSTG kernel:  [<ffffffff81076cce>] ?
handle_fasteoi_irq+0x95/0xd0
Feb  5 02:49:56 SunSTG kernel:  [<ffffffff8100f00f>] ? do_IRQ+0xf7/0x16c
Feb  5 02:49:56 SunSTG kernel:  [<ffffffff8100c6cd>] ? ret_from_intr
+0x0/0x19
Feb  5 02:49:56 SunSTG kernel:  <EOI>
[<ffffffffa027e82a>] ? :xor:xor_sse_5+0x97/0x3d7
Feb  5 02:49:56 SunSTG kernel:  [<ffffffffa027ebd3>] ? :xor:xor_blocks
+0x69/0x6b
Feb  5 02:49:56 SunSTG kernel:
[<ffffffffa0296146>] ? :raid456:compute_block_1+0x149/0x1b2
Feb  5 02:49:56 SunSTG kernel:
[<ffffffffa0296c8c>] ? :raid456:handle_stripe+0x8e8/0xf1b
Feb  5 02:49:56 SunSTG kernel:  [<ffffffffa029769d>] ? :raid456:raid5d
+0x3de/0x3ee
Feb  5 02:49:56 SunSTG kernel:  [<ffffffff81297b98>] ? schedule_timeout
+0x22/0xb4
Feb  5 02:49:56 SunSTG kernel:  [<ffffffff811f687a>] ? md_thread
+0xd6/0xee
Feb  5 02:49:56 SunSTG kernel:  [<ffffffff810492dc>] ?
autoremove_wake_function+0x0/0x38
Feb  5 02:49:56 SunSTG kernel:  [<ffffffff811f67a4>] ? md_thread
+0x0/0xee
Feb  5 02:49:56 SunSTG kernel:  [<ffffffff810491a5>] ? kthread+0x49/0x78
Feb  5 02:49:56 SunSTG kernel:  [<ffffffff8100d188>] ? child_rip
+0xa/0x12
Feb  5 02:49:56 SunSTG kernel:  [<ffffffff8104915c>] ? kthread+0x0/0x78
Feb  5 02:49:57 SunSTG kernel:  [<ffffffff8100d17e>] ? child_rip
+0x0/0x12
Feb  5 02:49:57 SunSTG kernel:
Feb  5 02:51:01 SunSTG kernel: BUG: soft lockup - CPU#3 stuck for 61s!
[md4_raid5:13198]
Feb  5 02:51:01 SunSTG kernel: Modules linked in: raid456 async_xor
async_memcpy async_tx xor autofs4 hidp rfcomm l2cap bluetooth sunrpc
dm_mirror dm_log dm_multipath dm_mod wmi video output sbs sbshc battery
ac ipv6 parport_pc lp parport sr_mod cdrom joydev sg e1000 serio_raw
pata_amd pata_acpi i2c_amd8111 i2c_amd756 pcspkr ata_generic i2c_core
shpchp k8temp amd_rng hwmon usb_storage sata_mv libata sd_mod scsi_mod
raid1 ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded:
freq_table]
Feb  5 02:51:01 SunSTG kernel: CPU 3:
Feb  5 02:51:01 SunSTG kernel: Modules linked in: raid456 async_xor
async_memcpy async_tx xor autofs4 hidp rfcomm l2cap bluetooth sunrpc
dm_mirror dm_log dm_multipath dm_mod wmi video output sbs sbshc battery
ac ipv6 parport_pc lp parport sr_mod cdrom joydev sg e1000 serio_raw
pata_amd pata_acpi i2c_amd8111 i2c_amd756 pcspkr ata_generic i2c_core
shpchp k8temp amd_rng hwmon usb_storage sata_mv libata sd_mod scsi_mod
raid1 ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded:
freq_table]
Feb  5 02:51:01 SunSTG kernel: Pid: 13198, comm: md4_raid5 Not tainted
2.6.26.8-57.fc8 #1
Feb  5 02:51:01 SunSTG kernel: RIP: 0010:[<ffffffffa0061d58>]
[<ffffffffa0061d58>] :scsi_mod:scsi_softirq_done+0xf4/0xfa
Feb  5 02:51:01 SunSTG kernel: RSP: 0018:ffff8101ff10bed0  EFLAGS:
00000282
Feb  5 02:51:01 SunSTG kernel: RAX: 0000000000000000 RBX:
ffff8101ff10bee0 RCX: ffff8101ff10bca0
Feb  5 02:51:01 SunSTG kernel: RDX: 0000000000000000 RSI:
ffff8101ff0e31e0 RDI: ffff8101fe3de218
Feb  5 02:51:01 SunSTG kernel: RBP: ffff8101ff10be50 R08:
0000000000000001 R09: 00000000ef6e7000
Feb  5 02:51:01 SunSTG kernel: R10: 0000000000001000 R11:
0000000000002002 R12: ffffffff8100cf52
Feb  5 02:51:01 SunSTG kernel: R13: ffff8101ff10be50 R14:
ffffffff8141b140 R15: 0000000000000001
Feb  5 02:51:01 SunSTG kernel: FS:  00007fdaeea3a6e0(0000)
GS:ffff8103ff039700(0000) knlGS:0000000000000000
Feb  5 02:51:01 SunSTG kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
0000000080050033
Feb  5 02:51:01 SunSTG kernel: CR2: 00007fadb1a4d170 CR3:
00000003f996e000 CR4: 00000000000006e0
Feb  5 02:51:01 SunSTG kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Feb  5 02:51:01 SunSTG kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Feb  5 02:51:01 SunSTG kernel:
Feb  5 02:51:01 SunSTG kernel: Call Trace:
Feb  5 02:51:01 SunSTG kernel:  <IRQ>  [<ffffffff8112d332>] ?
blk_done_softirq+0x71/0x80
Feb  5 02:51:01 SunSTG kernel:  [<ffffffff8103b31f>] ? __do_softirq
+0x5e/0xd5
Feb  5 02:51:01 SunSTG kernel:  [<ffffffff8100d52c>] ? call_softirq
+0x1c/0x28
Feb  5 02:51:01 SunSTG kernel:  [<ffffffff8100ed5e>] ? do_softirq
+0x44/0x8b
Feb  5 02:51:01 SunSTG kernel:  [<ffffffff8103b280>] ? irq_exit
+0x3f/0x80
Feb  5 02:51:01 SunSTG kernel:  [<ffffffff8100f05f>] ? do_IRQ
+0x147/0x16c
Feb  5 02:51:01 SunSTG kernel:  [<ffffffff8100c6cd>] ? ret_from_intr
+0x0/0x19
Feb  5 02:51:01 SunSTG kernel:  <EOI>
[<ffffffffa029940b>] ? :raid456:raid6_sse24_gen_syndrome+0x127/0x210
Feb  5 02:51:02 SunSTG kernel:
[<ffffffffa0299362>] ? :raid456:raid6_sse24_gen_syndrome+0x7e/0x210
Feb  5 02:51:02 SunSTG kernel:
[<ffffffffa0295f6a>] ? :raid456:compute_parity6+0x24f/0x2e2
Feb  5 02:51:02 SunSTG kernel:
[<ffffffffa0296146>] ? :raid456:compute_block_1+0x149/0x1b2
Feb  5 02:51:02 SunSTG kernel:
[<ffffffffa0296d8f>] ? :raid456:handle_stripe+0x9eb/0xf1b
Feb  5 02:51:02 SunSTG kernel:  [<ffffffffa029769d>] ? :raid456:raid5d
+0x3de/0x3ee
Feb  5 02:51:02 SunSTG kernel:  [<ffffffff81297b98>] ? schedule_timeout
+0x22/0xb4
Feb  5 02:51:02 SunSTG kernel:  [<ffffffff811f687a>] ? md_thread
+0xd6/0xee
Feb  5 02:51:02 SunSTG kernel:  [<ffffffff810492dc>] ?
autoremove_wake_function+0x0/0x38
Feb  5 02:51:02 SunSTG kernel:  [<ffffffff811f67a4>] ? md_thread
+0x0/0xee
Feb  5 02:51:02 SunSTG kernel:  [<ffffffff810491a5>] ? kthread+0x49/0x78
Feb  5 02:51:02 SunSTG kernel:  [<ffffffff8100d188>] ? child_rip
+0xa/0x12
Feb  5 02:51:02 SunSTG kernel:  [<ffffffff8104915c>] ? kthread+0x0/0x78
Feb  5 02:51:02 SunSTG kernel:  [<ffffffff8100d17e>] ? child_rip
+0x0/0x12
Feb  5 02:51:02 SunSTG kernel:


On Wed, 2009-01-28 at 22:30 +0200, Vladimir Ivashchenko wrote:
> Hi,
> 
> We've got these new Sun X4500 servers. The system I'm playing with now
> has 48 x 250 GB SATA HDDs.
> 
> Right now I'm creating two RAID6 arrays, 24 and 22 drives each:
> 
> mdadm --verbose --create /dev/md3 --level=6
> --raid-devices=24 /dev/sda /dev/sdaa /dev/sdab /dev/sdad /dev/sdae /dev/sdaf /dev/sdag /dev/sdah /dev/sdai /dev/sdaj /dev/sdak /dev/sdal /dev/sdam /dev/sdan /dev/sdao /dev/sdap /dev/sdaq /dev/sdar /dev/sdas /dev/sdat /dev/sdau /dev/sdav /dev/sdb /dev/sdc
> 
> mdadm --verbose --create /dev/md4 --level=6
> --raid-devices=22 /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sdm /dev/sdn /dev/sdo /dev/sdp /dev/sdq /dev/sdr /dev/sds /dev/sdt /dev/sdu /dev/sdv /dev/sdw /dev/sdx /dev/sdz
> 
> mdadm --detail is reporting that everything is going smoothly, however
> my /var/log/messages is full of "BUG: soft lockup - CPU#X stuck for
> 10s!" errors appearing every 1-3 minutes. 
> 
> CentOS 5.2, 2.6.18-92.1.22.el5PAE, sata_mv. Two dual-core Opterons @ 2.8
> Ghz, 16 GB RAM.
> 
> The system does not crash and otherwise seems to be healthy. Arrays are
> still under construction and I don't know if they will actually work
> yet.
> 
> What I noticed is that at first it was complaining about lockups on md3
> process, but once I started creating md4, complaints were exclusively
> for md4 process only.
> 
> Any stability assurances or workarounds are highly appreciated. :)
> 
> Jan 28 21:31:32 SunSTG kernel: BUG: soft lockup - CPU#0 stuck for 10s!
> [md3_raid5:5672]
> Jan 28 21:31:32 SunSTG kernel:
> Jan 28 21:31:32 SunSTG kernel: Pid: 5672, comm:            md3_raid5
> Jan 28 21:31:32 SunSTG kernel: EIP: 0060:[<f8d68162>] CPU: 0
> Jan 28 21:31:32 SunSTG kernel: EIP is at raid6_sse22_gen_syndrome
> +0x10a/0x1b6 [raid456]
> Jan 28 21:31:32 SunSTG kernel:  EFLAGS: 00000202    Not tainted
> (2.6.18-92.1.22.el5PAE #1)
> Jan 28 21:31:32 SunSTG kernel: EAX: ea0774e0 EBX: 000004e0 ECX: ead0ad30
> EDX: ea077000
> Jan 28 21:31:32 SunSTG kernel: ESI: ead0ade0 EDI: 00000004 EBP: ead0add0
> DS: 007b ES: 007b
> Jan 28 21:31:32 SunSTG kernel: CR0: 80050033 CR2: 0806e000 CR3: 373239e0
> CR4: 000006f0
> Jan 28 21:31:32 SunSTG kernel:  [<f8d63562>] compute_parity6+0x21c/0x28a
> [raid456]
> Jan 28 21:31:32 SunSTG kernel:  [<f8d6452e>] handle_stripe+0xc8b/0x215e
> [raid456]
> Jan 28 21:31:32 SunSTG kernel:  [<c041fdb3>] enqueue_task+0x29/0x39
> Jan 28 21:31:32 SunSTG kernel:  [<c0420629>] try_to_wake_up+0x371/0x37b
> Jan 28 21:31:32 SunSTG kernel:  [<c041edec>] __wake_up_common+0x2f/0x53
> Jan 28 21:31:32 SunSTG kernel:  [<c041fbe6>] __wake_up+0x2a/0x3d
> Jan 28 21:31:32 SunSTG kernel:  [<f8d61744>] release_stripe+0x21/0x2e
> [raid456]
> Jan 28 21:31:33 SunSTG kernel:  [<f8d65b0c>] raid5d+0x10b/0x130
> [raid456]
> Jan 28 21:31:33 SunSTG kernel:  [<c059aca8>] md_thread+0xdf/0xf5
> Jan 28 21:31:33 SunSTG kernel:  [<c0436347>] autoremove_wake_function
> +0x0/0x2d
> Jan 28 21:31:33 SunSTG kernel:  [<c059abc9>] md_thread+0x0/0xf5
> Jan 28 21:31:33 SunSTG kernel:  [<c0436285>] kthread+0xc0/0xeb
> Jan 28 21:31:33 SunSTG kernel:  [<c04361c5>] kthread+0x0/0xeb
> Jan 28 21:31:33 SunSTG kernel:  [<c0405c3b>] kernel_thread_helper
> +0x7/0x10
> 
> Jan 28 21:31:33 SunSTG kernel:  =======================
> Jan 28 21:32:26 SunSTG kernel: BUG: soft lockup - CPU#2 stuck for 10s!
> [md3_raid5:5672]
> Jan 28 21:32:26 SunSTG kernel:
> Jan 28 21:32:26 SunSTG kernel: Pid: 5672, comm:            md3_raid5
> Jan 28 21:32:26 SunSTG kernel: EIP: 0060:[<f8d68170>] CPU: 2
> Jan 28 21:32:26 SunSTG kernel: EIP is at raid6_sse22_gen_syndrome
> +0x118/0x1b6 [raid456]
> Jan 28 21:32:26 SunSTG kernel:  EFLAGS: 00000202    Not tainted
> (2.6.18-92.1.22.el5PAE #1)
> Jan 28 21:32:26 SunSTG kernel: EAX: ea784040 EBX: 00000040 ECX: ead0ad30
> EDX: ea784000
> Jan 28 21:32:26 SunSTG kernel: ESI: ead0adf0 EDI: 00000008 EBP: ead0add0
> DS: 007b ES: 007b
> Jan 28 21:32:26 SunSTG kernel: CR0: 80050033 CR2: b7f6f000 CR3: 3714e920
> CR4: 000006f0
> Jan 28 21:32:26 SunSTG kernel:  [<f8d63562>] compute_parity6+0x21c/0x28a
> [raid456]
> Jan 28 21:32:26 SunSTG kernel:  [<f8d6452e>] handle_stripe+0xc8b/0x215e
> [raid456]
> Jan 28 21:32:26 SunSTG kernel:  [<c041f34b>] find_busiest_group
> +0x177/0x462
> Jan 28 21:32:26 SunSTG kernel:  [<c041fc53>] task_rq_lock+0x31/0x58
> Jan 28 21:32:26 SunSTG kernel:  [<c0420629>] try_to_wake_up+0x371/0x37b
> Jan 28 21:32:26 SunSTG kernel:  [<f8d6171e>] __release_stripe+0xfc/0x101
> [raid456]
> Jan 28 21:32:26 SunSTG kernel:  [<f8d61744>] release_stripe+0x21/0x2e
> [raid456]
> Jan 28 21:32:26 SunSTG kernel:  [<f8d65b0c>] raid5d+0x10b/0x130
> [raid456]
> Jan 28 21:32:26 SunSTG kernel:  [<c059aca8>] md_thread+0xdf/0xf5
> Jan 28 21:32:26 SunSTG kernel:  [<c0436347>] autoremove_wake_function
> +0x0/0x2d
> Jan 28 21:32:26 SunSTG kernel:  [<c059abc9>] md_thread+0x0/0xf5
> Jan 28 21:32:26 SunSTG kernel:  [<c0436285>] kthread+0xc0/0xeb
> Jan 28 21:32:26 SunSTG kernel:  [<c04361c5>] kthread+0x0/0xeb
> Jan 28 21:32:26 SunSTG kernel:  [<c0405c3b>] kernel_thread_helper
> +0x7/0x10
> Jan 28 21:32:26 SunSTG kernel:  =======================
> 
> <somewhere here I issue commands to create md4>
> 
> Jan 28 21:32:43 SunSTG kernel: md: syncing RAID array md4
> Jan 28 21:32:43 SunSTG kernel: md: minimum _guaranteed_ reconstruction
> speed: 1000 KB/sec/disc.
> Jan 28 21:32:43 SunSTG kernel: md: using maximum available idle IO
> bandwidth (but not more than 200000 KB/sec) for reconstruction.
> Jan 28 21:32:43 SunSTG kernel: md: using 128k window, over a total of
> 244195200 blocks.
> Jan 28 21:33:20 SunSTG kernel: BUG: soft lockup - CPU#3 stuck for 10s!
> [md4_raid5:5694]
> Jan 28 21:33:20 SunSTG kernel:
> Jan 28 21:33:20 SunSTG kernel: Pid: 5694, comm:            md4_raid5
> Jan 28 21:33:20 SunSTG kernel: EIP: 0060:[<f8d63aff>] CPU: 3
> Jan 28 21:33:20 SunSTG kernel: EIP is at handle_stripe+0x25c/0x215e
> [raid456]
> Jan 28 21:33:20 SunSTG kernel:  EFLAGS: 00000282    Not tainted
> (2.6.18-92.1.22.el5PAE #1)
> Jan 28 21:33:20 SunSTG kernel: EAX: f6a2b404 EBX: 00000001 ECX: f53d17c0
> EDX: e8c532c0
> Jan 28 21:33:20 SunSTG kernel: ESI: e8c532c4 EDI: 00000016 EBP: e8c52b64
> DS: 007b ES: 007b
> Jan 28 21:33:20 SunSTG kernel: CR0: 8005003b CR2: b7cfc000 CR3: 3714ef00
> CR4: 000006f0
> Jan 28 21:33:20 SunSTG kernel:  [<c041f34b>] find_busiest_group
> +0x177/0x462
> Jan 28 21:33:20 SunSTG kernel:  [<c041fc53>] task_rq_lock+0x31/0x58
> Jan 28 21:33:20 SunSTG kernel:  [<c041fdb3>] enqueue_task+0x29/0x39
> Jan 28 21:33:20 SunSTG kernel:  [<c0420629>] try_to_wake_up+0x371/0x37b
> Jan 28 21:33:20 SunSTG kernel:  [<c041edec>] __wake_up_common+0x2f/0x53
> Jan 28 21:33:20 SunSTG kernel:  [<c041fbe6>] __wake_up+0x2a/0x3d
> Jan 28 21:33:20 SunSTG kernel:  [<f8d61744>] release_stripe+0x21/0x2e
> [raid456]
> Jan 28 21:33:20 SunSTG kernel:  [<f8d65b0c>] raid5d+0x10b/0x130
> [raid456]
> Jan 28 21:33:20 SunSTG kernel:  [<c059aca8>] md_thread+0xdf/0xf5
> Jan 28 21:33:20 SunSTG kernel:  [<c0436347>] autoremove_wake_function
> +0x0/0x2d
> Jan 28 21:33:20 SunSTG kernel:  [<c059abc9>] md_thread+0x0/0xf5
> Jan 28 21:33:21 SunSTG kernel:  [<c0436285>] kthread+0xc0/0xeb
> Jan 28 21:33:21 SunSTG kernel:  [<c04361c5>] kthread+0x0/0xeb
> Jan 28 21:33:21 SunSTG kernel:  [<c0405c3b>] kernel_thread_helper
> +0x7/0x10
> Jan 28 21:33:21 SunSTG kernel:  =======================
> Jan 28 21:33:50 SunSTG kernel: BUG: soft lockup - CPU#3 stuck for 10s!
> [md4_raid5:5694]
> Jan 28 21:33:50 SunSTG kernel:
> Jan 28 21:33:50 SunSTG kernel: Pid: 5694, comm:            md4_raid5
> Jan 28 21:33:50 SunSTG kernel: EIP: 0060:[<f8bf9813>] CPU: 3
> Jan 28 21:33:50 SunSTG kernel: EIP is at xor_sse_5+0xa0/0x3b5 [xor]
> Jan 28 21:33:50 SunSTG kernel:  EFLAGS: 00000202    Not tainted
> (2.6.18-92.1.22.el5PAE #1)
> Jan 28 21:33:50 SunSTG kernel: EAX: 0000000b EBX: e8e66500 ECX: e8e69500
> EDX: e8e6e500
> Jan 28 21:33:50 SunSTG kernel: ESI: e8e67500 EDI: e8e68500 EBP: e96b5dd4
> DS: 007b ES: 007b
> Jan 28 21:33:50 SunSTG kernel: CR0: 80050033 CR2: b7cfc000 CR3: 3714ef00
> CR4: 000006f0
> Jan 28 21:33:50 SunSTG kernel:  [<f8bfa200>] xor_block+0x74/0x7d [xor]
> Jan 28 21:33:50 SunSTG kernel:  [<f8d636b3>] compute_block_1+0xe3/0x13a
> [raid456]
> Jan 28 21:33:50 SunSTG kernel:  [<f8d644ba>] handle_stripe+0xc17/0x215e
> [raid456]
> Jan 28 21:33:50 SunSTG kernel:  [<c041f34b>] find_busiest_group
> +0x177/0x462
> Jan 28 21:33:50 SunSTG kernel:  [<c041fdb3>] enqueue_task+0x29/0x39
> Jan 28 21:33:50 SunSTG kernel:  [<c0420629>] try_to_wake_up+0x371/0x37b
> Jan 28 21:33:50 SunSTG kernel:  [<c041edec>] __wake_up_common+0x2f/0x53
> Jan 28 21:33:50 SunSTG kernel:  [<c041fbe6>] __wake_up+0x2a/0x3d
> Jan 28 21:33:50 SunSTG kernel:  [<f8d61744>] release_stripe+0x21/0x2e
> [raid456]
> Jan 28 21:33:50 SunSTG kernel:  [<f8d65b0c>] raid5d+0x10b/0x130
> [raid456]
> Jan 28 21:33:50 SunSTG kernel:  [<c059aca8>] md_thread+0xdf/0xf5
> Jan 28 21:33:50 SunSTG kernel:  [<c0436347>] autoremove_wake_function
> +0x0/0x2d
> Jan 28 21:33:50 SunSTG kernel:  [<c059abc9>] md_thread+0x0/0xf5
> Jan 28 21:33:51 SunSTG kernel:  [<c0436285>] kthread+0xc0/0xeb
> Jan 28 21:33:51 SunSTG kernel:  [<c04361c5>] kthread+0x0/0xeb
> Jan 28 21:33:51 SunSTG kernel:  [<c0405c3b>] kernel_thread_helper
> +0x7/0x10
> Jan 28 21:33:51 SunSTG kernel:  =======================
> ... and it goes on complaining about md4_raid5:5694.
> 
> [root@SunSTG ~]# mdadm --detail /dev/md3
> /dev/md3:
>         Version : 00.90.03
>   Creation Time : Wed Jan 28 21:30:50 2009
>      Raid Level : raid6
>      Array Size : 5372294400 (5123.42 GiB 5501.23 GB)
>   Used Dev Size : 244195200 (232.88 GiB 250.06 GB)
>    Raid Devices : 24
>   Total Devices : 24
> Preferred Minor : 3
>     Persistence : Superblock is persistent
> 
>     Update Time : Wed Jan 28 21:30:50 2009
>           State : clean, resyncing
>  Active Devices : 24
> Working Devices : 24
>  Failed Devices : 0
>   Spare Devices : 0
> 
>      Chunk Size : 64K
> 
>  Rebuild Status : 15% complete
> 
>            UUID : d8c2b5ce:576a117b:f2494cd1:626a774c
>          Events : 0.1
> 
>     Number   Major   Minor   RaidDevice State
>        0       8        0        0      active sync   /dev/sda
>        1      65      160        1      active sync   /dev/sdaa
>        2      65      176        2      active sync   /dev/sdab
>        3      65      208        3      active sync   /dev/sdad
>        4      65      224        4      active sync   /dev/sdae
>        5      65      240        5      active sync   /dev/sdaf
>        6      66        0        6      active sync   /dev/sdag
>        7      66       16        7      active sync   /dev/sdah
>        8      66       32        8      active sync   /dev/sdai
>        9      66       48        9      active sync   /dev/sdaj
>       10      66       64       10      active sync   /dev/sdak
>       11      66       80       11      active sync   /dev/sdal
>       12      66       96       12      active sync   /dev/sdam
>       13      66      112       13      active sync   /dev/sdan
>       14      66      128       14      active sync   /dev/sdao
>       15      66      144       15      active sync   /dev/sdap
>       16      66      160       16      active sync   /dev/sdaq
>       17      66      176       17      active sync   /dev/sdar
>       18      66      192       18      active sync   /dev/sdas
>       19      66      208       19      active sync   /dev/sdat
>       20      66      224       20      active sync   /dev/sdau
>       21      66      240       21      active sync   /dev/sdav
>       22       8       16       22      active sync   /dev/sdb
>       23       8       32       23      active sync   /dev/sdc
> [root@SunSTG ~]# mdadm --detail /dev/md4
> /dev/md4:
>         Version : 00.90.03
>   Creation Time : Wed Jan 28 21:32:39 2009
>      Raid Level : raid6
>      Array Size : 4883904000 (4657.65 GiB 5001.12 GB)
>   Used Dev Size : 244195200 (232.88 GiB 250.06 GB)
>    Raid Devices : 22
>   Total Devices : 22
> Preferred Minor : 4
>     Persistence : Superblock is persistent
> 
>     Update Time : Wed Jan 28 21:32:39 2009
>           State : clean, resyncing
>  Active Devices : 22
> Working Devices : 22
>  Failed Devices : 0
>   Spare Devices : 0
> 
>      Chunk Size : 64K
> 
>  Rebuild Status : 17% complete
> 
>            UUID : 7e2c7f35:f51c9047:40130c15:63a7cfa6
>          Events : 0.1
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       48        0      active sync   /dev/sdd
>        1       8       64        1      active sync   /dev/sde
>        2       8       80        2      active sync   /dev/sdf
>        3       8       96        3      active sync   /dev/sdg
>        4       8      112        4      active sync   /dev/sdh
>        5       8      128        5      active sync   /dev/sdi
>        6       8      144        6      active sync   /dev/sdj
>        7       8      160        7      active sync   /dev/sdk
>        8       8      176        8      active sync   /dev/sdl
>        9       8      192        9      active sync   /dev/sdm
>       10       8      208       10      active sync   /dev/sdn
>       11       8      224       11      active sync   /dev/sdo
>       12       8      240       12      active sync   /dev/sdp
>       13      65        0       13      active sync   /dev/sdq
>       14      65       16       14      active sync   /dev/sdr
>       15      65       32       15      active sync   /dev/sds
>       16      65       48       16      active sync   /dev/sdt
>       17      65       64       17      active sync   /dev/sdu
>       18      65       80       18      active sync   /dev/sdv
>       19      65       96       19      active sync   /dev/sdw
>       20      65      112       20      active sync   /dev/sdx
>       21      65      144       21      active sync   /dev/sdz
> 
> 
-- 
Best Regards,
Vladimir Ivashchenko
Chief Technology Officer
PrimeTel PLC, Cyprus - www.prime-tel.com
Tel: +357 25 100100 Fax: +357 2210 2211


