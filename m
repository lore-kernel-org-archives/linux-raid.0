From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: Fast (intelligent) raid1
Date: Tue, 18 Feb 2003 23:13:25 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302182213.h1IMDPw26887@oboe.it.uc3m.es>
References: <15952.20989.131713.951636@notabene.cse.unsw.edu.au>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15952.20989.131713.951636@notabene.cse.unsw.edu.au> from Neil Brown
 at "Feb 17, 2003 02:07:41 pm"
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: ptb@it.uc3m.es, Ross Vandegrift <ross@willow.seitz.com>, Ingo Molnar <mingo@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've now completed the preliminary patch which conforms to Neil's
ideas, and I've put it up at

 ftp://oboe.it.uc3m.es/pub/Programs/fr1-2.2.tgz

I'll follow roughly the same procedure as before, and publish the main
part of the patch here, with my comments. Then later I'll abstract
one further time.

First let me go through Neils' ideas and comment on what changes I made
to accomodate them ...

            ======================================

"Neil Brown wrote:"
> Rather than having several bitmaps, have just one.  Normally it is

This was easy, and welcome. I did it at once and several things became
simpler. The bitmap is stuck in the raid1 private data, but it can go 
one layer up (down?) into the general raid info at any time.

> full of zero and isn't touched.

At the moment, normally it's not there. It's brought into existence
when needed. I agree that that's wrong and I'll alter it in a
subsequent patch.

> When a write fails, or when a write is sent to some-but-not-all
> devices, set the relevant bit in the bitmap.

Well, I think that was already so.

> The first time you set a bit, record the current 'event' number with
> the bitmap.

OK - now you got me there for a while, because I didn't realize you
were talking about the "events" counter in the current code. At
least I think you are. I saved it into the "reserved" area of the
md device superblock, because it has to be in the md layer in order
to avoid a layering violation. This is another indicator that the
bitmap should be there too.

> The interpretation of this bit map is 'only the blocks that are
> flagged in this bitmap have changed since event X'.
> 
> On hot-add, read the old superblock.  If it looks valid and matches

I managed that. It seems to more or less work, though I'm a bit wary of
this event counter thing. I've only seen the case 1 <= 1 so far.

> the current array, and has an event counter of X or more, then ignore

I signal this desire via another entry in the reserved area of the
md device superblock. In the resync, the write to the first sector
examines this flag and decides whether to observe or disregard the
bitmap. If the bitmap is to be disregarded (because the disk that's been
added is too old or does not match), then it is removed. It can't
presently be removed in the md code which set the flag, because it's
currently a raid1 thing only. This is the first opportunity.

> blocks that have their bits set in the bitmap which reconstructing,
> otherwise do a full reconstruction.
> 
> When we have a full compliment of devices again, clear the bitmap and
> the event record.

Well, that was done in one of the diskops already. Spare active, I
think.

> As for ths other bits about a block device 'fixing itself' - I think
> that belongs in user-space.  Have some program monitoring things and

I've mentioned that I disagree, but I haven't had time to do anything
about it yet.

> re-adding the device to the array when it appears to be working again.

            ======================================

Now I'll select the main parts of the current patch and go through them ...

We start with raid1.h. It gets a few extra fields in the private data
structure for raid1.


--- linux-2.4.20-xfs/include/linux/raid/raid1.h.orig	Sun Jan 26 20:03:48 2003
+++ linux-2.4.20-xfs/include/linux/raid/raid1.h	Tue Feb 18 17:48:10 2003
@@ -59,6 +59,11 @@
 	md_wait_queue_head_t	wait_done;
 	md_wait_queue_head_t	wait_ready;
 	md_spinlock_t		segment_lock;
+        long last_clean_sector;                 /* helps debugging printout */
+        long last_dirty_sector;
+        int sync_mode;                          /* clean or dirty in sync ? */
+        struct bitmap * bitmap;                 /* the array bitmap */
+        int    bitmap_dirty;                    /* flag */
 };
 
 typedef struct raid1_private_data raid1_conf_t;


