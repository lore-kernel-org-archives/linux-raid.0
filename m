From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: Fast (intelligent) raid1
Date: Wed, 12 Feb 2003 00:05:49 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302112305.h1BN5nu16695@oboe.it.uc3m.es>
References: <200302112036.h1BKaMV30242@oboe.it.uc3m.es>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200302112036.h1BKaMV30242@oboe.it.uc3m.es> from "Peter T. Breuer"
 at "Feb 11, 2003 09:36:22 pm"
To: ptb@it.uc3m.es
Cc: Ross Vandegrift <ross@willow.seitz.com>, Ingo Molnar <mingo@redhat.com>, neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Peter T. Breuer wrote:"
> Have a look at the patch in the .tgz. I tried to make it as clean as I
> could. Every change I made in the md.c code is commented. There are 4
> "hunks" of changes to md.c, to allow hotadd after setfaulty, and about
> ten significant hunks of changes to raid1.c, inserting the extra
> technology. There is some extra debugging code in that, which I can
> remove if a minimal patch is required. The rest of the support is given
> in a separate, new, bitmap.c file, which supplies infrastructure.

In fact - I'll publish and go through the patch here. Here we go.

We start with md.c and the addition to the block comment in the head
of the file>

--- linux-2.4.19-xfs.orig/drivers/md/md.c	Sun Feb  9 10:35:53 2003
+++ linux-2.4.19-xfs/drivers/md/md.c	Sun Feb  9 10:45:42 2003
@@ -26,6 +26,12 @@
    You should have received a copy of the GNU General Public License
    (for example /usr/src/linux/COPYING); if not, write to the Free
    Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+
+   Changes 31/1/2003 by Peter T.  Breuer <ptb@it.uc3m.es> to support
+   hotadd directly after setfaulty without intervening hotremove
+   ("hotrepair"). 
+        - save and restore extra data when hotrepair detected
+
 */
 
 #include <linux/module.h>



Next in md.c is a set of changes in the hotadd function. We're going
to detect a hotadd of a faulty disk, and interpret it as a "hotrepair",
so we need a state variable to signal it. When we spot it, we will do a
hotremove before doing the hotadd, as the raid code expects that and
I don't want to play around. But we'll save and restore all the extra
data that I've put in the "reserved for future use" part of the
md disk data when we declared the disk faulty. Well, I say "all", but
it's only the address of a bitmap. Anyway, the hotrepair boolean
signals what we're doing, and the extra_data array holds the extra data
temporarily.


@@ -2374,6 +2380,9 @@
 	unsigned int size;
 	mdk_rdev_t *rdev;
 	mdp_disk_t *disk;
+        /* do extra hotremove and save/restore extra data in hotrepair */
+        int hotrepair = 0;
+        typeof(disk->reserved) extra_data;
 
 	if (!mddev->pers)
 		return -ENODEV;


Now for the change in the hotadd function that spots an attempt to
hotadd a faulty disk, and adds an extra hotremove before continuing. We
set the hotrepair boolean here, and save the extra_data. In order to
preserve exactly what should happen if we had really done a hotremove
before getting here, I put a label at the start of this section and
jump back to it with a goto after saving the datam, setting the
boolean, and calling the hotremove. When we start again we're exactly
in the sutuation that the original md.c code expects. We don't
reexecute this detection code again because there's a !hotrepair
guard on it. So we just fall through. I could have fallen through
originally, but I wanted to not miss anything by accident.

@@ -2396,14 +2405,48 @@
 		return -ENOSPC;
 	}
 
+start_again:
 	rdev = find_rdev(mddev, dev);
