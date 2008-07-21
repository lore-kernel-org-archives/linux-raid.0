From: "Dailey, Nate" <Nate.Dailey@stratus.com>
Subject: RE: crash: write_sb_page walks mddev.disks without holding reconfig_mutex
Date: Mon, 21 Jul 2008 15:59:35 -0400
Message-ID: <3DC430E8F4814543943B52C2F34BF52A119498@EXNA.corp.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: 18555.61731.440879.486136@notabene.brown
References: message from Dailey, Nate on Monday July 14 18555.61731.440879.486136@notabene.brown
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, mingo@redhat.com
List-Id: linux-raid.ids

Quick update... I've applied your patch to the kernel I'm using. There
were a few differences... for example, md_delayed_delete doesn't exist
in my kernel (so I added it).

Unfortunately, I'm hitting a deadlock, and it looks like md_delayed_work
is at fault. Seems that in at least one case, code which holds the
inode_lock is interrupted, at which point the md_delayed_delete code
gets to run. He ends up needing the inode_lock too, and we're stuck.

Just mentioning this in case you have any suggestions... I'll keep
investigating. It may be there's some difference between the upstream
kernel and the kernel I'm using, or it may be that I made some
brain-dead mistake in applying the patch. I haven't been able to boot
the latest kernel.org kernel in my environment (I won't get into
details, seems to be an issue with loading Adaptec firmware which is no
longer built into the driver, not sure how hard it will be to work
around).

A backtrace showing the problem, plus my version of the patch, can be
found below.

Nate



PID: 11501  TASK: ffff810079b1d7a0  CPU: 1   COMMAND: "mdadm"
 #0 [ffff81007fe0ff20] ftmod_call_wedge at ffffffff882d2865
 #1 [ffff81007fe0ff30] fosil_nmi_handler at ffffffff88205da4
 #2 [ffff81007fe0ff40] do_nmi at ffffffff800659cc
 #3 [ffff81007fe0ff50] nmi at ffffffff80064e47
    [exception RIP: .text.lock.spinlock+0x5]
    RIP: ffffffff80064b57  RSP: ffff81007fe13e58  RFLAGS: 00000282
    RAX: 0000000000000000  RBX: ffff8100775004f8  RCX: 0000000000000001
    RDX: 0000000000000045  RSI: ffffffff802f50b0  RDI: ffffffff802f50b0
    RBP: ffffffff802f50b0   R8: 0000000000000000   R9: ffff810058290670
    R10: ffff81007fe13ec0  R11: ffffffff80102dcf  R12: ffff81004c9d3a98
    R13: ffff810058290670  R14: ffff810058290660  R15: ffff8100307e1a60
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
--- <exception stack> ---
 #4 [ffff81007fe13e58] .text.lock.spinlock at ffffffff80064b57 (via
_spin_lock)
 #5 [ffff81007fe13e58] _atomic_dec_and_lock at ffffffff8000c31a
 #6 [ffff81007fe13e78] iput at ffffffff8002abf6
 #7 [ffff81007fe13e88] dput at ffffffff8000d11c
 #8 [ffff81007fe13ea8] sysfs_remove_dir at ffffffff80102d45
 #9 [ffff81007fe13ee8] kobject_del at ffffffff8014380e
#10 [ffff81007fe13ef8] md_delayed_delete at ffffffff801fd77b
#11 [ffff81007fe13f08] __rcu_process_callbacks at ffffffff8009be52
#12 [ffff81007fe13f28] rcu_process_callbacks at ffffffff8009befb
#13 [ffff81007fe13f38] tasklet_action at ffffffff800928d3
#14 [ffff81007fe13f58] __do_softirq at ffffffff80011ed2
#15 [ffff81007fe13f88] call_softirq at ffffffff8005e2fc
#16 [ffff81007fe13fa0] do_softirq at ffffffff8006c571
#17 [ffff81007fe13fb0] apic_timer_interrupt at ffffffff8005dc8e
--- <IRQ stack> ---
#18 [ffff81006e793d08] apic_timer_interrupt at ffffffff8005dc8e
    [exception RIP: _atomic_dec_and_lock+0x3c]
    RIP: ffffffff8000c31d  RSP: ffff81006e793db8  RFLAGS: 00000246
    RAX: 0000000000000000  RBX: ffffffff802f50b0  RCX: 0000000000000001
    RDX: ffff81005da433a8  RSI: ffffffff802f50b0  RDI: ffffffff802f50b0
    RBP: 0000000000000002   R8: 00000000ffffffff   R9: 0000000000000020
    R10: 0000000000000046  R11: ffff81006e793e78  R12: ffffffff8001a090
    R13: ffff81006e793e82  R14: 0000000000000002  R15: 00000000ffffffff
    ORIG_RAX: ffffffffffffff10  CS: 0010  SS: 0018
