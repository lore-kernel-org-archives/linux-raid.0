From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 014 of 20] Allow md/raid_disks to be settable.
Date: Mon, 12 Dec 2005 14:15:24 +1100
Message-ID: <1051212031524.5140@suse.de>
References: <20051212135705.4561.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


If array is active, try to reshape, else just set the value.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./Documentation/md.txt |    3 +
 ./drivers/md/md.c      |   74 +++++++++++++++++++++++++++++++++----------------
 2 files changed, 54 insertions(+), 23 deletions(-)

diff ./Documentation/md.txt~current~ ./Documentation/md.txt
--- ./Documentation/md.txt~current~	2005-12-12 11:34:21.000000000 +1100
+++ ./Documentation/md.txt	2005-12-12 11:35:01.000000000 +1100
@@ -165,6 +165,9 @@ All md devices contain:
      in a fully functional array.  If this is not yet known, the file
      will be empty.  If an array is being resized (not currently
      possible) this will contain the larger of the old and new sizes.
+     Some raid level (RAID1) allow this value to be set while the
+     array is active.  This will reconfigure the array.   Otherwise
+     it can only be set while assembling an array.
 
   chunk_size
      This is the size if bytes for 'chunks' and is only relevant to

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-12-12 11:34:37.000000000 +1100
+++ ./drivers/md/md.c	2005-12-12 11:35:53.000000000 +1100
@@ -1843,7 +1843,27 @@ raid_disks_show(mddev_t *mddev, char *pa
 	return sprintf(page, "%d\n", mddev->raid_disks);
 }
 
-static struct md_sysfs_entry md_raid_disks = __ATTR_RO(raid_disks);
+static int update_raid_disks(mddev_t *mddev, int raid_disks);
+
+static ssize_t
+raid_disks_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	/* can only set raid_disks if array is not yet active */
+	char *e;
+	int rv = 0;
+	unsigned long n = simple_strtoul(buf, &e, 10);
+
+	if (!*buf || (*e && *e != '\n'))
+		return -EINVAL;
+
+	if (mddev->pers)
+		rv = update_raid_disks(mddev, n);
+	else
+		mddev->raid_disks = n;
+	return rv ? rv : len;
+}
+static struct md_sysfs_entry md_raid_disks =
+__ATTR(raid_disks, 0644, raid_disks_show, raid_disks_store);
 
 static ssize_t
 chunk_size_show(mddev_t *mddev, char *page)
@@ -3201,6 +3221,33 @@ static int update_size(mddev_t *mddev, u
 	return rv;
 }
 
+static int update_raid_disks(mddev_t *mddev, int raid_disks)
+{
+	int rv;
+	/* change the number of raid disks */
+	if (mddev->pers->reshape == NULL)
+		return -EINVAL;
+	if (raid_disks <= 0 ||
+	    raid_disks >= mddev->max_disks)
+		return -EINVAL;
+	if (mddev->sync_thread)
+		return -EBUSY;
+	rv = mddev->pers->reshape(mddev, raid_disks);
+	if (!rv) {
+		struct block_device *bdev;
+
+		bdev = bdget_disk(mddev->gendisk, 0);
+		if (bdev) {
+			down(&bdev->bd_inode->i_sem);
+			i_size_write(bdev->bd_inode, mddev->array_size << 10);
+			up(&bdev->bd_inode->i_sem);
+			bdput(bdev);
+		}
+	}
+	return rv;
+}
+
+
 /*
  * update_array_info is used to change the configuration of an
  * on-line array.
@@ -3252,28 +3299,9 @@ static int update_array_info(mddev_t *md
 	if (mddev->size != info->size)
 		rv = update_size(mddev, info->size);
 
-	if (mddev->raid_disks    != info->raid_disks) {
-		/* change the number of raid disks */
-		if (mddev->pers->reshape == NULL)
-			return -EINVAL;
-		if (info->raid_disks <= 0 ||
-		    info->raid_disks >= mddev->max_disks)
-			return -EINVAL;
-		if (mddev->sync_thread)
-			return -EBUSY;
-		rv = mddev->pers->reshape(mddev, info->raid_disks);
-		if (!rv) {
-			struct block_device *bdev;
-
-			bdev = bdget_disk(mddev->gendisk, 0);
-			if (bdev) {
-				down(&bdev->bd_inode->i_sem);
-				i_size_write(bdev->bd_inode, mddev->array_size << 10);
-				up(&bdev->bd_inode->i_sem);
-				bdput(bdev);
-			}
-		}
-	}
+	if (mddev->raid_disks    != info->raid_disks)
+		rv = update_raid_disks(mddev, info->raid_disks);
+
 	if ((state ^ info->state) & (1<<MD_SB_BITMAP_PRESENT)) {
 		if (mddev->pers->quiesce == NULL)
 			return -EINVAL;