Now for the changes to md.c. Start with the flag that indicates we have
detected a "hotrepair" situation in hot_add(). It's either a previously
removed disk being readded and we've been maintaining a bitmap of
pending writes for it, or we can force it (in the case of no persistent
superblock) by doing a hotadd of the same disk immediately after setfaulty
without an intervening  hotremove.


--- linux-2.4.20-xfs/drivers/md/md.c.orig	Sun Jan 26 18:57:20 2003
+++ linux-2.4.20-xfs/drivers/md/md.c	Tue Feb 18 22:07:58 2003
@@ -2374,6 +2382,7 @@
 	unsigned int size;
 	mdk_rdev_t *rdev;
 	mdp_disk_t *disk;
+        int hotrepair = 0;
 
 	if (!mddev->pers)
 		return -ENODEV;



Here is where we detect the case of no persistent superblock, and
hotadd after setfaulty. Neil won't want this. We force an extra 
hotremove and restart the hotadd.

But near the end of this hunk there is an important change, of a "0" to
a "persistent" in the md_import_device() call. This is for the case
when there IS a persistent superblock. The value 1 to the call means
that the new disk superblock is tested. And read in to be tested. That's 
the key.


@@ -2396,11 +2405,38 @@
 		return -ENOSPC;
 	}
 
-	rdev = find_rdev(mddev, dev);
-	if (rdev)
-		return -EBUSY;
+        /*
+         * This is a do at most once loop because the remove in the loop will
+         * cause the test to fail the next time round. And if that
+         * doesn't break us out, then the hotrepair count will.
+         */
+        while ((rdev = find_rdev(mddev, dev)) != NULL) {
+
+	        if (hotrepair || persistent || rdev->dev != dev || !rdev->faulty) {
+	                printk(KERN_WARNING "md%d: cannot add existing component %x\n",
+                                mdidx(mddev), dev);
+	                return -EBUSY;
+                }
+        /*
+         * Allow "hotrepair" of merely faulty device too if no superblock to
+         * go by. We assume a hotadd after setfaulty of the same device is a
+         * hotrepair, if there's no persistent superblock to say otherwise.
+         */
+	        printk(KERN_WARNING "md%d: repair of faulty disk %x!\n",
+	                mdidx(mddev), dev);
+
+         /* Remove will cause find_rdev to fail next time */
+	        err = hot_remove_disk(mddev, dev);
+                if (err < 0) {
+	                printk(KERN_WARNING "md%d: remove disk %x errored\n",
+                                mdidx(mddev), dev);
+	                return err;       
+                }
+        /* This will inevitably error us out of the loop interior next time */
+                hotrepair = 1;
+        }
 
-	err = md_import_device (dev, 0);
+	err = md_import_device (dev, persistent);
 	if (err) {
 		printk(KERN_WARNING "md: error, md_import_device() returned %d\n", err);
 		return -EINVAL;



Here's where we test the uuid of the disk superblock just read in. We're
still in hotadd.

I also test the event counter. That's kept in fields 2 and 3 of the
"reserved" array on the disk superblock.  I'm not at all sure right now
how I got it there ...  the counter seems to have the value 1 in the
tests I've done!

The idea is that a counter that is old (low) represents a disk that
separated from our lineage way before the point at which our bitmap was
created, which is recored in the corresponding reserved fields of the md
device superblock in memory.  I know that I write those fields when I
dirty the bitmap for the first time.

I've tested by doing a setfaulty, then writing to the device, then
doing hotremove and hotadd, and things work. But I am uneasy about the 
semantics here.

The end result of this bit in hotadd is merely to set the local
hotrepair flag. We use it nearer the end of the function.



@@ -2416,6 +2452,52 @@
 		err = -EINVAL;
 		goto abort_export;
 	}
