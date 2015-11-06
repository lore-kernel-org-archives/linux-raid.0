From: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Subject: [PATCH 5/8] zram: handle add_disk() & blk_register_region() return
 value
Date: Fri, 06 Nov 2015 17:52:12 +0530
Message-ID: <1446812535-10567-5-git-send-email-vishnu.ps@samsung.com>
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
 drivers/block/z2ram.c         | 12 ++++++++++--
 drivers/block/zram/zram_drv.c |  9 ++++++---
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index 968f9e5..85e841f 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -364,12 +364,20 @@ z2_init(void)
     sprintf(z2ram_gendisk->disk_name, "z2ram");
 
     z2ram_gendisk->queue = z2_queue;
-    add_disk(z2ram_gendisk);
-    blk_register_region(MKDEV(Z2RAM_MAJOR, 0), Z2MINOR_COUNT, THIS_MODULE,
+    ret = add_disk(z2ram_gendisk);
+    if (ret)
+	goto out_add_disk;
+
+    ret = blk_register_region(MKDEV(Z2RAM_MAJOR, 0), Z2MINOR_COUNT, THIS_MODULE,
 				z2_find, NULL, NULL);
+    if (ret)
+	goto out_blk_reg;
 
     return 0;
 
+out_blk_reg:
+	del_gendisk(z2ram_gendisk);
+out_add_disk:
 out_queue:
     put_disk(z2ram_gendisk);
 out_disk:
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 81a557c..f3d7a49 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1261,14 +1261,16 @@ static int zram_add(void)
 		zram->disk->queue->limits.discard_zeroes_data = 0;
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, zram->disk->queue);
 
-	add_disk(zram->disk);
+	ret = add_disk(zram->disk);
+	if (ret)
+		goto out_free_disk;
 
 	ret = sysfs_create_group(&disk_to_dev(zram->disk)->kobj,
 				&zram_disk_attr_group);
 	if (ret < 0) {
 		pr_err("Error creating sysfs group for device %d\n",
 				device_id);
-		goto out_free_disk;
+		goto out_del_disk;
 	}
 	strlcpy(zram->compressor, default_compressor, sizeof(zram->compressor));
 	zram->meta = NULL;
@@ -1277,8 +1279,9 @@ static int zram_add(void)
 	pr_info("Added device: %s\n", zram->disk->disk_name);
 	return device_id;
 
-out_free_disk:
+out_del_disk:
 	del_gendisk(zram->disk);
+out_free_disk:
 	put_disk(zram->disk);
 out_free_queue:
 	blk_cleanup_queue(queue);
-- 
1.9.1

