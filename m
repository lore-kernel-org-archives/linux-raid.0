From: Sebastian Sobolewski <linux@thirdmartini.com>
Subject: [PATCH] Re: Write and verify correct data to read-failed sectors
 before degrading array?
Date: Tue, 21 Sep 2004 18:06:02 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4150C1EA.3050802@thirdmartini.com>
References: <41420D07.4060001@steeleye.com>	<16709.12517.514905.627708@cse.unsw.edu.au>	<41487D18.1050000@steeleye.com>	<4149700F.6060509@buttersideup.com>	<16714.12891.987589.769643@cse.unsw.edu.au>	<414A40DB.6070309@thirdmartini.com> <16714.17729.576621.347771@cse.unsw.edu.au> <414A4831.1040407@thirdmartini.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020600030805010008060402"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <414A4831.1040407@thirdmartini.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------020600030805010008060402
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


    Here is the patch for URE recovery from a good mirror that I've been 
using.  I would not use it with /dev/raw as a R-W conflict during URE 
recovery can result in data in one copy potentially corrupting.  I've 
used this with ext2/ext3 and xfs.  This is against kernel.org 2.4.36 
kernel.  Please note that I do not verify that the recovery write wrote 
correct data, I assume that if the write was successful the drive 
remapped the sector and not failed on us silently.

-Sebastian

--- linux-2.4.26/include/linux/raid/raid1.h    2001-08-12 
13:39:02.000000000 -0600
+++ ../2420/linux/include/linux/raid/raid1.h    2004-09-21 
09:18:03.000000000 -0600
@@ -18,6 +18,7 @@
     int        spare;
 
     int        used_slot;
+    atomic_t rr_count;
 };
 
 struct raid1_private_data {
@@ -59,6 +60,9 @@
     md_wait_queue_head_t    wait_done;
     md_wait_queue_head_t    wait_ready;
     md_spinlock_t        segment_lock;
+    /* Use Read Recovery */
+    int use_read_recovery;
+    atomic_t rr_total;
 };
 
 typedef struct raid1_private_data raid1_conf_t;
@@ -86,6 +90,7 @@
     struct buffer_head    *mirror_bh_list;
     struct buffer_head    bh_req;
     struct raid1_bh        *next_r1;    /* next for retry or in free 
list */
+    kdev_t             failed_dev;
 };
 /* bits for raid1_bh.state */
 #define    R1BH_Uptodate    1
--- linux-2.4.26/drivers/md/raid1.c    2004-04-14 07:05:30.000000000 -0600
+++ ../2420/linux/drivers/md/raid1.c    2004-09-21 09:21:59.000000000 -0600
@@ -32,10 +32,19 @@
 #define MD_DRIVER
 #define MD_PERSONALITY
 
-#define MAX_WORK_PER_DISK 128
-
 #define    NR_RESERVED_BUFS    32
 
+unsigned MAX_WORK_PER_DISK = 128;
+MODULE_PARM(RAID1_MAX_WORK_PER_DISK, "i");
+MODULE_PARM_DESC(RAID1_MAX_WORK_PER_DISK, "The Maximum number of 
sectors given to any disk before we switch disks in read balance code");
+
+/*
+ * Enable Read Recovery code.  For more information see 
end_request_recovery()
+ */
+unsigned RAID1_READ_RECOVERY = 1;
+MODULE_PARM(RAID1_READ_RECOVERY, "i");
+MODULE_PARM_DESC(RAID1_READ_RECOVERY, "Use raid1 read recovery code");
+
 
 /*
  * The following can be used to debug the driver
@@ -165,6 +174,7 @@
             r1_bh->next_r1 = NULL;
             r1_bh->state = (1 << R1BH_PreAlloc);
             r1_bh->bh_req.b_state = 0;
+            r1_bh->failed_dev = 0;
         }
         md_spin_unlock_irq(&conf->device_lock);
         if (r1_bh)
@@ -262,6 +272,7 @@
     r1_bh = conf->freebuf;
     conf->freebuf = r1_bh->next_r1;
     r1_bh->next_r1= NULL;
+    r1_bh->failed_dev = 0;
     md_spin_unlock_irq(&conf->device_lock);
 
     return r1_bh;
@@ -321,6 +332,33 @@
     }
 }
 
+static int raid1_map_notsame(mddev_t *mddev, kdev_t *rdev)
+{
+    raid1_conf_t *conf = mddev_to_conf(mddev);
+    //kdev_t new_dev = *rdev;
+    int i, disks = MD_SB_DISKS;
+
+    /*
+     * Later we do read balancing on the read side
+     * now we use the first available disk.
+     */
+
+    for (i = 0; i < disks; i++) {
+        if (conf->mirrors[i].operational) {
+            /*
+             * Pick a different device then the original
+             */
+            if( conf->mirrors[i].dev != *rdev ){
+                *rdev = conf->mirrors[i].dev;
+                return (0);
+            }
+        }
+    }
+
+    return (-1);
+}
+
+#if 0
 static int raid1_map (mddev_t *mddev, kdev_t *rdev)
 {
     raid1_conf_t *conf = mddev_to_conf(mddev);
@@ -341,6 +379,7 @@
     printk (KERN_ERR "raid1_map(): huh, no more operational devices?\n");
     return (-1);
 }
