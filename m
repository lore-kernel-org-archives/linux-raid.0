From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH] md/raid5: init batch_xxx for new sh at resize_stripes
Date: Mon,  4 May 2015 13:50:24 +0800
Message-ID: <1430718624-8988-1-git-send-email-yuanhan.liu@linux.intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

This is to fix a kernel NULL dereference oops introduced by commit
59fc630b("RAID5: batch adjacent full stripe write"), which introduced
several batch_xxx fields, and did initiation for them at grow_one_stripes(),
but forgot to do same at resize_stripes().

This oops can be easily triggered by following steps:

    __create RAID5 /dev/md0
    __grow /dev/md0
    mdadm --wait /dev/md0
    dd if=/dev/zero of=/dev/md0

Here is the detailed oops log:

[   32.384499] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   32.385366] IP: [<ffffffff81844082>] add_stripe_bio+0x48d/0x544
[   32.385955] PGD 373f3067 PUD 36e34067 PMD 0
[   32.386404] Oops: 0002 [#1] SMP
[   32.386740] Modules linked in:
[   32.387040] CPU: 0 PID: 1059 Comm: kworker/u2:2 Not tainted 4.0.0-next-20150427+ #107
[   32.387762] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
[   32.388044] Workqueue: writeback bdi_writeback_workfn (flush-9:0)
[   32.388044] task: ffff88003d038000 ti: ffff88003d40c000 task.ti: ffff88003d40c000
[   32.388044] RIP: 0010:[<ffffffff81844082>]  [<ffffffff81844082>] add_stripe_bio+0x48d/0x544
[   32.388044] RSP: 0000:ffff88003d40f6f8  EFLAGS: 00010046
[   32.388044] RAX: 0000000000000000 RBX: ffff880037168cd0 RCX: ffff880037179a28
[   32.388044] RDX: ffff880037168d58 RSI: 0000000000000000 RDI: ffff880037179a20
[   32.388044] RBP: ffff88003d40f738 R08: 0000000000000410 R09: 0000000000000410
[   32.388044] R10: 0000000000000410 R11: 0000000000000002 R12: ffff8800371799a0
[   32.388044] R13: ffff88003c3d0800 R14: 0000000000000001 R15: ffff880037179a08
[   32.388044] FS:  0000000000000000(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
[   32.388044] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   32.388044] CR2: 0000000000000000 CR3: 0000000036e33000 CR4: 00000000000006f0
[   32.388044] Stack:
[   32.388044]  0000000200000000 ffff880037168d38 ffff88003d40f738 ffff88003c3abd00
[   32.388044]  ffff88003c2df800 ffff88003c3d0800 0000000000000408 ffff88003c3d0b54
[   32.388044]  ffff88003d40f828 ffffffff8184b9ea ffffffff3d40f7e8 0000000000000292
[   32.388044] Call Trace:
[   32.388044]  [<ffffffff8184b9ea>] make_request+0x7a8/0xaee
[   32.388044]  [<ffffffff81120387>] ? wait_woken+0x79/0x79
[   32.388044]  [<ffffffff811e9a85>] ? kmem_cache_alloc+0x95/0x1b6
[   32.388044]  [<ffffffff8186b944>] md_make_request+0xeb/0x1c3
[   32.388044]  [<ffffffff811a3025>] ? mempool_alloc+0x64/0x127
[   32.388044]  [<ffffffff81481575>] generic_make_request+0x9c/0xdb
[   32.388044]  [<ffffffff814816aa>] submit_bio+0xf6/0x134
[   32.388044]  [<ffffffff8122a1f7>] _submit_bh+0x119/0x141
[   32.388044]  [<ffffffff8122a22f>] submit_bh+0x10/0x12
[   32.388044]  [<ffffffff8122bbb9>] __block_write_full_page.constprop.30+0x1a3/0x2a4
[   32.388044]  [<ffffffff8122bead>] ? I_BDEV+0xd/0xd
[   32.388044]  [<ffffffff8122bd65>] block_write_full_page+0xab/0xaf
[   32.388044]  [<ffffffff8122c657>] blkdev_writepage+0x18/0x1a
[   32.388044]  [<ffffffff811a9853>] __writepage+0x14/0x2d
[   32.388044]  [<ffffffff811a9ef3>] write_cache_pages+0x29a/0x3a7
[   32.388044]  [<ffffffff811a983f>] ? mapping_tagged+0x14/0x14
[   32.388044]  [<ffffffff811aa03e>] generic_writepages+0x3e/0x56
[   32.388044]  [<ffffffff811ab638>] do_writepages+0x1e/0x2c
[   32.388044]  [<ffffffff812229ed>] __writeback_single_inode+0x5b/0x27e
[   32.388044]  [<ffffffff81222ec7>] writeback_sb_inodes+0x1dc/0x358
[   32.388044]  [<ffffffff812230c2>] __writeback_inodes_wb+0x7f/0xb8
[   32.388044]  [<ffffffff812232b9>] wb_writeback+0x11a/0x271
[   32.388044]  [<ffffffff811aa483>] ? global_dirty_limits+0x1b/0xfd
[   32.388044]  [<ffffffff8122399c>] bdi_writeback_workfn+0x1ae/0x360
[   32.388044]  [<ffffffff81101bab>] process_one_work+0x1c2/0x340
[   32.388044]  [<ffffffff81102571>] worker_thread+0x28b/0x389
[   32.388044]  [<ffffffff811022e6>] ? cancel_delayed_work_sync+0x15/0x15
[   32.388044]  [<ffffffff81106936>] kthread+0xd2/0xda
[   32.388044]  [<ffffffff81106864>] ? kthread_create_on_node+0x17c/0x17c
[   32.388044]  [<ffffffff81a16682>] ret_from_fork+0x42/0x70
[   32.388044]  [<ffffffff81106864>] ? kthread_create_on_node+0x17c/0x17c
[   32.388044] Code: 84 24 90 00 00 00 48 8d 93 88 00 00 00 49 8d 8c 24 88 00 00 00 49 89 94 24 90 00 00 00 48 89 8b 88 00 00 00 48 89 83 90 00 00 00 <48> 89 10 66 41 83 84 24 80 00 00 00 01 3e 0f ba 73 48 06 72 02
[   32.388044] RIP  [<ffffffff81844082>] add_stripe_bio+0x48d/0x544
[   32.388044]  RSP <ffff88003d40f6f8>
[   32.388044] CR2: 0000000000000000
[   32.388044] ---[ end trace 2b255d3f55be9eb3 ]---

Cc: Shaohua Li <shli@kernel.org>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 drivers/md/raid5.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 697d77a..7b074f7 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2217,6 +2217,10 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 				if (!p)
 					err = -ENOMEM;
 			}
+
+		spin_lock_init(&nsh->batch_lock);
+		INIT_LIST_HEAD(&nsh->batch_list);
+		nsh->batch_head = NULL;
 		release_stripe(nsh);
 	}
 	/* critical section pass, GFP_NOIO no longer needed */
-- 
1.9.0

