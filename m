From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [2.4.21] Small patch to quieten md.c boot messages
Date: Tue, 5 Aug 2003 14:39:21 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16175.13561.631283.796341@gargle.gargle.HOWL>
References: <20030801053819.71667.qmail@web21310.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mark ZZZ Smith on Friday August 1
To: =?iso-8859-1?q?Mark=20ZZZ=20Smith?= <markzzzsmith@yahoo.com.au>
Cc: mingo@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday August 1, markzzzsmith@yahoo.com.au wrote:
> Hi Ingo, Neil,
> 
> I have a Linux software RAID1 array with twelve separate /dev/md* devices.
> 
> I've found all the "md:" messages upon boot fill up my kernel message buffer, to the point where
> I've had to increase the size of the buffer to be able to see earlier hardware config messages
> eg., for the PCI subsystem.
> 
> Looking at the boot messages, I've gone through md.c and changed a number of them to KERN_DEBUG,
> and dprintk. I've selected messages that either don't mean anything to me as a normal RAID1 user,
> or messages that I personally don't think add much value when the system is booting.
> 
> I've attached the patch to this email.

I am dis-inclined to change things to dprintk as they can then not be
turned on without recompiling the kernel, but I am happy to reduce
several KERN_INFO to KERN_DEBUG, thereby removing them from the
console messages, but leaving them in the logs.

The following patch will probably be submitted for early 2.4.23-pre

Thanks
NeilBrown

=================================================
Reduce level of some md message from KERN_INFO to KERN_DEBUG

md tends to be very noisy when assembling arrays.
This patch reduces a lot of messages to KERN_DEBUG so they are
still in the logs, but not on the console


 ----------- Diffstat output ------------
 ./drivers/md/md.c |   63 +++++++++++++++++++++++++-----------------------------
 1 files changed, 30 insertions(+), 33 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-08-04 09:25:10.000000000 +1000
+++ ./drivers/md/md.c	2003-08-05 14:34:50.000000000 +1000
@@ -524,7 +524,7 @@ static int read_disk_sb(mdk_rdev_t * rde
 		printk(NO_SB,partition_name(dev));
 		return -EINVAL;
 	}
-	printk(KERN_INFO " [events: %08lx]\n", (unsigned long)rdev->sb->events_lo);
+	printk(KERN_DEBUG " [events: %08lx]\n", (unsigned long)rdev->sb->events_lo);
 	ret = 0;
 abort:
 	return ret;
@@ -633,7 +633,7 @@ static void bind_rdev_to_array(mdk_rdev_
 	md_list_add(&rdev->same_set, &mddev->disks);
 	rdev->mddev = mddev;
 	mddev->nb_dev++;
-	printk(KERN_INFO "md: bind<%s,%d>\n", partition_name(rdev->dev), mddev->nb_dev);
+	printk(KERN_DEBUG "md: bind<%s,%d>\n", partition_name(rdev->dev), mddev->nb_dev);
 }
 
 static void unbind_rdev_from_array(mdk_rdev_t * rdev)