+#endif
 
 static void raid1_reschedule_retry (struct raid1_bh *r1_bh)
 {
@@ -403,6 +442,103 @@
     bh->b_end_io(bh, uptodate);
     raid1_free_r1bh(r1_bh);
 }
+
+/*
+ * incement the read recovery counter for the mddevice as well as on 
the individual disk. 
+ *  this information is output in raid1_status.  This allows us to 
print out the per disk error counts
+ *  so we can decide when the disk is likely to be going completely bad 
as opposed to having partial media/sector
+ *  errors.
+ */
+void raid1_mark_recovered( raid1_conf_t *conf , kdev_t rdev )
+{
+    int i, disks = MD_SB_DISKS;
+    atomic_inc( &conf->rr_total );
+    for (i = 0; i < disks; i++) {
+        if( conf->mirrors[i].dev == rdev ){
+            atomic_inc( &conf->mirrors[i].rr_count );
+            return ;
+        }
+    }
+}
+
+/*
+ * This is the completion callback for the correcting write operation.  
If the write fails
+ * the disk is definetly bad.  Otherwise the write forced the disk 
drive to remap the bad sector
+ * to one of it's spares. 
+ *
+ * If we want to be paranoid, we can issue a read of the just written 
sector and compare it to the mirror
+ *  copy before we acknowledge the read. However impirical data has 
shown that if the write succeeds, the read will be correct.
+ *
+ */
+void raid1_end_request_recover_complete( struct buffer_head *bh, int 
uptodate )
+{
+    struct raid1_bh * r1_bh = (struct raid1_bh *)(bh->b_private);
+    raid1_conf_t *conf = mddev_to_conf(r1_bh->mddev);
+   
+    if( !uptodate )
+    {
+        printk(KERN_ERR "raid1: %s: recover failed lba=%lu\n",  
partition_name(bh->b_dev), bh->b_blocknr);
+        md_error (r1_bh->mddev, r1_bh->failed_dev );
+        r1_bh->failed_dev = 0;
+    }
+    else
+    {
+        raid1_mark_recovered( conf,  r1_bh->failed_dev );
+        printk(KERN_INFO "raid1: %s: recover success lba=%lu\n",  
partition_name(bh->b_dev), bh->b_blocknr);
+    }
+    /*
+     *  We got here because the write recovery attempt failed us, 
however since we made it this far
+     *  it means that the read WAS SUCESSFULL originally.
+     */
+    r1_bh->cmd = READ;
+    raid1_end_bh_io(r1_bh, 1 );
+}
+
+/*
+ * This is the io completion callback for the read from the redundant 
mirror.  If the read is sucessfull we will issue
+ *  a write to the mirror that previsouly failed the read of this 
sector.  This should cause the drive to remap the bad
+ *  sector to a spare.
+ */
+void raid1_end_request_recover( struct buffer_head *bh, int uptodate )
+{
+    struct raid1_bh * r1_bh = (struct raid1_bh *)(bh->b_private);
+    if( !uptodate )
+    {
+        printk(KERN_ERR "raid1: %s: recovering lba=%lu failed.. double 
fault\n",  partition_name(bh->b_dev), bh->b_blocknr);
+        /*
+         * We delayed the failure of this device earlier.  Now we had 2 
failures in a row from different devices
+         * thus we must fail the previos device to ensure we don;t do 
this forever.
+         */
+        md_error (r1_bh->mddev, r1_bh->failed_dev);
+        r1_bh->failed_dev = bh->b_dev;
+       
+        /*
+         * Now retry one more time.  We may have more valid devices/  
If not raid1d READ/READA handler
+         *   will tell us so.
+         */
+        printk(KERN_INFO "raid1: %s: rescheduling lba=%lu again (have 
more devices?)\n",
+             partition_name(bh->b_dev), bh->b_blocknr);
+        raid1_reschedule_retry(r1_bh);
+        return;
+    }
+    else
+    {
+        /*
+         * FIXME: this whole thing only recovers 1 raid mirror.  To do 
this 100% correctly we need to keep a list of prefail devices
+         *        since a 3 way mirror will drop 1 device before 
rebuilding
+         */
+        printk(KERN_INFO "raid1: %s: recovering block lba=%lu read ok.. 
do write\n",  partition_name(bh->b_dev), bh->b_blocknr);
+        //
+        // We need to map in the recovery device
+        //
+        r1_bh->cmd   = WRITE;
+        bh->b_end_io = raid1_end_request_recover_complete;
+        bh->b_dev    = r1_bh->failed_dev;
+        bh->b_rdev   = r1_bh->failed_dev;
+        raid1_reschedule_retry(r1_bh);
+    }
+}
+
 void raid1_end_request (struct buffer_head *bh, int uptodate)
 {
     struct raid1_bh * r1_bh = (struct raid1_bh *)(bh->b_private);
@@ -410,8 +546,27 @@
     /*
      * this branch is our 'one mirror IO has finished' event handler:
      */
-    if (!uptodate)
+    if (!uptodate){
+        raid1_conf_t *conf = mddev_to_conf(r1_bh->mddev);
+       
+        if ( ( conf->use_read_recovery == 1 ) && ( (r1_bh->cmd == READ) 
|| (r1_bh->cmd == READA) ) )
+        {
+            /*
+             * Remap the end io for this device since we are going to 
try recovery
+             * DO NOT change the mddev.. we need the original failing MDDEV
+             */
+            printk(KERN_INFO "raid1: %s: read recovery will be 
attempted on lba=%lu from another mirror\n",
+            partition_name(bh->b_dev), bh->b_blocknr);
+
+            bh->b_end_io = raid1_end_request_recover;
+            r1_bh->failed_dev = bh->b_dev;
+        }
+        else
+        {
         md_error (r1_bh->mddev, bh->b_dev);
+        }
+       
+    }
     else
         /*
          * Set R1BH_Uptodate in our master buffer_head, so that
@@ -441,7 +596,7 @@
         /*
          * oops, read error:
          */
-        printk(KERN_ERR "raid1: %s: rescheduling block %lu\n",
+        printk(KERN_ERR "raid1: %s: rescheduling lba=%lu\n",
              partition_name(bh->b_dev), bh->b_blocknr);
         raid1_reschedule_retry(r1_bh);
         return;
@@ -480,10 +635,11 @@
     unsigned long current_distance;
    
     /*
-     * Check if it is sane at all to balance
+     * Check if it is sane at all to balance.
+     * make sure the last used drive is operational (it may have been 
removed).
      */
    
-    if (conf->resync_mirrors)
+    if (conf->resync_mirrors && conf->mirrors[new_disk].operational)
         goto rb_out;
    
 
@@ -737,10 +893,17 @@
    
     seq_printf(seq, " [%d/%d] [", conf->raid_disks,
                          conf->working_disks);
+                         
     for (i = 0; i < conf->raid_disks; i++)
         seq_printf(seq, "%s",
             conf->mirrors[i].operational ? "U" : "_");
     seq_printf(seq, "]");
+   
+    seq_printf(seq, " ( ");
+    for (i = 0; i < conf->raid_disks; i++){
+        seq_printf(seq,"%d ",atomic_read( &conf->mirrors[i].rr_count ) );
+    }
+    seq_printf(seq, ")");
 }
 
 #define LAST_DISK KERN_ALERT \
@@ -783,6 +946,7 @@
 
 static int raid1_error (mddev_t *mddev, kdev_t dev)
 {
+    mdk_rdev_t *rrdev = NULL;
     raid1_conf_t *conf = mddev_to_conf(mddev);
     struct mirror_info * mirrors = conf->mirrors;
     int disks = MD_SB_DISKS;
@@ -808,6 +972,16 @@
 
         return 1;
     }
+   
+    rrdev = find_rdev( mddev, dev );
+    if( rrdev )
+    {
+        rrdev->faulty = 1;
+    }
+    else
+    {
+        printk("raid1: rrdev == NULL in raid1_error\n");
+    }
     mark_disk_bad(mddev, i);
     return 0;
 }
@@ -963,6 +1137,7 @@
             tmp = conf->mirrors + i;
             if (!tmp->used_slot) {
                 added_disk = i;
+                atomic_set(&tmp->rr_count,0);
                 break;
             }
         }
