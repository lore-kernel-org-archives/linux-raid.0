From: "George Spelvin" <linux@horizon.com>
Subject: Re: want-replacement got stuck?
Date: 22 Nov 2012 00:27:57 -0500
Message-ID: <20121122052757.26082.qmail@science.horizon.com>
References: <20121122152249.0adcc076@notabene.brown>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121122152249.0adcc076@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux@horizon.com, neilb@suse.de
Cc: joystick@shiftmail.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> wrote:
> OK, below are two patches.
> The first fixes the data corruption race.  You'll almost never hit it with
> the bug that the second patch fixes, but in theory you could.  Without the
> second patch you can hit it easily.

This one doesn't apply cleanly to 3.6.7.  In particular, the large third hunk where
you wrap some stuff in "if" that used to be handled by "continue".

The first difference is "mbio->bi_rw = WRITE | do_sync | do_fua | do_discard;",
which is missing the "do_discard"part in my tree.  Not a biggie.

The second difference, which I'm less confident of, is that entire
"cb = blk_check_plugged(...); if (cb) plug = contaner_of(...)" block,
which is also missing from 3.6.7. Instead, I just have

                        if (!mddev_check_plugged(mddev))
                                md_wakeup_thread(mddev->thread);

Is it safe to just indent that inside the if() and leave it?

Here's the patch I ended up applying.  First, the -b version (ignore
whitespace changes), which makes it easier to read, then the real thing.

(I also un-line-wrapped two instances of choose_data_offset that no
longer needed to be broken to fit in 80 columns.)


Does this look okay to you?  I'll reboot and test if you say so.


commit 1611c6944449fff9cfbf2a96db30d6d9e81f1979
Author: NeilBrown <neilb@suse.de>
Date:   Thu Nov 22 14:42:49 2012 +1100

    md/raid10: close race that lose writes lost when replacement completes.
    
    When a replacement operation completes there is a small window
    when the original device is marked 'faulty' and the replacement
    still looks like a replacement.  The faulty should be removed and
    the replacement moved in place very quickly, bit it isn't instant.
    
    So the code write out to the array must handle the possibility that
    the only working device for some slot in the replacement - but it
    doesn't.  If the primary device is faulty it just gives up.  This
    can lead to corruption.
    
    So make the code more robust: if either  the primary or the
    replacement is present and working, write to them.  Only when
    neither are present do we give up.
    
    This bug has been present since replacement was introduced in
    3.3, so it is suitable for any -stable kernel since then.
    
    Reported-by: "George Spelvin" <linux@horizon.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: NeilBrown <neilb@suse.de>

diff -b --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a48c215..60e5a65 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1287,18 +1287,21 @@ retry_write:
 			blocked_rdev = rrdev;
 			break;
 		}
+		if (rdev && (test_bit(Faulty, &rdev->flags)
+			     || test_bit(Unmerged, &rdev->flags)))
+			rdev = NULL;
 		if (rrdev && (test_bit(Faulty, &rrdev->flags)
 			      || test_bit(Unmerged, &rrdev->flags)))
 			rrdev = NULL;
 
 		r10_bio->devs[i].bio = NULL;
 		r10_bio->devs[i].repl_bio = NULL;
