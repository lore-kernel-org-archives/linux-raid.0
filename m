From: Neil Brown <neilb@suse.de>
Subject: Re: raid1 oops, 2.6.16
Date: Mon, 21 Aug 2006 09:42:17 +1000
Message-ID: <17640.62297.58971.549302@cse.unsw.edu.au>
References: <eb28go$vl2$1@sea.gmane.org>
	<44E5F35A.8020707@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Friday August 18
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: Jason Lunz <lunz@falooley.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday August 18, paul.clements@steeleye.com wrote:
> 
> The atomic_add (and any other access to an rdev, for that matter) needs 
> to be guarded by a NULL check, I think.
> 
> Neil, does that sound right?

Yes.  Thanks for doing the analysis.

However after looking closely through the code, I think the atomic_inc
really is in the wrong place.
We are increasing 'corrected_errors' before we try to write out the
good data.  We should really wait until after reading back the good
data.  So rather than just protecting the atomic_inc with "if(dev)",
I'm going to move it several lines down.

And while I'm at it, there seem to be several place that reference
->rdev that could be cleaned up.

So I'm thinking of something like the following against -mm

I'll make a smaller patch for -stable.

Thanks,
NeilBrown

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |   55 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 21 deletions(-)

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2006-08-15 13:33:02.000000000 +1000
+++ ./drivers/md/raid1.c	2006-08-21 09:40:41.000000000 +1000
@@ -930,10 +930,13 @@ static void status(struct seq_file *seq,
 
 	seq_printf(seq, " [%d/%d] [", conf->raid_disks,
 		   conf->raid_disks - mddev->degraded);
-	for (i = 0; i < conf->raid_disks; i++)
+	rcu_read_lock();
+	for (i = 0; i < conf->raid_disks; i++) {
+		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[i].rdev);
 		seq_printf(seq, "%s",
-			      conf->mirrors[i].rdev &&
-			      test_bit(In_sync, &conf->mirrors[i].rdev->flags) ? "U" : "_");
+			   rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
+	}
+	rcu_read_unlock();
 	seq_printf(seq, "]");
 }
 
@@ -976,7 +979,6 @@ static void error(mddev_t *mddev, mdk_rd
 static void print_conf(conf_t *conf)
 {
 	int i;
-	mirror_info_t *tmp;
 
 	printk("RAID1 conf printout:\n");
 	if (!conf) {
@@ -986,14 +988,17 @@ static void print_conf(conf_t *conf)
 	printk(" --- wd:%d rd:%d\n", conf->raid_disks - conf->mddev->degraded,
 		conf->raid_disks);
 
+	rcu_read_lock();
 	for (i = 0; i < conf->raid_disks; i++) {
 		char b[BDEVNAME_SIZE];
-		tmp = conf->mirrors + i;
-		if (tmp->rdev)
+		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[i].rdev);
+		if (rdev)
 			printk(" disk %d, wo:%d, o:%d, dev:%s\n",
-				i, !test_bit(In_sync, &tmp->rdev->flags), !test_bit(Faulty, &tmp->rdev->flags),
-				bdevname(tmp->rdev->bdev,b));
+			       i, !test_bit(In_sync, &rdev->flags),
+			       !test_bit(Faulty, &rdev->flags),
+			       bdevname(rdev->bdev,b));
 	}
+	rcu_read_unlock();
 }
 
 static void close_sync(conf_t *conf)
