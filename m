From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: [PATCH] raid superblock sanity checking (validate_sb)
Date: Mon, 12 Aug 2002 07:52:20 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A664702CD66E4@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Troy Benjegerdes' <hozer@drgw.net>, linux-raid@vger.kernel.org, 'Neil Brown' <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids


I've written a patch to help this problem.  I guess now is a good time to
submit it to the group for comments.  The patch is against kernel 2.4.18,
but should be useful going forward as well.  It uses a common validation
subroutine when the superblock gets changed, before it is written.  I've
been using it for a while now with a raid1 root mirror doing various nasty
tests and haven't had any more problems.  There could be some additional
tuning to the validation logic though.

Neil, 

You've seen a lot of these type problems corrected with mdadm.  Does this
cover most of the cases?

Andy Cress

-----Original Message-----
From: Troy Benjegerdes [mailto:hozer@drgw.net] 
Sent: Sunday, August 11, 2002 3:18 AM
Subject: on-disk superblock sanity checking

I have recently run into a case where a kernel bug appears to have written 
a bogus value into the raid superblock structure (in particular, 
sb->disks[26].raid_disk was 0xd7e56000).

[...]

'mkraid --force /dev/md0' appears to have cleaned up the panic on boot 
problem.. but I wonder if it wouldn't be a good idea to have some 
additional sanity checking? 

-------PATCH----------
--- linux-2.4.18-orig/drivers/md/md.c	Mon Feb 25 14:37:58 2002
+++ linux-2.4.18/drivers/md/md.c	Thu May 16 13:02:35 2002
@@ -393,6 +393,54 @@
 	return 1;
 }
 
+static unsigned int calc_sb_csum(mdp_super_t * sb);
+ 
+int validate_sb(mdp_super_t *sb, int op)
+{
+   int changed = 0;
+#ifdef TEST
+   printk("md%d:validate_sb(%d_x): working=%d spare=%d failed=%d
nr_disks=%d\n",            sb->md_minor, op, sb->working_disks,
sb->spare_disks,
+            sb->failed_disks, sb->nr_disks);
+#endif
+   /* check for some observed invalid values in the superblock */
+   if ((int)(sb->failed_disks) < 0) { /* saw -1, invalid */
+        sb->failed_disks = 0;
+        changed = 1;
+   }
+   if ((int)(sb->nr_disks) <= 0) {    /* saw 0, invalid */
+        sb->nr_disks = sb->working_disks; /* or raid_disks */
+        changed = 1;
+   }
+   if ((int)sb->working_disks > (int)sb->nr_disks) {
+        sb->working_disks = sb->nr_disks;
+        changed = 1;
+   }
+   if ((int)sb->active_disks > (int)sb->nr_disks) {
+        sb->active_disks = sb->working_disks;
+        changed = 1;
+   }
+   /* Also need to check spare_disks (can increment too high). */
+   if ((int)sb->spare_disks > (int)sb->nr_disks) {
+        sb->spare_disks = sb->nr_disks - sb->active_disks;
+        changed = 1;
+   }
+#ifdef TEST
+   /* Total nr_disks should >= raid_disks */
+   if ((int)sb->raid_disks > (int)sb->nr_disks) {
+        sb->nr_disks = sb->raid_disks;
+        changed = 1;
+   }
+#endif  
+   if (changed) {
+     printk("md%d:validate_sb(%d): working=%d spare=%d failed=%d
nr_disks=%d\n",            sb->md_minor, op, sb->working_disks,
sb->spare_disks,
+            sb->failed_disks, sb->nr_disks);
+     /* recalculate the checksum */
+     sb->sb_csum = calc_sb_csum(sb);
+   }
+   /* The sb should be ok to write now */
+   return 0;
+}
+
 static void remove_descriptor(mdp_disk_t *disk, mdp_super_t *sb)
 {
 	if (disk_active(disk)) {
@@ -406,6 +454,7 @@
 		}
 	}
 	sb->nr_disks--;
