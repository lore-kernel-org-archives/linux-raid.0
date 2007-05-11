From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-mm2 boot failure, raid autodetect, bd_set_size+0xb/0x80
Date: Fri, 11 May 2007 11:18:09 -0700
Message-ID: <20070511111809.bec8b938.akpm@linux-foundation.org>
References: <20070509012322.199f292b.akpm@linux-foundation.org>
	<20070511180334.GA4068@amd64.of.nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070511180334.GA4068@amd64.of.nowhere>
Sender: linux-raid-owner@vger.kernel.org
To: thunder7@xs4all.nl
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 11 May 2007 20:03:34 +0200
thunder7@xs4all.nl wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Wed, May 09, 2007 at 01:23:22AM -0700
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm2/
> > 
> > 
> It won't boot here.
> 
> AMD64 platform, raid6 partition.
> 
> 2.6.21-rc7-mm2 runs fine, it's dmesg says:
> 
> md: created md4
> md: bind<hda9>
> md: bind<hdc9>
> md: running: <hdc9><hda9>
> raid1: raid set md4 active with 2 out of 2 mirrors
> md4: bitmap initialized from disk: read 10/10 pages, set 46 bits, status: 0
> created bitmap (156 pages) for device md4
> md: considering hdc8 ...
> md:  adding hdc8 ...
> <snip>
> 
> 
> where 2.6.21-mm2 halts with
> 
> md: created md4
> md: bind<hda9>
> md: bind<hdc9>
> md: running: <hdc9><hda9>
> raid1: raid set md4 active with 2 out of 2 mirrors
> md4: bitmap initialized from disk: read 10/10 pages, set 46 bits, status: 0
> created bitmap (156 pages) for device md4
> Unable to handle kernel null pointer dereference 
> 
> bd_set_size+0xb/0x80

Yes, Neil had a whoops and a dud patch spent a day in mainline.

Hopefully the below revert (from mainline) will fix it.


From: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: git-commits-head@vger.kernel.org
Subject: Revert "md: improve partition detection in md array"
Date: 	Thu, 10 May 2007 01:59:03 GMT
Sender: git-commits-head-owner@vger.kernel.org

Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=44ce6294d07555c3d313757105fd44b78208407f
Commit:     44ce6294d07555c3d313757105fd44b78208407f
Parent:     497f050c42e46a4b1f6a9bcd8827fa5d97fe1feb
Author:     Linus Torvalds <torvalds@woody.linux-foundation.org>
AuthorDate: Wed May 9 18:51:36 2007 -0700
Committer:  Linus Torvalds <torvalds@woody.linux-foundation.org>
CommitDate: Wed May 9 18:51:36 2007 -0700

    Revert "md: improve partition detection in md array"
    
    This reverts commit 5b479c91da90eef605f851508744bfe8269591a0.
    
    Quoth Neil Brown:
    
      "It causes an oops when auto-detecting raid arrays, and it doesn't
       seem easy to fix.
    
       The array may not be 'open' when do_md_run is called, so
       bdev->bd_disk might be NULL, so bd_set_size can oops.
    
       This whole approach of opening an md device before it has been
       assembled just seems to get more and more painful.  I think I'm going
       to have to come up with something clever to provide both backward
       comparability with usage expectation, and sane integration into the
       rest of the kernel."
    
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 drivers/md/md.c           |   26 ++++++++++++++++++--------
 drivers/md/raid1.c        |    1 +
 drivers/md/raid5.c        |    2 ++
 include/linux/raid/md_k.h |    1 +
 4 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2901d0c..65814b0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3104,7 +3104,6 @@ static int do_md_run(mddev_t * mddev)
 	struct gendisk *disk;
 	struct mdk_personality *pers;
 	char b[BDEVNAME_SIZE];
-	struct block_device *bdev;
 
 	if (list_empty(&mddev->disks))
 		/* cannot run an array with no devices.. */
@@ -3332,13 +3331,7 @@ static int do_md_run(mddev_t * mddev)
 	md_wakeup_thread(mddev->thread);
 	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
 
-	bdev = bdget_disk(mddev->gendisk, 0);
-	if (bdev) {
-		bd_set_size(bdev, mddev->array_size << 1);
-		blkdev_ioctl(bdev->bd_inode, NULL, BLKRRPART, 0);
-		bdput(bdev);
-	}
-
+	mddev->changed = 1;
 	md_new_event(mddev);
 	kobject_uevent(&mddev->gendisk->kobj, KOBJ_CHANGE);
 	return 0;
@@ -3460,6 +3453,7 @@ static int do_md_stop(mddev_t * mddev, int mode)
 			mddev->pers = NULL;
 
 			set_capacity(disk, 0);
+			mddev->changed = 1;
 
 			if (mddev->ro)
 				mddev->ro = 0;
@@ -4599,6 +4593,20 @@ static int md_release(struct inode *inode, struct file * file)
 	return 0;
 }
 
+static int md_media_changed(struct gendisk *disk)
+{
+	mddev_t *mddev = disk->private_data;
+
+	return mddev->changed;
+}
+
+static int md_revalidate(struct gendisk *disk)
+{
+	mddev_t *mddev = disk->private_data;
+
+	mddev->changed = 0;
+	return 0;
+}
 static struct block_device_operations md_fops =
 {
 	.owner		= THIS_MODULE,
@@ -4606,6 +4614,8 @@ static struct block_device_operations md_fops =
 	.release	= md_release,
 	.ioctl		= md_ioctl,
 	.getgeo		= md_getgeo,
+	.media_changed	= md_media_changed,
+	.revalidate_disk= md_revalidate,
 };
 
 static int md_thread(void * arg)
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 1b7130c..97ee870 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2063,6 +2063,7 @@ static int raid1_resize(mddev_t *mddev, sector_t sectors)
 	 */
 	mddev->array_size = sectors>>1;
 	set_capacity(mddev->gendisk, mddev->array_size << 1);
+	mddev->changed = 1;
 	if (mddev->array_size > mddev->size && mddev->recovery_cp == MaxSector) {
 		mddev->recovery_cp = mddev->size << 1;
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a72e70a..061375e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3864,6 +3864,7 @@ static int raid5_resize(mddev_t *mddev, sector_t sectors)
 	sectors &= ~((sector_t)mddev->chunk_size/512 - 1);
 	mddev->array_size = (sectors * (mddev->raid_disks-conf->max_degraded))>>1;
 	set_capacity(mddev->gendisk, mddev->array_size << 1);
+	mddev->changed = 1;
 	if (sectors/2  > mddev->size && mddev->recovery_cp == MaxSector) {
 		mddev->recovery_cp = mddev->size << 1;
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
@@ -3998,6 +3999,7 @@ static void end_reshape(raid5_conf_t *conf)
 		conf->mddev->array_size = conf->mddev->size *
 			(conf->raid_disks - conf->max_degraded);
 		set_capacity(conf->mddev->gendisk, conf->mddev->array_size << 1);
+		conf->mddev->changed = 1;
 
 		bdev = bdget_disk(conf->mddev->gendisk, 0);
 		if (bdev) {
diff --git a/include/linux/raid/md_k.h b/include/linux/raid/md_k.h
index a121f36..de72c49 100644
--- a/include/linux/raid/md_k.h
+++ b/include/linux/raid/md_k.h
@@ -201,6 +201,7 @@ struct mddev_s
 	struct mutex			reconfig_mutex;
 	atomic_t			active;
 
+	int				changed;	/* true if we might need to reread partition info */
 	int				degraded;	/* whether md should consider
 							 * adding a spare
 							 */
-
To unsubscribe from this list: send the line "unsubscribe git-commits-head" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