#19 [ffff81006e793db0] _atomic_dec_and_lock at ffffffff8000c31a
#20 [ffff81006e793dd0] iput at ffffffff8002abf6
#21 [ffff81006e793de0] prune_one_dentry at ffffffff800e203d
#22 [ffff81006e793e00] prune_dcache at ffffffff8002e88a
#23 [ffff81006e793e30] shrink_dcache_parent at ffffffff8004cd0d
#24 [ffff81006e793e60] proc_flush_task at ffffffff800fc9e8
#25 [ffff81006e793ec0] release_task at ffffffff80017aa9
#26 [ffff81006e793ef0] do_wait at ffffffff80027de7
#27 [ffff81006e793f80] tracesys at ffffffff8005d28d (via system_call)
    RIP: 00000036c2a6276d  RSP: 00007fffdac3f5d0  RFLAGS: 00000246
    RAX: ffffffffffffffda  RBX: ffffffff8005d28d  RCX: ffffffffffffffff
    RDX: 0000000000000000  RSI: 00007fffdac3f5fc  RDI: 000000000000458d
    RBP: 0000000000000000   R8: 000000000000003d   R9: 00007fffdac3f790
    R10: 0000000000000000  R11: 0000000000000246  R12: 0000000000000000
    R13: 00007fffdac43590  R14: 0000000000000000  R15: 0000000000000000
    ORIG_RAX: 000000000000003d  CS: 0033  SS: 002b