@@ -1129,7 +1304,7 @@
         conf->nr_disks++;
 
         break;
-
+       
     default:
         MD_BUG();   
         err = 1;
@@ -1266,12 +1441,26 @@
             }
 
             break;
+       
+        case WRITE:
+            /*
+             * We do not map the dev.  It SHOULD be already mapped for us
+             */
+            printk ("raid1: %s: read-error recovery lba=%lu  (writing 
recovered lba)\n",partition_name(bh->b_dev),bh->b_blocknr);
+            generic_make_request (r1_bh->cmd, bh);
+            break;
+           
         case READ:
         case READA:
             dev = bh->b_dev;
-            raid1_map (mddev, &bh->b_dev);
+            raid1_map_notsame(mddev, &bh->b_dev);
             if (bh->b_dev == dev) {
                 printk (IO_ERROR, partition_name(bh->b_dev), 
bh->b_blocknr);
+        /*        if( r1_bh->failed_dev )
+                {
+                    md_error (r1_bh->mddev, r1_bh->failed_dev);
+                    r1_bh->failed_dev = 0;
+                }*/
                 raid1_end_bh_io(r1_bh, 0);
             } else {
                 printk (REDIRECT_SECTOR,
@@ -1596,6 +1785,8 @@
         disk_idx = descriptor->raid_disk;
         disk = conf->mirrors + disk_idx;
 
+        atomic_set(&disk->rr_count, 0 );
+       
         if (disk_faulty(descriptor)) {
             disk->number = descriptor->number;
             disk->raid_disk = disk_idx;
@@ -1761,6 +1952,8 @@
         }
     }
     sb->active_disks = conf->working_disks;
+    /* Set the read recovery flag to the default value */
+    conf->use_read_recovery = RAID1_READ_RECOVERY;
 
     if (start_recovery)
         md_recover_arrays();
@@ -1859,6 +2052,9 @@
 
 static int md__init raid1_init (void)
 {
+    if( RAID1_READ_RECOVERY ){
+        printk("raid1: Read Recovery Enabled\n");
+    }
     return register_md_personality (RAID1, &raid1_personality);
 }


--------------020600030805010008060402
Content-Type: text/plain;
 name="raid1rr.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="raid1rr.patch"

--- linux-2.4.26/include/linux/raid/raid1.h	2001-08-12 13:39:02.000000000 -0600
+++ ../2420/linux/include/linux/raid/raid1.h	2004-09-21 09:18:03.000000000 -0600
@@ -18,6 +18,7 @@
 	int		spare;
 
 	int		used_slot;
+	atomic_t rr_count;
 };
 
 struct raid1_private_data {
@@ -59,6 +60,9 @@
 	md_wait_queue_head_t	wait_done;
 	md_wait_queue_head_t	wait_ready;
 	md_spinlock_t		segment_lock;
+	/* Use Read Recovery */
+	int use_read_recovery;
+	atomic_t rr_total;
 };
 
 typedef struct raid1_private_data raid1_conf_t;