@@ -645,7 +645,7 @@ static void unbind_rdev_from_array(mdk_r
 	md_list_del(&rdev->same_set);
 	MD_INIT_LIST_HEAD(&rdev->same_set);
 	rdev->mddev->nb_dev--;
-	printk(KERN_INFO "md: unbind<%s,%d>\n", partition_name(rdev->dev),
+	printk(KERN_DEBUG "md: unbind<%s,%d>\n", partition_name(rdev->dev),
 						 rdev->mddev->nb_dev);
 	rdev->mddev = NULL;
 }
@@ -684,7 +684,7 @@ void md_autodetect_dev(kdev_t dev);
 
 static void export_rdev(mdk_rdev_t * rdev)
 {
-	printk(KERN_INFO "md: export_rdev(%s)\n",partition_name(rdev->dev));
+	printk(KERN_DEBUG "md: export_rdev(%s)\n",partition_name(rdev->dev));
 	if (rdev->mddev)
 		MD_BUG();
 	unlock_rdev(rdev);
@@ -776,44 +776,44 @@ static void print_sb(mdp_super_t *sb)
 {
 	int i;
 
-	printk(KERN_INFO "md:  SB: (V:%d.%d.%d) ID:<%08x.%08x.%08x.%08x> CT:%08x\n",
+	printk(KERN_DEBUG "md:  SB: (V:%d.%d.%d) ID:<%08x.%08x.%08x.%08x> CT:%08x\n",
 		sb->major_version, sb->minor_version, sb->patch_version,
 		sb->set_uuid0, sb->set_uuid1, sb->set_uuid2, sb->set_uuid3,
 		sb->ctime);
-	printk(KERN_INFO "md:     L%d S%08d ND:%d RD:%d md%d LO:%d CS:%d\n", sb->level,
+	printk(KERN_DEBUG "md:     L%d S%08d ND:%d RD:%d md%d LO:%d CS:%d\n", sb->level,
 		sb->size, sb->nr_disks, sb->raid_disks, sb->md_minor,
 		sb->layout, sb->chunk_size);
-	printk(KERN_INFO "md:     UT:%08x ST:%d AD:%d WD:%d FD:%d SD:%d CSUM:%08x E:%08lx\n",
+	printk(KERN_DEBUG "md:     UT:%08x ST:%d AD:%d WD:%d FD:%d SD:%d CSUM:%08x E:%08lx\n",
 		sb->utime, sb->state, sb->active_disks, sb->working_disks,
 		sb->failed_disks, sb->spare_disks,
 		sb->sb_csum, (unsigned long)sb->events_lo);
 
-	printk(KERN_INFO);
+	printk(KERN_DEBUG);
 	for (i = 0; i < MD_SB_DISKS; i++) {
 		mdp_disk_t *desc;
 
 		desc = sb->disks + i;
 		if (desc->number || desc->major || desc->minor ||
 		    desc->raid_disk || (desc->state && (desc->state != 4))) {
-			printk("     D %2d: ", i);
+			printk(KERN_DEBUG "     D %2d: ", i);
 			print_desc(desc);
 		}
 	}
-	printk(KERN_INFO "md:     THIS: ");
+	printk(KERN_DEBUG "md:     THIS: ");
 	print_desc(&sb->this_disk);
 
 }
 
 static void print_rdev(mdk_rdev_t *rdev)
 {
-	printk(KERN_INFO "md: rdev %s: O:%s, SZ:%08ld F:%d DN:%d ",
+	printk(KERN_DEBUG "md: rdev %s: O:%s, SZ:%08ld F:%d DN:%d ",
 		partition_name(rdev->dev), partition_name(rdev->old_dev),
 		rdev->size, rdev->faulty, rdev->desc_nr);
 	if (rdev->sb) {
-		printk(KERN_INFO "md: rdev superblock:\n");
+		printk(KERN_DEBUG "md: rdev superblock:\n");
 		print_sb(rdev->sb);
 	} else
-		printk(KERN_INFO "md: no rdev superblock!\n");
+		printk(KERN_DEBUG "md: no rdev superblock!\n");
 }
 
 void md_print_devices(void)
@@ -949,7 +949,7 @@ static int write_disk_sb(mdk_rdev_t * rd
 		goto skip;
 	}
 
-	printk(KERN_INFO "(write) %s's sb offset: %ld\n", partition_name(dev), sb_offset);
+	printk(KERN_DEBUG "(write) %s's sb offset: %ld\n", partition_name(dev), sb_offset);
 
 	if (!sync_page_io(dev, sb_offset<<1, MD_SB_BYTES, rdev->sb_page, WRITE)) {
 		printk("md: write_disk_sb failed for device %s\n", partition_name(dev));
@@ -1043,7 +1043,7 @@ repeat:
 
 	err = 0;
 	ITERATE_RDEV(mddev,rdev,tmp) {
-		printk(KERN_INFO "md: ");
+		printk(KERN_DEBUG "md: ");
 		if (rdev->faulty)
 			printk("(skipping faulty ");
 		if (rdev->alias_device)
@@ -1246,7 +1246,7 @@ static int analyze_sbs(mddev_t * mddev)
 					rdev->sb->events_hi--;
 		}
 
-		printk(KERN_INFO "md: %s's event counter: %08lx\n",
+		printk(KERN_DEBUG "md: %s's event counter: %08lx\n",
 		       partition_name(rdev->dev),
 			(unsigned long)rdev->sb->events_lo);
 		if (!freshest) {
@@ -1600,10 +1600,10 @@ static int device_size_calculation(mddev
 	}
 	md_maxreadahead[mdidx(mddev)] = readahead;
 
-	printk(KERN_INFO "md%d: max total readahead window set to %ldk\n",
+	printk(KERN_DEBUG "md%d: max total readahead window set to %ldk\n",
 		mdidx(mddev), readahead*(PAGE_SIZE/1024));
 
-	printk(KERN_INFO
+	printk(KERN_DEBUG
 		"md%d: %d data-disks, max readahead per data-disk: %ldk\n",
 			mdidx(mddev), data_disks, readahead/data_disks*(PAGE_SIZE/1024));
 	return 0;
@@ -1683,10 +1683,7 @@ static int do_md_run(mddev_t * mddev)
 			printk(TOO_SMALL_CHUNKSIZE, chunk_size, PAGE_SIZE);
 			return -EINVAL;
 		}
-	} else
-		if (chunk_size)
-			printk(KERN_INFO "md: RAID level %d does not need chunksize! Continuing anyway.\n",
-			       mddev->sb->level);
+	}
 
 	if (pnum >= MAX_PERSONALITY) {
 		MD_BUG();
@@ -1907,7 +1904,7 @@ static void autorun_array(mddev_t *mddev
 		return;
 	}
 
-	printk(KERN_INFO "md: running: ");
+	printk(KERN_DEBUG "md: running: ");
 
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		printk("<%s>", partition_name(rdev->dev));
@@ -1951,7 +1948,7 @@ static void autorun_devices(kdev_t count
 		rdev0 = md_list_entry(pending_raid_disks.next,
 					 mdk_rdev_t, pending);
 
-		printk(KERN_INFO "md: considering %s ...\n", partition_name(rdev0->dev));
+		printk(KERN_DEBUG "md: considering %s ...\n", partition_name(rdev0->dev));
 		MD_INIT_LIST_HEAD(&candidates);
 		ITERATE_RDEV_PENDING(rdev,tmp) {
 			if (uuid_equal(rdev0, rdev)) {
@@ -1961,7 +1958,7 @@ static void autorun_devices(kdev_t count
 					       partition_name(rdev->dev), partition_name(rdev0->dev));
 					continue;
 				}
-				printk(KERN_INFO "md:  adding %s ...\n", partition_name(rdev->dev));
+				printk(KERN_DEBUG "md:  adding %s ...\n", partition_name(rdev->dev));
 				md_list_del(&rdev->pending);
 				md_list_add(&rdev->pending, &candidates);
 			}
@@ -2717,7 +2714,7 @@ static int md_ioctl(struct inode *inode,
 	}
 	err = lock_mddev(mddev);
 	if (err) {
-		printk(KERN_INFO "md: ioctl lock interrupted, reason %d, cmd %d\n",err, cmd);
+		printk(KERN_DEBUG "md: ioctl lock interrupted, reason %d, cmd %d\n",err, cmd);
 		goto abort;
 	}
 	/* if we don't have a superblock yet, only ADD_NEW_DISK or STOP_ARRAY is allowed */
@@ -3315,7 +3312,7 @@ int register_md_personality(int pnum, md
 	}
 
 	pers[pnum] = p;
-	printk(KERN_INFO "md: %s personality registered as nr %d\n", p->name, pnum);
+	printk(KERN_DEBUG "md: %s personality registered as nr %d\n", p->name, pnum);
 	return 0;
 }
 
@@ -3326,7 +3323,7 @@ int unregister_md_personality(int pnum)
 		return -EINVAL;
 	}
 
-	printk(KERN_INFO "md: %s personality unregistered\n", pers[pnum]->name);
+	printk(KERN_DEBUG "md: %s personality unregistered\n", pers[pnum]->name);
 	pers[pnum] = NULL;
 	return 0;
 }
@@ -3458,9 +3455,9 @@ recheck:
 	max_sectors = mddev->sb->size<<1;
 
 	printk(KERN_INFO "md: syncing RAID array md%d\n", mdidx(mddev));
-	printk(KERN_INFO "md: minimum _guaranteed_ reconstruction speed: %d KB/sec/disc.\n",
+	printk(KERN_DEBUG "md: minimum _guaranteed_ reconstruction speed: %d KB/sec/disc.\n",
 						sysctl_speed_limit_min);
-	printk(KERN_INFO "md: using maximum available idle IO bandwith "
+	printk(KERN_DEBUG "md: using maximum available idle IO bandwith "
 	       "(but not more than %d KB/sec) for reconstruction.\n",
 	       sysctl_speed_limit_max);
 
@@ -3482,7 +3479,7 @@ recheck:
 	 * Tune reconstruction:
 	 */
 	window = vm_max_readahead*(PAGE_SIZE/512);
-	printk(KERN_INFO "md: using %dk window, over a total of %d blocks.\n",
+	printk(KERN_DEBUG "md: using %dk window, over a total of %d blocks.\n",
 	       window/2,max_sectors/2);
 
 	atomic_set(&mddev->recovery_active, 0);
@@ -3588,7 +3585,7 @@ void md_do_recovery(void *data)
 	mdp_disk_t *spare;
 	struct md_list_head *tmp;
 
-	printk(KERN_INFO "md: recovery thread got woken up ...\n");
+	printk(KERN_DEBUG "md: recovery thread got woken up ...\n");
 restart:
 	ITERATE_MDDEV(mddev,tmp) {
 		sb = mddev->sb;
@@ -3665,7 +3662,7 @@ restart:
 		md_update_sb(mddev);
 		goto restart;
 	}
-	printk(KERN_INFO "md: recovery thread finished ...\n");
+	printk(KERN_DEBUG "md: recovery thread finished ...\n");
 
 }
 
