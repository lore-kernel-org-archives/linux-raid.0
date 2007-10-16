From: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Subject: [BUG] Raid5 trouble
Date: Tue, 16 Oct 2007 15:24:34 +0200
Message-ID: <4714BB92.7040701@systella.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
Sender: sparclinux-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-raid.ids

	Hello,

	I run 2.6.23 linux kernel on two T1000 (sparc64) servers. Each server 
has a partitionable raid5 array (/dev/md/d0) and I have to synchronize 
both raid5 volumes by raid1. Thus, I have tried to build a raid1 volume 
between /dev/md/d0p1 and /dev/sdi1 (exported by iscsi from the second 
server) and I obtain a BUG :

Root gershwin:[/usr/scripts] > mdadm -C /dev/md7 -l1 -n2 /dev/md/d0p1 
/dev/sdi1
...
kernel BUG at drivers/md/raid5.c:380!
               \|/ ____ \|/
               "@'/ .. \`@"
               /_| \__/ |_\
                  \__U_/
md7_resync(4476): Kernel bad sw trap 5 [#1]
TSTATE: 0000000080001606 TPC: 00000000005ed50c TNPC: 00000000005ed510 Y: 
00000000    Not tainted
TPC: <get_stripe_work+0x1f4/0x200>
g0: 0000000000000005 g1: 00000000007c0400 g2: 0000000000000001 g3: 
0000000000748400
g4: fffff800ebdb2400 g5: fffff80002080000 g6: fffff800e82fc000 g7: 
0000000000748528
o0: 0000000000000029 o1: 0000000000715798 o2: 000000000000017c o3: 
0000000000000005
o4: 0000000000000006 o5: fffff800e9bb6e28 sp: fffff800e82fed81 ret_pc: 
00000000005ed504
RPC: <get_stripe_work+0x1ec/0x200>
l0: 0000000000000002 l1: ffffffffffffffff l2: fffff800e9bb6e68 l3: 
fffff800e9bb6db0
l4: fffff800e9bb6e50 l5: fffffffffffffff8 l6: 0000000000000005 l7: 
fffff800fcbd6000
i0: fffff800e9bb6df0 i1: 0000000000000000 i2: 0000000000000004 i3: 
fffff800e82ff720
i4: 0000000000000080 i5: 0000000000000080 i6: fffff800e82fee51 i7: 
00000000005f0274
I7: <handle_stripe5+0x4fc/0x1340>
Caller[00000000005f0274]: handle_stripe5+0x4fc/0x1340
Caller[00000000005f211c]: handle_stripe+0x24/0x13e0
Caller[00000000005f4450]: make_request+0x358/0x600
Caller[0000000000542890]: generic_make_request+0x198/0x220
Caller[00000000005eb240]: sync_request+0x608/0x640
Caller[00000000005fef7c]: md_do_sync+0x384/0x920
Caller[00000000005ff8f0]: md_thread+0x38/0x140
Caller[0000000000478b40]: kthread+0x48/0x80
Caller[00000000004273d0]: kernel_thread+0x38/0x60
Caller[0000000000478de0]: kthreadd+0x148/0x1c0
Instruction DUMP: 9210217c  7ff8f57f  90122398 <91d02005> 30680004 
01000000  01000000  01000000  9de3bf00

Root gershwin:[/usr/scripts] > cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md7 : active raid1 sdi1[1] md_d0p1[0]
       1464725632 blocks [2/2] [UU]
       [>....................]  resync =  0.0% (132600/1464725632) 
finish=141823.7min speed=171K/sec

md_d0 : active raid5 sdc1[0] sdh1[5] sdg1[4] sdf1[3] sde1[2] sdd1[1]
       1464725760 blocks level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]
...
Root gershwin:[/usr/scripts] > fdisk -l /dev/md/d0

Disk /dev/md/d0: 1499.8 GB, 1499879178240 bytes
2 heads, 4 sectors/track, 366181440 cylinders
Units = cylinders of 8 * 512 = 4096 bytes
Disk identifier: 0xa4a52979

       Device Boot      Start         End      Blocks   Id  System
/dev/md/d0p1               1   366181440  1464725758   fd  Linux raid 
autodetect
Root gershwin:[/usr/scripts] > fdisk -l /dev/sdi

Disk /dev/sdi: 1499.8 GB, 1499879178240 bytes
2 heads, 4 sectors/track, 366181440 cylinders
Units = cylinders of 8 * 512 = 4096 bytes
Disk identifier: 0xf6cdb2a3

    Device Boot      Start         End      Blocks   Id  System
/dev/sdi1               1   366181440  1464725758   fd  Linux raid 
autodetect
Root gershwin:[/usr/scripts] > cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: FUJITSU  Model: MAY2073RCSUN72G  Rev: 0501
   Type:   Direct-Access                    ANSI  SCSI revision: 04
Host: scsi0 Channel: 00 Id: 01 Lun: 00
   Vendor: FUJITSU  Model: MAY2073RCSUN72G  Rev: 0501
   Type:   Direct-Access                    ANSI  SCSI revision: 04
Host: scsi2 Channel: 00 Id: 08 Lun: 00
   Vendor: FUJITSU  Model: MAW3300NC        Rev: 0104
   Type:   Direct-Access                    ANSI  SCSI revision: 03
Host: scsi2 Channel: 00 Id: 09 Lun: 00
   Vendor: FUJITSU  Model: MAW3300NC        Rev: 0104
   Type:   Direct-Access                    ANSI  SCSI revision: 03
Host: scsi2 Channel: 00 Id: 10 Lun: 00
   Vendor: FUJITSU  Model: MAW3300NC        Rev: 0104
   Type:   Direct-Access                    ANSI  SCSI revision: 03
Host: scsi2 Channel: 00 Id: 11 Lun: 00
   Vendor: FUJITSU  Model: MAW3300NC        Rev: 0104
   Type:   Direct-Access                    ANSI  SCSI revision: 03
Host: scsi2 Channel: 00 Id: 12 Lun: 00
   Vendor: FUJITSU  Model: MAW3300NC        Rev: 0104
   Type:   Direct-Access                    ANSI  SCSI revision: 03
Host: scsi2 Channel: 00 Id: 13 Lun: 00
   Vendor: FUJITSU  Model: MAW3300NC        Rev: 0104
   Type:   Direct-Access                    ANSI  SCSI revision: 03
Host: scsi3 Channel: 00 Id: 00 Lun: 00
   Vendor: IET      Model: VIRTUAL-DISK     Rev: 0
   Type:   Direct-Access                    ANSI  SCSI revision: 04
Root gershwin:[/usr/scripts] >

	I don't think if this bug is arch specific, but I never see it on amd64...

	Regards,

	JKB
