From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject:[PATCH 011:013]: raid0.h: reshape structure
Date: Wed, 17 Jun 2009 00:59:24 +0300
Message-ID: <1245189564.3478.115.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

reshape structures. reshape and reshape_bio
for reverse mapping.

 raid0.h |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

Signed-off-by: razb <raziebe@gmail.com>
---
diff --git a/drivers/md/raid0.h b/drivers/md/raid0.h
index 91f8e87..a0d6ae2 100644
--- a/drivers/md/raid0.h
+++ b/drivers/md/raid0.h
@@ -13,8 +13,37 @@ struct raid0_private_data
 	struct strip_zone *strip_zone;
 	mdk_rdev_t **devlist; /* lists of rdevs, pointed to by strip_zone->dev */
 	int nr_strip_zones;
+	struct mutex reshape_lock;
+	struct raid0_reshape *reshape;
 };
 
 typedef struct raid0_private_data raid0_conf_t;
 
+struct raid0_reshape {
+	int16_t pages;	/* single reshape io size in pages */
+	int16_t nr_bios; /* number of bios in each chunk read */
+	int32_t bio_size; /* single reshape io size in bytes */
+	int32_t last_bio_size; /* single reshape io size in bytes */
+	atomic_t active_ios; /*number of active reshape bios (read or write)*/
+	struct bio_list ios;/* succefull reshape reads list */
+	struct bio_list incoming_ios;/* incmoing ios while reshaping  */
+	int raid_disks; /* number of raid disks in new array */
+	int window; 	/* reshape last window size */
+	long flags;	/* reshape state flag */
+	spinlock_t lock; /* lock used to maintain both lists */
+	raid0_conf_t *conf;/* reshape temporary mapping raid device */
+	mddev_t *mddev_src; /* source mddev */
+};
+
+struct raid0_reshape_bio{
+	sector_t array_sector;
+	int bi_size;
+	struct raid0_reshape *reshape;
+};
+
+static inline struct raid0_reshape *mddev_to_reshape(mddev_t *mddev)
+{
+	return	((raid0_conf_t *)mddev->private)->reshape;
+}
+
 #endif



