From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 2/8] md_getgeo(): Move comment to proper position.
Date: Fri, 25 Apr 2008 20:57:58 +0200
Message-ID: <S1752573AbYGGId5/20080707083358Z+1942@vger.kernel.org>
References: <20080707075532.GA32617@skl-net.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080707075532.GA32617@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids


Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/md.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b16d08d..f94ebe6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4641,6 +4641,12 @@ static int set_disk_faulty(mddev_t *mddev, dev_t dev)
 	return 0;
 }
 
+/*
+ * We have a problem here : there is no easy way to give a CHS
+ * virtual geometry. We currently pretend that we have a 2 heads
+ * 4 sectors (with a BIG number of cylinders...). This drives
+ * dosfs just mad... ;-)
+ */
 static int md_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 {
 	mddev_t *mddev = bdev->bd_disk->private_data;
@@ -4792,12 +4798,6 @@ static int md_ioctl(struct inode *inode, struct file *file,
 			err = do_md_stop (mddev, 1);
 			goto done_unlock;
 
-	/*
-	 * We have a problem here : there is no easy way to give a CHS
-	 * virtual geometry. We currently pretend that we have a 2 heads
-	 * 4 sectors (with a BIG number of cylinders...). This drives
-	 * dosfs just mad... ;-)
-	 */
 	}
 
 	/*
-- 
1.5.3.8

