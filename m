From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/6] md: switch to ->check_events for media change notifications
Date: Wed,  8 Jul 2020 14:25:41 +0200
Message-ID: <20200708122546.214579-2-hch@lst.de>
References: <20200708122546.214579-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <20200708122546.214579-1-hch@lst.de>
Sender: linux-mmc-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

md is the last driver using the legacy media_changed method.  Switch
it over to (not so) new ->clear_events approach, which also removes the
need for the ->revalidate_disk method.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/filesystems/locking.rst |  4 +---
 block/genhd.c                         |  7 +------
 drivers/md/md.c                       | 19 ++++++++-----------
 include/linux/blkdev.h                |  2 --
 4 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index 318605de83f33c..17bea12538c32d 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -467,7 +467,6 @@ prototypes::
 	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*direct_access) (struct block_device *, sector_t, void **,
 				unsigned long *);
-	int (*media_changed) (struct gendisk *);
 	void (*unlock_native_capacity) (struct gendisk *);
 	int (*revalidate_disk) (struct gendisk *);
 	int (*getgeo)(struct block_device *, struct hd_geometry *);
@@ -483,14 +482,13 @@ release:		yes
 ioctl:			no
 compat_ioctl:		no
 direct_access:		no
-media_changed:		no
 unlock_native_capacity:	no
 revalidate_disk:	no
 getgeo:			no
 swap_slot_free_notify:	no	(see below)
 ======================= ===================
 
-media_changed, unlock_native_capacity and revalidate_disk are called only from
+unlock_native_capacity and revalidate_disk are called only from
 check_disk_change().
 
 swap_slot_free_notify is called with swap_lock and sometimes the page lock
diff --git a/block/genhd.c b/block/genhd.c
index 60ae4e1b4d3877..1070da9d4d9a77 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -2061,13 +2061,8 @@ unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask)
 	unsigned int pending;
 	unsigned int clearing = mask;
 
-	if (!ev) {
-		/* for drivers still using the old ->media_changed method */
-		if ((mask & DISK_EVENT_MEDIA_CHANGE) &&
-		    bdops->media_changed && bdops->media_changed(disk))
-			return DISK_EVENT_MEDIA_CHANGE;
+	if (!ev)
 		return 0;
-	}
 
 	disk_block_events(disk);
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8bb69c61afe086..77dfe4765c3111 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5670,6 +5670,7 @@ static int md_alloc(dev_t dev, char *name)
 	 * remove it now.
 	 */
 	disk->flags |= GENHD_FL_EXT_DEVT;
+	disk->events |= DISK_EVENT_MEDIA_CHANGE;
 	mddev->gendisk = disk;
 	/* As soon as we call add_disk(), another thread could get
 	 * through to md_open, so make sure it doesn't get too far
@@ -7806,20 +7807,17 @@ static void md_release(struct gendisk *disk, fmode_t mode)
 	mddev_put(mddev);
 }
 
-static int md_media_changed(struct gendisk *disk)
-{
-	struct mddev *mddev = disk->private_data;
-
-	return mddev->changed;
-}
-
-static int md_revalidate(struct gendisk *disk)
+static unsigned int md_check_events(struct gendisk *disk, unsigned int clearing)
 {
 	struct mddev *mddev = disk->private_data;
+	unsigned int ret = 0;
 
+	if (mddev->changed)
+		ret = DISK_EVENT_MEDIA_CHANGE;
 	mddev->changed = 0;
-	return 0;
+	return ret;
 }
+
 static const struct block_device_operations md_fops =
 {
 	.owner		= THIS_MODULE,
@@ -7831,8 +7829,7 @@ static const struct block_device_operations md_fops =
 	.compat_ioctl	= md_compat_ioctl,
 #endif
 	.getgeo		= md_getgeo,
-	.media_changed  = md_media_changed,
-	.revalidate_disk= md_revalidate,
+	.check_events	= md_check_events,
 };
 
 static int md_thread(void *arg)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 408eb66a82fdc7..71173a1ffa8b87 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1781,8 +1781,6 @@ struct block_device_operations {
 	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	unsigned int (*check_events) (struct gendisk *disk,
 				      unsigned int clearing);
-	/* ->media_changed() is DEPRECATED, use ->check_events() instead */
-	int (*media_changed) (struct gendisk *);
 	void (*unlock_native_capacity) (struct gendisk *);
 	int (*revalidate_disk) (struct gendisk *);
 	int (*getgeo)(struct block_device *, struct hd_geometry *);
-- 
2.26.2
