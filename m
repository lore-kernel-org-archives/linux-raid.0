From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Sat, 19 Mar 2005 13:53:51 +0100
Message-ID: <vvjtg2-t16.ln1@news.it.uc3m.es>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <20050314094454.GK3858@marowsky-bree.de> <16949.26113.68948.938529@cse.unsw.edu.au> <20050314112403.GT3858@marowsky-bree.de> <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <20050318171608.GA28494@percy.comedia.it> <423B4C4B.7070404@tls.msk.ru> <9phtg2-6c1.ln1@news.it.uc3m.es> <423C1C58.1090609@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev <mjt@tls.msk.ru> wrote:
> Ok, you intrigued me enouth already.. what's the FR1 patch?  I want
> to give it a try... ;)  Especially I'm interested in the "Robust Read"
> thing...

That was published on this list a few weeks ago (probably needs updating,
but I am sure you can help :-). Google "linux raid robust read patch
for raid1". I see a pointer to at least

http://www.spinics.net/lists/raid/msg07732.html

but glancing at it I can't see if it's the latest.  In particular I
can't see a correction I made at one point that sets the current
rdev before calling the map() function ...  In the FR1 patch it's all
delineated by #ifdef blah_ROBUST_READ_blah. That's at

   ftp://oboe.it.uc3m.es/pub/Programs/fr1-2.16.tgz

The patch was originally developed for 2.4, then ported to 2.6.3, and
then to 2.6.8.1. Neil has recently been doing stuff, so I don't
think it applies cleanly to 2.6.10, but somebody WAS porting it for me
until they found that 2.6.10 didn't support their hardware ... and I
recall discussing with him what to do about the change of map() to
read_balance() in the code (essentially, put map() back). And finding
that the spinlocks have changed too.

So essentially, if you want to update the patch for 2.6.10 or above,
please do! Here's my quick extraction for 2.6.8.1 (a small hunk that I
probably needed for the patches published here is the one at the end).

Peter


--- ./drivers/md/raid1.c.pre-fr1	Sat Dec 18 22:37:14 2004
+++ ./drivers/md/raid1.c	Sun Jan 16 13:18:42 2005
@@ -200,6 +234,32 @@
 	 */
 
 	spin_lock_irq(&conf->device_lock);
+#ifdef CONFIG_MD_RAID1_ROBUST_READ
+        /*
+         * Uh, no. Choose the next disk if we can, not the first.
+         */
+	for (i = 0; i < disks; i++) {
+		if (conf->mirrors[i].rdev == *rdevp) {
+        	        i++;
+                    	break;
+                }
+        }
+	if (i >= disks)
+		i = 0;
+	for (; i < disks; i++) {
+		mdk_rdev_t *rdev = conf->mirrors[i].rdev;
+		if (rdev && rdev != *rdevp && rdev->in_sync) {
+			*rdevp = rdev;
+			atomic_inc(&rdev->nr_pending);
+			spin_unlock_irq(&conf->device_lock);
+			return i;
+		}
+        }
+        /*
+         * If for some reason we found nothing, dropthru and use the old
+         * routine.
+         */
+#endif /* CONFIG_MD_RAID1_ROBUST_READ */
 	for (i = 0; i < disks; i++) {
 		mdk_rdev_t *rdev = conf->mirrors[i].rdev;
 		if (rdev && rdev->in_sync) {
@@ -266,9 +368,19 @@
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
 	 */
-	if (!uptodate)
-		md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
-	else
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
@@ -285,8 +397,20 @@
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
+	        if (uptodate && test_bit(R1BIO_ReadRetry, &r1_bio->state)) {
+	                /* Success at last - rewrite failed reads */
+                        set_bit(R1BIO_IsSync, &r1_bio->state);
+			reschedule_retry(r1_bio);
+		} else
+#endif /* DO_ADD_READ_WRITE_CORRECT */
+			raid_end_bio_io(r1_bio);
 	else {
 		/*
 		 * oops, read error:
@@ -560,6 +716,19 @@
 		read_bio->bi_end_io = raid1_end_read_request;
 		read_bio->bi_rw = READ;
 		read_bio->bi_private = r1_bio;
+#ifdef CONFIG_MD_RAID1_ROBUST_READ
+		atomic_set(&r1_bio->remaining, 0);
+		/* count source devices under spinlock */
+		spin_lock_irq(&conf->device_lock);
+	        disks = conf->raid_disks;
+		for (i = 0;  i < disks; i++) {
+			if (conf->mirrors[i].rdev &&
+			!conf->mirrors[i].rdev->faulty) {
+				atomic_inc(&r1_bio->remaining);
+			} 
+		}
+		spin_unlock_irq(&conf->device_lock);
+#endif /* CONFIG_MD_RAID1_ROBUST_READ */
 
 		generic_make_request(read_bio);
 		return 0;
@@ -925,6 +1249,9 @@
 		} else {
 			int disk;
 			bio = r1_bio->bios[r1_bio->read_disk];
+#ifdef CONFIG_MD_RAID1_ROBUST_READ
+	                rdev = conf->mirrors[r1_bio->read_disk].rdev;
+#endif /* CONFIG_MD_RAID1_ROBUST_READ */
 			if ((disk=map(mddev, &rdev)) == -1) {
 				printk(KERN_ALERT "raid1: %s: unrecoverable I/O"
 				       " read error for block %llu\n",



