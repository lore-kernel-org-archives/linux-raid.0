From: Neil Brown <neilb@suse.de>
Subject: Re: crash: write_sb_page walks mddev.disks without holding reconfig_mutex
Date: Tue, 15 Jul 2008 10:36:51 +1000
Message-ID: <18555.61731.440879.486136@notabene.brown>
References: <3DC430E8F4814543943B52C2F34BF52A119474@EXNA.corp.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dailey, Nate on Monday July 14
Sender: linux-raid-owner@vger.kernel.org
To: "Dailey, Nate" <Nate.Dailey@stratus.com>
Cc: linux-raid@vger.kernel.org, mingo@redhat.com
List-Id: linux-raid.ids

On Monday July 14, Nate.Dailey@stratus.com wrote:
> Hitting several related crashes, and looking for advice/help...
> 
> I'm using MD raid1 under RHEL 5 update 2 (kernel 2.6.18-92.el5). I've
> also incorporated a few upstream patches to address various bugs, but
> don't believe any of these are causing what I'm now seeing.
> 
> I've hit 3 different crashes that all involve an rdev being ripped out
> from under someone walking the mddev.disks list. It looks like the
> reconfig_mutex is supposed to prevent this.

Thanks for reporting this.
You are right.  The mddev.disks list is not being protected properly.
It is only ever changed under reconfig_mutex, and lots of the accesses
are under the same mutex.  However I count three that are not:
    write_sb_page (which you found)
    match_mddev_units
    is_mddev_idle

It is not really appropriate to take reconfig_mutex in these cases.

I think the best fix would be to use the 'rcu' approach.
The following patch attempts that.  If you could test it I would
really appreciate it.

Thanks,
NeilBrown


commit ec54a752a284ee3ace5177935bc0385c5ee2c70c
Author: Neil Brown <neilb@suse.de>
Date:   Tue Jul 15 10:35:28 2008 +1000

    Protect access to mddev->disks list using RCU
    
    All modifications and most access to the mddev->disks list are made
    under the reconfig_mutex lock.  However there are three places where
    the list is walked without any locking.  If a reconfig happens at this
    time, havoc (and oops) can ensue.
    
    So use RCU to protect these accesses:
      - wrap them in rcu_read_{,un}lock()
      - use list_for_each_entry_rcu
      - add to the list with list_add_rcu
      - delete from the list with list_del_rcu
      - delay the 'free' with call_rcu rather than schedule_work
    
    Note that export_rdev did a list_del_init on this list.  In almost all
    cases the entry was not in the list anymore so it was a no-op and so
    safe.  It is no longer safe as after list_del_rcu we may not touch
    the list_head.
    An audit shows that export_rdev is called:
      - after unbind_rdev_from_array, in which case the delete has
         already been done,
      - after bind_rdev_to_array fails, in which case the delete isn't needed.
      - before the device has been put on a list at all (e.g. in
          add_new_disk where reading the superblock fails).
      - and in autorun devices after a failure when the device is on a
          different list.
    
    So remove the list_del_init call from export_rdev, and add it back
    immediately before the called to export_rdev for that last case.
    
    Note also that ->same_set is sometimes used for lists other than
    mddev->list (e.g. candidates).  In these cases rcu is not needed.
    
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index eba83e2..621a272 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -241,10 +241,10 @@ static struct page *read_sb_page(mddev_t *mddev, long offset, unsigned long inde
 static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 {
 	mdk_rdev_t *rdev;
-	struct list_head *tmp;
 	mddev_t *mddev = bitmap->mddev;
 
-	rdev_for_each(rdev, tmp, mddev)
+	rcu_read_lock();
+	rdev_for_each_rcu(rdev, mddev)
 		if (test_bit(In_sync, &rdev->flags)
 		    && !test_bit(Faulty, &rdev->flags)) {
 			int size = PAGE_SIZE;
@@ -260,11 +260,11 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 				    + (long)(page->index * (PAGE_SIZE/512))
 				    + size/512 > 0)
 					/* bitmap runs in to metadata */
-					return -EINVAL;
+					goto bad_alignment;
 				if (rdev->data_offset + mddev->size*2
 				    > rdev->sb_start + bitmap->offset)
 					/* data runs in to bitmap */
-					return -EINVAL;
+					goto bad_alignment;
 			} else if (rdev->sb_start < rdev->data_offset) {
 				/* METADATA BITMAP DATA */
 				if (rdev->sb_start
@@ -272,7 +272,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 				    + page->index*(PAGE_SIZE/512) + size/512
 				    > rdev->data_offset)
 					/* bitmap runs in to data */
-					return -EINVAL;
+					goto bad_alignment;
 			} else {
 				/* DATA METADATA BITMAP - no problems */
 			}
@@ -282,10 +282,15 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 				       size,
 				       page);
 		}
+	rcu_read_unlock();
 
 	if (wait)
 		md_super_wait(mddev);
 	return 0;