@@ -86,6 +90,7 @@
 	struct buffer_head	*mirror_bh_list;
 	struct buffer_head	bh_req;
 	struct raid1_bh		*next_r1;	/* next for retry or in free list */
+	kdev_t 			failed_dev;
 };
 /* bits for raid1_bh.state */
 #define	R1BH_Uptodate	1
--- linux-2.4.26/drivers/md/raid1.c	2004-04-14 07:05:30.000000000 -0600
+++ ../2420/linux/drivers/md/raid1.c	2004-09-21 09:21:59.000000000 -0600
@@ -32,10 +32,19 @@
 #define MD_DRIVER
 #define MD_PERSONALITY
 
-#define MAX_WORK_PER_DISK 128
-
 #define	NR_RESERVED_BUFS	32
 
+unsigned MAX_WORK_PER_DISK = 128;
+MODULE_PARM(RAID1_MAX_WORK_PER_DISK, "i");
+MODULE_PARM_DESC(RAID1_MAX_WORK_PER_DISK, "The Maximum number of sectors given to any disk before we switch disks in read balance code");
+ 
+/*
+ * Enable Read Recovery code.  For more information see end_request_recovery()
+ */
+unsigned RAID1_READ_RECOVERY = 1;
+MODULE_PARM(RAID1_READ_RECOVERY, "i");
+MODULE_PARM_DESC(RAID1_READ_RECOVERY, "Use raid1 read recovery code");
+
 
 /*
  * The following can be used to debug the driver
@@ -165,6 +174,7 @@
 			r1_bh->next_r1 = NULL;
 			r1_bh->state = (1 << R1BH_PreAlloc);
 			r1_bh->bh_req.b_state = 0;
+			r1_bh->failed_dev = 0;
 		}
 		md_spin_unlock_irq(&conf->device_lock);
 		if (r1_bh)
@@ -262,6 +272,7 @@
 	r1_bh = conf->freebuf;
 	conf->freebuf = r1_bh->next_r1;
 	r1_bh->next_r1= NULL;
+	r1_bh->failed_dev = 0;
 	md_spin_unlock_irq(&conf->device_lock);
 
 	return r1_bh;
@@ -321,6 +332,33 @@
 	}
 }
 
+static int raid1_map_notsame(mddev_t *mddev, kdev_t *rdev)
+{
+	raid1_conf_t *conf = mddev_to_conf(mddev);
+	//kdev_t new_dev = *rdev;
+	int i, disks = MD_SB_DISKS;
+
+	/*
+	 * Later we do read balancing on the read side 
+	 * now we use the first available disk.
+	 */
+
+	for (i = 0; i < disks; i++) {
+		if (conf->mirrors[i].operational) {
+			/*
+			 * Pick a different device then the original
+			 */
+			if( conf->mirrors[i].dev != *rdev ){
+				*rdev = conf->mirrors[i].dev;
+				return (0);
+			}
+		}
+	}
+
+	return (-1);
+}
+
+#if 0
 static int raid1_map (mddev_t *mddev, kdev_t *rdev)
 {
 	raid1_conf_t *conf = mddev_to_conf(mddev);
@@ -341,6 +379,7 @@
 	printk (KERN_ERR "raid1_map(): huh, no more operational devices?\n");
 	return (-1);
 }
