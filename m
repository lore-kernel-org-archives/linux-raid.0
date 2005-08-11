From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 004 of 6] All hot-add and hot-remove of md intent logging bitmaps
Date: Thu, 11 Aug 2005 17:22:27 +1000
Message-ID: <E1E37OV-0002jL-17@notabene.cse.unsw.edu.au>
References: <20050811171720.10115.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Both file-bitmaps and superblock bitmaps are supported.

If you add a bitmap file on the array device, you lose.

This introduces a 'default_bitmap_offset' field in mddev,
as the ioctl used for adding a superblock bitmap doesn't have
room for giving an offset.  Later, this value will be setable
via sysfs.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c           |  104 ++++++++++++++++++++++++++++++++++++--------
 ./drivers/md/raid1.c        |   30 ++++++++++++
 ./include/linux/raid/md_k.h |   10 ++++
 3 files changed, 127 insertions(+), 17 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-08-11 15:12:51.000000000 +1000
+++ ./drivers/md/md.c	2005-08-11 15:35:33.000000000 +1000
@@ -624,6 +624,7 @@ static int super_90_validate(mddev_t *md
 		mddev->size = sb->size;
 		mddev->events = md_event(sb);
 		mddev->bitmap_offset = 0;
+		mddev->default_bitmap_offset = MD_SB_BYTES >> 9;
 
 		if (sb->state & (1<<MD_SB_CLEAN))
 			mddev->recovery_cp = MaxSector;
@@ -649,7 +650,7 @@ static int super_90_validate(mddev_t *md
 				printk(KERN_WARNING "md: bitmaps only support for raid1\n");
 				return -EINVAL;
 			}
-			mddev->bitmap_offset = (MD_SB_BYTES >> 9);
+			mddev->bitmap_offset = mddev->default_bitmap_offset;
 		}
 
 	} else if (mddev->pers == NULL) {
@@ -940,6 +941,9 @@ static int super_1_validate(mddev_t *mdd
 		mddev->size = le64_to_cpu(sb->size)/2;
 		mddev->events = le64_to_cpu(sb->events);
 		mddev->bitmap_offset = 0;
+		mddev->default_bitmap_offset = 0;
+		if (mddev->minor_version == 0)
+			mddev->default_bitmap_offset = -(64*1024)/512;
 		
 		mddev->recovery_cp = le64_to_cpu(sb->resync_offset);
 		memcpy(mddev->uuid, sb->set_uuid, 16);
@@ -2072,6 +2076,8 @@ static int get_array_info(mddev_t * mdde
 	info.state         = 0;
 	if (mddev->in_sync)
 		info.state = (1<<MD_SB_CLEAN);
+	if (mddev->bitmap && mddev->bitmap_offset)
+		info.state = (1<<MD_SB_BITMAP_PRESENT);
 	info.active_disks  = active;
 	info.working_disks = working;
 	info.failed_disks  = failed;
@@ -2430,25 +2436,51 @@ static int set_bitmap_file(mddev_t *mdde
 {
 	int err;
 
-	if (mddev->pers || mddev->bitmap_file)
-		return -EBUSY;
+	if (mddev->pers) {
+		if (!mddev->pers->quiesce)
+			return -EBUSY;
+		if (mddev->recovery || mddev->sync_thread)
+			return -EBUSY;
+		/* we should be able to change the bitmap.. */
+	}
 
-	mddev->bitmap_file = fget(fd);
 
-	if (mddev->bitmap_file == NULL) {
-		printk(KERN_ERR "%s: error: failed to get bitmap file\n",
-			mdname(mddev));
-		return -EBADF;
-	}
+	if (fd >= 0) {
+		if (mddev->bitmap)
+			return -EEXIST; /* cannot add when bitmap is present */
+		mddev->bitmap_file = fget(fd);
 
-	err = deny_bitmap_write_access(mddev->bitmap_file);
-	if (err) {
-		printk(KERN_ERR "%s: error: bitmap file is already in use\n",
-			mdname(mddev));
-		fput(mddev->bitmap_file);
-		mddev->bitmap_file = NULL;
-	} else
+		if (mddev->bitmap_file == NULL) {
+			printk(KERN_ERR "%s: error: failed to get bitmap file\n",
+			       mdname(mddev));
+			return -EBADF;
+		}
+
+		err = deny_bitmap_write_access(mddev->bitmap_file);
+		if (err) {
+			printk(KERN_ERR "%s: error: bitmap file is already in use\n",
+			       mdname(mddev));
+			fput(mddev->bitmap_file);
+			mddev->bitmap_file = NULL;
+			return err;
+		}
 		mddev->bitmap_offset = 0; /* file overrides offset */
+	} else if (mddev->bitmap == NULL)
+		return -ENOENT; /* cannot remove what isn't there */
+	err = 0;
+	if (mddev->pers) {
+		mddev->pers->quiesce(mddev, 1);
+		if (fd >= 0)
+			err = bitmap_create(mddev);
+		if (fd < 0 || err)
+			bitmap_destroy(mddev);
+		mddev->pers->quiesce(mddev, 0);
+	} else if (fd < 0) {
+		if (mddev->bitmap_file)
+			fput(mddev->bitmap_file);
+		mddev->bitmap_file = NULL;
+	}
+
 	return err;
 }
 
@@ -2528,6 +2560,11 @@ static int update_array_info(mddev_t *md
 {
 	int rv = 0;
 	int cnt = 0;
+	int state = 0;
+
+	/* calculate expected state,ignoring low bits */
+	if (mddev->bitmap && mddev->bitmap_offset)
+		state |= (1 << MD_SB_BITMAP_PRESENT);
 
 	if (mddev->major_version != info->major_version ||
 	    mddev->minor_version != info->minor_version ||
@@ -2536,12 +2573,16 @@ static int update_array_info(mddev_t *md
 	    mddev->level         != info->level         ||
 /*	    mddev->layout        != info->layout        || */
 	    !mddev->persistent	 != info->not_persistent||
-	    mddev->chunk_size    != info->chunk_size    )
+	    mddev->chunk_size    != info->chunk_size    ||
+	    /* ignore bottom 8 bits of state, and allow SB_BITMAP_PRESENT to change */
+	    ((state^info->state) & 0xfffffe00)
+		)
 		return -EINVAL;
 	/* Check there is only one change */
 	if (mddev->size != info->size) cnt++;
 	if (mddev->raid_disks != info->raid_disks) cnt++;
 	if (mddev->layout != info->layout) cnt++;
+	if ((state ^ info->state) & (1<<MD_SB_BITMAP_PRESENT)) cnt++;
 	if (cnt == 0) return 0;
 	if (cnt > 1) return -EINVAL;
 
@@ -2620,6 +2661,35 @@ static int update_array_info(mddev_t *md
 			}
 		}
 	}
+	if ((state ^ info->state) & (1<<MD_SB_BITMAP_PRESENT)) {
+		if (mddev->pers->quiesce == NULL)
+			return -EINVAL;
+		if (mddev->recovery || mddev->sync_thread)
+			return -EBUSY;
+		if (info->state & (1<<MD_SB_BITMAP_PRESENT)) {
+			/* add the bitmap */
+			if (mddev->bitmap)
+				return -EEXIST;
+			if (mddev->default_bitmap_offset == 0)
+				return -EINVAL;
+			mddev->bitmap_offset = mddev->default_bitmap_offset;
+			mddev->pers->quiesce(mddev, 1);
+			rv = bitmap_create(mddev);
+			if (rv)
+				bitmap_destroy(mddev);
+			mddev->pers->quiesce(mddev, 0);
+		} else {
+			/* remove the bitmap */
+			if (!mddev->bitmap)
+				return -ENOENT;
+			if (mddev->bitmap->file)
+				return -EINVAL;
+			mddev->pers->quiesce(mddev, 1);
+			bitmap_destroy(mddev);
+			mddev->pers->quiesce(mddev, 0);
+			mddev->bitmap_offset = 0;
+		}
+	}
 	md_update_sb(mddev);
 	return rv;
 }

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-08-11 15:14:01.000000000 +1000
+++ ./drivers/md/raid1.c	2005-08-11 15:14:05.000000000 +1000
@@ -1565,6 +1565,35 @@ static int raid1_reshape(mddev_t *mddev,
 	return 0;
 }
 
+void raid1_quiesce(mddev_t *mddev, int state)
+{
+	conf_t *conf = mddev_to_conf(mddev);
+
+	switch(state) {
+	case 0:
+		spin_lock_irq(&conf->resync_lock);
+		conf->barrier++;
+		wait_event_lock_irq(conf->wait_idle, !conf->nr_pending,
+				    conf->resync_lock, raid1_unplug(mddev->queue));
+		spin_unlock_irq(&conf->resync_lock);
+		break;
+	case 1:
+		spin_lock_irq(&conf->resync_lock);
+		conf->barrier--;
+		spin_unlock_irq(&conf->resync_lock);
+		wake_up(&conf->wait_resume);
+		wake_up(&conf->wait_idle);
+		break;
+	}
+	if (mddev->thread) {
+		if (mddev->bitmap)
+			mddev->thread->timeout = mddev->bitmap->daemon_sleep * HZ;
+		else
+			mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
+		md_wakeup_thread(mddev->thread);
+	}
+}
+
 
 static mdk_personality_t raid1_personality =
 {
@@ -1581,6 +1610,7 @@ static mdk_personality_t raid1_personali
 	.sync_request	= sync_request,
 	.resize		= raid1_resize,
 	.reshape	= raid1_reshape,
+	.quiesce	= raid1_quiesce,
 };
 
 static int __init raid_init(void)

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2005-08-11 15:14:02.000000000 +1000
+++ ./include/linux/raid/md_k.h	2005-08-11 15:28:56.000000000 +1000
@@ -278,6 +278,10 @@ struct mddev_s
 							* start of bitmap. May be
 							* negative, but not '0'
 							*/
+	long				default_bitmap_offset; /* this is the offset to use when
+								* hot-adding a bitmap.  It should
+								* eventually be settable by sysfs.
+								*/
 
 	struct list_head		all_mddevs;
 };
@@ -314,6 +318,12 @@ struct mdk_personality_s
 	int (*resize) (mddev_t *mddev, sector_t sectors);
 	int (*reshape) (mddev_t *mddev, int raid_disks);
 	int (*reconfig) (mddev_t *mddev, int layout, int chunk_size);
+	/* quiesce moves between quiescence states
+	 * 0 - fully active
+	 * 1 - no new requests allowed
+	 * others - reserved
+	 */
+	void (*quiesce) (mddev_t *mddev, int state);
 };
 
 
