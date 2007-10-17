From: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Subject: Re: [BUG] Raid5 trouble
Date: Wed, 17 Oct 2007 16:32:03 +0200
Message-ID: <47161CE3.80909@systella.fr>
References: <4714BB92.7040701@systella.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4714BB92.7040701@systella.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-raid.ids

BERTRAND Jo=EBl wrote:
>     Hello,
>=20
>     I run 2.6.23 linux kernel on two T1000 (sparc64) servers. Each=20
> server has a partitionable raid5 array (/dev/md/d0) and I have to=20
> synchronize both raid5 volumes by raid1. Thus, I have tried to build =
a=20
> raid1 volume between /dev/md/d0p1 and /dev/sdi1 (exported by iscsi fr=
om=20
> the second server) and I obtain a BUG :
>=20
> Root gershwin:[/usr/scripts] > mdadm -C /dev/md7 -l1 -n2 /dev/md/d0p1=
=20
> /dev/sdi1
> ...

	Hello,

	I have fixed iscsi-target, and I have tested it. It works now without=20
any trouble. Patches were posted on iscsi-target mailing list. When I=20
use iSCSI to access to foreign raid5 volume, it works fine. I can forma=
t=20
foreign volume, copy large files on it... But when I tried to create a=20
new raid1 volume with a local raid5 volume and a foreign raid5 volume, =
I=20
receive my well known Oops. You can find my dmesg after Oops :

md: md_d0 stopped.
md: bind<sdd1>
md: bind<sde1>
md: bind<sdf1>
md: bind<sdg1>
md: bind<sdh1>

md: bind<sdc1>
raid5: device sdc1 operational as raid disk 0
raid5: device sdh1 operational as raid disk 5
raid5: device sdg1 operational as raid disk 4
raid5: device sdf1 operational as raid disk 3
raid5: device sde1 operational as raid disk 2
raid5: device sdd1 operational as raid disk 1
raid5: allocated 12518kB for md_d0
raid5: raid level 5 set md_d0 active with 6 out of 6 devices, algorithm=
 2
RAID5 conf printout:
  --- rd:6 wd:6
  disk 0, o:1, dev:sdc1
  disk 1, o:1, dev:sdd1
  disk 2, o:1, dev:sde1
  disk 3, o:1, dev:sdf1
  disk 4, o:1, dev:sdg1
  disk 5, o:1, dev:sdh1
  md_d0: p1
scsi3 : iSCSI Initiator over TCP/IP
scsi 3:0:0:0: Direct-Access     IET      VIRTUAL-DISK     0    PQ: 0 AN=
SI: 4
sd 3:0:0:0: [sdi] 2929451520 512-byte hardware sectors (1499879 MB)
sd 3:0:0:0: [sdi] Write Protect is off
sd 3:0:0:0: [sdi] Mode Sense: 77 00 00 08
sd 3:0:0:0: [sdi] Write cache: disabled, read cache: enabled, doesn't=20
support DPO or FUA
sd 3:0:0:0: [sdi] 2929451520 512-byte hardware sectors (1499879 MB)
sd 3:0:0:0: [sdi] Write Protect is off
sd 3:0:0:0: [sdi] Mode Sense: 77 00 00 08
sd 3:0:0:0: [sdi] Write cache: disabled, read cache: enabled, doesn't=20
support DPO or FUA
  sdi: sdi1
sd 3:0:0:0: [sdi] Attached SCSI disk
md: bind<md_d0p1>
md: bind<sdi1>
md: md7: raid array is not clean -- starting background reconstruction
raid1: raid set md7 active with 2 out of 2 mirrors
md: resync of RAID array md7
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000=
=20
KB/sec) for resync.
md: using 256k window, over a total of 1464725632 blocks.
kernel BUG at drivers/md/raid5.c:380!
               \|/ ____ \|/
               "@'/ .. \`@"
               /_| \__/ |_\
                  \__U_/
md7_resync(4929): Kernel bad sw trap 5 [#1]
TSTATE: 0000000080001606 TPC: 00000000005ed50c TNPC: 00000000005ed510 Y=
:=20
00000000    Not tainted
TPC: <get_stripe_work+0x1f4/0x200>
g0: 0000000000000005 g1: 00000000007c0400 g2: 0000000000000001 g3:=20
0000000000748400
g4: fffff800feeb6880 g5: fffff80002080000 g6: fffff800e7598000 g7:=20
0000000000748528
o0: 0000000000000029 o1: 0000000000715798 o2: 000000000000017c o3:=20
0000000000000005
o4: 0000000000000006 o5: fffff800e8f0a060 sp: fffff800e759ad81 ret_pc:=20
00000000005ed504
RPC: <get_stripe_work+0x1ec/0x200>
l0: 0000000000000002 l1: ffffffffffffffff l2: fffff800e8f0a0a0 l3:=20
fffff800e8f09fe8
l4: fffff800e8f0a088 l5: fffffffffffffff8 l6: 0000000000000005 l7:=20
fffff800e8374000
i0: fffff800e8f0a028 i1: 0000000000000000 i2: 0000000000000004 i3:=20
fffff800e759b720
i4: 0000000000000080 i5: 0000000000000080 i6: fffff800e759ae51 i7:=20
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
Instruction DUMP: 9210217c  7ff8f57f  90122398 <91d02005> 30680004=20
01000000  01000000  01000000  9de3bf00

	I suspect a major bug in raid5 code but I don't know how debug it...

	md7 was crated by mdadm -C /dev/md7 -l1 -n2 /dev/md/d0 /dev/sdi1.=20
/dev/md/d0 is a raid5 volume, and sdi a iSCSI disk.

	Regards,

	JKB
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
