From: =?iso-8859-1?q?Mark=20ZZZ=20Smith?= <markzzzsmith@yahoo.com.au>
Subject: [2.4.21] Small patch to quieten md.c boot messages
Date: Fri, 1 Aug 2003 15:38:19 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030801053819.71667.qmail@web21310.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0-597628777-1059716299=:71205"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: mingo@redhat.com, neilb@cse.unsw.edu.au
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--0-597628777-1059716299=:71205
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Id: 
Content-Disposition: inline

Hi Ingo, Neil,

I have a Linux software RAID1 array with twelve separate /dev/md* devices.

I've found all the "md:" messages upon boot fill up my kernel message buffer, to the point where
I've had to increase the size of the buffer to be able to see earlier hardware config messages
eg., for the PCI subsystem.

Looking at the boot messages, I've gone through md.c and changed a number of them to KERN_DEBUG,
and dprintk. I've selected messages that either don't mean anything to me as a normal RAID1 user,
or messages that I personally don't think add much value when the system is booting.

I've attached the patch to this email.

Alternatively, the patch can be downloaded from here :

http://members.ozemail.com.au/~markzzzsmith/quieten-md.c.diff

Please consider applying it.

BTW, a big *THANKS* for the Linux software RAID implementation. I've been very happy with it since
I started using it, almost 12 months ago.

Regards,
Mark.

=====
--
Mark ZZZ Smith
"Absolute security is a fallacy."

http://personals.yahoo.com.au - Yahoo! Personals
-  New people, new possibilities! Try Yahoo! Personals, FREE for a limited period!
--0-597628777-1059716299=:71205
Content-Type: text/plain; name="quieten-md.c.diff"
Content-Description: quieten-md.c.diff
Content-Disposition: inline; filename="quieten-md.c.diff"

--- linux-2.4.21.pure/drivers/md/md.c	Sun Jun 15 14:31:39 2003
+++ linux-2.4.21.mrs/drivers/md/md.c	Fri Aug  1 14:30:17 2003
@@ -524,7 +524,7 @@
 		printk(NO_SB,partition_name(dev));
 		return -EINVAL;
 	}
-	printk(KERN_INFO " [events: %08lx]\n", (unsigned long)rdev->sb->events_lo);
+	dprintk(KERN_DEBUG " [events: %08lx]\n", (unsigned long)rdev->sb->events_lo);
 	ret = 0;
 abort:
 	return ret;
@@ -633,7 +633,7 @@
 	md_list_add(&rdev->same_set, &mddev->disks);
 	rdev->mddev = mddev;
 	mddev->nb_dev++;
-	printk(KERN_INFO "md: bind<%s,%d>\n", partition_name(rdev->dev), mddev->nb_dev);
+	dprintk(KERN_DEBUG "md: bind<%s,%d>\n", partition_name(rdev->dev), mddev->nb_dev);
 }
 
 static void unbind_rdev_from_array(mdk_rdev_t * rdev)
@@ -949,7 +949,7 @@
 		goto skip;
 	}
 
