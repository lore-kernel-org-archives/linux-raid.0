From: "majianpeng" <majianpeng@gmail.com>
Subject: [PATCH] md:Fix mem leak about rdev->badblocks.page.
Date: Wed, 11 Apr 2012 15:58:27 +0800
Message-ID: <201204111558200780185@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From 7cc5b99748a5505d94d6e67ba4e639e341f0a00a Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Wed, 11 Apr 2012 15:44:55 +0800
Subject: [PATCH] md:Fix mem leak about rdev->badblocks.page. When exec
 md_import_device(),alloc badblocks.page.But met error when
 exec bind_rdev_to_array().So exec export_rdev().But
 export_rdev() did not free badblocks.page.

This may occur in those functions:
1:add_new_disk()
2:new_dev_store()

Reported by kmemleak:
unreferenced object 0xffff88008223d668 (size 4096):
  comm "mdadm", pid 9497, jiffies 4295848888 (age 21898.212s)
  hex dump (first 32 bytes):
    6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
    6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
  backtrace:
    [<ffffffff81695ec1>] kmemleak_alloc+0x21/0x50
    [<ffffffff811180fd>] kmem_cache_alloc_trace+0xad/0x1b0
    [<ffffffffa0003b78>] md_rdev_init+0xd8/0x130 [md_mod]
    [<ffffffffa0007e28>] md_import_device+0x58/0x2a0 [md_mod]
    [<ffffffffa001199e>] add_new_disk+0x178/0x49d [md_mod]
    [<ffffffffa000d78e>] md_ioctl+0xb8e/0x11f0 [md_mod]
    [<ffffffff8127aa18>] blkdev_ioctl+0xd8/0x790
    [<ffffffff8115416b>] block_ioctl+0x3b/0x40
    [<ffffffff81131cc6>] do_vfs_ioctl+0x96/0x550
    [<ffffffff81132211>] sys_ioctl+0x91/0xa0
    [<ffffffff816bc9a2>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff

Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/md.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b572e1e..e07c60c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -813,6 +813,7 @@ static void free_disk_sb(struct md_rdev * rdev)
 		put_page(rdev->bb_page);
 		rdev->bb_page = NULL;
 	}
+
 }
 
 
@@ -2161,6 +2162,10 @@ static void export_rdev(struct md_rdev * rdev)
 	if (test_bit(AutoDetected, &rdev->flags))
 		md_autodetect_dev(rdev->bdev->bd_dev);
 #endif
+	if (rdev->badblocks.page) {
+		kfree(rdev->badblocks.page);
+		rdev->badblocks.page = NULL;
+	}
 	unlock_rdev(rdev);
 	kobject_put(&rdev->kobj);
 }
-- 
1.7.5.4

 				
--------------
majianpeng
2012-04-11

