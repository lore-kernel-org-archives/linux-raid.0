From: Fam Zheng <famz@redhat.com>
Subject: [PATCH v2 02/12] genhd: Honor gen_uevent and add disk_gen_uevents
Date: Thu, 30 Jun 2016 09:59:43 +0800
Message-ID: <20160630015953.6888-3-famz@redhat.com>
References: <20160630015953.6888-1-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20160630015953.6888-1-famz@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org, Keith Busch <keith.busch@intel.com>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@kernel.org>, Nitin Gupta <ngupta@vflare.org>, famz@redhat.com, Jiri Kosina <jikos@kernel.org>, linux-block@vger.kernel.org, "Ed L. Cashin" <ed.cashin@acm.org>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>, linux-mmc@vger.kernel.org, Minchan Kim <minchan@kernel.org>, linux-mtd@lists.infradead.org, Brian Norris <computersforpeace@gmail.com>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-raid.ids

In add_disk(), don't send uevent to userspace when gen_uevent is true;
also export the refactored function disk_gen_uevents for later use.

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 block/genhd.c         | 23 +++++++++++++++++++----
 include/linux/genhd.h |  1 +
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 8e1bfa1..9b66953 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -506,12 +506,10 @@ static int exact_lock(dev_t devt, void *data)
 	return 0;
 }
 
-static void register_disk(struct gendisk *disk)
+static void register_disk(struct gendisk *disk, bool gen_uevent)
 {
 	struct device *ddev = disk_to_dev(disk);
 	struct block_device *bdev;
-	struct disk_part_iter piter;
-	struct hd_struct *part;
 	int err;
 
 	ddev->parent = disk->driverfs_dev;
@@ -563,6 +561,22 @@ static void register_disk(struct gendisk *disk)
 exit:
 	/* announce disk after possible partitions are created */
 	dev_set_uevent_suppress(ddev, 0);
+	if (gen_uevent)
+		disk_gen_uevents(disk);
+}
+
+/**
+ * disk_gen_uevents
+ * @disk - the disk to generate uevent
+ *
+ * Generate KOBJ_ADD uevents on the disk and partitions.
+ */
+void disk_gen_uevents(struct gendisk *disk)
+{
+	struct device *ddev = disk_to_dev(disk);
+	struct disk_part_iter piter;
+	struct hd_struct *part;
+
 	kobject_uevent(&ddev->kobj, KOBJ_ADD);
 
 	/* announce possible partitions */
@@ -571,6 +585,7 @@ exit:
 		kobject_uevent(&part_to_dev(part)->kobj, KOBJ_ADD);
 	disk_part_iter_exit(&piter);
 }
+EXPORT_SYMBOL(disk_gen_uevents);
 
 /**
  * add_disk - add partitioning information to kernel list
@@ -618,7 +633,7 @@ void add_disk(struct gendisk *disk, bool gen_uevent)
 
 	blk_register_region(disk_devt(disk), disk->minors, NULL,
 			    exact_match, exact_lock, disk);
-	register_disk(disk);
+	register_disk(disk, gen_uevent);
 	blk_register_queue(disk);
 
 	/*
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 038be80..87ad9e5 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -416,6 +416,7 @@ extern void part_round_stats(int cpu, struct hd_struct *part);
 /* block/genhd.c */
 extern void add_disk(struct gendisk *disk, bool gen_uevent);
 extern void del_gendisk(struct gendisk *gp);
+extern void disk_gen_uevents(struct gendisk *disk);
 extern struct gendisk *get_gendisk(dev_t dev, int *partno);
 extern struct block_device *bdget_disk(struct gendisk *disk, int partno);
 
-- 
2.9.0