+
+ bad_alignment:
+	rcu_read_unlock();
+	return -EINVAL;
 }
 
 static void bitmap_file_kick(struct bitmap *bitmap);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7dcdff6..66ca159 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1397,15 +1397,17 @@ static struct super_type super_types[] = {
 
 static int match_mddev_units(mddev_t *mddev1, mddev_t *mddev2)
 {
-	struct list_head *tmp, *tmp2;
 	mdk_rdev_t *rdev, *rdev2;
 
-	rdev_for_each(rdev, tmp, mddev1)
-		rdev_for_each(rdev2, tmp2, mddev2)
+	rcu_read_lock();
+	rdev_for_each_rcu(rdev, mddev1)
+		rdev_for_each_rcu(rdev2, mddev2)
 			if (rdev->bdev->bd_contains ==
-			    rdev2->bdev->bd_contains)
+			    rdev2->bdev->bd_contains) {
+				rcu_read_unlock();
 				return 1;
-
+			}
+	rcu_read_unlock();
 	return 0;
 }
 
@@ -1472,7 +1474,7 @@ static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
 		kobject_del(&rdev->kobj);
 		goto fail;
 	}
-	list_add(&rdev->same_set, &mddev->disks);
+	list_add_rcu(&rdev->same_set, &mddev->disks);
 	bd_claim_by_disk(rdev->bdev, rdev->bdev->bd_holder, mddev->gendisk);
 	return 0;
 
@@ -1482,9 +1484,9 @@ static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
 	return err;
 }
 
-static void md_delayed_delete(struct work_struct *ws)
+static void md_delayed_delete(struct rcu_head *rcu)
 {
-	mdk_rdev_t *rdev = container_of(ws, mdk_rdev_t, del_work);
+	mdk_rdev_t *rdev = container_of(rcu, mdk_rdev_t, rcu_work);
 	kobject_del(&rdev->kobj);
 	kobject_put(&rdev->kobj);
 }
@@ -1497,17 +1499,17 @@ static void unbind_rdev_from_array(mdk_rdev_t * rdev)
 		return;
 	}
 	bd_release_from_disk(rdev->bdev, rdev->mddev->gendisk);
-	list_del_init(&rdev->same_set);
+	list_del_rcu(&rdev->same_set);
 	printk(KERN_INFO "md: unbind<%s>\n", bdevname(rdev->bdev,b));
 	rdev->mddev = NULL;
 	sysfs_remove_link(&rdev->kobj, "block");
 
 	/* We need to delay this, otherwise we can deadlock when
-	 * writing to 'remove' to "dev/state"
+	 * writing to 'remove' to "dev/state".  We also need
+	 * to delay it due to rcu usage.
 	 */
-	INIT_WORK(&rdev->del_work, md_delayed_delete);
 	kobject_get(&rdev->kobj);
-	schedule_work(&rdev->del_work);
+	call_rcu(&rdev->rcu_work, md_delayed_delete);
 }
 
 /*
@@ -1560,7 +1562,6 @@ static void export_rdev(mdk_rdev_t * rdev)
 	if (rdev->mddev)
 		MD_BUG();
 	free_disk_sb(rdev);
-	list_del_init(&rdev->same_set);
 #ifndef MODULE
 	if (test_bit(AutoDetected, &rdev->flags))
 		md_autodetect_dev(rdev->bdev->bd_dev);
@@ -4063,8 +4064,10 @@ static void autorun_devices(int part)
 		/* on success, candidates will be empty, on error
 		 * it won't...
 		 */
-		rdev_for_each_list(rdev, tmp, candidates)
+		rdev_for_each_list(rdev, tmp, candidates) {
+			list_del_init(&rdev->same_set);
 			export_rdev(rdev);
+		}
 		mddev_put(mddev);
 	}
 	printk(KERN_INFO "md: ... autorun DONE.\n");
@@ -5528,12 +5531,12 @@ int unregister_md_personality(struct mdk_personality *p)
 static int is_mddev_idle(mddev_t *mddev)
 {
 	mdk_rdev_t * rdev;
-	struct list_head *tmp;
 	int idle;
 	long curr_events;
 
 	idle = 1;
-	rdev_for_each(rdev, tmp, mddev) {
+	rcu_read_lock();
+	rdev_for_each_rcu(rdev, mddev) {
 		struct gendisk *disk = rdev->bdev->bd_contains->bd_disk;
 		curr_events = disk_stat_read(disk, sectors[0]) + 
 				disk_stat_read(disk, sectors[1]) - 
@@ -5565,6 +5568,7 @@ static int is_mddev_idle(mddev_t *mddev)
 			idle = 0;
 		}
 	}
+	rcu_read_unlock();
 	return idle;
 }
 
diff --git a/include/linux/raid/md_k.h b/include/linux/raid/md_k.h
index 35da93c..6fa94ff 100644
--- a/include/linux/raid/md_k.h
+++ b/include/linux/raid/md_k.h
@@ -114,7 +114,7 @@ struct mdk_rdev_s
 					   * for reporting to userspace and storing
 					   * in superblock.
 					   */
-	struct work_struct del_work;	/* used for delayed sysfs removal */
+	struct rcu_head	rcu_work;	/* used for delayed sysfs removal */
 };
 
 struct mddev_s
@@ -339,6 +339,9 @@ static inline char * mdname (mddev_t * mddev)
 #define rdev_for_each(rdev, tmp, mddev)				\
 	rdev_for_each_list(rdev, tmp, (mddev)->disks)
 
+#define rdev_for_each_rcu(rdev, mddev)				\
+	list_for_each_entry_rcu(rdev, &((mddev)->disks), same_set)
+
 typedef struct mdk_thread_s {
 	void			(*run) (mddev_t *mddev);
 	mddev_t			*mddev;
