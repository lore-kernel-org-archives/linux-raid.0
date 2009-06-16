From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject:[PATCH 009:013]: raid0:add hot add and hot remove
Date: Wed, 17 Jun 2009 00:57:51 +0300
Message-ID: <1245189471.3478.112.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

added : raid0_hot_add and raid0_hot_remove.fix alignment of device size to chunk size.

 raid0.c |   65 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

Signed-off-by: razb <raziebe@gmail.com>
---
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 1e01c61..984d603 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -619,6 +619,69 @@ static void raid0_status(struct seq_file *seq, mddev_t *mddev)
 	return;
 }
 
+
+static int raid0_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
+{
+	char b[BDEVNAME_SIZE];
+	sector_t sectors;
+
+	if (rdev->sectors < mddev->chunk_sectors) {
+		printk(KERN_INFO "raid0: device smaller than "
+			"chunk size %llusectors < %llusectors\n",
+				(unsigned long long)rdev->sectors,
+				((unsigned long long)mddev->chunk_sectors));
+		return -1;
+	}
+	if (queue_max_hw_sectors(rdev->bdev->bd_disk->queue) <
+				queue_max_hw_sectors(mddev->queue)) {
+		printk(KERN_INFO "raid0: device trasnfer"
+			" size %usectors is smaller than other"
+			"raid's components %usectors, rejecting ",
+			queue_max_hw_sectors(rdev->bdev->bd_disk->queue),
+			queue_max_hw_sectors(mddev->queue));
+		/*
+		* todo. accept the device. and only generate an error
+		*/
+		return -1;
+	}
+	/*
+	* never allow adding new disks while reshape takes place
+	*/
+	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery)) {
+		printk(KERN_ERR "raid0: %s is in reshape\n",
+				mdname(mddev));
+		return -EBUSY;
+	}
+	sectors = rdev->sectors;
+	sector_div(sectors, mddev->chunk_sectors);
+	sectors = sectors * mddev->chunk_sectors;
+	rdev->sectors = sectors;
+	printk(KERN_INFO "raid0: hot add:reduce device "
+		" %s size: %lld --> %lld\n",
+		bdevname(rdev->bdev, b),
+		(unsigned long long)rdev->sectors,
+		(unsigned long long)sectors);
+	return 0;
+}
+
+/*
+ * we allow removal of a disk only if it is a spare.
+*/
+static int raid0_remove_disk(mddev_t *mddev, int number)
+{
+	raid0_conf_t *conf = mddev->private;
+	mdk_rdev_t *rdev = conf->devlist[number];
+	if (!rdev) {
+		printk(KERN_ERR "%s: error try to"
+				" remove disk number %d\n",
+			mdname(mddev), number);
+		return -1;
+	}
+	if (rdev->raid_disk != -1)
+		return -1;
+	return 0;
+}
+
 static struct mdk_personality raid0_personality=
 {
 	.name		= "raid0",
@@ -629,6 +692,8 @@ static struct mdk_personality raid0_personality=
 	.stop		= raid0_stop,
 	.status		= raid0_status,
 	.size		= raid0_size,
+	.hot_add_disk	= raid0_add_disk,
+	.hot_remove_disk = raid0_remove_disk,
 };
 
 static int __init raid0_init (void)