diff -Nupr a/drivers/md/bitmap.c b/drivers/md/bitmap.c
--- a/drivers/md/bitmap.c	2008-07-15 10:27:38.000000000 -0400
+++ b/drivers/md/bitmap.c	2008-07-15 10:45:28.000000000 -0400
@@ -258,9 +258,9 @@ static struct page *read_sb_page(mddev_t
 static int write_sb_page(mddev_t *mddev, long offset, struct page
*page, int wait)
 {
 	mdk_rdev_t *rdev;
-	struct list_head *tmp;
 
-	ITERATE_RDEV(mddev, rdev, tmp)
+	rcu_read_lock();
+	rdev_for_each_rcu(rdev, mddev)
 		if (test_bit(In_sync, &rdev->flags)
 		    && !test_bit(Faulty, &rdev->flags))
 			md_super_write(mddev, rdev,
@@ -268,6 +268,7 @@ static int write_sb_page(mddev_t *mddev,
 				       + page->index * (PAGE_SIZE/512),
 				       PAGE_SIZE,
 				       page);
+	rcu_read_unlock();
 
 	if (wait)
 		md_super_wait(mddev);
diff -Nupr a/drivers/md/md.c b/drivers/md/md.c
--- a/drivers/md/md.c	2008-07-15 10:27:38.000000000 -0400
+++ b/drivers/md/md.c	2008-07-16 11:52:11.000000000 -0400
@@ -1306,13 +1306,17 @@ static mdk_rdev_t * match_dev_unit(mddev
 
 static int match_mddev_units(mddev_t *mddev1, mddev_t *mddev2)
 {
-	struct list_head *tmp;
-	mdk_rdev_t *rdev;
+	mdk_rdev_t *rdev, *rdev2;
 
-	ITERATE_RDEV(mddev1,rdev,tmp)
-		if (match_dev_unit(mddev2, rdev))
+	rcu_read_lock();
+	rdev_for_each_rcu(rdev, mddev1)
+		rdev_for_each_rcu(rdev2, mddev2)
+		if (rdev->bdev->bd_contains ==
+		    rdev2->bdev->bd_contains) {
+			rcu_read_unlock();
 			return 1;
-
+		}
+	rcu_read_unlock();
 	return 0;
 }
 
@@ -1366,7 +1370,7 @@ static int bind_rdev_to_array(mdk_rdev_t
 	while ( (s=strchr(rdev->kobj.k_name, '/')) != NULL)
 		*s = '!';
 			
-	list_add(&rdev->same_set, &mddev->disks);
+	list_add_rcu(&rdev->same_set, &mddev->disks);
 	rdev->mddev = mddev;
 	printk(KERN_INFO "md: bind<%s>\n", b);
 
@@ -1382,6 +1386,13 @@ static int bind_rdev_to_array(mdk_rdev_t
 	return 0;
 }
 
+static void md_delayed_delete(struct rcu_head *rcu)
+{
+	mdk_rdev_t *rdev = container_of(rcu, mdk_rdev_t, rcu_work);
+	kobject_del(&rdev->kobj);
+	kobject_put(&rdev->kobj);
+}
+
 static void unbind_rdev_from_array(mdk_rdev_t * rdev)
 {
 	char b[BDEVNAME_SIZE];
@@ -1390,11 +1401,17 @@ static void unbind_rdev_from_array(mdk_r
 		return;
 	}
 	bd_release_from_disk(rdev->bdev, rdev->mddev->gendisk);
-	list_del_init(&rdev->same_set);
+	list_del_rcu(&rdev->same_set);
 	printk(KERN_INFO "md: unbind<%s>\n", bdevname(rdev->bdev,b));
 	rdev->mddev = NULL;
 	sysfs_remove_link(&rdev->kobj, "block");
-	kobject_del(&rdev->kobj);
+
+        /* We need to delay this, otherwise we can deadlock when
+	 * writing to 'remove' to "dev/state".  We also need
+	 * to delay it due to rcu usage.
+	 */
+	kobject_get(&rdev->kobj);
+	call_rcu(&rdev->rcu_work, md_delayed_delete);
 }
 
 /*
@@ -1445,7 +1462,6 @@ static void export_rdev(mdk_rdev_t * rde
 	if (rdev->mddev)
 		MD_BUG();
 	free_disk_sb(rdev);
-	list_del_init(&rdev->same_set);
 #ifndef MODULE
 	md_autodetect_dev(rdev->bdev->bd_dev);
 #endif
@@ -1924,10 +1940,21 @@ rdev_attr_show(struct kobject *kobj, str
 {
 	struct rdev_sysfs_entry *entry = container_of(attr, struct
rdev_sysfs_entry, attr);
 	mdk_rdev_t *rdev = container_of(kobj, mdk_rdev_t, kobj);
+	mddev_t *mddev = rdev->mddev;
+	ssize_t rv;
 
 	if (!entry->show)
 		return -EIO;
-	return entry->show(rdev, page);
+
+	rv = mddev ? mddev_lock(mddev) : -EBUSY;
+	if (!rv) {
+		if (rdev->mddev == NULL)
+			rv = -EBUSY;
+		else
+			rv = entry->show(rdev, page);
+		mddev_unlock(mddev);
+	}
+	return rv;
 }
 
 static ssize_t
@@ -1936,12 +1963,22 @@ rdev_attr_store(struct kobject *kobj, st
 {
 	struct rdev_sysfs_entry *entry = container_of(attr, struct
rdev_sysfs_entry, attr);
 	mdk_rdev_t *rdev = container_of(kobj, mdk_rdev_t, kobj);
+	ssize_t rv;
+	mddev_t *mddev = rdev->mddev;
 
 	if (!entry->store)
 		return -EIO;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
-	return entry->store(rdev, page, length);
+	rv = mddev ? mddev_lock(mddev): -EBUSY;
+	if (!rv) {
+		if (rdev->mddev == NULL)
+			rv = -EBUSY;
+		else
+			rv = entry->store(rdev, page, length);
+		mddev_unlock(mddev);
+	}
+	return rv;
 }
 
 static void rdev_free(struct kobject *ko)
@@ -3310,6 +3347,9 @@ static int do_md_stop(mddev_t * mddev, i
 				sysfs_remove_link(&mddev->kobj, nm);
 			}
 
+		/* make sure all md_delayed_delete calls have finished
*/
+		flush_scheduled_work();
+
 		export_array(mddev);
 
 		mddev->array_size = 0;
@@ -3434,8 +3474,10 @@ static void autorun_devices(int part)
 		/* on success, candidates will be empty, on error
 		 * it won't...
 		 */
-		ITERATE_RDEV_GENERIC(candidates,rdev,tmp)
+		ITERATE_RDEV_GENERIC(candidates,rdev,tmp) {
+			list_del_init(&rdev->same_set);
 			export_rdev(rdev);
+		}
 		mddev_put(mddev);
 	}
 	printk(KERN_INFO "md: ... autorun DONE.\n");
@@ -4978,12 +5020,12 @@ int unregister_md_personality(struct mdk
 static int is_mddev_idle(mddev_t *mddev)
 {
 	mdk_rdev_t * rdev;
-	struct list_head *tmp;
 	int idle;
 	unsigned long curr_events;
 
 	idle = 1;
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rcu_read_lock();
+	rdev_for_each_rcu(rdev, mddev) {
 		struct gendisk *disk = rdev->bdev->bd_contains->bd_disk;
 		curr_events = disk_stat_read(disk, sectors[0]) + 
 				disk_stat_read(disk, sectors[1]) - 
@@ -5006,6 +5048,7 @@ static int is_mddev_idle(mddev_t *mddev)
 			idle = 0;
 		}
 	}
+	rcu_read_unlock();
 	return idle;
 }
 
diff -Nupr a/include/linux/raid/md_k.h b/include/linux/raid/md_k.h
--- a/include/linux/raid/md_k.h	2008-07-15 10:27:55.000000000 -0400
+++ b/include/linux/raid/md_k.h	2008-07-15 11:23:09.000000000 -0400
@@ -105,6 +105,7 @@ struct mdk_rdev_s
 					   * for reporting to userspace
and storing
 					   * in superblock.
 					   */
+	struct rcu_head rcu_work;	/* used for delayed sysfs
removal */
 };
 
 struct mddev_s
@@ -314,6 +315,9 @@ static inline char * mdname (mddev_t * m
 #define ITERATE_RDEV(mddev,rdev,tmp)
\
 	ITERATE_RDEV_GENERIC((mddev)->disks,rdev,tmp)
 
+#define rdev_for_each_rcu(rdev, mddev)
\
+	list_for_each_entry_rcu(rdev, &((mddev)->disks), same_set)
+
 /*
  * Iterates through 'pending RAID disks'
  */









-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Neil Brown
Sent: Monday, July 14, 2008 8:37 PM
To: Dailey, Nate
Cc: linux-raid@vger.kernel.org; mingo@redhat.com
Subject: Re: crash: write_sb_page walks mddev.disks without holding
reconfig_mutex

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
    the list is walked without any locking.  If a reconfig happens at
this
    time, havoc (and oops) can ensue.
    
    So use RCU to protect these accesses:
      - wrap them in rcu_read_{,un}lock()
      - use list_for_each_entry_rcu
      - add to the list with list_add_rcu
      - delete from the list with list_del_rcu
      - delay the 'free' with call_rcu rather than schedule_work
    
    Note that export_rdev did a list_del_init on this list.  In almost
all
    cases the entry was not in the list anymore so it was a no-op and so
    safe.  It is no longer safe as after list_del_rcu we may not touch
    the list_head.
    An audit shows that export_rdev is called:
      - after unbind_rdev_from_array, in which case the delete has
         already been done,
      - after bind_rdev_to_array fails, in which case the delete isn't
needed.
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
@@ -241,10 +241,10 @@ static struct page *read_sb_page(mddev_t *mddev,
long offset, unsigned long inde
 static int write_sb_page(struct bitmap *bitmap, struct page *page, int
wait)
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
@@ -260,11 +260,11 @@ static int write_sb_page(struct bitmap *bitmap,
struct page *page, int wait)
 				    + (long)(page->index *
(PAGE_SIZE/512))
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
@@ -272,7 +272,7 @@ static int write_sb_page(struct bitmap *bitmap,
struct page *page, int wait)
 				    + page->index*(PAGE_SIZE/512) +
size/512
 				    > rdev->data_offset)
 					/* bitmap runs in to data */
-					return -EINVAL;
+					goto bad_alignment;
 			} else {
 				/* DATA METADATA BITMAP - no problems */
 			}
@@ -282,10 +282,15 @@ static int write_sb_page(struct bitmap *bitmap,
struct page *page, int wait)
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
 
@@ -1472,7 +1474,7 @@ static int bind_rdev_to_array(mdk_rdev_t * rdev,
mddev_t * mddev)
 		kobject_del(&rdev->kobj);
 		goto fail;
 	}
-	list_add(&rdev->same_set, &mddev->disks);
+	list_add_rcu(&rdev->same_set, &mddev->disks);
 	bd_claim_by_disk(rdev->bdev, rdev->bdev->bd_holder,
mddev->gendisk);
 	return 0;
 
@@ -1482,9 +1484,9 @@ static int bind_rdev_to_array(mdk_rdev_t * rdev,
mddev_t * mddev)
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
@@ -1497,17 +1499,17 @@ static void unbind_rdev_from_array(mdk_rdev_t *
rdev)
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
@@ -5528,12 +5531,12 @@ int unregister_md_personality(struct
mdk_personality *p)
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
 					   * for reporting to userspace
and storing
 					   * in superblock.
 					   */
-	struct work_struct del_work;	/* used for delayed sysfs
removal */
+	struct rcu_head	rcu_work;	/* used for delayed sysfs
removal */
 };
 
 struct mddev_s
@@ -339,6 +339,9 @@ static inline char * mdname (mddev_t * mddev)
 #define rdev_for_each(rdev, tmp, mddev)
\
 	rdev_for_each_list(rdev, tmp, (mddev)->disks)
 
+#define rdev_for_each_rcu(rdev, mddev)				\
+	list_for_each_entry_rcu(rdev, &((mddev)->disks), same_set)
+
 typedef struct mdk_thread_s {
 	void			(*run) (mddev_t *mddev);
 	mddev_t			*mddev;
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