+#endif
 
 static void raid1_reschedule_retry (struct raid1_bh *r1_bh)
 {
@@ -403,6 +442,103 @@
 	bh->b_end_io(bh, uptodate);
 	raid1_free_r1bh(r1_bh);
 }
+
+/*
+ * incement the read recovery counter for the mddevice as well as on the individual disk.  
+ *  this information is output in raid1_status.  This allows us to print out the per disk error counts
+ *  so we can decide when the disk is likely to be going completely bad as opposed to having partial media/sector
+ *  errors.
+ */
+void raid1_mark_recovered( raid1_conf_t *conf , kdev_t rdev )
+{
+	int i, disks = MD_SB_DISKS;
+	atomic_inc( &conf->rr_total );
+	for (i = 0; i < disks; i++) {
+		if( conf->mirrors[i].dev == rdev ){
+			atomic_inc( &conf->mirrors[i].rr_count );
+			return ;
+		}
+	}
+}
+
+/*
+ * This is the completion callback for the correcting write operation.  If the write fails
+ * the disk is definetly bad.  Otherwise the write forced the disk drive to remap the bad sector
+ * to one of it's spares.  
+ *
+ * If we want to be paranoid, we can issue a read of the just written sector and compare it to the mirror
+ *  copy before we acknowledge the read. However impirical data has shown that if the write succeeds, the read will be correct.
+ *
+ */
+void raid1_end_request_recover_complete( struct buffer_head *bh, int uptodate )
+{
+	struct raid1_bh * r1_bh = (struct raid1_bh *)(bh->b_private);
+	raid1_conf_t *conf = mddev_to_conf(r1_bh->mddev);
+	
+	if( !uptodate )
+	{
+		printk(KERN_ERR "raid1: %s: recover failed lba=%lu\n",  partition_name(bh->b_dev), bh->b_blocknr);
+		md_error (r1_bh->mddev, r1_bh->failed_dev );
+		r1_bh->failed_dev = 0;
+	}
+	else
+	{
+		raid1_mark_recovered( conf,  r1_bh->failed_dev );
+		printk(KERN_INFO "raid1: %s: recover success lba=%lu\n",  partition_name(bh->b_dev), bh->b_blocknr);
+	}
+	/*
+	 *  We got here because the write recovery attempt failed us, however since we made it this far
+	 *  it means that the read WAS SUCESSFULL originally.
+	 */
+	r1_bh->cmd = READ;
+	raid1_end_bh_io(r1_bh, 1 );
+}
+
+/*
+ * This is the io completion callback for the read from the redundant mirror.  If the read is sucessfull we will issue
+ *  a write to the mirror that previsouly failed the read of this sector.  This should cause the drive to remap the bad
+ *  sector to a spare.
+ */
+void raid1_end_request_recover( struct buffer_head *bh, int uptodate )
+{
+	struct raid1_bh * r1_bh = (struct raid1_bh *)(bh->b_private);
+	if( !uptodate )
+	{
+		printk(KERN_ERR "raid1: %s: recovering lba=%lu failed.. double fault\n",  partition_name(bh->b_dev), bh->b_blocknr);
+		/*
+		 * We delayed the failure of this device earlier.  Now we had 2 failures in a row from different devices
+		 * thus we must fail the previos device to ensure we don;t do this forever.
+		 */
+		md_error (r1_bh->mddev, r1_bh->failed_dev);
+		r1_bh->failed_dev = bh->b_dev;
+		
+		/*
+		 * Now retry one more time.  We may have more valid devices/  If not raid1d READ/READA handler
+		 *   will tell us so.
+		 */
+		printk(KERN_INFO "raid1: %s: rescheduling lba=%lu again (have more devices?)\n", 
+			 partition_name(bh->b_dev), bh->b_blocknr);
+		raid1_reschedule_retry(r1_bh);
+		return;
+	}
+	else
+	{
+		/*
+		 * FIXME: this whole thing only recovers 1 raid mirror.  To do this 100% correctly we need to keep a list of prefail devices
+		 *        since a 3 way mirror will drop 1 device before rebuilding 
+		 */
+		printk(KERN_INFO "raid1: %s: recovering block lba=%lu read ok.. do write\n",  partition_name(bh->b_dev), bh->b_blocknr);
+		//
+		// We need to map in the recovery device
+		//
+		r1_bh->cmd   = WRITE;
+		bh->b_end_io = raid1_end_request_recover_complete;
+		bh->b_dev    = r1_bh->failed_dev;
+		bh->b_rdev   = r1_bh->failed_dev;
+		raid1_reschedule_retry(r1_bh);
+	}
+}
+
 void raid1_end_request (struct buffer_head *bh, int uptodate)
 {
 	struct raid1_bh * r1_bh = (struct raid1_bh *)(bh->b_private);
@@ -410,8 +546,27 @@
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
 	 */
-	if (!uptodate)
+	if (!uptodate){
+		raid1_conf_t *conf = mddev_to_conf(r1_bh->mddev);
+		
+		if ( ( conf->use_read_recovery == 1 ) && ( (r1_bh->cmd == READ) || (r1_bh->cmd == READA) ) ) 
+		{
+			/*
+			 * Remap the end io for this device since we are going to try recovery
+			 * DO NOT change the mddev.. we need the original failing MDDEV
+			 */
+			printk(KERN_INFO "raid1: %s: read recovery will be attempted on lba=%lu from another mirror\n", 
+			partition_name(bh->b_dev), bh->b_blocknr);
+
+			bh->b_end_io = raid1_end_request_recover;
+			r1_bh->failed_dev = bh->b_dev;
+		}
+		else
+		{
 		md_error (r1_bh->mddev, bh->b_dev);
+		}
+		
+	}
 	else
 		/*
 		 * Set R1BH_Uptodate in our master buffer_head, so that
@@ -441,7 +596,7 @@
 		/*
 		 * oops, read error:
 		 */
-		printk(KERN_ERR "raid1: %s: rescheduling block %lu\n", 
+		printk(KERN_ERR "raid1: %s: rescheduling lba=%lu\n", 
 			 partition_name(bh->b_dev), bh->b_blocknr);
 		raid1_reschedule_retry(r1_bh);
 		return;
@@ -480,10 +635,11 @@
 	unsigned long current_distance;
 	
 	/*
-	 * Check if it is sane at all to balance
+	 * Check if it is sane at all to balance.
+	 * make sure the last used drive is operational (it may have been removed).
 	 */
 	
-	if (conf->resync_mirrors)
+	if (conf->resync_mirrors && conf->mirrors[new_disk].operational)
 		goto rb_out;
 	
 
@@ -737,10 +893,17 @@
 	
 	seq_printf(seq, " [%d/%d] [", conf->raid_disks,
 						 conf->working_disks);
+						 
 	for (i = 0; i < conf->raid_disks; i++)
 		seq_printf(seq, "%s",
 			conf->mirrors[i].operational ? "U" : "_");
 	seq_printf(seq, "]");
+	
+	seq_printf(seq, " ( ");
+	for (i = 0; i < conf->raid_disks; i++){
+		seq_printf(seq,"%d ",atomic_read( &conf->mirrors[i].rr_count ) );
+	}
+	seq_printf(seq, ")");
 }
 
 #define LAST_DISK KERN_ALERT \
@@ -783,6 +946,7 @@
 
 static int raid1_error (mddev_t *mddev, kdev_t dev)
 {
+	mdk_rdev_t *rrdev = NULL;
 	raid1_conf_t *conf = mddev_to_conf(mddev);
 	struct mirror_info * mirrors = conf->mirrors;
 	int disks = MD_SB_DISKS;
@@ -808,6 +972,16 @@
 
 		return 1;
 	}
+	
+	rrdev = find_rdev( mddev, dev );
+	if( rrdev )
+	{
+		rrdev->faulty = 1;
+	}
+	else
+	{
+		printk("raid1: rrdev == NULL in raid1_error\n");
+	}
 	mark_disk_bad(mddev, i);
 	return 0;
 }
