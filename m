From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: [PATCH] md sleeps under spinlock on exit
Date: Sun, 27 Mar 2005 14:22:04 +0200
Message-ID: <c4lih2-1pv.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

md_exit calls mddev_put on each mddev during module exit. mddev_put
calls blk_put_queue under spinlock, although it can sleep (it clearly
calls kblockd_flush). This patch lifts the spinlock to do the flush.

--- md.c.orig	Fri Dec 24 22:34:29 2004
+++ md.c	Sun Mar 27 14:14:22 2005
@@ -173,7 +173,10 @@
 		return;
 	if (!mddev->raid_disks && list_empty(&mddev->disks)) {
 		list_del(&mddev->all_mddevs);
+	        spin_unlock(&all_mddevs_lock);
+                /* blk_put_queue calls kblockd_flush, which sleeps */
 		blk_put_queue(mddev->queue);
+	        spin_lock(&all_mddevs_lock);
 		kfree(mddev);
 	}
 	spin_unlock(&all_mddevs_lock);



Here's a trace

  [__might_sleep+166/176]    __might_sleep+0xa6/0xb0
  [flush_workqueue+21/144]   flush_workqueue+0x15/0x90
  [kblockd_flush+10/12]      kblockd_flush+0xa/0xc
  [blk_cleanup_queue+49/108] blk_cleanup_queue+0x31/0x6c
  [pg0+273956980/1069723648] mddev_put+0x5c/0x8c [md]
  [pg0+273983937/1069723648] md_exit+0x121/0x18d [md]


Peter

