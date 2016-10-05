From: Marc Smith <marc.smith@mcc.edu>
Subject: md-cluster - Assemble/Scan During Resync
Date: Wed, 5 Oct 2016 16:43:46 -0400
Message-ID: <CAHkw+Lc3XGqTL5pLX=UhQ+-kdHiVDPO8Z+EbTkWjyk6RgW5tug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

First, I believe this issue may have been reported/solved with this
thread ("[PATCH 3/3] MD: hold mddev lock for md-cluster receive
thread"):
http://www.spinics.net/lists/raid/msg53121.html

But I'm not totally sure, and I'm looking for confirmation, or maybe
this is a new one... I'm trying to hold out for Linux 4.9 in my
project, and I am hoping to just cherry pick any patches until then.

Testing md-cluster with Linux 4.5.2 (yes, I know its dated)... two
nodes connected to shared SAS storage, and I'm using DM Multipath in
front of the individual SAS disks (two I/O modules with dual-domain
SAS disks).

On tgtnode2 I created the array like this: mdadm --create --verbose
--run /dev/md/test4 --name=test4 --level=raid1 --raid-devices=2
--chunk=64 --bitmap=clustered /dev/dm-4 /dev/dm-5

And then, without waiting for the resync to complete, on the second
node (tgtnode1) I do this: mdadm --assemble --scan

Then I end up with this on tgtnode1:
--snip--
Oct  5 16:02:26 tgtnode1 kernel: [687524.358611] BUG: unable to handle
kernel NULL pointer dereference at 0000000000000098
Oct  5 16:02:26 tgtnode1 kernel: [687524.358637] IP:
[<ffffffff8182434a>] recv_daemon+0x104/0x366
Oct  5 16:02:26 tgtnode1 kernel: [687524.358660] PGD 0
Oct  5 16:02:26 tgtnode1 kernel: [687524.358669] Oops: 0000 [#1] SMP
Oct  5 16:02:26 tgtnode1 kernel: [687524.358683] Modules linked in:
fcst(O) scst_changer(O) scst_tape(O) scst_vdisk(O) scst_disk(O)
ib_srpt(O) iscsi_scst(O) qla2x00tgt(O) scst(O) qla2xxx bonding
mlx5_core bna ib_umad rdma_ucm ib_uverbs ib_srp iw_nes iw_cxgb4 cxgb4
iw_cxgb3 ib_qib mlx4_ib ib_mthca [last unloaded: scst]
Oct  5 16:02:26 tgtnode1 kernel: [687524.358791] CPU: 8 PID: 4840
Comm: md127_cluster_r Tainted: G           O    4.5.2-esos.prod #1
Oct  5 16:02:26 tgtnode1 kernel: [687524.358809] Hardware name: Dell
Inc. PowerEdge R710/00NH4P, BIOS 6.4.0 07/23/2013
Oct  5 16:02:26 tgtnode1 kernel: [687524.359038] task:
ffff880618991600 ti: ffff8806198a0000 task.ti: ffff8806198a0000
Oct  5 16:02:26 tgtnode1 kernel: [687524.359271] RIP:
0010:[<ffffffff8182434a>]  [<ffffffff8182434a>]
recv_daemon+0x104/0x366
Oct  5 16:02:26 tgtnode1 kernel: [687524.359515] RSP:
0018:ffff8806198a3df8  EFLAGS: 00010286
Oct  5 16:02:26 tgtnode1 kernel: [687524.359639] RAX: 0000000000000000
RBX: ffff8806189ce000 RCX: 00000000004cd980
Oct  5 16:02:26 tgtnode1 kernel: [687524.359885] RDX: 00000000004dd980
RSI: 0000000000000001 RDI: ffff8806189ce000
Oct  5 16:02:26 tgtnode1 kernel: [687524.360124] RBP: ffff88031a5ce700
R08: 0000000000016ec0 R09: ffff88061e85dfc0
Oct  5 16:02:26 tgtnode1 kernel: [687524.360367] R10: ffffffff8182431d
R11: 0000000000000002 R12: ffff88061e85dfc0
Oct  5 16:02:26 tgtnode1 kernel: [687524.360600] R13: ffff8800aeb60480
R14: 0000000000000000 R15: ffff8800aeb60b80
Oct  5 16:02:26 tgtnode1 kernel: [687524.360827] FS:
0000000000000000(0000) GS:ffff88062fc80000(0000)
knlGS:0000000000000000
Oct  5 16:02:26 tgtnode1 kernel: [687524.361059] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b
Oct  5 16:02:26 tgtnode1 kernel: [687524.361184] CR2: 0000000000000098
CR3: 0000000002012000 CR4: 00000000000006e0
Oct  5 16:02:26 tgtnode1 kernel: [687524.361422] Stack:
Oct  5 16:02:26 tgtnode1 kernel: [687524.361535]  ffff88031a5ce730
00000000004dd980 00000000004cd980 0000000000000001
Oct  5 16:02:26 tgtnode1 kernel: [687524.361771]  00000000004cd980
00000000004dd980 0000000000000000 0000000000000000
Oct  5 16:02:26 tgtnode1 kernel: [687524.362007]  0000000000000000
0000000093f3fcfe ffff88061efde3c0 7fffffffffffffff
Oct  5 16:02:26 tgtnode1 kernel: [687524.362251] Call Trace:
Oct  5 16:02:26 tgtnode1 kernel: [687524.362369]  [<ffffffff8183df32>]
? md_thread+0x112/0x128
Oct  5 16:02:26 tgtnode1 kernel: [687524.362491]  [<ffffffff8108b4d6>]
? wait_woken+0x69/0x69
Oct  5 16:02:26 tgtnode1 kernel: [687524.362611]  [<ffffffff8183de20>]
? md_wait_for_blocked_rdev+0x102/0x102
Oct  5 16:02:26 tgtnode1 kernel: [687524.362736]  [<ffffffff81077eb1>]
? kthread+0xc1/0xc9
Oct  5 16:02:26 tgtnode1 kernel: [687524.362855]  [<ffffffff81077df0>]
? kthread_create_on_node+0x163/0x163
Oct  5 16:02:26 tgtnode1 kernel: [687524.362979]  [<ffffffff81a3111f>]
? ret_from_fork+0x3f/0x70
Oct  5 16:02:26 tgtnode1 kernel: [687524.363099]  [<ffffffff81077df0>]
? kthread_create_on_node+0x163/0x163
Oct  5 16:02:26 tgtnode1 kernel: [687524.363223] Code: c0 49 89 c4 0f
84 86 00 00 00 48 8b 54 24 08 48 8b 4c 24 10 48 89 df 44 89 30 be 01
00 00 00 48 89 48 08 48 89 50 10 48 8b 43 08 <ff> 90 98 00 00 00 48 8b
43 08 31 f6 48 89 df ff 90 98 00 00 00
Oct  5 16:02:26 tgtnode1 kernel: [687524.363707] RIP
[<ffffffff8182434a>] recv_daemon+0x104/0x366
Oct  5 16:02:26 tgtnode1 kernel: [687524.363832]  RSP <ffff8806198a3df8>
Oct  5 16:02:26 tgtnode1 kernel: [687524.363952] CR2: 0000000000000098
Oct  5 16:02:26 tgtnode1 kernel: [687524.364395] ---[ end trace
18dcff928d33f203 ]---
Oct  5 16:02:27 tgtnode1 kernel: [687525.358844]
gather_all_resync_info:700 Resync[5036416..5101952] in progress on 0
Oct  5 16:02:27 tgtnode1 kernel: [687525.758862] bitmap_read_sb:587 bm
slot: 2 offset: 24
Oct  5 16:02:27 tgtnode1 kernel: [687525.759203] created bitmap (1
pages) for device md127
Oct  5 16:02:27 tgtnode1 kernel: [687525.759536] md127: bitmap
initialized from disk: read 1 pages, set 0 of 1093 bits
Oct  5 16:02:27 tgtnode1 kernel: [687525.759990] bitmap_read_sb:587 bm
slot: 3 offset: 32
Oct  5 16:02:27 tgtnode1 kernel: [687525.760335] created bitmap (1
pages) for device md127
Oct  5 16:02:27 tgtnode1 kernel: [687525.760650] md127: bitmap
initialized from disk: read 1 pages, set 0 of 1093 bits
Oct  5 16:02:27 tgtnode1 kernel: [687525.761137] bitmap_read_sb:587 bm
slot: 1 offset: 16
Oct  5 16:02:27 tgtnode1 kernel: [687525.761459] created bitmap (1
pages) for device md127
Oct  5 16:02:27 tgtnode1 kernel: [687525.761793] md127: bitmap
initialized from disk: read 1 pages, set 0 of 1093 bits
Oct  5 16:03:22 tgtnode1 kernel: <28>[687580.180227] udevd[482]:
worker [4803] /devices/virtual/block/dm-5 is taking a long time
Oct  5 16:03:22 tgtnode1 kernel: <28>[687580.180515] udevd[482]:
worker [4804] /devices/virtual/block/dm-4 is taking a long time
--snip--

And it appears the resync task hangs then and makes no more progress...

On tgtnode2:
# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md127 : active raid1 dm-5[1] dm-4[0]
      71621824 blocks super 1.2 [2/2] [UU]
      [>....................]  resync =  3.5% (2518208/71621824)
finish=212.1min speed=5427K/sec
      bitmap: 1/1 pages [4KB], 65536KB chunk

unused devices: <none>


On tgtnode1:
# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md127 : active raid1 dm-4[0] dm-5[1]
      71621824 blocks super 1.2 [2/2] [UU]
        resync=PENDING
      bitmap: 0/1 pages [0KB], 65536KB chunk

unused devices: <none>


So, again, this may already be fixed, just looking for confirmation if
the aforementioned patch / thread is related to this bug (or maybe
another).

I appreciate your time.


--Marc
