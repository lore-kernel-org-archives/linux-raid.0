From: "Francois Barre" <francois.barre@gmail.com>
Subject: Ooops on read-only raid5 while unmounting as xfs
Date: Thu, 18 Jan 2007 11:18:33 +0100
Message-ID: <fd8d0180701180218o66a48176q172b029673c22660@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

I've hit the following bug while unmounting a xfs partition

----------- [cut here ] --------- [please bite here ] ---------
Kernel BUG at drivers/md/md.c:5035
invalid opcode: 0000 [1] SMP
CPU 0
Modules linked in: unionfs sbp2 ohci1394 ieee1394 raid456 xor
w83627ehf i2c_isa i2c_core
Pid: 1838, comm: umount Not tainted 2.6.18.6 #3
RIP: 0010:[<ffffffff8048ddc8>]  [<ffffffff8048ddc8>] md_write_start+0x28/0x160
RSP: 0000:ffff81000d581b28  EFLAGS: 00010246
RAX: 0000000000000001 RBX: ffff8100184f3800 RCX: ffff8100184ea670
RDX: 0000000000000008 RSI: ffff810011ade140 RDI: ffff8100184f3800
RBP: ffff810011ade140 R08: 0000000000000000 R09: 00000000000000ff
R10: ffff810011ade140 R11: ffffffff8038fbc0 R12: ffff810018094c00
R13: ffff810011ade140 R14: ffff810011ade140 R15: 0000000000000000
FS:  00002b7ce7f871f0(0000) GS:ffffffff807b9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002b7ce7807471 CR3: 0000000016818000 CR4: 00000000000006e0
Process umount (pid: 1838, threadinfo ffff81000d580000, task ffff81001f5ff850)
Stack:  ffff810004b630d0 0000000000000000 0000000000001000 ffff81000d581c08
 0000000000000001 ffffffff8028a355 0000000000000008 ffff810011ade140
 ffff810018094c00 ffffffff8801dc51 0000000000000000 ffff8100075f5880
Call Trace:
 [<ffffffff8801dc51>] :raid456:make_request+0x51/0x540
 [<ffffffff803ae472>] generic_make_request+0x152/0x170
 [<ffffffff803b0fbd>] submit_bio+0xdd/0xf0
 [<ffffffff8039ae36>] xfs_buf_iorequest+0x3c6/0x430
 [<ffffffff8039fdc5>] xfs_bdstrat_cb+0x45/0x50
 [<ffffffff8039743c>] xfs_bwrite+0x6c/0xf0
 [<ffffffff8038fa1f>] xfs_syncsub+0x16f/0x2a0
 [<ffffffff803a166f>] xfs_fs_sync_super+0x4f/0x130
 [<ffffffff8028aab6>] __fsync_super+0x76/0xa0
 [<ffffffff8028ab69>] fsync_super+0x9/0x20
 [<ffffffff8028eb60>] generic_shutdown_super+0x40/0x150
 [<ffffffff8028ec9d>] kill_block_super+0x2d/0x50
 [<ffffffff8028ed6f>] deactivate_super+0x4f/0x80
 [<ffffffff802a5100>] sys_umount+0x220/0x280
 [<ffffffff80209daa>] system_call+0x7e/0x83
 [<00002b7ce788c689>]

Code: 0f 0b 68 ed d4 59 80 c2 ab 13 eb 21 83 f8 02 75 1c c7 47 2c
RIP  [<ffffffff8048ddc8>] md_write_start+0x28/0x160
 RSP <ffff81000d581b28>

Kernel : stock-kernel 2.6.18.6, x86_64
Setup : xfs on raid5, on 5 250Go ieee1394 drives
Way to reproduce :
1. assemble the array
2. mount the xfs array
3. mark the array read-only (mdadm -o)
4. umount the xfs array...

I guess the problem is hit in md.c:  md_write_start(), at the
BUG_ON(mddev->ro == 1). It is obvious that my mddev->ro is set to 1,
because I set it read-only.
Nowhere before md_write_start() the check on mddev->ro == 1 is done,
so that the upper layer never sees that the underlying device is
read-only. As a result, when xfs wishes to write to it, bad things
happen.

May it be possible to relax the BUG_ON() and be able to send to
upper-layer a more gentle message ?

Regards
