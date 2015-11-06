From: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Subject: [PATCH 4/8] block/loop.c: handle add_disk() & blk_register_region()
 return value
Date: Fri, 06 Nov 2015 17:52:11 +0530
Message-ID: <1446812535-10567-4-git-send-email-vishnu.ps@samsung.com>
References: <437969438-9181-1-git-send-email-vishnu.ps@samsung.com>
 <1446812535-10567-1-git-send-email-vishnu.ps@samsung.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-reply-to: <1446812535-10567-1-git-send-email-vishnu.ps@samsung.com>
Sender: linux-ide-owner@vger.kernel.org
To: axboe@kernel.dk, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, jmoyer@redhat.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, davem@davemloft.net, neilb@suse.com, ulf.hansson@linaro.org, tiwai@suse.de, hare@suse.de, ming.lei@canonical.com, jarod@redhat.com, viro@zeniv.linux.org.uk, tj@kernel.org, adrian.hunter@intel.com, jonathanh@nvidia.com, grundler@chromium.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org
Cc: cpgs@samsung.com, vishu13285@gmail.com, pintu.k@samsung.com, rohit.kr@samsung.com, Vishnu Pratap Singh <vishnu.ps@samsung.com>
List-Id: linux-raid.ids

This patch handles blk_register_region() & add_disk() return value.
Earlier these function doesn't handle error cases, now it is added,
so the callers of this function should also handle it.

Verfied on X86 based ubuntu machine.
This patch depends on [PATCH 1/8] block/genhd.c: Add error handling

Signed-off-by: Vishnu Pratap Singh <vishnu.ps@samsung.com>
---
 drivers/block/loop.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 423f4ca..22e6fd0 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1794,10 +1794,14 @@ static int loop_add(struct loop_device **l, int i)
 	disk->private_data	= lo;
 	disk->queue		= lo->lo_queue;
 	sprintf(disk->disk_name, "loop%d", i);
-	add_disk(disk);
+	err = add_disk(disk);
+	if (err)
+		goto out_free_disk;
 	*l = lo;
 	return lo->lo_number;
 
+out_free_disk:
+	put_disk(disk);
 out_free_queue:
 	blk_cleanup_queue(lo->lo_queue);
 out_cleanup_tags:
@@ -1998,8 +2002,10 @@ static int __init loop_init(void)
 		goto misc_out;
 	}
 
-	blk_register_region(MKDEV(LOOP_MAJOR, 0), range,
+	err = blk_register_region(MKDEV(LOOP_MAJOR, 0), range,
 				  THIS_MODULE, loop_probe, NULL, NULL);
+	if (err)
+		goto out_blkdev;
 
 	/* pre-create number of devices given by config or max_loop */
 	mutex_lock(&loop_index_mutex);
@@ -2010,6 +2016,8 @@ static int __init loop_init(void)
 	printk(KERN_INFO "loop: module loaded\n");
 	return 0;
 
+out_blkdev:
+	unregister_blkdev(LOOP_MAJOR, "loop");
 misc_out:
 	misc_deregister(&loop_misc);
 	return err;
-- 
1.9.1