+        /* let's check the new disk sb at this poimt */
+        if (persistent && rdev->sb 
+                && rdev->sb->set_uuid0 == mddev->sb->set_uuid0
+                && rdev->sb->set_uuid1 == mddev->sb->set_uuid1
+                && rdev->sb->set_uuid2 == mddev->sb->set_uuid2
+                && rdev->sb->set_uuid3 == mddev->sb->set_uuid3) {
+                unsigned long long disk_events, bitmap_events;
+                disk_events = rdev->sb->reserved[3];
+                disk_events <<= 32;
+                disk_events |= rdev->sb->reserved[2];
+
+                bitmap_events = mddev->sb->reserved[3];
+                bitmap_events <<= 32;
+                bitmap_events |= mddev->sb->reserved[2];
+
+                if (disk_events < bitmap_events) {
+                        /* new disk is too old! */
+                        hotrepair = 0;
+                        printk(KERN_INFO "md%d: new disk %x too old for repair %Lu < %Lu\n",
+                                mdidx(mddev), dev, disk_events, bitmap_events);
+                } else {
+                        hotrepair = 1;
+                        printk(KERN_INFO "md%d: repairing old mirror component %x (%Lu >= %Lu)\n",
+                                mdidx(mddev), dev, disk_events, bitmap_events);
+                }
+        } else if (!persistent && hotrepair) {
+                hotrepair = 1;
+                printk(KERN_INFO "md: forced repair of mirror component %x\n",
+                        dev);
+        } else {
+                /* failed match */
+                hotrepair = 0;
+                printk(KERN_INFO "md: adding new mirror component %x\n",
+                        dev);
+                printk(KERN_DEBUG "md: old uuid %x %x %x %x\n",
+                        mddev->sb->set_uuid0,
+                        mddev->sb->set_uuid1,
+                        mddev->sb->set_uuid2,
+                        mddev->sb->set_uuid3);
+                printk(KERN_DEBUG "md: new uuid %x %x %x %x\n",
+                        rdev->sb->set_uuid0,
+                        rdev->sb->set_uuid1,
+                        rdev->sb->set_uuid2,
+                        rdev->sb->set_uuid3);
+        }
+
 	bind_rdev_to_array(rdev, mddev);
 
 	/*

At the end of the hotadd function, I set the flag (the 0th reserved
field of the md device superblock) to indicate that we are doing a
hotrepair - intelligent resync if possible. It'll be seen in the raid1
resync.

@@ -2470,6 +2554,19 @@
 	mddev->sb->spare_disks++;
 	mddev->sb->working_disks++;
 
+        if (hotrepair) {
+                /* maybe say something nice - this means we want to respect
+                 * the bitmap in raid1 resync if teher is one
+                 */
+                printk(KERN_DEBUG "md%d: set repair bit on superblock\n",
+                               mdidx(mddev));
+                mddev->sb->reserved[0] = 1;
+        } else {
+                /* this means we need to kill any bitmap that we have been
+                 * saving but we'll do it in the raid1 resync instead of here
+                 */
+                mddev->sb->reserved[0] = 0;
+        }
 	mddev->sb_dirty = 1;
 	md_update_sb(mddev);
 


That was the end of changes to md.c. Now changes to raid1.c.

First of all, in the make request function, mark the bitmaps of every
nonoperational component of the mirror. This is as it was last time,
except I decided to take the device spinlock while  looking at the
metadata. I see lots of potential races in the current code, and I
don't want to be responsible for any more. Let's try and avoid things
moving around underneath while we waffle around in here ...