-	if (rdev)
-		return -EBUSY;
+        /*
+         * Allow "hotrepair" of merely faulty device too.
+         */
+	if (rdev) {
+                if (!rdev->faulty)
+		        return -EBUSY;
+		if (!hotrepair && rdev->dev == dev) {
+		        printk(KERN_WARNING "md%d: re-add of faulty disk detected! Will remove first.\n",
+		       mdidx(mddev));
+                        for (i = 0; i < MD_SB_DISKS; i++) {
+		                disk = mddev->sb->disks + i;
+                                if (MKDEV(disk->major,disk->minor) == dev) {
+                                        break;
+                                }
+                        }
+                        if (i < MD_SB_DISKS) {
+		                mdp_disk_t * disk = mddev->sb->disks + i;
+		                printk(KERN_WARNING "md%d: saving extra data from disk %d!\n",
+		                        mdidx(mddev), disk->number);
+                                memcpy(extra_data,
+                                       (&mddev->sb->disks[disk->number])->reserved, sizeof(extra_data));
+                                printk(KERN_DEBUG "saved data");
+                                for (i = 0; i < sizeof(extra_data)/4; i++) {
+                                        printk(" %d: %x", i, extra_data[i]);
+                                }
+                                printk("\n");
+                        }
+		        err = hot_remove_disk(mddev, dev);
+                        if (err < 0) {
+	                        return err;       
+                        }
+                        hotrepair = 1;
+                        goto start_again;
+                }
+        }
 
 	err = md_import_device (dev, 0);
 	if (err) {
		printk(KERN_WARNING "md: error, md_import_device() returned %d\n", err);
		return -EINVAL;
 	}
 	rdev = find_rdev_all(dev);
 	if (!rdev) {


Further down the function we come to a bit where the "new" disk, which
has been added as a spare disk, is finally shifted into place in the
array. At this point we restore the saved data to it (it's only the
address of a bitmap really, but we restore all the data that's possible
to restore so as not to know anything about raid1 structures).

@@ -2466,6 +2509,16 @@
 	}
 
 	mark_disk_spare(disk);
+        if (hotrepair) {
+		printk(KERN_WARNING "md%d: restoring saved extra data to disk %d!\n",
+		       mdidx(mddev), disk->number);
+                memcpy((&mddev->sb->disks[disk->number])->reserved, extra_data, sizeof(extra_data));
+                printk(KERN_DEBUG "restored data");
+                for (i = 0; i < sizeof(extra_data)/4; i++) {
+                        printk(" %d: %x", i, extra_data[i]);
+                }
+                printk("\n");
+        }
 	mddev->sb->nr_disks++;
 	mddev->sb->spare_disks++;
 	mddev->sb->working_disks++;


That was all the changes in md.c. Now for the changes in raid1.c. First
an addition to the comment at the head:



--- linux-2.4.19-xfs.orig/drivers/md/raid1.c	Sat Feb  8 23:19:06 2003
+++ linux-2.4.19-xfs/drivers/md/raid1.c	Sun Feb  9 09:48:24 2003
@@ -20,6 +20,17 @@
  * You should have received a copy of the GNU General Public License
  * (for example /usr/src/linux/COPYING); if not, write to the Free
  * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ * Changes by Peter T. Breuer <ptb@it.uc3m.es> 31/1/2003 to support
+ * bitmapped intelligence in resync:
+ *
+ *      - bitmap attached on setfaulty (mark bad)
+ *      - bitmap marked during normal i/o if faulty disk
+ *      - bitmap used to skip nondirty blocks during sync
+ *      - bitmap removed on set active
+ *
+ *   Minor changes are needed in raid1.h (extra fields in conf) and in
+ *   md.c (support hotadd directly after hotremove).
  */
 
 #include <linux/module.h>


OK. I turned on what debugging there was in order to help me. That's
this nect hunk.


@@ -39,7 +50,7 @@
 /*
  * The following can be used to debug the driver
  */
-#define RAID1_DEBUG	0
+#define RAID1_DEBUG	1
 
 #if RAID1_DEBUG
 #define PRINTK(x...)   printk(x)



In order to include the bitmap technology, I need some of the functions
declared in bitmap.h. Actually, it's an object/class, and I need the
class declaration with its methods. I didn't want to play with the
raid1 disk info structs, so I used the first 32bit reserved field in
the struct to contain a bitmap address. Sorry.