+	validate_sb(sb,1);
 	disk->major = 0;
 	disk->minor = 0;
 	mark_disk_removed(disk);
@@ -1028,6 +1077,7 @@
 	if (mddev->sb->not_persistent)
 		return 0;
 
+	validate_sb(mddev->sb,9);
 	printk(KERN_INFO "md: updating md%d RAID superblock on device\n",
 					mdidx(mddev));
 
@@ -1489,6 +1539,7 @@
 		}
 	}
 
+	validate_sb(sb,10);
 	/*
 	 * Check if we can support this RAID array
 	 */
@@ -2023,7 +2074,7 @@
 	mdp_super_t *sb = NULL;
 	mdk_rdev_t *start_rdev = NULL, *rdev;
 
-	if (md_import_device(startdev, 1)) {
+	if ((err=md_import_device(startdev, 1))) {
 		printk(KERN_WARNING "md: could not import %s!\n",
partition_name(startdev));
 		goto abort;
 	}
@@ -2518,6 +2569,7 @@
 	SET_SB(chunk_size);
 
 	mddev->sb->md_magic = MD_SB_MAGIC;
+	validate_sb(mddev->sb,8);
 
 	/*
 	 * Generate a 128 bit UUID
@@ -3554,6 +3606,7 @@
 				sb->spare_disks--;
 				sb->working_disks--;
 				sb->failed_disks++;
+				validate_sb(sb,2);
 			}
 		} else
 			if (disk_faulty(spare))
@@ -3583,6 +3636,7 @@
 			mark_disk_active(spare);
 			sb->active_disks++;
 			sb->spare_disks--;
+			validate_sb(sb,3);
 		}
 		mddev->sb_dirty = 1;
 		md_update_sb(mddev);
@@ -3929,6 +3983,7 @@
 				mddev->sb->active_disks++;
 				mddev->sb->working_disks++;
 				err = add_new_disk (mddev, &dinfo);
+				validate_sb(mddev->sb,4);
 			}
 		} else {
 			/* persistent */
@@ -3941,8 +3996,10 @@
 		if (!err)
 			err = do_md_run(mddev);
 		if (err) {
-			mddev->sb_dirty = 0;
-			do_md_stop(mddev, 0);
+                       if (mddev != NULL) {
+			   mddev->sb_dirty = 0;
+			   do_md_stop(mddev, 0);
+			}
 			printk(KERN_WARNING "md: starting md%d failed\n",
minor);
 		}
 	}
@@ -4047,4 +4104,5 @@
 MD_EXPORT_SYMBOL(mddev_map);
 MD_EXPORT_SYMBOL(md_check_ordering);
 MD_EXPORT_SYMBOL(get_spare);
+MD_EXPORT_SYMBOL(validate_sb);
 MODULE_LICENSE("GPL");
--- linux-2.4.18-orig/drivers/md/raid1.c	Mon Feb 25 14:37:58 2002
+++ linux-2.4.18/drivers/md/raid1.c	Thu May 16 13:02:35 2002
@@ -731,6 +731,8 @@
 #define ALREADY_SYNCING KERN_INFO \
 "raid1: syncing already in progress.\n"
 
+extern int validate_sb(mdp_super_t *sb, int op);
+
 static void mark_disk_bad (mddev_t *mddev, int failed)
 {
 	raid1_conf_t *conf = mddev_to_conf(mddev);
@@ -745,6 +747,8 @@
 		sb->active_disks--;
 	sb->working_disks--;
 	sb->failed_disks++;
+
+	validate_sb(sb,6);
 	mddev->sb_dirty = 1;
 	md_wakeup_thread(conf->thread);
 	if (!mirror->write_only)
@@ -1091,6 +1095,7 @@
 		err = 1;
 		goto abort;
 	}
+	validate_sb(sb,7);
 abort:
 	md_spin_unlock_irq(&conf->device_lock);
 	if (state == DISKOP_SPARE_ACTIVE || state == DISKOP_SPARE_INACTIVE)