--- linux-2.4.20-xfs/drivers/md/raid1.c.orig	Sun Jan 26 18:57:20 2003
+++ linux-2.4.20-xfs/drivers/md/raid1.c	Tue Feb 18 18:28:12 2003
@@ -645,8 +658,38 @@
 	bhl = raid1_alloc_bh(conf, conf->raid_disks);
 	for (i = 0; i < disks; i++) {
 		struct buffer_head *mbh;
-		if (!conf->mirrors[i].operational) 
+                /*
+                 * Mark the bitmap of each mirror we can't write to
+                 * (i.e. is not operational).
+                 */
+
+	        spin_lock_irq(&conf->segment_lock);
+		if (!conf->mirrors[i].operational) {
+
+                        struct bitmap * bitmap = conf->bitmap;
+
+                        if (!conf->mirrors[i].used_slot) {
+	                        spin_unlock_irq(&conf->segment_lock);
+                                continue; 
+                        }
+
+                        if (bitmap) {
+                                bitmap->setbits(bitmap, bh->b_rsector >> 1, bh->b_size >> 10);
+                                if (!conf->bitmap_dirty) {
+                                        conf->bitmap_dirty = 1;
+                                        mddev->sb->reserved[2] =
+                                            mddev->sb->events_lo;
+                                        mddev->sb->reserved[3] =
+                                            mddev->sb->events_hi;
+                                }
+                                PRINTK(KERN_DEBUG "raid1: mark mirror %d blk %lu-%lu\n",
+                                 i, bh->b_rsector >> 1,
+                                 (bh->b_rsector >> 1) + (bh->b_size >> 10) - 1);
+                        }
+	                spin_unlock_irq(&conf->segment_lock);
 			continue;
+                }
+	        spin_unlock_irq(&conf->segment_lock);
  
 	/*
 	 * We should use a private pool (size depending on NR_REQUEST),

As before, in the mark disk bad function, we make a bitmap and attach
it to the device. Mmmph .. should take the device spinlock. Well, I
probably do. In the functions called.

@@ -757,6 +869,18 @@
 
 	mirror->operational = 0;
 	mark_disk_faulty(sb->disks+mirror->number);
+        /*
+         * Put the bitmap on a mirror just marked faulty (and
+         * nonoperational).
+         */
+        if (conf->bitmap == NULL) {
+	        int err = raid1_create_bitmap(mddev);
+                printk(KERN_DEBUG "raid1: make bitmap %x on mirror %d (%d)\n",
+                    (unsigned) conf->bitmap, mirror->number, err);
+        } else {
+                printk(KERN_WARNING "raid1: bitmap %x already on mirror %d\n",
+                    (unsigned) conf->bitmap, mirror->number );
+        }
 	mark_disk_nonsync(sb->disks+mirror->number);
 	mark_disk_inactive(sb->disks+mirror->number);
 	if (!mirror->write_only)


In the diskop that activates a spare device, we reomve the bitmap. All
is well again.


@@ -1082,9 +1223,17 @@
 
 		conf->working_disks++;
 
+                /*
+                 * We need to vamoosh the bitmap.
+                 */
+                raid1_remove_bitmap(mddev);
+
 		break;
 
 	case DISKOP_HOT_REMOVE_DISK:
+
+                PRINTK(KERN_DEBUG "raid1: diskop HOT REMOVE\n");
+
 		rdisk = conf->mirrors + removed_disk;
 
 		if (rdisk->spare && (removed_disk < conf->raid_disks)) {

Now we get to the resync function. A few local variables added.
"targets" is the set of faulted (writeonly) disks. "Count" is how many of
them there are. 


@@ -1363,6 +1515,15 @@
 	int disk;
 	int block_nr;
 	int buffs;
+        /*
+         * Will need to count mirror components currently with a bitmap
+         * which have been marked faulty and nonoperational at some
+         * point beforehand, and have been accumulating marks on the
+         * bitmap to indicate dirty blocks that need syncing.
+         */
+        struct bitmap * bitmap;
+        int count;
+        int targets[MD_SB_DISKS];
 
 	if (!sector_nr) {
 		/* we want enough buffers to hold twice the window of 128*/

When looking at the first sector, we check the "hotrepair" flag  that's
been passed down in the md device superblock. If it says 1, ok,
we leave any bitmap in place and later in the resync use it. If the
flag says 0, we remove any bitmap, so the resync will be the ordinary
full resync.


@@ -1371,9 +1532,25 @@
 		if (buffs < 2)
 			goto nomem;
 		conf->window = buffs*(PAGE_SIZE>>9)/2;
+                /* also remove bitmap if not indicated */
+                if (! mddev->sb->reserved[0]) {
+                        /* has to be outside spinlock as it takes it */
+                        printk(KERN_WARNING "md%d: removed bitmap\n",
+                                mdidx(mddev));
+                        raid1_remove_bitmap (mddev);
+                } else {
+                        printk(KERN_WARNING "md%d: retained bitmap %x\n",
+                                mdidx(mddev), (unsigned)conf->bitmap);
+                }
+                /* reset the bitmap indicator always */
+                mddev->sb->reserved[0] = 0;
 	}
 	spin_lock_irq(&conf->segment_lock);
 	if (!sector_nr) {
+                /* setup extra report counters for skipped/synced blocks */
+                conf->sync_mode = -1;
+                conf->last_clean_sector = -1;
+                conf->last_dirty_sector = -1;
 		/* initialize ...*/
 		conf->start_active = 0;
 		conf->start_ready = 0;

This is where we find our targets. And skip them if we have a clean
bitmap for our current block. I need to fix this. This can now be more 
efficient.


@@ -1427,7 +1604,63 @@
 	conf->last_used = disk;
 	
 	mirror = conf->mirrors+conf->last_used;
+
+        /* go looking for the faulted (nonoperational) mirrors */
+        count = 0;
+	while (1) {
+                const int maxdisk = 2 * conf->raid_disks - conf->working_disks;
+		if (disk <= 0)
+                        disk = maxdisk > MD_SB_DISKS ? MD_SB_DISKS : maxdisk;
+		disk--;
+		if (disk == conf->last_used)
+			break;
+                if (!conf->mirrors[disk].operational)
+                        continue;
+                /* We need them to be writable */
+                if (conf->mirrors[disk].write_only) {
+                        targets[count++] = disk;
+                }
+	}
+
+        if (count > 0) {
+                int i;
+                int dirty = 0;
+                for (i = 0; i < count; i++) {
+                        disk = targets[i];
+                        bitmap = conf->bitmap;
+
+                        if (!bitmap
+                        || bitmap->testbit(bitmap, sector_nr >> 1)) {
+                                dirty++;
+                                break;
+                        }
+                }
+                if (dirty <= 0) {
+                        const int done = 2 - (sector_nr & 1);
+	                md_sync_acct(mirror->dev, done);
+                        sync_request_done(sector_nr, conf);
+		        md_done_sync(mddev, done, 1);
+                        if (conf->sync_mode != 0) {
+                                if (conf->sync_mode == 1) {
+                                        printk(KERN_INFO "raid1: synced dirty sectors %lu-%lu\n",
+                                        conf->last_clean_sector+1,
+                                        conf->last_dirty_sector);
+                                }
+                                conf->sync_mode = 0;
+                        }
+                        conf->last_clean_sector = sector_nr + done - 1;
+			wake_up(&conf->wait_ready);
+                        if (mddev->sb && sector_nr + done >= mddev->sb->size<<1) {
+                                printk(KERN_INFO "raid1: skipped clean sectors %lu-%lu\n",
+                                conf->last_dirty_sector+1,
+                                conf->last_clean_sector);
+                        }
+                        /* skip remainder of block */
+                        return done;
+                }
+        }
 	
+        /* read */
 	r1_bh = raid1_alloc_buf (conf);
 	r1_bh->master_bh = NULL;
 	r1_bh->mddev = mddev;

And that's that. I'll summarise later.

Peter
