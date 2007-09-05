From: Mike Accetta <maccetta@laurelnetworks.com>
Subject: raid1 error handling and faulty drives
Date: Wed, 05 Sep 2007 18:22:27 -0400
Message-ID: <915.1189030947@mdt.ecitele.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I've been looking at ways to minimize the impact of a faulty drive in
a raid1 array.  Our major problem is that a faulty drive can absorb
lots of wall clock time in error recovery within the device driver
(SATA libata error handler in this case), during which any further raid
activity is blocked and the system effectively hangs.  This tends to
negate the high availability advantage of placing the file system on a
RAID array in the first place.

We've had one particularly bad drive, for example, which could sync
without indicating any write errors but as soon as it became active in
the array would start yielding read errors.  It this particular case it
would take 30 minutes or more for the process to progress to a point
where some fatal error would occur to kick the drive out of the array
and return the system to normal opreation.

For SATA, this effect can be partially mitigated by reducing the default
30 second timeout at the SCSI layer (/sys/block/sda/device/timeout).
However, the system stills spends 45 seconds or so per retry in the
driver issuing various reset operations in an attempt to recover from
the error before returning control to the SCSI layer.

I've been experimenting with a patch which makes two basic changes.

1) It issues the first read request against a mirror with more than 1 drive
   active using the BIO_RW_FAILFAST flag to short-circuit the SCSI layer from 
   re-trying the failed operation in the low level device driver the default 5
   times.

2) It adds a threshold on the level of recent error acivity which is
   acceptable in a given interval, all configured through /sys.  If a
   mirror has generated more errors in this interval than the threshold,
   it is kicked out of the array.

One would think that #2 should not be necessary as the raid1 retry
logic already attempts to rewrite and then reread bad sectors and fails
the drive if it cannot do both.  However, what we observe is that the
re-write step succeeds as does the re-read but the drive is really no
more healthy.  Maybe the re-read is not actually going out to the media
in this case due to some caching effect?

This patch (against 2.6.20) still contains some debugging printk's but
should be otherwise functional.  I'd be interested in any feedback on
this specific approach and would also be happy if this served to foster
an error recovery discussion which came up with some even better approach.

Mike Accetta

ECI Telecom Ltd.
Transport Networking Division, US (previously Laurel Networks)
---
diff -Naurp 2.6.20/drivers/md/md.c kernel/drivers/md/md.c
--- 2.6.20/drivers/md/md.c	2007-06-04 13:52:42.000000000 -0400
+++ kernel/drivers/md/md.c	2007-08-30 16:28:58.633816000 -0400
@@ -1842,6 +1842,46 @@ static struct rdev_sysfs_entry rdev_erro
 __ATTR(errors, S_IRUGO|S_IWUSR, errors_show, errors_store);
 
 static ssize_t
