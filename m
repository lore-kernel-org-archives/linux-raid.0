From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Spares and partitioning huge disks
Date: Mon, 10 Jan 2005 14:19:53 +0100
Message-ID: <p0cab2-s27.ln1@news.it.uc3m.es>
References: <41E17117.2090500@tls.msk.ru> <200501092028.j09KSr918180@www.watkins-home.com> <jsh8b2-5g6.ln1@news.it.uc3m.es> <jsm9b2-iqp.ln1@news.it.uc3m.es> <i69ab2-onm.ln1@news.it.uc3m.es>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer <ptb@lab.it.uc3m.es> wrote:
> Hmm ...  I must be crackers at 7.39 in the morning.  Surely if the bio

Perhaps this is more obviously correct (or less obviously incorrect).
Same rationale as before. Detailed reasoning after lunch. This patch is
noticably less invasive, less convoluted. See embedded comments.


--- linux-2.6.3/drivers/md/raid1.c.orig	Tue Dec 28 00:39:01 2004
+++ linux-2.6.3/drivers/md/raid1.c	Mon Jan 10 14:05:46 2005
@@ -354,9 +354,15 @@
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
 	 */
-	if (!uptodate)
-		md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
-	else
+	if (!uptodate) {
+#ifndef DO_NOT_ADD_ROBUST_READ_SUPPORT
+                /*
+                 * Only fault disk out of array on write error, not read.
+                 */
+                if (r1_bio->cmd == WRITE)
+#endif /* DO_NOT_ADD_ROBUST_READ_SUPPORT */
+		        md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
+        } else
 		/*
 		 * Set R1BIO_Uptodate in our master bio, so that
 		 * we will return a good error code for to the higher
@@ -375,7 +381,12 @@
 		/*
 		 * we have only one bio on the read side
 		 */
-		if (uptodate)
+		if (uptodate
+#ifndef DO_NOT_ADD_ROBUST_READ_SUPPORT
+                        /* Give up and error if we're last */
+                        || atomic_dec_and_test(&r1_bio->remaining)
+#endif /* DO_NOT_ADD_ROBUST_READ_SUPPORT */
+                        )
 			raid_end_bio_io(r1_bio);
 		else {
 			/*
@@ -708,6 +720,18 @@
 		read_bio->bi_end_io = raid1_end_request;
 		read_bio->bi_rw = r1_bio->cmd;
 		read_bio->bi_private = r1_bio;
+#ifndef DO_NOT_ADD_ROBUST_READ_SUPPORT
+	        atomic_set(&r1_bio->remaining, 0);
+	        /* count source devices under spinlock */
+	        spin_lock_irq(&conf->device_lock);
+	        for (i = 0;  i < disks; i++) {
+		        if (conf->mirrors[i].rdev &&
+		        !conf->mirrors[i].rdev->faulty) {
+		                atomic_inc(&r1_bio->remaining);
+		        } 
+	        }
+	        spin_unlock_irq(&conf->device_lock);
+#endif /* DO_NOT_ADD_ROBUST_READ_SUPPORT */
 
 		generic_make_request(read_bio);
 		return 0;