@@ -963,6 +1137,7 @@
 			tmp = conf->mirrors + i;
 			if (!tmp->used_slot) {
 				added_disk = i;
+				atomic_set(&tmp->rr_count,0);
 				break;
 			}
 		}
@@ -1129,7 +1304,7 @@
 		conf->nr_disks++;
 
 		break;
-
+		
 	default:
 		MD_BUG();	
 		err = 1;
@@ -1266,12 +1441,26 @@
 			}
 
 			break;
+		
+		case WRITE:
+			/*
+			 * We do not map the dev.  It SHOULD be already mapped for us
+			 */
+			printk ("raid1: %s: read-error recovery lba=%lu  (writing recovered lba)\n",partition_name(bh->b_dev),bh->b_blocknr);
+			generic_make_request (r1_bh->cmd, bh);
+			break;
+			
 		case READ:
 		case READA:
 			dev = bh->b_dev;
-			raid1_map (mddev, &bh->b_dev);
+			raid1_map_notsame(mddev, &bh->b_dev);
 			if (bh->b_dev == dev) {
 				printk (IO_ERROR, partition_name(bh->b_dev), bh->b_blocknr);
+		/*		if( r1_bh->failed_dev )
+				{
+					md_error (r1_bh->mddev, r1_bh->failed_dev);
+					r1_bh->failed_dev = 0;
+				}*/
 				raid1_end_bh_io(r1_bh, 0);
 			} else {
 				printk (REDIRECT_SECTOR,
@@ -1596,6 +1785,8 @@
 		disk_idx = descriptor->raid_disk;
 		disk = conf->mirrors + disk_idx;
 
+		atomic_set(&disk->rr_count, 0 );
+		
 		if (disk_faulty(descriptor)) {
 			disk->number = descriptor->number;
 			disk->raid_disk = disk_idx;
@@ -1761,6 +1952,8 @@
 		}
 	}
 	sb->active_disks = conf->working_disks;
+	/* Set the read recovery flag to the default value */
+	conf->use_read_recovery = RAID1_READ_RECOVERY;
 
 	if (start_recovery)
 		md_recover_arrays();
@@ -1859,6 +2052,9 @@
 
 static int md__init raid1_init (void)
 {
+	if( RAID1_READ_RECOVERY ){
+		printk("raid1: Read Recovery Enabled\n");
+	}
 	return register_md_personality (RAID1, &raid1_personality);
 }
 

--------------020600030805010008060402--