+errors_threshold_show(mdk_rdev_t *rdev, char *page)
+{
+	return sprintf(page, "%d\n", rdev->errors_threshold);
+}
+
+static ssize_t
+errors_threshold_store(mdk_rdev_t *rdev, const char *buf, size_t len)
+{
+	char *e;
+	unsigned long n = simple_strtoul(buf, &e, 10);
+	if (*buf && (*e == 0 || *e == '\n')) {
+		rdev->errors_threshold = n;
+		return len;
+	}
+	return -EINVAL;
+}
+static struct rdev_sysfs_entry rdev_errors_threshold =
+__ATTR(errors_threshold, S_IRUGO|S_IWUSR, errors_threshold_show, errors_threshold_store);
+
+static ssize_t
+errors_interval_show(mdk_rdev_t *rdev, char *page)
+{
+	return sprintf(page, "%d\n", rdev->errors_interval);
+}
+
+static ssize_t
+errors_interval_store(mdk_rdev_t *rdev, const char *buf, size_t len)
+{
+	char *e;
+	unsigned long n = simple_strtoul(buf, &e, 10);
+	if (*buf && (*e == 0 || *e == '\n')) {
+		rdev->errors_interval = n;
+		return len;
+	}
+	return -EINVAL;
+}
+static struct rdev_sysfs_entry rdev_errors_interval =
+__ATTR(errors_interval, S_IRUGO|S_IWUSR, errors_interval_show, errors_interval_store);
+
+static ssize_t
 slot_show(mdk_rdev_t *rdev, char *page)
 {
 	if (rdev->raid_disk < 0)
@@ -1925,6 +1965,8 @@ static struct attribute *rdev_default_at
 	&rdev_state.attr,
 	&rdev_super.attr,
 	&rdev_errors.attr,
+	&rdev_errors_interval.attr,
+	&rdev_errors_threshold.attr,
 	&rdev_slot.attr,
 	&rdev_offset.attr,
 	&rdev_size.attr,
@@ -2010,6 +2052,9 @@ static mdk_rdev_t *md_import_device(dev_
 	rdev->flags = 0;
 	rdev->data_offset = 0;
 	rdev->sb_events = 0;
+	rdev->errors_interval = 15;	/* minutes */
+	rdev->errors_threshold = 16;	/* sectors */
+	rdev->errors_asof = INITIAL_JIFFIES;
 	atomic_set(&rdev->nr_pending, 0);
 	atomic_set(&rdev->read_errors, 0);
 	atomic_set(&rdev->corrected_errors, 0);
diff -Naurp 2.6.20/drivers/md/raid1.c kernel/drivers/md/raid1.c
--- 2.6.20/drivers/md/raid1.c	2007-06-04 13:52:42.000000000 -0400
+++ kernel/drivers/md/raid1.c	2007-08-30 16:58:26.002331000 -0400
@@ -761,6 +761,14 @@ do_sync_io:
 	return NULL;
 }
 
+static int failfast_mddev(mddev_t *mddev)
+{
+	conf_t *conf = mddev_to_conf(mddev);
+
+	return 
+	    ((conf->raid_disks-mddev->degraded) > 1)?(1 << BIO_RW_FAILFAST):0;
+}
+
 static int make_request(request_queue_t *q, struct bio * bio)
 {
 	mddev_t *mddev = q->queuedata;
@@ -836,7 +844,7 @@ static int make_request(request_queue_t 
 		read_bio->bi_sector = r1_bio->sector + mirror->rdev->data_offset;
 		read_bio->bi_bdev = mirror->rdev->bdev;
 		read_bio->bi_end_io = raid1_end_read_request;
-		read_bio->bi_rw = READ | do_sync;
+		read_bio->bi_rw = READ | do_sync | failfast_mddev(mddev);
 		read_bio->bi_private = r1_bio;
 
 		generic_make_request(read_bio);
@@ -1296,6 +1304,11 @@ static void sync_request_write(mddev_t *
 			int d = r1_bio->read_disk;
 			int success = 0;
 			mdk_rdev_t *rdev;
+			/*
+			 * Use the same retry "fail fast" logic as
+			 * fix_read_error().
+			 */
+			int rw = READ | failfast_mddev(mddev);
 
 			if (s > (PAGE_SIZE>>9))
 				s = PAGE_SIZE >> 9;
@@ -1310,7 +1323,7 @@ static void sync_request_write(mddev_t *
 							 sect + rdev->data_offset,
 							 s<<9,
 							 bio->bi_io_vec[idx].bv_page,
-							 READ)) {
+							 rw)) {
 						success = 1;
 						break;
 					}
@@ -1318,6 +1331,7 @@ static void sync_request_write(mddev_t *
 				d++;
 				if (d == conf->raid_disks)
 					d = 0;
+				rw = READ;
 			} while (!success && d != r1_bio->read_disk);
 
 			if (success) {
@@ -1401,6 +1415,46 @@ static void sync_request_write(mddev_t *
 }
 
 /*
+ * Check recent error activity on the mirror over the currently configured
+ * interval (in minutes) from the first recent error with respect to the
+ * currently configured error threshold (in sectors).  If a mirror has
+ * generated more errors in this interval than the threshold, we give up on it.
+ */
+static void monitor_read_errors(conf_t *conf, int read_disk, int sectors)
+{
+	char b[BDEVNAME_SIZE];
+	mdk_rdev_t *rdev;
+	rdev = conf->mirrors[read_disk].rdev;
+	if (rdev) {
+		mddev_t *mddev = conf->mddev;
+		u64 j64 = get_jiffies_64();
+		if (time_after64(j64, rdev->errors_asof+
+		                      (60LLU*HZ*rdev->errors_interval))) {
+			printk(KERN_INFO
+			      "raid1:%s: error stamp on %s\n",
+			       mdname(mddev),
+			       bdevname(rdev->bdev, b));
+			rdev->errors_asof = j64;
+			atomic_set(&rdev->read_errors, 0);
+		}
+		if (atomic_add_return(sectors, &rdev->read_errors)
+		    >= rdev->errors_threshold) {
+			if (1 && printk_ratelimit()) {
+				u64 elapsed = j64-rdev->errors_asof;
+				printk(KERN_INFO
+				    "raid1:%s: too many (%d) "
+				    "recent errors in past %lu minutes "
+				    "on %s\n",
+				mdname(mddev), atomic_read(&rdev->read_errors),
+				((unsigned long)elapsed)/(HZ*60),
+				bdevname(rdev->bdev, b));
+			}
+			md_error(mddev, rdev);
+		}
+	}
+}
+
+/*
  * This is a kernel thread which:
  *
  *	1.	Retries failed read operations on working mirrors.
@@ -1418,11 +1472,31 @@ static void fix_read_error(conf_t *conf,
 		int success = 0;
 		int start;
 		mdk_rdev_t *rdev;
+		int rw;
 
 		if (s > (PAGE_SIZE>>9))
 			s = PAGE_SIZE >> 9;
 
+		/*
+		 * We make this check inside the loop so that it can be
+		 * applied on every retry and possibly abort earlier on a
+		 * large read to a faulty disk.
+		 */
+		monitor_read_errors(conf, read_disk, s);
+
+		/*
+		 * We will start re-reading with the failing device.  Since it
+		 * will likely fail again, we want to include the "fail fast"
+		 * flag again (if still appropriate) in order to get on to the
+		 * next mirror as quickly as possible.  Reads from subsequent
+		 * mirrors use full retry so that we don't fail fast on all
+		 * mirrors when an extended retry might have succeeded on one
+		 * of them.
+		 */
+		rw = READ | failfast_mddev(mddev);
+
 		do {
+			char b[BDEVNAME_SIZE];
 			/* Note: no rcu protection needed here
 			 * as this is synchronous in the raid1d thread
 			 * which is the thread that might remove
@@ -1431,15 +1505,23 @@ static void fix_read_error(conf_t *conf,
 			rdev = conf->mirrors[d].rdev;
 			if (rdev &&
 			    test_bit(In_sync, &rdev->flags) &&
+			    printk(KERN_INFO
+				   "raid1:%s: attempting read fix "
+				   "(%d sectors at %llu on %s)\n",
+				   mdname(mddev), s,
+				   (unsigned long long)(sect +
+				       rdev->data_offset),
+				   bdevname(rdev->bdev, b)) &&
 			    sync_page_io(rdev->bdev,
 					 sect + rdev->data_offset,
 					 s<<9,
-					 conf->tmppage, READ))
+					 conf->tmppage, rw))
 				success = 1;
 			else {
 				d++;
 				if (d == conf->raid_disks)
 					d = 0;
+				rw = READ;
 			}
 		} while (!success && d != read_disk);
 
@@ -1451,12 +1533,20 @@ static void fix_read_error(conf_t *conf,
 		/* write it back and re-read */
 		start = d;
 		while (d != read_disk) {
+			char b[BDEVNAME_SIZE];
 			if (d==0)
 				d = conf->raid_disks;
 			d--;
 			rdev = conf->mirrors[d].rdev;
 			if (rdev &&
 			    test_bit(In_sync, &rdev->flags)) {
+				printk(KERN_INFO
+				       "raid1:%s: attempting rewrite "
+				       "(%d sectors at %llu on %s)\n",
+				       mdname(mddev), s,
+				       (unsigned long long)(sect +
+					   rdev->data_offset),
+				       bdevname(rdev->bdev, b));
 				if (sync_page_io(rdev->bdev,
 						 sect + rdev->data_offset,
 						 s<<9, conf->tmppage, WRITE)
@@ -1474,6 +1564,13 @@ static void fix_read_error(conf_t *conf,
 			rdev = conf->mirrors[d].rdev;
 			if (rdev &&
 			    test_bit(In_sync, &rdev->flags)) {
+				printk(KERN_INFO
+				       "raid1:%s: attempting reread "
+				       "(%d sectors at %llu on %s)\n",
+				       mdname(mddev), s,
+				       (unsigned long long)(sect +
+					   rdev->data_offset),
+				       bdevname(rdev->bdev, b));
 				if (sync_page_io(rdev->bdev,
 						 sect + rdev->data_offset,
 						 s<<9, conf->tmppage, READ)
@@ -1590,12 +1687,21 @@ static void raid1d(mddev_t *mddev)
 			 * This is all done synchronously while the array is
 			 * frozen
 			 */
+			printk(KERN_INFO "raid1: %s: read error recovery "
+			       "started for block %llu, sectors %d\n",
+			       bdevname(r1_bio->bios[r1_bio->read_disk]->bi_bdev,b),
+			       (unsigned long long)r1_bio->sector,
+			       r1_bio->sectors);
+
 			if (mddev->ro == 0) {
 				freeze_array(conf);
 				fix_read_error(conf, r1_bio->read_disk,
 					       r1_bio->sector,
 					       r1_bio->sectors);
 				unfreeze_array(conf);
+			} else {
+				monitor_read_errors(conf, r1_bio->read_disk,
+					            r1_bio->sectors);
 			}
 
 			bio = r1_bio->bios[r1_bio->read_disk];
@@ -1609,6 +1715,8 @@ static void raid1d(mddev_t *mddev)
 				const int do_sync = bio_sync(r1_bio->master_bio);
 				r1_bio->bios[r1_bio->read_disk] =
 					mddev->ro ? IO_BLOCKED : NULL;
+				/* save right name for error message below */
+			        bdevname(conf->mirrors[r1_bio->read_disk].rdev->bdev,b);
 				r1_bio->read_disk = disk;
 				bio_put(bio);
 				bio = bio_clone(r1_bio->master_bio, GFP_NOIO);
@@ -1617,7 +1725,7 @@ static void raid1d(mddev_t *mddev)
 				if (printk_ratelimit())
 					printk(KERN_ERR "raid1: %s: redirecting sector %llu to"
 					       " another mirror\n",
-					       bdevname(rdev->bdev,b),
+					       b,
 					       (unsigned long long)r1_bio->sector);
 				bio->bi_sector = r1_bio->sector + rdev->data_offset;
 				bio->bi_bdev = rdev->bdev;
diff -Naurp 2.6.20/include/linux/raid/md_k.h kernel/include/linux/raid/md_k.h
--- 2.6.20/include/linux/raid/md_k.h	2007-06-04 13:54:58.000000000 -0400
+++ kernel/include/linux/raid/md_k.h	2007-09-05 17:28:09.316520000 -0400
@@ -104,6 +104,12 @@ struct mdk_rdev_s
 					   * for reporting to userspace and storing
 					   * in superblock.
 					   */
+	u64		errors_asof;	/* begin time of current read errors interval */
+	int		errors_interval;/* duration of the read errors interval */
+	int		errors_threshold;/* maximum read errors allowed in any
+					  * interval before we will raise an
+					  * array error
+					  */
 };
 
 struct mddev_s