@@ -49,6 +60,8 @@
 #define PRINTK(x...)  do { } while (0)
 #endif
 
+#include "bitmap.h"
+#define raid1_bitmap(disk) ((struct bitmap *)(disk)->reserved[0])
 
 static mdk_personality_t raid1_personality;
 static md_spinlock_t retry_list_lock = MD_SPIN_LOCK_UNLOCKED;


Now comes a change to the ordinary write code. When we get a write
command we go and search for "nonoperational" mirror components,
and mark the bitmap on each of them for the blocks that we are supposed
to be writing to. Sorry about the search each time, but the only
sensible alternative is to maintain an array of indices of the
nonoperatonal devices, and that's plain confusing as code.

I'm not sure if nonworking mirror components ARE signalled by the
!operational flag. What's this used_slot field for? Am I supposed
to ignore it, or respect it, or what? I seem to be skipping components
without the used_slot field set. It didn't hurt me, but who knows what
it's for ...



@@ -640,8 +653,31 @@
 	bhl = raid1_alloc_bh(conf, conf->raid_disks);
 	for (i = 0; i < disks; i++) {
 		struct buffer_head *mbh;
-		if (!conf->mirrors[i].operational) 
+                /*
+                 * Mark the bitmap of each mirror we can't write to
+                 * (i.e. is not operational).
+                 */
+		if (!conf->mirrors[i].operational) {
+
+                        struct bitmap * bitmap = NULL;
+	                mdp_super_t *sb = mddev->sb;
+
+                        if (!conf->mirrors[i].used_slot)
+                                continue; 
+
+                        /* I'm not sure if mddev always has sb. FIXME. */
+                        if (sb) {
+                                bitmap =
+                            raid1_bitmap(&sb->disks[conf->mirrors[i].number]);
+                        }
+                        if (bitmap) {
+                                bitmap->setbits(bitmap, bh->b_rsector >> 1, bh->b_size >> 10);
+                                PRINTK(KERN_DEBUG "raid1: mark mirror %d blk %lu-%lu\n",
+                                 i, bh->b_rsector >> 1,
+                                 (bh->b_rsector >> 1) + (bh->b_size >> 10) - 1);
+                        }
 			continue;
+                }
  
 	/*
 	 * We should use a private pool (size depending on NR_REQUEST),


The next bit just adds a couple of functions for adding and removing a
bitmap from a raid1 component disk. It's purely an interface to the
underlying bitmap make and destroy methods. The create function figures
out the size of the component and passes it to the init method, for
example.


@@ -744,6 +780,47 @@
 #define ALREADY_SYNCING KERN_INFO \
 "raid1: syncing already in progress.\n"
 
+static int raid1_create_bitmap(mdp_disk_t * disk) {
+
+        struct bitmap * bitmap;
+        unsigned long blocks;
+        int err;
+
+        if (raid1_bitmap(disk) != NULL)
+                return -EINVAL;
+
+        if (!blk_size[disk->major])
+                return -EINVAL;
+
+        blocks = blk_size[disk->major][disk->minor];
+
+        bitmap = kmalloc (sizeof (*bitmap), GFP_KERNEL);
+	if (!bitmap)
+                return -ENOMEM;
+
+	bitmap_init (bitmap, blocks);
+	err = bitmap->make (bitmap);
+	if (err < 0) {
+		kfree (bitmap);
+                return err;
+	}
+        raid1_bitmap(disk) = bitmap;
+        return 0;
+}
+
+static void
+raid1_bitmap_remove (mdp_disk_t * disk) {
+
+        struct bitmap * bitmap = raid1_bitmap(disk);
+
+        if (bitmap == NULL)
+                return;
+
+        raid1_bitmap(disk) = NULL;
+        bitmap->destroy(bitmap);
+        kfree(bitmap);
+}
+
 static void mark_disk_bad (mddev_t *mddev, int failed)
 {
 	raid1_conf_t *conf = mddev_to_conf(mddev);


The mark disk bad function is apparently what's called when we do a
setfaulty. It gets altered to add in a bitmap for the component, if one
wasn't already there.


@@ -752,6 +829,20 @@
 
 	mirror->operational = 0;
 	mark_disk_faulty(sb->disks+mirror->number);
+        /*
+         * Put the bitmap on a mirror just marked faulty (and
+         * nonoperational).
+         */
+        if (raid1_bitmap(&sb->disks[mirror->number]) == NULL) {
+	        raid1_create_bitmap(&sb->disks[mirror->number]);
+                PRINTK(KERN_DEBUG "raid1: make bitmap %x on mirror %d\n",
+                    (unsigned) raid1_bitmap(&sb->disks[mirror->number]),
+                    mirror->number );
+        } else {
+                PRINTK(KERN_DEBUG "raid1: bitmap %x already on mirror %d\n",
+                    (unsigned) raid1_bitmap(&sb->disks[mirror->number]),
+                    mirror->number );
+        }
 	mark_disk_nonsync(sb->disks+mirror->number);
 	mark_disk_inactive(sb->disks+mirror->number);
 	if (!mirror->write_only)


This hunk is purely for my debugging convenience. I removed repeats of
"zero" entries from the conf map.


@@ -818,6 +909,12 @@
 
 	for (i = 0; i < MD_SB_DISKS; i++) {
 		tmp = conf->mirrors + i;
+                /*
+                 * Remove repeats from debug printout.
+                 */
+                if (i > 0 && memcmp(tmp, &conf->mirrors[i-1], sizeof(*tmp)) == 0) {
+                    continue;
+                }
 		printk(" disk %d, s:%d, o:%d, n:%d rd:%d us:%d dev:%s\n",
 			i, tmp->spare,tmp->operational,
 			tmp->number,tmp->raid_disk,tmp->used_slot,


Hohum - more debugging. The diskop function is a complete mystery to
me. I had to add printouts in every case of all its case statements. 
I used the PRINTK call, so it's turned off when you turn off debugging
in the code. I left the debug stuff in because it prints out only
when somebody actually does an operation, so it's human-related.

@@ -878,6 +975,8 @@
 
 	case DISKOP_SPARE_ACTIVE:
 
+                PRINTK(KERN_DEBUG "raid1: diskop SPARE ACTIVE\n");
+
 		/*
 		 * Find the failed disk within the RAID1 configuration ...
 		 * (this can only be in the first conf->working_disks part)


More debugging in diskop, plus a possibly gratuitous change that allows
the code, which goes looking for a spare device to apply one of its
spare_active or spare_inactive or spare_write changes to, to find a 
spare device more easily. The device major and minor matching is
sufficient after this change. I didn't know wxactly what the  disk
"number" signified.

@@ -904,13 +1003,24 @@
 	case DISKOP_SPARE_WRITE:
 	case DISKOP_SPARE_INACTIVE:
 
+                PRINTK(KERN_DEBUG "raid1: diskop SPARE %s\n",
+                        state == DISKOP_SPARE_WRITE ? "WRITE" : 
+                        state == DISKOP_SPARE_INACTIVE ? "INACTIVE" : 
+                        state == DISKOP_SPARE_ACTIVE ? "ACTIVE" : ""
+                        );
 		/*
 		 * Find the spare disk ... (can only be in the 'high'
 		 * area of the array)
 		 */
 		for (i = conf->raid_disks; i < MD_SB_DISKS; i++) {
 			tmp = conf->mirrors + i;
-			if (tmp->spare && tmp->number == (*d)->number) {
+			if (tmp->spare
+                        && (tmp->number == (*d)->number
+                        /*
+                         * I'm not sure we now need to allow match by
+                         * device number too. FIXME.
+                         */
+                            || tmp->dev == MKDEV((*d)->major,(*d)->minor))) {
 				spare_disk = i;
 				break;
 			}


and more debugging in diskop.

@@ -924,6 +1034,8 @@
 
 	case DISKOP_HOT_REMOVE_DISK:
 
+                PRINTK(KERN_DEBUG "raid1: diskop HOT REMOVE\n");
+
 		for (i = 0; i < MD_SB_DISKS; i++) {
 			tmp = conf->mirrors + i;
 			if (tmp->used_slot && (tmp->number == (*d)->number)) {

and more debugging in diskop.


@@ -944,6 +1056,8 @@
 
 	case DISKOP_HOT_ADD_DISK:
 
+                PRINTK(KERN_DEBUG "raid1: diskop HOT ADD\n");
+
 		for (i = conf->raid_disks; i < MD_SB_DISKS; i++) {
 			tmp = conf->mirrors + i;
 			if (!tmp->used_slot) {

and more debugging in diskop.

@@ -964,20 +1078,31 @@
 	 * Switch the spare disk to write-only mode:
 	 */
 	case DISKOP_SPARE_WRITE:
+
 		sdisk = conf->mirrors + spare_disk;
+
+                PRINTK(KERN_DEBUG "raid1: diskop SPARE WRITE disk %d\n",
+                        sdisk->number);
+
 		sdisk->operational = 1;
 		sdisk->write_only = 1;
+
 		break;
 	/*
 	 * Deactivate a spare disk:
 	 */
 	case DISKOP_SPARE_INACTIVE:
+
 		if (conf->start_future > 0) {
 			MD_BUG();
 			err = -EBUSY;
 			break;
 		}
 		sdisk = conf->mirrors + spare_disk;
+
+                PRINTK(KERN_DEBUG "raid1: diskop SPARE INACTIVE disk %d\n",
+                        sdisk->number);
+
 		sdisk->operational = 0;
 		sdisk->write_only = 0;
 		break;

and more debugging in diskop. One can leave all this out of the patch.
But it would drive me crazy.

@@ -989,12 +1114,17 @@
 	 * property)
 	 */
 	case DISKOP_SPARE_ACTIVE:
+
 		if (conf->start_future > 0) {
 			MD_BUG();
 			err = -EBUSY;
 			break;
 		}
 		sdisk = conf->mirrors + spare_disk;
+
+                PRINTK(KERN_DEBUG "raid1: diskop SPARE ACTIVE disk %d\n",
+                        sdisk->number);
+
 		fdisk = conf->mirrors + failed_disk;
 
 		spare_desc = &sb->disks[sdisk->number];

Aha, finally, I think this is when we mark the spare active in diskop.
We remove the bitmap at this point. We've presumably just done
a sync. I'd have preferered to wipe the bitmap during the sync itself,
or at the end, but it appears that spare_active is called as a diskop
always just before integrating the "new" device in the array and after
it having synced. So I trust this is correct.


@@ -1077,9 +1207,17 @@
 
 		conf->working_disks++;
 
+                /*
+                 * We need to vamoosh the bitmap.
+                 */
+                raid1_bitmap_remove( mddev->sb->disks+fdisk->number);
+
 		break;
 
 	case DISKOP_HOT_REMOVE_DISK:
+
+                PRINTK(KERN_DEBUG "raid1: diskop HOT REMOVE\n");
+
 		rdisk = conf->mirrors + removed_disk;
 
 		if (rdisk->spare && (removed_disk < conf->raid_disks)) {

And more diskop debugging.

@@ -1093,6 +1231,9 @@
 		break;
 
 	case DISKOP_HOT_ADD_DISK:
+
+                PRINTK(KERN_DEBUG "raid1: diskop HOT ADD\n");
+
 		adisk = conf->mirrors + added_disk;
 		added_desc = *d;
 


And some debugging of my own, to show that the bitmap is there. It's
magicked into position because it comes from the data that md.c saved
and restored, and it's just "there" when we look here in diskop.  The
bitmap was really created dring the mark disk bad call, ages ago, after
a setfaulty.


@@ -1113,6 +1254,10 @@
 		adisk->head_position = 0;
 		conf->nr_disks++;
 
+                PRINTK(KERN_DEBUG "raid1: diskop HOT ADDed mirr %d disk %d bitmap %x\n",
+                        added_disk, adisk->number,
+                        (unsigned)raid1_bitmap(&mddev->sb->disks[adisk->number]));
+
 		break;
 
 	default:


Now here we are in the resync function. The original code synced every
block. We're only going to sync blocks that appear in the bitmaps of
the faulty devices. So I keep an array of the indices of the faulty
devices ("targets"), as well as a "count" of how many there are of
them. "bitmap" is just a temp variable.


@@ -1358,6 +1503,15 @@
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

The original code does its setup when its asked to sync sector 0. We do 
the same, but for a couple of extra accounting fields placed in the
"conf" raid1 struct. This is purely for informational output.


@@ -1369,6 +1523,10 @@
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


Umm, I fixed a couple of printk field types.



@@ -1382,7 +1540,7 @@
 			MD_BUG();
 	}
 	while (sector_nr >= conf->start_pending) {
-		PRINTK("wait .. sect=%lu start_active=%d ready=%d pending=%d future=%d, cnt_done=%d active=%d ready=%d pending=%d future=%d\n",
+		PRINTK("wait .. sect=%lu start_active=%ld ready=%ld pending=%ld future=%ld, cnt_done=%d active=%d ready=%d pending=%d future=%d\n",
 			sector_nr, conf->start_active, conf->start_ready, conf->start_pending, conf->start_future,
 			conf->cnt_done, conf->cnt_active, conf->cnt_ready, conf->cnt_pending, conf->cnt_future);
 		wait_event_lock_irq(conf->wait_done,



Here we go and find the list of faulted (nonoperational) mirror
components. There appears to be no sensible upper bound on where to
search for these in the existing array. So I look in the range n to n
+f, where n is the number of "raid disks", and "f" is the number of
the raid disks which have failed. We are presently syncing a device we
have just added, and it gets added in as a spare disk, so it will
be above the standard raid disks in the array. I don't think it can be
above n+f, but maybe I am wrong. I don't know what the effect of
"spare" disks is. "f" is "n-w", of course, where "w" is the number of
working disks.

If we find some faulted targets, then we check their bitmaps. If they
have a bitmap and its clean, then we skip the sync of this block.
I signalled md_sync_acct, sync_request_done, md_done_sync, and anything
else I could find. That seems to do the trick.

If, OTOH, the bitmaps are not clean for this block, we fall through and
do the normal sync.

@@ -1422,7 +1580,64 @@
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
+                        PRINTK(KERN_DEBUG "testing bitmap for disk %d\n", disk);
+                        bitmap = mddev->sb ? raid1_bitmap(&mddev->sb->disks[conf->mirrors[disk].number]) : NULL;
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


Here's some accounting printout at the end of the resync function. It's
just reporting sequences of clean or dirty blocks. It shouldn't be too
noisy in practice.

@@ -1456,6 +1671,22 @@
 	generic_make_request(READ, bh);
 	md_sync_acct(bh->b_dev, bh->b_size/512);
 
+        /* printout info from time to time */
+        if (conf->sync_mode != 1) {
+                if (conf->sync_mode == 0) {
+                        printk(KERN_INFO "raid1: skipped clean sectors %lu-%lu\n",
+                        conf->last_dirty_sector+1,
+                        conf->last_clean_sector);
+                }
+                conf->sync_mode = 1;
+        }
+        conf->last_dirty_sector = sector_nr + (bsize >> 9) - 1;
+
+        if (mddev->sb && sector_nr + (bsize >> 9) >= mddev->sb->size<<1) {
+                printk(KERN_INFO "raid1: synced dirty sectors %lu-%lu\n",
+                conf->last_clean_sector+1,
+                conf->last_dirty_sector);
+        }
 	return (bsize >> 9);
 
 nomem:


And that was that.


Peter

