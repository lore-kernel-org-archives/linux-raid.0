From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Robust read patch for raid1
Date: Wed, 2 Feb 2005 00:41:47 +0100
Message-ID: <rmg5d2-e8b.ln1@news.it.uc3m.es>
References: <inptc2-f5r.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer <ptb@lab.it.uc3m.es> wrote:
> Allow me to remind what the patch does: it allows raid1 to proceed
> smoothly after a read error on a mirror component, without faulting the
> component.  If the information is on another component, it will be
> returned.  If all components are faulty, an error will be returned, but
> nothing faulted out of the array.

I'll add the patch for the 2.4.x kernels, while I still have it around.
See below.

>    ftp://oboe.it.uc3m.es/pub/Programs/fr1-2.16.tgz
> 
> The tests I have run on 2.4 are this paltry few:
> 
>    1) confirm that normal operation is well, normal, incuding rsyncs
>    2) confirm that a read error in a block on one mirror component
>       is recovered via a read from a different component.
> 
> I haven't tested what happens when all the components have a read error
> in the same block. It was hard enough to do (2).

Actually, I realise I might have managed to do that test by accident:
before I found out that the unaltered "raid1_map" function did not
change the target disk to the next disk, but instead to the 0th disk
always.  When I had set an error on the 0th disk, it retargeted to
itself again, errored again, and returned an error to the top level, but
didn't fault the disk because I'd trapped for that.  That's how I
first learned I had to change the raid1_map function!

--- linux-2.4.24-uml/raid1.c.post-fr1-2.14b,post-read-balance,pre-robust-read	Tue Aug 31 20:22:49 2004
+++ linux-2.4.24-uml/raid1.c	Sun Jan 30 00:29:58 2005
@@ -351,12 +363,37 @@
 {
 	raid1_conf_t *conf = mddev_to_conf(mddev);
 	int i, disks = MD_SB_DISKS;
+#ifdef CONFIG_MD_RAID1_ROBUST_READ
+        kdev_t dev = *rdev;
+#endif /* CONFIG_MD_RAID1_READ_WRITE_CORRECT */
 
 	/*
 	 * Later we do read balancing on the read side 
 	 * now we use the first available disk.
 	 */
 
+#ifdef CONFIG_MD_RAID1_ROBUST_READ
+        /*
+         * Uh, no. Choose the next disk if we can, not the first.
+         */
+	for (i = 0; i < conf->raid_disks; i++) {
+		if (conf->mirrors[i].dev == dev)
+                    	break;
+        }
+        i++;
+	if (i >= conf->raid_disks)
+		i = 0;
+	for (; i < conf->raid_disks; i++) {
+		if (conf->mirrors[i].operational) {
+			*rdev = conf->mirrors[i].dev;
+			return (0);
+		}
+        }
+        /*
+         * If for some reason we fund nothing, dropthru and use the old
+         * routine.
+         */
+#endif /* CONFIG_MD_RAID1_READ_WRITE_CORRECT */
 	for (i = 0; i < disks; i++) {
 		if (conf->mirrors[i].operational) {
 			*rdev = conf->mirrors[i].dev;
@@ -480,9 +527,27 @@
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
 	 */
-	if (!uptodate)
-		md_error (r1_bh->mddev, bh->b_dev);
-	else
+	if (!uptodate) {
+#ifdef CONFIG_MD_RAID1_ROBUST_READ
+		/*
+		 * Only fault disk out of array on write error, not read.
+		 */
+                if (r1_bh->cmd == WRITE)
+                       	if (printk(KERN_ALERT
+                          "raid1: erroring bh WRITE for sector %ld\n",
+                                  bh->b_rsector), 1)
+#endif /* CONFIG_MD_RAID1_ROBUST_READ */
+			md_error (r1_bh->mddev, bh->b_dev);
+#ifdef CONFIG_MD_RAID1_READ_WRITE_CORRECT
+                } else {  /* tell next time we're here that we're a retry */
+                       	printk(KERN_ALERT
+                          "raid1: set retry bit on bh READ for sector %ld\n",
+                                  bh->b_rsector);
+			set_bit(R1BH_ReadRetry, &r1_bh->state);
+                }
+#endif /* CONFIG_MD_RAID1_READ_WRITE_CORRECT */
+
+        } else
 		/*
 		 * Set R1BH_Uptodate in our master buffer_head, so that
 		 * we will return a good error code for to the higher
@@ -504,7 +569,21 @@
 		 * we have only one buffer_head on the read side
 		 */
 		
-		if (uptodate) {
+               if (uptodate
+#ifdef CONFIG_MD_RAID1_ROBUST_READ
+			/* Give up and error if we're last */
+			|| atomic_dec_and_test(&r1_bh->remaining)
+#endif /* CONFIG_MD_RAID1_ROBUST_READ */
+			) {
+#ifdef CONFIG_MD_RAID1_READ_WRITE_CORRECT
+			if (uptodate && test_bit(R1BH_ReadRewrite, &r1_bh->state)) {
+				/* Success at last - rewrite failed reads */
+                                r1_bh->cmd = SPECIAL;
+				raid1_reschedule_retry(r1_bh);
+                                return;
+			} else
+#endif /* CONFIG_MD_RAID1_READ_WRITE_CORRECT */
+
 			raid1_end_bh_io(r1_bh, uptodate);
 			return;
 		}
@@ -513,6 +592,13 @@
 		 */
 		printk(KERN_ERR "raid1: %s: rescheduling block %lu\n", 
 			 partition_name(bh->b_dev), bh->b_blocknr);
+#ifdef CONFIG_MD_RAID1_ROBUST_READ
+               /*
+                * if not uptodate and not the last possible try,
+                * bh will be rescheduled and repointed while on the
+                * queue, by raid1_map.
+                */
+#endif /* CONFIG_MD_RAID1_READ_WRITE_CORRECT */
 		raid1_reschedule_retry(r1_bh);
 		return;
 	}
@@ -771,6 +874,20 @@
 	/*	bh_req->b_rsector = bh->n_rsector; */
 		bh_req->b_end_io = raid1_end_request;
 		bh_req->b_private = r1_bh;
+#ifdef CONFIG_MD_RAID1_ROBUST_READ
+		atomic_set(&r1_bh->remaining, 0);
+		/* count target devices under spinlock */
+		md_spin_lock_irq(&conf->device_lock);
+		for (i = 0;  i < disks; i++) {
+	                if (!conf->mirrors[i].operational
+                        ||  !conf->mirrors[i].used_slot) {
+                                	continue;
+			} 
+			atomic_inc(&r1_bh->remaining);
+		}
+		md_spin_unlock_irq(&conf->device_lock);
+#endif /* CONFIG_MD_RAID1_ROBUST_READ */
+
 		generic_make_request (rw, bh_req);
 		return 0;
 	}
@@ -1562,6 +1707,13 @@
 		case READA:
 			dev = bh->b_dev;
 			raid1_map (mddev, &bh->b_dev);
+#ifdef CONFIG_MD_RAID1_ROBUST_READ
+                        /* raid1_map incorrectly used to change target to
+                         * 0th disk always - now I hope it does a
+                         * better job that before and switches target t
+                         * next disk in the mirror.
+                         */
+#endif /* CONFIG_MD_RAID1_ROBUST_READ */
 			if (bh->b_dev == dev) {
 				printk (IO_ERROR, partition_name(bh->b_dev), bh->b_blocknr);
 				raid1_end_bh_io(r1_bh, 0);

