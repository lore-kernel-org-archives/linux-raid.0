From: Neil Brown <neilb@suse.de>
Subject: Re: Partitioned arrays initially missing from /proc/partitions
Date: Mon, 7 May 2007 19:01:25 +1000
Message-ID: <17982.60133.905805.651286@notabene.brown>
References: <462CC91B.8030008@dgreaves.com>
	<16046.1177356707@mdt.dhcp.pit.laurelnetworks.com>
	<17965.18112.135843.417561@notabene.brown>
	<462DE0A2.6000701@dgreaves.com>
	<17965.60458.702567.463105@notabene.brown>
	<462DF8F1.3000306@dgreaves.com>
	<463EE31B.7000601@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Greaves on Monday May 7
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

On Monday May 7, david@dgreaves.com wrote:
> Hi Neil
> 
> Just wondering what the status is here - do you need any more from me or is it
> on your stack?
> 
> The patch helped but didn't cure.
> After a clean boot it mounted correctly first try.
> Then I unmounted, stopped and re-assembled the array.
> The next mount failed.
> The subsequent mount succeeded.

I just wrote the following patch.  I think it does what you want.
Let me know how it goes.

> 
> How do other block devices initialise their partitions on 'discovery'?
> 

They don't call add_disk() until the disk actually exists.
md has to call add_disk before the array exists, so that it can be
created.

NeilBrown

-----------------------------------
Improve partition detection in md array.

md currently uses ->media_changed to make sure rescan_partitions
is call on md array after they are assembled.

However that doesn't happen until the array is opened, which is later
than some people would like.

So use blkdev_ioctl to do the rescan immediately that the
array has been assembled.

This means we can remove all the ->change infrastructure as it was only used
to trigger a partition rescan.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c           |   26 ++++++++------------------
 ./drivers/md/raid1.c        |    1 -
 ./drivers/md/raid5.c        |    2 --
 ./include/linux/raid/md_k.h |    6 +++---
 4 files changed, 11 insertions(+), 24 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-05-07 16:43:02.000000000 +1000
+++ ./drivers/md/md.c	2007-05-07 17:47:15.000000000 +1000
@@ -3104,6 +3104,7 @@ static int do_md_run(mddev_t * mddev)
 	struct gendisk *disk;
 	struct mdk_personality *pers;
 	char b[BDEVNAME_SIZE];
+	struct block_device *bdev;
 
 	if (list_empty(&mddev->disks))
 		/* cannot run an array with no devices.. */
@@ -3331,7 +3332,13 @@ static int do_md_run(mddev_t * mddev)
 	md_wakeup_thread(mddev->thread);
 	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
 
-	mddev->changed = 1;
+	bdev = bdget_disk(mddev->gendisk, 0);
+	if (bdev) {
+		bd_set_size(bdev, mddev->array_size << 1);
+		blkdev_ioctl(bdev->bd_inode, NULL, BLKRRPART, 0);
+		bdput(bdev);
+	}
+
 	md_new_event(mddev);
 	kobject_uevent(&mddev->gendisk->kobj, KOBJ_CHANGE);
 	return 0;
@@ -3453,7 +3460,6 @@ static int do_md_stop(mddev_t * mddev, i
 			mddev->pers = NULL;
 
 			set_capacity(disk, 0);
-			mddev->changed = 1;
 
 			if (mddev->ro)
 				mddev->ro = 0;
@@ -4593,20 +4599,6 @@ static int md_release(struct inode *inod
 	return 0;
 }
 
-static int md_media_changed(struct gendisk *disk)
-{
-	mddev_t *mddev = disk->private_data;
-
-	return mddev->changed;
-}
-
-static int md_revalidate(struct gendisk *disk)
-{
-	mddev_t *mddev = disk->private_data;
-
-	mddev->changed = 0;
-	return 0;
-}
 static struct block_device_operations md_fops =
 {
 	.owner		= THIS_MODULE,
@@ -4614,8 +4606,6 @@ static struct block_device_operations md
 	.release	= md_release,
 	.ioctl		= md_ioctl,
 	.getgeo		= md_getgeo,
-	.media_changed	= md_media_changed,
-	.revalidate_disk= md_revalidate,
 };
 
 static int md_thread(void * arg)

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2007-05-07 16:43:01.000000000 +1000
+++ ./drivers/md/raid1.c	2007-05-07 17:02:27.000000000 +1000
@@ -2063,7 +2063,6 @@ static int raid1_resize(mddev_t *mddev, 
 	 */
 	mddev->array_size = sectors>>1;
 	set_capacity(mddev->gendisk, mddev->array_size << 1);
-	mddev->changed = 1;
 	if (mddev->array_size > mddev->size && mddev->recovery_cp == MaxSector) {
 		mddev->recovery_cp = mddev->size << 1;
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-05-07 16:43:01.000000000 +1000
+++ ./drivers/md/raid5.c	2007-05-07 17:03:05.000000000 +1000
@@ -4514,7 +4514,6 @@ static int raid5_resize(mddev_t *mddev, 
 	sectors &= ~((sector_t)mddev->chunk_size/512 - 1);
 	mddev->array_size = (sectors * (mddev->raid_disks-conf->max_degraded))>>1;
 	set_capacity(mddev->gendisk, mddev->array_size << 1);
-	mddev->changed = 1;
 	if (sectors/2  > mddev->size && mddev->recovery_cp == MaxSector) {
 		mddev->recovery_cp = mddev->size << 1;
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
@@ -4649,7 +4648,6 @@ static void end_reshape(raid5_conf_t *co
 		conf->mddev->array_size = conf->mddev->size *
 			(conf->raid_disks - conf->max_degraded);
 		set_capacity(conf->mddev->gendisk, conf->mddev->array_size << 1);
-		conf->mddev->changed = 1;
 
 		bdev = bdget_disk(conf->mddev->gendisk, 0);
 		if (bdev) {

diff .prev/include/linux/raid/md_k.h ./include/linux/raid/md_k.h
--- .prev/include/linux/raid/md_k.h	2007-05-07 16:43:02.000000000 +1000
+++ ./include/linux/raid/md_k.h	2007-05-07 17:00:19.000000000 +1000
@@ -201,9 +201,9 @@ struct mddev_s
 	struct mutex			reconfig_mutex;
 	atomic_t			active;
 
-	int				changed;	/* true if we might need to reread partition info */
-	int				degraded;	/* whether md should consider
-							 * adding a spare
+	int				degraded;	/* whether md should
+							 * consider adding a
+							 * spare
 							 */
 	int				barriers_work;	/* initialised to true, cleared as soon
 							 * as a barrier request to slave