-	printk(KERN_INFO "(write) %s's sb offset: %ld\n", partition_name(dev), sb_offset);
+	dprintk(KERN_DEBUG "(write) %s's sb offset: %ld\n", partition_name(dev), sb_offset);
 
 	if (!sync_page_io(dev, sb_offset<<1, MD_SB_BYTES, rdev->sb_page, WRITE)) {
 		printk("md: write_disk_sb failed for device %s\n", partition_name(dev));
@@ -1038,28 +1038,28 @@
 	if (mddev->sb->not_persistent)
 		return 0;
 
-	printk(KERN_INFO "md: updating md%d RAID superblock on device\n",
+	dprintk(KERN_DEBUG "md: updating md%d RAID superblock on device\n",
 					mdidx(mddev));
 
 	err = 0;
 	ITERATE_RDEV(mddev,rdev,tmp) {
-		printk(KERN_INFO "md: ");
+		dprintk(KERN_DEBUG "md: ");
 		if (rdev->faulty)
-			printk("(skipping faulty ");
+			dprintk("(skipping faulty ");
 		if (rdev->alias_device)
-			printk("(skipping alias ");
+			dprintk("(skipping alias ");
 		if (!rdev->faulty && disk_faulty(&rdev->sb->this_disk)) {
-			printk("(skipping new-faulty %s )\n",
+			dprintk("(skipping new-faulty %s )\n",
 			       partition_name(rdev->dev));
 			continue;
 		}
-		printk("%s ", partition_name(rdev->dev));
+		dprintk("%s ", partition_name(rdev->dev));
 		if (!rdev->faulty && !rdev->alias_device) {
-			printk("[events: %08lx]",
+			dprintk("[events: %08lx]\n",
 				(unsigned long)rdev->sb->events_lo);
 			err += write_disk_sb(rdev);
 		} else
-			printk(")\n");
+			dprintk(")\n");
 	}
 	if (err) {
 		if (--count) {
@@ -1246,7 +1246,7 @@
 					rdev->sb->events_hi--;
 		}
 
-		printk(KERN_INFO "md: %s's event counter: %08lx\n",
+		dprintk(KERN_DEBUG "md: %s's event counter: %08lx\n",
 		       partition_name(rdev->dev),
 			(unsigned long)rdev->sb->events_lo);
 		if (!freshest) {
@@ -1600,10 +1600,10 @@
 	}
 	md_maxreadahead[mdidx(mddev)] = readahead;
 
-	printk(KERN_INFO "md%d: max total readahead window set to %ldk\n",
+	dprintk(KERN_DEBUG "md%d: max total readahead window set to %ldk\n",
 		mdidx(mddev), readahead*(PAGE_SIZE/1024));
 
-	printk(KERN_INFO
+	dprintk(KERN_DEBUG
 		"md%d: %d data-disks, max readahead per data-disk: %ldk\n",
 			mdidx(mddev), data_disks, readahead/data_disks*(PAGE_SIZE/1024));
 	return 0;
@@ -1685,7 +1685,7 @@
 		}
 	} else
 		if (chunk_size)
-			printk(KERN_INFO "md: RAID level %d does not need chunksize! Continuing anyway.\n",
+			dprintk(KERN_DEBUG "md: RAID level %d does not need chunksize! Continuing anyway.\n",
 			       mddev->sb->level);
 
 	if (pnum >= MAX_PERSONALITY) {
@@ -2943,9 +2943,9 @@
 		add_wait_queue(&thread->wqueue, &wait);
 		set_task_state(current, TASK_INTERRUPTIBLE);
 		if (!test_bit(THREAD_WAKEUP, &thread->flags)) {
-			dprintk("md: thread %p went to sleep.\n", thread);
+			dprintk(KERN_DEBUG "md: thread %p went to sleep.\n", thread);
 			schedule();
-			dprintk("md: thread %p woke up.\n", thread);
+			dprintk(KERN_DEBUG "md: thread %p woke up.\n", thread);
 		}
 		current->state = TASK_RUNNING;
 		remove_wait_queue(&thread->wqueue, &wait);
@@ -2965,7 +2965,7 @@
 
 void md_wakeup_thread(mdk_thread_t *thread)
 {
-	dprintk("md: waking up MD thread %p.\n", thread);
+	dprintk(KERN_DEBUG "md: waking up MD thread %p.\n", thread);
 	set_bit(THREAD_WAKEUP, &thread->flags);
 	wake_up(&thread->wqueue);
 }
@@ -3005,7 +3005,7 @@
 		MD_BUG();
 		return;
 	}
-	dprintk("interrupting MD-thread pid %d\n", thread->tsk->pid);
+	dprintk(KERN_DEBUG "interrupting MD-thread pid %d\n", thread->tsk->pid);
 	send_sig(SIGKILL, thread->tsk, 1);
 }
 
@@ -3037,7 +3037,7 @@
 {
 	mdk_rdev_t * rrdev;
 
-	dprintk("md_error dev:(%d:%d), rdev:(%d:%d), (caller: %p,%p,%p,%p).\n",
+	dprintk(KERN_DEBUG "md_error dev:(%d:%d), rdev:(%d:%d), (caller: %p,%p,%p,%p).\n",
 		MAJOR(dev),MINOR(dev),MAJOR(rdev),MINOR(rdev),
 		__builtin_return_address(0),__builtin_return_address(1),
 		__builtin_return_address(2),__builtin_return_address(3));
@@ -3448,9 +3448,9 @@
 	max_sectors = mddev->sb->size<<1;
 
 	printk(KERN_INFO "md: syncing RAID array md%d\n", mdidx(mddev));
-	printk(KERN_INFO "md: minimum _guaranteed_ reconstruction speed: %d KB/sec/disc.\n",
+	dprintk(KERN_DEBUG "md: minimum _guaranteed_ reconstruction speed: %d KB/sec/disc.\n",
 						sysctl_speed_limit_min);
-	printk(KERN_INFO "md: using maximum available idle IO bandwith "
+	dprintk(KERN_DEBUG "md: using maximum available idle IO bandwith "
 	       "(but not more than %d KB/sec) for reconstruction.\n",
 	       sysctl_speed_limit_max);
 
@@ -3472,7 +3472,7 @@
 	 * Tune reconstruction:
 	 */
 	window = vm_max_readahead*(PAGE_SIZE/512);
-	printk(KERN_INFO "md: using %dk window, over a total of %d blocks.\n",
+	dprintk(KERN_DEBUG "md: using %dk window, over a total of %d blocks.\n",
 	       window/2,max_sectors/2);
 
 	atomic_set(&mddev->recovery_active, 0);
@@ -3705,7 +3705,7 @@
 	max_readahead[MAJOR_NR] = md_maxreadahead;
 	hardsect_size[MAJOR_NR] = md_hardsect_sizes;
 
-	dprintk("md: sizeof(mdp_super_t) = %d\n", (int)sizeof(mdp_super_t));
+	dprintk(KERN_DEBUG "md: sizeof(mdp_super_t) = %d\n", (int)sizeof(mdp_super_t));
 
 #ifdef CONFIG_PROC_FS
 	p = create_proc_entry("mdstat", S_IRUGO, NULL);

--0-597628777-1059716299=:71205--