-		if (!rdev || test_bit(Faulty, &rdev->flags) ||
-		    test_bit(Unmerged, &rdev->flags)) {
+
+		if (!rdev && !rrdev) {
 			set_bit(R10BIO_Degraded, &r10_bio->state);
 			continue;
 		}
-		if (test_bit(WriteErrorSeen, &rdev->flags)) {
+		if (rdev && test_bit(WriteErrorSeen, &rdev->flags)) {
 			sector_t first_bad;
 			sector_t dev_sector = r10_bio->devs[i].addr;
 			int bad_sectors;
@@ -1340,8 +1343,10 @@ retry_write:
 					max_sectors = good_sectors;
 			}
 		}
+		if (rdev) {
 			r10_bio->devs[i].bio = bio;
 			atomic_inc(&rdev->nr_pending);
+		}
 		if (rrdev) {
 			r10_bio->devs[i].repl_bio = bio;
 			atomic_inc(&rrdev->nr_pending);
@@ -1400,15 +1405,16 @@ retry_write:
 		if (!r10_bio->devs[i].bio)
 			continue;
 
+		if (r10_bio->devs[i].bio) {
+			struct md_rdev *rdev = conf->mirrors[d].rdev;
 			mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
 			md_trim_bio(mbio, r10_bio->sector - bio->bi_sector,
 				    max_sectors);
 			r10_bio->devs[i].bio = mbio;
 
-		mbio->bi_sector	= (r10_bio->devs[i].addr+
-				   choose_data_offset(r10_bio,
-						      conf->mirrors[d].rdev));
-		mbio->bi_bdev = conf->mirrors[d].rdev->bdev;
+			mbio->bi_sector	= (r10_bio->devs[i].addr +
+					   choose_data_offset(r10_bio, rdev));
+			mbio->bi_bdev = rdev->bdev;
 			mbio->bi_end_io	= raid10_end_write_request;
 			mbio->bi_rw = WRITE | do_sync | do_fua;
 			mbio->bi_private = r10_bio;
@@ -1420,24 +1426,23 @@ retry_write:
 			spin_unlock_irqrestore(&conf->device_lock, flags);
 			if (!mddev_check_plugged(mddev))
 				md_wakeup_thread(mddev->thread);
+		}
 
-		if (!r10_bio->devs[i].repl_bio)
-			continue;
-
+		if (r10_bio->devs[i].repl_bio) {
+			struct md_rdev *rdev = conf->mirrors[d].replacement;
+			if (rdev == NULL) {
+				/* Replacement just got moved to main 'rdev' */
+				smp_mb();
+				rdev = conf->mirrors[d].rdev;
+			}
 			mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
 			md_trim_bio(mbio, r10_bio->sector - bio->bi_sector,
 				    max_sectors);
 			r10_bio->devs[i].repl_bio = mbio;
 
-		/* We are actively writing to the original device
-		 * so it cannot disappear, so the replacement cannot
-		 * become NULL here
-		 */
 			mbio->bi_sector	= (r10_bio->devs[i].addr +
-				   choose_data_offset(
-					   r10_bio,
-					   conf->mirrors[d].replacement));
-		mbio->bi_bdev = conf->mirrors[d].replacement->bdev;
+					   choose_data_offset(r10_bio, rdev));
+			mbio->bi_bdev = rdev->bdev;
 			mbio->bi_end_io	= raid10_end_write_request;
 			mbio->bi_rw = WRITE | do_sync | do_fua;
 			mbio->bi_private = r10_bio;
@@ -1450,6 +1455,7 @@ retry_write:
 			if (!mddev_check_plugged(mddev))
 				md_wakeup_thread(mddev->thread);
 		}
+	}
 
 	/* Don't remove the bias on 'remaining' (one_write_done) until
 	 * after checking if we need to go around again.




commit 1611c6944449fff9cfbf2a96db30d6d9e81f1979
Author: NeilBrown <neilb@suse.de>
Date:   Thu Nov 22 14:42:49 2012 +1100

    md/raid10: close race that lose writes lost when replacement completes.
    
    When a replacement operation completes there is a small window
    when the original device is marked 'faulty' and the replacement
    still looks like a replacement.  The faulty should be removed and
    the replacement moved in place very quickly, bit it isn't instant.
    
    So the code write out to the array must handle the possibility that
    the only working device for some slot in the replacement - but it
    doesn't.  If the primary device is faulty it just gives up.  This
    can lead to corruption.
    
    So make the code more robust: if either  the primary or the
    replacement is present and working, write to them.  Only when
    neither are present do we give up.
    
    This bug has been present since replacement was introduced in
    3.3, so it is suitable for any -stable kernel since then.
    
    Reported-by: "George Spelvin" <linux@horizon.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a48c215..60e5a65 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1287,18 +1287,21 @@ retry_write:
 			blocked_rdev = rrdev;
 			break;
 		}
+		if (rdev && (test_bit(Faulty, &rdev->flags)
+			     || test_bit(Unmerged, &rdev->flags)))
+			rdev = NULL;
 		if (rrdev && (test_bit(Faulty, &rrdev->flags)
 			      || test_bit(Unmerged, &rrdev->flags)))
 			rrdev = NULL;
 
 		r10_bio->devs[i].bio = NULL;
 		r10_bio->devs[i].repl_bio = NULL;
-		if (!rdev || test_bit(Faulty, &rdev->flags) ||
-		    test_bit(Unmerged, &rdev->flags)) {
+
+		if (!rdev && !rrdev) {
 			set_bit(R10BIO_Degraded, &r10_bio->state);
 			continue;
 		}
-		if (test_bit(WriteErrorSeen, &rdev->flags)) {
+		if (rdev && test_bit(WriteErrorSeen, &rdev->flags)) {
 			sector_t first_bad;
 			sector_t dev_sector = r10_bio->devs[i].addr;
 			int bad_sectors;
@@ -1340,8 +1343,10 @@ retry_write:
 					max_sectors = good_sectors;
 			}
 		}
-		r10_bio->devs[i].bio = bio;
-		atomic_inc(&rdev->nr_pending);
+		if (rdev) {
+			r10_bio->devs[i].bio = bio;
+			atomic_inc(&rdev->nr_pending);
+		}
 		if (rrdev) {
 			r10_bio->devs[i].repl_bio = bio;
 			atomic_inc(&rrdev->nr_pending);
@@ -1400,55 +1405,56 @@ retry_write:
 		if (!r10_bio->devs[i].bio)
 			continue;
 
-		mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
-		md_trim_bio(mbio, r10_bio->sector - bio->bi_sector,
-			    max_sectors);
-		r10_bio->devs[i].bio = mbio;
-
-		mbio->bi_sector	= (r10_bio->devs[i].addr+
-				   choose_data_offset(r10_bio,
-						      conf->mirrors[d].rdev));
-		mbio->bi_bdev = conf->mirrors[d].rdev->bdev;
-		mbio->bi_end_io	= raid10_end_write_request;
-		mbio->bi_rw = WRITE | do_sync | do_fua;
-		mbio->bi_private = r10_bio;
-
-		atomic_inc(&r10_bio->remaining);
-		spin_lock_irqsave(&conf->device_lock, flags);
-		bio_list_add(&conf->pending_bio_list, mbio);
-		conf->pending_count++;
-		spin_unlock_irqrestore(&conf->device_lock, flags);
-		if (!mddev_check_plugged(mddev))
-			md_wakeup_thread(mddev->thread);
-
-		if (!r10_bio->devs[i].repl_bio)
-			continue;
+		if (r10_bio->devs[i].bio) {
+			struct md_rdev *rdev = conf->mirrors[d].rdev;
+			mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
+			md_trim_bio(mbio, r10_bio->sector - bio->bi_sector,
+				    max_sectors);
+			r10_bio->devs[i].bio = mbio;
+
+			mbio->bi_sector	= (r10_bio->devs[i].addr +
+					   choose_data_offset(r10_bio, rdev));
+			mbio->bi_bdev = rdev->bdev;
+			mbio->bi_end_io	= raid10_end_write_request;
+			mbio->bi_rw = WRITE | do_sync | do_fua;
+			mbio->bi_private = r10_bio;
 
-		mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
-		md_trim_bio(mbio, r10_bio->sector - bio->bi_sector,
-			    max_sectors);
-		r10_bio->devs[i].repl_bio = mbio;
+			atomic_inc(&r10_bio->remaining);
+			spin_lock_irqsave(&conf->device_lock, flags);
+			bio_list_add(&conf->pending_bio_list, mbio);
+			conf->pending_count++;
+			spin_unlock_irqrestore(&conf->device_lock, flags);
+			if (!mddev_check_plugged(mddev))
+				md_wakeup_thread(mddev->thread);
+		}
 
-		/* We are actively writing to the original device
-		 * so it cannot disappear, so the replacement cannot
-		 * become NULL here
-		 */
-		mbio->bi_sector	= (r10_bio->devs[i].addr +
-				   choose_data_offset(
-					   r10_bio,
-					   conf->mirrors[d].replacement));
-		mbio->bi_bdev = conf->mirrors[d].replacement->bdev;
-		mbio->bi_end_io	= raid10_end_write_request;
-		mbio->bi_rw = WRITE | do_sync | do_fua;
-		mbio->bi_private = r10_bio;
+		if (r10_bio->devs[i].repl_bio) {
+			struct md_rdev *rdev = conf->mirrors[d].replacement;
+			if (rdev == NULL) {
+				/* Replacement just got moved to main 'rdev' */
+				smp_mb();
+				rdev = conf->mirrors[d].rdev;
+			}
+			mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
+			md_trim_bio(mbio, r10_bio->sector - bio->bi_sector,
+				    max_sectors);
+			r10_bio->devs[i].repl_bio = mbio;
+
+			mbio->bi_sector	= (r10_bio->devs[i].addr +
+					   choose_data_offset(r10_bio, rdev));
+			mbio->bi_bdev = rdev->bdev;
+			mbio->bi_end_io	= raid10_end_write_request;
+			mbio->bi_rw = WRITE | do_sync | do_fua;
+			mbio->bi_private = r10_bio;
 
-		atomic_inc(&r10_bio->remaining);
-		spin_lock_irqsave(&conf->device_lock, flags);
-		bio_list_add(&conf->pending_bio_list, mbio);
-		conf->pending_count++;
-		spin_unlock_irqrestore(&conf->device_lock, flags);
-		if (!mddev_check_plugged(mddev))
-			md_wakeup_thread(mddev->thread);
+			atomic_inc(&r10_bio->remaining);
+			spin_lock_irqsave(&conf->device_lock, flags);
+			bio_list_add(&conf->pending_bio_list, mbio);
+			conf->pending_count++;
+			spin_unlock_irqrestore(&conf->device_lock, flags);
+			if (!mddev_check_plugged(mddev))
+				md_wakeup_thread(mddev->thread);
+		}
 	}
 
 	/* Don't remove the bias on 'remaining' (one_write_done) until
