From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Robust read patch for raid1
Date: Sun, 30 Jan 2005 02:26:42 +0100
Message-ID: <inptc2-f5r.ln1@news.it.uc3m.es>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've had the opportunity to test the "robust read" patch that I posted
earier in the month (10 Jan, Subject: Re: Spares and partitioning huge
disks), and it needs one more change ... I assumed that the raid1 map
function would move a (retried) request to another disk, but it des not,
it always moves it to disk 0 in the array.  So now I've changed the
function to move the request to the next disk instead.  The previous
patch would only have worked if the read fault were not on the first
disk.

Allow me to remind what the patch does: it allows raid1 to proceed
smoothly after a read error on a mirror component, without faulting the
component.  If the information is on another component, it will be
returned.  If all components are faulty, an error will be returned, but
nothing faulted out of the array.

An additional ifdefed out patch within the patch does a write repair,
but it is untested (probably incomplete) so I haven't enabled it.

The patch I am publishing below has only been confirmed to work on the
2.4.24 kernel, but I'll publish the 2.6.8.1 version (untested, hey,
even uncompiled) in the hopes of getting more testers.

Fuller patches with hookups to the kernel config files (make
menuconfig, etc) are in there as part of the fr1 patchset at

   ftp://oboe.it.uc3m.es/pub/Programs/fr1-2.16.tgz

The tests I have run on 2.4 are this paltry few:

   1) confirm that normal operation is well, normal, incuding rsyncs
   2) confirm that a read error in a block on one mirror component
      is recovered via a read from a different component.

I haven't tested what happens when all the components have a read error
in the same block. It was hard enough to do (2).

The patch is now in FOUR hunks.

1) Put the count of valid disks in the "remaining" field during
   construction of a raid1 read bio (make_request).

2) In the end_request code, simply, instead of erroring the current disk
   out of the array whenever an error has happened, do it only if a
   WRITE is being handled.

3) Also in end_request, finish a read request back to the user not only
   if the component read was successful, but also if we were
   unsuccessful and we have already tried all possible mirror components
   (we decrement the remaining count each time we go through here).

   The read request will be rescheduled otherwise.

4) change the remap (map) of the target device that happens on
   rescheduling to move on to the next possibility, not always try the
   first mirror component, as at present.

You have to set

  CONFIG_MD_RAID1_ROBUST_READ


--- linux-2.6.8.1/drivers/md/raid1.c.pre-fr1-robust-read	Sun Jan 16 12:48:15 2005
+++ linux-2.6.8.1/drivers/md/raid1.c	Sun Jan 30 00:56:37 2005
@@ -227,6 +227,9 @@
 {
 	conf_t *conf = mddev_to_conf(mddev);
 	int i, disks = conf->raid_disks;
+#ifdef CONFIG_MD_RAID1_ROBUST_READ
+        mdk_rdev_t *rdev = *rdevp;
+#endif /* CONFIG_MD_RAID1_ROBUST_READ */
 
 	/*
 	 * Later we do read balancing on the read side
@@ -234,6 +237,31 @@
 	 */
 
 	spin_lock_irq(&conf->device_lock);
+#ifdef CONFIG_MD_RAID1_ROBUST_READ
+        /*
+         * Uh, no. Choose the next disk if we can, not the first.
+         */
+	for (i = 0; i < disks; i++) {
+		if (conf->mirrors[i].rdev == rdev) {
+        	        i++;
+                    	break;
+                }
+        }
+	if (i >= disks)
+		i = 0;
+	for (; i < disks; i++) {
+		if (conf->mirrors[i].operational) {
+			*rdevp = conf->mirrors[i].rdev;
+			atomic_inc(&(*rdevp)->nr_pending);
+			spin_unlock_irq(&conf->device_lock);
+			return i;
+		}
+        }
+        /*
+         * If for some reason we fund nothing, dropthru and use the old
+         * routine.
+         */
+#endif /* CONFIG_MD_RAID1_ROBUST_READ */
 	for (i = 0; i < disks; i++) {
 		mdk_rdev_t *rdev = conf->mirrors[i].rdev;
 		if (rdev && rdev->in_sync) {
@@ -342,9 +370,19 @@
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
 	 */
-	if (!uptodate)
-	        md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
-        else
+	if (!uptodate) {
+#ifdef CONFIG_MD_RAID1_ROBUST_READ
+	        /*
+                 * Only fault disk out of array on write error, not read.
+                 */
+	        if (0)
+#endif /* CONFIG_MD_RAID1_ROBUST_READ */
+	        	md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
+#ifdef DO_ADD_READ_WRITE_CORRECT
+	        else    /* tell next time we're here that we're a retry */
+	                set_bit(R1BIO_ReadRetry, &r1_bio->state);
+#endif /* DO_ADD_READ_WRITE_CORRECT */
+        } else
 		/*
 		 * Set R1BIO_Uptodate in our master bio, so that
 		 * we will return a good error code for to the higher
@@ -361,8 +399,20 @@
 	/*
 	 * we have only one bio on the read side
 	 */
-	if (uptodate)
-		raid_end_bio_io(r1_bio);
+	if (uptodate
+#ifdef CONFIG_MD_RAID1_ROBUST_READ
+                /* Give up and error if we're last */
+                || (atomic_dec_and_test(&r1_bio->remaining))
+#endif /* CONFIG_MD_RAID1_ROBUST_READ */
+                )
+#ifdef DO_ADD_READ_WRITE_CORRECT
+	        if (uptodate && test_bit(R1BIO_ReadRewrite, &r1_bio->state)) {
+	                /* Success at last - rewrite failed reads */
+			set_bit(R1BIO_IsSync, &r1_bio->state);
+			reschedule_retry(r1_bio);
+		} else
+#endif /* DO_ADD_READ_WRITE_CORRECT */
+			raid_end_bio_io(r1_bio);
 	else {
 		/*
 		 * oops, read error:
@@ -665,6 +718,21 @@
 		read_bio->bi_end_io = raid1_end_read_request;
 		read_bio->bi_rw = READ;
 		read_bio->bi_private = r1_bio;
+#ifdef CONFIG_MD_RAID1_ROBUST_READ
+                if (1) {
+			atomic_set(&r1_bio->remaining, 0);
+			/* count source devices under spinlock */
+			spin_lock_irq(&conf->device_lock);
+	        	disks = conf->raid_disks;
+			for (i = 0;  i < disks; i++) {
+				if (conf->mirrors[i].rdev &&
+				!conf->mirrors[i].rdev->faulty) {
+					atomic_inc(&r1_bio->remaining);
+				} 
+			}
+			spin_unlock_irq(&conf->device_lock);
+                }
+#endif /* CONFIG_MD_RAID1_ROBUST_READ */
 
 		generic_make_request(read_bio);
 		return 0;

