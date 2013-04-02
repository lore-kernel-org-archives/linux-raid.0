From: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: bcache: BUG in fuzz testing without devices
Date: Tue, 02 Apr 2013 12:21:02 -0400
Message-ID: <515B056E.6010002@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-raid.ids

Hi all,

It seems that trying to fuzz bcache without any devices triggers a BUG:

sh-4.2# echo 1 > /sys/fs/bcache/fuzz
[   89.700458] bio: create slab <bio-1> at 1
[   89.704543] ------------[ cut here ]------------
[   89.710043] kernel BUG at drivers/md/bcache/debug.c:447!
[   89.710043] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[   89.710043] Modules linked in:
[   89.710043] CPU 2
[   89.710043] Pid: 6885, comm: sh Tainted: G        W    3.9.0-rc4-next-20130328-sasha-00017-g1463000 #321
[   89.710043] RIP: 0010:[<ffffffff8324c005>]  [<ffffffff8324c005>] btree_fuzz+0x95/0x720
[   89.710043] RSP: 0018:ffff880035279be8  EFLAGS: 00010246
[   89.710043] RAX: ffff880034720000 RBX: ffff880034721030 RCX: ffff8800353af400
[   89.710043] RDX: 0000000000000000 RSI: ffff880034723b18 RDI: ffff88003477a960
[   89.710043] RBP: ffff880035279e88 R08: ffff88003477a900 R09: ffff88003d801e00
[   89.710043] R10: 000000000048d002 R11: 0000000000000000 R12: ffff880035279c18
[   89.710043] R13: ffff880034721030 R14: ffff880034720000 R15: ffff880035279c30
[   89.710043] FS:  00007f591db62700(0000) GS:ffff88003e000000(0000) knlGS:0000000000000000
[   89.710043] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   89.710043] CR2: 00007f591db8e000 CR3: 0000000035bf0000 CR4: 00000000000406e0
[   89.710043] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   89.710043] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   89.710043] Process sh (pid: 6885, threadinfo ffff880035278000, task ffff880037060000)
[   89.710043] Stack:
[   89.710043]  ffffffff84c1b104 ffffffff83e20320 000000000000d8e0 ffff880035279ca8
[   89.710043]  ffff88003e00a000 ffff880035278000 ffff880035279fd8 ffff88003e1d7cd0
[   89.710043]  ffff880035279c58 0000000000000000 0000000000000000 0000000000000000
[   89.710043] Call Trace:
[   89.710043]  [<ffffffff812ffd92>] ? sysfs_write_file+0xe2/0x150
[   89.710043]  [<ffffffff819fff5f>] kobj_attr_store+0xf/0x20
[   89.710043]  [<ffffffff812ffdaa>] sysfs_write_file+0xfa/0x150
[   89.710043]  [<ffffffff8127eff0>] vfs_write+0xb0/0x180
[   89.710043]  [<ffffffff8127f480>] SyS_write+0x50/0xa0
[   89.710043]  [<ffffffff83db7e58>] tracesys+0xe1/0xe6
[   89.710043] Code: c0 49 89 c6 0f 84 2c 06 00 00 4c 8d a5 90 fd ff ff 4c 8d a8 30 10 00 00 4d 89 e7 49 83 c7 18 49 8b 9e 30 10
00 00 4c 39 eb 75 0b <0f> 0b 66 0f 1f 84 00 00 00 00 00 48 8d 83 a0 fd ff ff 48 89 df
[   89.710043] RIP  [<ffffffff8324c005>] btree_fuzz+0x95/0x720
[   89.710043]  RSP <ffff880035279be8>
[   89.755259] ---[ end trace d6647580839fba22 ]---

That BUG looks very intentional there, any reason for adding it instead of exiting
if there aren't any devices?


Thanks,
Sasha