@@ -1009,17 +1014,17 @@ static int raid1_spare_active(mddev_t *m
 {
 	int i;
 	conf_t *conf = mddev->private;
-	mirror_info_t *tmp;
 
 	/*
 	 * Find all failed disks within the RAID1 configuration 
-	 * and mark them readable
+	 * and mark them readable.
+	 * Called under mddev lock, so rcu protection not needed.
 	 */
 	for (i = 0; i < conf->raid_disks; i++) {
-		tmp = conf->mirrors + i;
-		if (tmp->rdev 
-		    && !test_bit(Faulty, &tmp->rdev->flags)
-		    && !test_and_set_bit(In_sync, &tmp->rdev->flags)) {
+		mdk_rdev_t *rdev = conf->mirrors[i].rdev;
+		if (rdev
+		    && !test_bit(Faulty, &rdev->flags)
+		    && !test_and_set_bit(In_sync, &rdev->flags)) {
 			unsigned long flags;
 			spin_lock_irqsave(&conf->device_lock, flags);
 			mddev->degraded--;
@@ -1239,7 +1244,7 @@ static void sync_request_write(mddev_t *
 		/* ouch - failed to read all of that.
 		 * Try some synchronous reads of other devices to get
 		 * good data, much like with normal read errors.  Only
-		 * read into the pages we already have so they we don't
+		 * read into the pages we already have so we don't
 		 * need to re-issue the read request.
 		 * We don't need to freeze the array, because being in an
 		 * active sync request, there is no normal IO, and
@@ -1259,6 +1264,10 @@ static void sync_request_write(mddev_t *
 				s = PAGE_SIZE >> 9;
 			do {
 				if (r1_bio->bios[d]->bi_end_io == end_sync_read) {
+					/* No rcu protection needed here devices
+					 * can only be removed when no resync is 
+					 * active, and resync is currently active
+					 */
 					rdev = conf->mirrors[d].rdev;
 					if (sync_page_io(rdev->bdev,
 							 sect + rdev->data_offset,
@@ -1376,6 +1385,11 @@ static void fix_read_error(conf_t *conf,
 			s = PAGE_SIZE >> 9;
 
 		do {
+			/* Note: no rcu protection needed here
+			 * as this is synchronous in the raid1d thread
+			 * which is the thread that might remove
+			 * a device.  If raid1d ever becomes multi-threaded....
+			 */
 			rdev = conf->mirrors[d].rdev;
 			if (rdev &&
 			    test_bit(In_sync, &rdev->flags) &&
@@ -1403,7 +1417,6 @@ static void fix_read_error(conf_t *conf,
 				d = conf->raid_disks;
 			d--;
 			rdev = conf->mirrors[d].rdev;
-			atomic_add(s, &rdev->corrected_errors);
 			if (rdev &&
 			    test_bit(In_sync, &rdev->flags)) {
 				if (sync_page_io(rdev->bdev,
@@ -1429,7 +1442,8 @@ static void fix_read_error(conf_t *conf,
 				    == 0)
 					/* Well, this device is dead */
 					md_error(mddev, rdev);
-				else
+				else {
+					atomic_add(s, &rdev->corrected_errors);
 					printk(KERN_INFO
 					       "raid1:%s: read error corrected "
 					       "(%d sectors at %llu on %s)\n",
@@ -1437,6 +1451,7 @@ static void fix_read_error(conf_t *conf,
 					       (unsigned long long)sect +
 					           rdev->data_offset,
 					       bdevname(rdev->bdev, b));
+				}
 			}
 		}
 		sectors -= s;
@@ -1806,19 +1821,17 @@ static sector_t sync_request(mddev_t *md
 		for (i=0; i<conf->raid_disks; i++) {
 			bio = r1_bio->bios[i];
 			if (bio->bi_end_io == end_sync_read) {
-				md_sync_acct(conf->mirrors[i].rdev->bdev, nr_sectors);
+				md_sync_acct(bio->bi_bdev, nr_sectors);
 				generic_make_request(bio);
 			}
 		}
 	} else {
 		atomic_set(&r1_bio->remaining, 1);
 		bio = r1_bio->bios[r1_bio->read_disk];
-		md_sync_acct(conf->mirrors[r1_bio->read_disk].rdev->bdev,
-			     nr_sectors);
+		md_sync_acct(bio->bi_bdev, nr_sectors);
 		generic_make_request(bio);
 
 	}
-
 	return nr_sectors;
 }
 
