From: "George Spelvin" <linux@horizon.com>
Subject: Re: 3-way mirrors
Date: 8 Sep 2010 10:52:32 -0400
Message-ID: <20100908145232.9468.qmail@science.horizon.com>
References: <20100908080155.2ed9300e@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100908080155.2ed9300e@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: linux@horizon.com, neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> The relevant bit of code is in the MD_RECOVERY_REQUESTED branch of
> sync_request_write() in drivers/md/raid1.c
> Look for "memcmp".

Okay, so the data is in r1_bio->bios[i]->bi_io_vec[j].bv_page,
for 0 <= i < mddev->raid_disks, and 0 <= j < vcnt (the number
of 4K pages in the chunk).

Okay, so the first for() loop sets primary to the lowest disk
number that was completely readable (.bi_end_io == end_sync_read
&& test_bit(BIO_UPTODATE).

Then the second loop compares all the data to the primary's data
and, if it doesn't match, re-initializes the mirror's sbio to
write it back.

I could probably figure this out with a lot of RTFSing, but if you
don't mind me asking:
- What does it mean if r1_bio->bios[i]->bi_end_io != end_sync_read.
  Does that case only avoid testing the primary again, or are there
  other cases where it might be true.  If there are, why not count
  them as a mismatch?
- What does it mean if !test_bit(BIO_UPTODATE, &sbio->bi_flags)?
- How does the need to write back a particular disk get communicated
  from the sbio setup code to the "schedule writes" section?

(On a tangential note, why the heck are bi_flags and bi_rw "unsigned long"
rather than "u32"?  You'd have to change "if test_bit(BIO_UPTODATE" to
"if bio_flagged(sbio, BIO_UPTODATE."... untested patch appended.)

> You possibly want to factor out that code into a separate function before
> trying to add any 'voting' code.

Indeed, the first thing I'd like to do is add some much more detailed
logging.  What part of the chunk is mismatched?  One sector, one page,
or the whole chunk?  Are just a few bits flipped, or is it a gross
mismatch?  Which disks are mismatched?

> This is controlled by raid10_add_disk in drivers/md/raid10.c.  I would
> happily accept a patch which made a more balanced choice about where to add
> the new disk.

Thank you very much for the encouragement!  The tricky cases are when
the number of drives is not a multiple of the number of data copies.
If I have -n3 and 7 drives, there are many possible subsets of 3 that will
operate.  Suppose I have U__U_U_.  What order should drives 4..7 be added?

(That's something of a rhetorical question; I expect to figure out the
answer myself, although you're welcome to chime in if you have any ideas.
I'm thinking of some kind of score where I consider the n/gcd(n,k) stripe
start positions and rank possible solutions based on the minimum redundancy
level and the number of stripes at that level.  The question is, is there
ever a case where the locations I'd like to add *two* disks differ from the
location I'd like to add one?  If there were, it would be nasty.)



Proof-of-concept patch to shrink bi_flags filed on 64-bit:

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 7fc5606..8cababe 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -64,8 +64,8 @@ struct bio {
 						   sectors */
 	struct bio		*bi_next;	/* request queue link */
 	struct block_device	*bi_bdev;
-	unsigned long		bi_flags;	/* status, command, etc */
-	unsigned long		bi_rw;		/* bottom bits READ/WRITE,
+	unsigned int		bi_flags;	/* status, command, etc */
+	unsigned int		bi_rw;		/* bottom bits READ/WRITE,
 						 * top bits priority
 						 */
 
diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 0d710c9..aed45dd 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -283,8 +283,8 @@ static void bio_end_empty_barrier(struct bio *bio, int err)
 {
 	if (err) {
 		if (err == -EOPNOTSUPP)
-			set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
-		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+			bio->bi_flags |= (1<<BIO_EOPNOTSUPP);
+		bio->bi_flags &= ~(1<<BIO_UPTODATE);
 	}
 	if (bio->bi_private)
 		complete(bio->bi_private);
diff --git a/block/blk-core.c b/block/blk-core.c
index f0640d7..dfca463 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -138,8 +138,8 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 
 	if (&q->bar_rq != rq) {
 		if (error)
-			clear_bit(BIO_UPTODATE, &bio->bi_flags);
-		else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
+			bio->bi_flags &= ~(1<<BIO_UPTODATE);
+		else if (bio_flagged(bio, BIO_UPTODATE))
 			error = -EIO;
 
 		if (unlikely(nbytes > bio->bi_size)) {
@@ -149,7 +149,7 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 		}
 
 		if (unlikely(rq->cmd_flags & REQ_QUIET))
-			set_bit(BIO_QUIET, &bio->bi_flags);
+			bio->bi_flags |= (1<<BIO_QUIET);
 
 		bio->bi_size -= nbytes;
 		bio->bi_sector += (nbytes >> 9);
@@ -1329,13 +1329,13 @@ static void handle_bad_sector(struct bio *bio)
 	char b[BDEVNAME_SIZE];
 
 	printk(KERN_INFO "attempt to access beyond end of device\n");
-	printk(KERN_INFO "%s: rw=%ld, want=%Lu, limit=%Lu\n",
+	printk(KERN_INFO "%s: rw=%u, want=%Lu, limit=%Lu\n",
 			bdevname(bio->bi_bdev, b),
 			bio->bi_rw,
 			(unsigned long long)bio->bi_sector + bio_sectors(bio),
 			(long long)(bio->bi_bdev->bd_inode->i_size >> 9));
 
-	set_bit(BIO_EOF, &bio->bi_flags);
+	bio->bi_flags |= (1<<BIO_EOF);
 }
 
 #ifdef CONFIG_FAIL_MAKE_REQUEST
diff --git a/block/blk-lib.c b/block/blk-lib.c
index d0216b9..ee1f2d3 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -13,8 +13,8 @@ static void blkdev_discard_end_io(struct bio *bio, int err)
 {
 	if (err) {
 		if (err == -EOPNOTSUPP)
-			set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
-		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+			bio->bi_flags |= (1<<BIO_EOPNOTSUPP);
+		bio->bi_flags &= ~(1<<BIO_UPTODATE);
 	}
 
 	if (bio->bi_private)
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 8a549db..ce4a6a0 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -1450,7 +1450,7 @@ static void pkt_finish_packet(struct packet_data *pkt, int uptodate)
 
 static void pkt_run_state_machine(struct pktcdvd_device *pd, struct packet_data *pkt)
 {
-	int uptodate;
+	bool uptodate;
 
 	VPRINTK("run_state_machine: pkt %d\n", pkt->id);
 
@@ -1480,7 +1480,7 @@ static void pkt_run_state_machine(struct pktcdvd_device *pd, struct packet_data
 			if (atomic_read(&pkt->io_wait) > 0)
 				return;
 
-			if (test_bit(BIO_UPTODATE, &pkt->w_bio->bi_flags)) {
+			if (bio_flagged(pkt->w_bio, BIO_UPTODATE)) {
 				pkt_set_state(pkt, PACKET_FINISHED_STATE);
 			} else {
 				pkt_set_state(pkt, PACKET_RECOVERY_STATE);
@@ -1497,7 +1497,7 @@ static void pkt_run_state_machine(struct pktcdvd_device *pd, struct packet_data
 			break;
 
 		case PACKET_FINISHED_STATE:
-			uptodate = test_bit(BIO_UPTODATE, &pkt->w_bio->bi_flags);
+			uptodate = bio_flagged(pkt->w_bio, BIO_UPTODATE);
 			pkt_finish_packet(pkt, uptodate);
 			return;
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index cb20d0b..58162b1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -296,7 +296,7 @@ static void md_end_barrier(struct bio *bio, int err)
 	mdk_rdev_t *rdev = bio->bi_private;
 	mddev_t *mddev = rdev->mddev;
 	if (err == -EOPNOTSUPP && mddev->barrier != POST_REQUEST_BARRIER)
-		set_bit(BIO_EOPNOTSUPP, &mddev->barrier->bi_flags);
+		mddev->barrier->bi_flags |= (1<<BIO_EOPNOTSUPP);
 
 	rdev_dec_pending(rdev, mddev);
 
@@ -347,7 +347,7 @@ static void md_submit_barrier(struct work_struct *ws)
 
 	atomic_set(&mddev->flush_pending, 1);
 
-	if (test_bit(BIO_EOPNOTSUPP, &bio->bi_flags))
+	if (bio_flagged(bio, BIO_EOPNOTSUPP))
 		bio_endio(bio, -EOPNOTSUPP);
 	else if (bio->bi_size == 0)
 		/* an empty barrier - all done */
@@ -629,10 +629,10 @@ static void super_written(struct bio *bio, int error)
 	mdk_rdev_t *rdev = bio->bi_private;
 	mddev_t *mddev = rdev->mddev;
 
-	if (error || !test_bit(BIO_UPTODATE, &bio->bi_flags)) {
+	if (error || !bio_flagged(bio, BIO_UPTODATE)) {
 		printk("md: super_written gets error=%d, uptodate=%d\n",
-		       error, test_bit(BIO_UPTODATE, &bio->bi_flags));
-		WARN_ON(test_bit(BIO_UPTODATE, &bio->bi_flags));
+		       error, bio_flagged(bio, BIO_UPTODATE));
+		WARN_ON(bio_flagged(bio, BIO_UPTODATE));
 		md_error(mddev, rdev);
 	}
 
@@ -647,7 +647,7 @@ static void super_written_barrier(struct bio *bio, int error)
 	mdk_rdev_t *rdev = bio2->bi_private;
 	mddev_t *mddev = rdev->mddev;
 
-	if (!test_bit(BIO_UPTODATE, &bio->bi_flags) &&
+	if (!bio_flagged(bio, BIO_UPTODATE) &&
 	    error == -EOPNOTSUPP) {
 		unsigned long flags;
 		/* barriers don't appear to be supported :-( */
@@ -747,7 +747,7 @@ int sync_page_io(struct block_device *bdev, sector_t sector, int size,
 	submit_bio(rw, bio);
 	wait_for_completion(&event);
 
-	ret = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	ret = bio_flagged(bio, BIO_UPTODATE);
 	bio_put(bio);
 	return ret;
 }
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 410fb60..f57fc90 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -84,7 +84,7 @@ static void multipath_end_bh_io (struct multipath_bh *mp_bh, int err)
 
 static void multipath_end_request(struct bio *bio, int error)
 {
-	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	int uptodate = bio_flagged(bio, BIO_UPTODATE);
 	struct multipath_bh *mp_bh = bio->bi_private;
 	multipath_conf_t *conf = mp_bh->mddev->private;
 	mdk_rdev_t *rdev = conf->multipaths[mp_bh->path].rdev;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a948da8..8e43334 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -262,7 +262,7 @@ static inline void update_head_pos(int disk, r1bio_t *r1_bio)
 
 static void raid1_end_read_request(struct bio *bio, int error)
 {
-	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	bool uptodate = bio_flagged(bio, BIO_UPTODATE);
 	r1bio_t *r1_bio = bio->bi_private;
 	int mirror;
 	conf_t *conf = r1_bio->mddev->private;
@@ -285,7 +285,7 @@ static void raid1_end_read_request(struct bio *bio, int error)
 		if (r1_bio->mddev->degraded == conf->raid_disks ||
 		    (r1_bio->mddev->degraded == conf->raid_disks-1 &&
 		     !test_bit(Faulty, &conf->mirrors[mirror].rdev->flags)))
-			uptodate = 1;
+			uptodate = true;
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 	}
 
@@ -308,7 +308,7 @@ static void raid1_end_read_request(struct bio *bio, int error)
 
 static void raid1_end_write_request(struct bio *bio, int error)
 {
-	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	bool uptodate = bio_flagged(bio, BIO_UPTODATE);
 	r1bio_t *r1_bio = bio->bi_private;
 	int mirror, behind = test_bit(R1BIO_BehindIO, &r1_bio->state);
 	conf_t *conf = r1_bio->mddev->private;
@@ -1244,7 +1244,7 @@ static void end_sync_read(struct bio *bio, int error)
 	 * or re-read if the read failed.
 	 * We don't do much here, just schedule handling by raid1d
 	 */
-	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
+	if (bio_flagged(bio, BIO_UPTODATE))
 		set_bit(R1BIO_Uptodate, &r1_bio->state);
 
 	if (atomic_dec_and_test(&r1_bio->remaining))
@@ -1253,7 +1253,7 @@ static void end_sync_read(struct bio *bio, int error)
 
 static void end_sync_write(struct bio *bio, int error)
 {
-	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	bool uptodate = bio_flagged(bio, BIO_UPTODATE);
 	r1bio_t *r1_bio = bio->bi_private;
 	mddev_t *mddev = r1_bio->mddev;
 	conf_t *conf = mddev->private;
@@ -1318,7 +1318,7 @@ static void sync_request_write(mddev_t *mddev, r1bio_t *r1_bio)
 		}
 		for (primary=0; primary<mddev->raid_disks; primary++)
 			if (r1_bio->bios[primary]->bi_end_io == end_sync_read &&
-			    test_bit(BIO_UPTODATE, &r1_bio->bios[primary]->bi_flags)) {
+			    bio_flagged(r1_bio->bios[primary], BIO_UPTODATE)) {
 				r1_bio->bios[primary]->bi_end_io = NULL;
 				rdev_dec_pending(conf->mirrors[primary].rdev, mddev);
 				break;
@@ -1331,7 +1331,7 @@ static void sync_request_write(mddev_t *mddev, r1bio_t *r1_bio)
 				struct bio *pbio = r1_bio->bios[primary];
 				struct bio *sbio = r1_bio->bios[i];
 
-				if (test_bit(BIO_UPTODATE, &sbio->bi_flags)) {
+				if (bio_flagged(sbio, BIO_UPTODATE)) {
 					for (j = vcnt; j-- ; ) {
 						struct page *p, *s;
 						p = pbio->bi_io_vec[j].bv_page;
@@ -1346,7 +1346,7 @@ static void sync_request_write(mddev_t *mddev, r1bio_t *r1_bio)
 				if (j >= 0)
 					mddev->resync_mismatches += r1_bio->sectors;
 				if (j < 0 || (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)
-					      && test_bit(BIO_UPTODATE, &sbio->bi_flags))) {
+					      && bio_flagged(sbio, BIO_UPTODATE))) {
 					sbio->bi_end_io = NULL;
 					rdev_dec_pending(conf->mirrors[i].rdev, mddev);
 				} else {
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 42e64e4..4ae0e20 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -255,7 +255,7 @@ static inline void update_head_pos(int slot, r10bio_t *r10_bio)
 
 static void raid10_end_read_request(struct bio *bio, int error)
 {
-	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	bool uptodate = bio_flagged(bio, BIO_UPTODATE);
 	r10bio_t *r10_bio = bio->bi_private;
 	int slot, dev;
 	conf_t *conf = r10_bio->mddev->private;
@@ -297,7 +297,7 @@ static void raid10_end_read_request(struct bio *bio, int error)
 
 static void raid10_end_write_request(struct bio *bio, int error)
 {
-	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	bool uptodate = bio_flagged(bio, BIO_UPTODATE);
 	r10bio_t *r10_bio = bio->bi_private;
 	int slot, dev;
 	conf_t *conf = r10_bio->mddev->private;
@@ -1230,7 +1230,7 @@ static void end_sync_read(struct bio *bio, int error)
 	update_head_pos(i, r10_bio);
 	d = r10_bio->devs[i].devnum;
 
-	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
+	if (bio_flagged(bio, BIO_UPTODATE))
 		set_bit(R10BIO_Uptodate, &r10_bio->state);
 	else {
 		atomic_add(r10_bio->sectors,
@@ -1255,7 +1255,7 @@ static void end_sync_read(struct bio *bio, int error)
 
 static void end_sync_write(struct bio *bio, int error)
 {
-	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	bool uptodate = bio_flagged(bio, BIO_UPTODATE);
 	r10bio_t *r10_bio = bio->bi_private;
 	mddev_t *mddev = r10_bio->mddev;
 	conf_t *conf = mddev->private;
@@ -1313,7 +1313,7 @@ static void sync_request_write(mddev_t *mddev, r10bio_t *r10_bio)
 
 	/* find the first device with a block */
 	for (i=0; i<conf->copies; i++)
-		if (test_bit(BIO_UPTODATE, &r10_bio->devs[i].bio->bi_flags))
+		if (bio_flagged(r10_bio->devs[i].bio, BIO_UPTODATE))
 			break;
 
 	if (i == conf->copies)
@@ -1333,7 +1333,7 @@ static void sync_request_write(mddev_t *mddev, r10bio_t *r10_bio)
 			continue;
 		if (i == first)
 			continue;
-		if (test_bit(BIO_UPTODATE, &r10_bio->devs[i].bio->bi_flags)) {
+		if (bio_flagged(r10_bio->devs[i].bio, BIO_UPTODATE)) {
 			/* We know that the bi_io_vec layout is the same for
 			 * both 'first' and 'i', so we just compare them.
 			 * All vec entries are PAGE_SIZE;
@@ -2027,7 +2027,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 			int d = r10_bio->devs[i].devnum;
 			bio = r10_bio->devs[i].bio;
 			bio->bi_end_io = NULL;
-			clear_bit(BIO_UPTODATE, &bio->bi_flags);
+			bio->bi_flags &= ~(1<<BIO_UPTODATE);
 			if (conf->mirrors[d].rdev == NULL ||
 			    test_bit(Faulty, &conf->mirrors[d].rdev->flags))
 				continue;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 96c6902..b92baad 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -537,7 +537,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			set_bit(STRIPE_IO_STARTED, &sh->state);
 
 			bi->bi_bdev = rdev->bdev;
-			pr_debug("%s: for %llu schedule op %ld on disc %d\n",
+			pr_debug("%s: for %llu schedule op %u on disc %d\n",
 				__func__, (unsigned long long)sh->sector,
 				bi->bi_rw, i);
 			atomic_inc(&sh->count);
@@ -559,7 +559,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 		} else {
 			if (rw == WRITE)
 				set_bit(STRIPE_DEGRADED, &sh->state);
-			pr_debug("skip op %ld on disc %d for sector %llu\n",
+			pr_debug("skip op %u on disc %d for sector %llu\n",
 				bi->bi_rw, i, (unsigned long long)sh->sector);
 			clear_bit(R5_LOCKED, &sh->dev[i].flags);
 			set_bit(STRIPE_HANDLE, &sh->state);
@@ -1557,7 +1557,7 @@ static void raid5_end_read_request(struct bio * bi, int error)
 	struct stripe_head *sh = bi->bi_private;
 	raid5_conf_t *conf = sh->raid_conf;
 	int disks = sh->disks, i;
-	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
+	bool uptodate = bio_flagged(bi, BIO_UPTODATE);
 	char b[BDEVNAME_SIZE];
 	mdk_rdev_t *rdev;
 
@@ -1591,7 +1591,7 @@ static void raid5_end_read_request(struct bio * bi, int error)
 			atomic_set(&conf->disks[i].rdev->read_errors, 0);
 	} else {
 		const char *bdn = bdevname(conf->disks[i].rdev->bdev, b);
-		int retry = 0;
+		bool retry = false;
 		rdev = conf->disks[i].rdev;
 
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
@@ -1619,7 +1619,7 @@ static void raid5_end_read_request(struct bio * bi, int error)
 			       "md/raid:%s: Too many read errors, failing device %s.\n",
 			       mdname(conf->mddev), bdn);
 		else
-			retry = 1;
+			retry = true;
 		if (retry)
 			set_bit(R5_ReadError, &sh->dev[i].flags);
 		else {
@@ -1639,7 +1639,7 @@ static void raid5_end_write_request(struct bio *bi, int error)
 	struct stripe_head *sh = bi->bi_private;
 	raid5_conf_t *conf = sh->raid_conf;
 	int disks = sh->disks, i;
-	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
+	bool uptodate = bio_flagged(bi, BIO_UPTODATE);
 
 	for (i=0 ; i<disks; i++)
 		if (bi == &sh->dev[i].req)
@@ -2251,7 +2251,7 @@ handle_failed_stripe(raid5_conf_t *conf, struct stripe_head *sh,
 		while (bi && bi->bi_sector <
 			sh->dev[i].sector + STRIPE_SECTORS) {
 			struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
-			clear_bit(BIO_UPTODATE, &bi->bi_flags);
+			bi->bi_flags &= ~(1<<BIO_UPTODATE);
 			if (!raid5_dec_bi_phys_segments(bi)) {
 				md_write_end(conf->mddev);
 				bi->bi_next = *return_bi;
@@ -2266,7 +2266,7 @@ handle_failed_stripe(raid5_conf_t *conf, struct stripe_head *sh,
 		while (bi && bi->bi_sector <
 		       sh->dev[i].sector + STRIPE_SECTORS) {
 			struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
-			clear_bit(BIO_UPTODATE, &bi->bi_flags);
+			bi->bi_flags &= ~(1<<BIO_UPTODATE);
 			if (!raid5_dec_bi_phys_segments(bi)) {
 				md_write_end(conf->mddev);
 				bi->bi_next = *return_bi;
@@ -2290,7 +2290,7 @@ handle_failed_stripe(raid5_conf_t *conf, struct stripe_head *sh,
 			       sh->dev[i].sector + STRIPE_SECTORS) {
 				struct bio *nextbi =
 					r5_next_bio(bi, sh->dev[i].sector);
-				clear_bit(BIO_UPTODATE, &bi->bi_flags);
+				bi->bi_flags &= ~(1<<BIO_UPTODATE);
 				if (!raid5_dec_bi_phys_segments(bi)) {
 					bi->bi_next = *return_bi;
 					*return_bi = bi;
@@ -3787,7 +3787,7 @@ static void raid5_align_endio(struct bio *bi, int error)
 	struct bio* raid_bi  = bi->bi_private;
 	mddev_t *mddev;
 	raid5_conf_t *conf;
-	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
+	bool uptodate = bio_flagged(bi, BIO_UPTODATE);
 	mdk_rdev_t *rdev;
 
 	bio_put(bi);
@@ -4089,7 +4089,7 @@ static int make_request(mddev_t *mddev, struct bio * bi)
 			release_stripe(sh);
 		} else {
 			/* cannot get stripe for read-ahead, just give-up */
-			clear_bit(BIO_UPTODATE, &bi->bi_flags);
+			bi->bi_flags &= ~(1<<BIO_UPTODATE);
 			finish_wait(&conf->wait_for_overlap, &w);
 			break;
 		}
diff --git a/fs/bio.c b/fs/bio.c
index e7bf6ca..76192ca 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1423,8 +1423,8 @@ EXPORT_SYMBOL(bio_flush_dcache_pages);
 void bio_endio(struct bio *bio, int error)
 {
 	if (error)
-		clear_bit(BIO_UPTODATE, &bio->bi_flags);
-	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
+		bio->bi_flags &= ~(1<<BIO_UPTODATE);
+	else if (!bio_flagged(bio, BIO_UPTODATE))
 		error = -EIO;
 
 	if (bio->bi_end_io)
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d74e6af..c58bef8 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1759,17 +1759,17 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
  */
 static void end_bio_extent_readpage(struct bio *bio, int err)
 {
-	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	bool uptodate = bio_flagged(bio, BIO_UPTODATE);
 	struct bio_vec *bvec_end = bio->bi_io_vec + bio->bi_vcnt - 1;
 	struct bio_vec *bvec = bio->bi_io_vec;
 	struct extent_io_tree *tree;
 	u64 start;
 	u64 end;
-	int whole_page;
+	bool whole_page;
 	int ret;
 
 	if (err)
-		uptodate = 0;
+		uptodate = false;
 
 	do {
 		struct page *page = bvec->bv_page;
@@ -1780,9 +1780,9 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		end = start + bvec->bv_len - 1;
 
 		if (bvec->bv_offset == 0 && bvec->bv_len == PAGE_CACHE_SIZE)
-			whole_page = 1;
+			whole_page = true;
 		else
-			whole_page = 0;
+			whole_page = false;
 
 		if (++bvec <= bvec_end)
 			prefetchw(&bvec->bv_page->flags);
@@ -1791,17 +1791,16 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 			ret = tree->ops->readpage_end_io_hook(page, start, end,
 							      NULL);
 			if (ret)
-				uptodate = 0;
+				uptodate = false;
 		}
 		if (!uptodate && tree->ops &&
 		    tree->ops->readpage_io_failed_hook) {
 			ret = tree->ops->readpage_io_failed_hook(bio, page,
 							 start, end, NULL);
 			if (ret == 0) {
-				uptodate =
-					test_bit(BIO_UPTODATE, &bio->bi_flags);
+				uptodate = bio_flagged(bio, BIO_UPTODATE);
 				if (err)
-					uptodate = 0;
+					uptodate = false;
 				continue;
 			}
 		}
@@ -1841,7 +1840,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
  */
 static void end_bio_extent_preparewrite(struct bio *bio, int err)
 {
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	const bool uptodate = bio_flagged(bio, BIO_UPTODATE);
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
 	struct extent_io_tree *tree;
 	u64 start;
diff --git a/fs/buffer.c b/fs/buffer.c
index d54812b..94af2b9 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2997,14 +2997,14 @@ static void end_bio_bh_io_sync(struct bio *bio, int err)
 	struct buffer_head *bh = bio->bi_private;
 
 	if (err == -EOPNOTSUPP) {
-		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
+		bio->bi_flags |= (1<<BIO_EOPNOTSUPP);
 		set_bit(BH_Eopnotsupp, &bh->b_state);
 	}
 
-	if (unlikely (test_bit(BIO_QUIET,&bio->bi_flags)))
+	if (unlikely (bio_flagged(bio, BIO_QUIET)))
 		set_bit(BH_Quiet, &bh->b_state);
 
-	bh->b_end_io(bh, test_bit(BIO_UPTODATE, &bio->bi_flags));
+	bh->b_end_io(bh, bio_flagged(bio, BIO_UPTODATE));
 	bio_put(bio);
 }
 
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 7600aac..c7d3a0f 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -425,7 +425,7 @@ static struct bio *dio_await_one(struct dio *dio)
  */
 static int dio_bio_complete(struct dio *dio, struct bio *bio)
 {
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	const bool uptodate = bio_flagged(bio, BIO_UPTODATE);
 	struct bio_vec *bvec = bio->bi_io_vec;
 	int page_no;
 
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 377309c..f6d3216 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2598,7 +2598,7 @@ static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
 		submit_bio(WRITE, bio);
 		wait_for_completion(&event);
 
-		if (!test_bit(BIO_UPTODATE, &bio->bi_flags)) {
+		if (!bio_flagged(bio, BIO_UPTODATE)) {
 			bio_put(bio);
 			return -EIO;
 		}
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index c51af2a..b37ee3e 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -2216,7 +2216,7 @@ static void lbmIODone(struct bio *bio, int error)
 
 	bp->l_flag |= lbmDONE;
 
-	if (!test_bit(BIO_UPTODATE, &bio->bi_flags)) {
+	if (!bio_flagged(bio, BIO_UPTODATE)) {
 		bp->l_flag |= lbmERROR;
 
 		jfs_err("lbmIODone: I/O error in JFS log");
diff --git a/fs/jfs/jfs_metapage.c b/fs/jfs/jfs_metapage.c
index 48b44bd..9222e06 100644
--- a/fs/jfs/jfs_metapage.c
+++ b/fs/jfs/jfs_metapage.c
@@ -287,7 +287,7 @@ static void metapage_read_end_io(struct bio *bio, int err)
 {
 	struct page *page = bio->bi_private;
 
-	if (!test_bit(BIO_UPTODATE, &bio->bi_flags)) {
+	if (!bio_flagged(bio, BIO_UPTODATE)) {
 		printk(KERN_ERR "metapage_read_end_io: I/O error\n");
 		SetPageError(page);
 	}
@@ -344,7 +344,7 @@ static void metapage_write_end_io(struct bio *bio, int err)
 
 	BUG_ON(!PagePrivate(page));
 
-	if (! test_bit(BIO_UPTODATE, &bio->bi_flags)) {
+	if (!bio_flagged(bio, BIO_UPTODATE)) {
 		printk(KERN_ERR "metapage_write_end_io: I/O error\n");
 		SetPageError(page);
 	}
diff --git a/fs/logfs/dev_bdev.c b/fs/logfs/dev_bdev.c
index 9bd2ce2..ea48736 100644
--- a/fs/logfs/dev_bdev.c
+++ b/fs/logfs/dev_bdev.c
@@ -41,7 +41,7 @@ static int sync_request(struct page *page, struct block_device *bdev, int rw)
 	submit_bio(rw, &bio);
 	generic_unplug_device(bdev_get_queue(bdev));
 	wait_for_completion(&complete);
-	return test_bit(BIO_UPTODATE, &bio.bi_flags) ? 0 : -EIO;
+	return bio_flagged(bio, BIO_UPTODATE) ? 0 : -EIO;
 }
 
 static int bdev_readpage(void *_sb, struct page *page)
@@ -66,7 +66,7 @@ static DECLARE_WAIT_QUEUE_HEAD(wq);
 
 static void writeseg_end_io(struct bio *bio, int err)
 {
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	const bool uptodate = bio_flagged(bio, BIO_UPTODATE);
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
 	struct super_block *sb = bio->bi_private;
 	struct logfs_super *super = logfs_super(sb);
@@ -174,7 +174,7 @@ static void bdev_writeseg(struct super_block *sb, u64 ofs, size_t len)
 
 static void erase_end_io(struct bio *bio, int err) 
 { 
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags); 
+	const bool uptodate = bio_flagged(bio, BIO_UPTODATE); 
 	struct super_block *sb = bio->bi_private; 
 	struct logfs_super *super = logfs_super(sb); 
 
diff --git a/fs/mpage.c b/fs/mpage.c
index fd56ca2..3be5895 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -42,7 +42,7 @@
  */
 static void mpage_end_io_read(struct bio *bio, int err)
 {
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	const bool uptodate = bio_flagged(bio, BIO_UPTODATE);
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
 
 	do {
@@ -64,7 +64,7 @@ static void mpage_end_io_read(struct bio *bio, int err)
 
 static void mpage_end_io_write(struct bio *bio, int err)
 {
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	const bool uptodate = bio_flagged(bio, BIO_UPTODATE);
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
 
 	do {
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 2e6a272..d3ef05c 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -349,11 +349,11 @@ void nilfs_add_checksums_on_logs(struct list_head *logs, u32 seed)
  */
 static void nilfs_end_bio_write(struct bio *bio, int err)
 {
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	const bool uptodate = bio_flagged(bio, BIO_UPTODATE);
 	struct nilfs_segment_buffer *segbuf = bio->bi_private;
 
 	if (err == -EOPNOTSUPP) {
-		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
+		bio->bi_flags |= (1<<BIO_EOPNOTSUPP);
 		bio_put(bio);
 		/* to be detected by submit_seg_bio() */
 	}
diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 34640d6..055de11 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -351,7 +351,7 @@ xfs_end_bio(
 	xfs_ioend_t		*ioend = bio->bi_private;
 
 	ASSERT(atomic_read(&bio->bi_cnt) >= 1);
-	ioend->io_error = test_bit(BIO_UPTODATE, &bio->bi_flags) ? 0 : error;
+	ioend->io_error = bio_flagged(bio, BIO_UPTODATE) ? 0 : error;
 
 	/* Toss bio and pass work off to an xfsdatad thread */
 	bio->bi_private = NULL;
diff --git a/mm/bounce.c b/mm/bounce.c
index 13b6dad..7a435fd 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -127,8 +127,7 @@ static void bounce_end_io(struct bio *bio, mempool_t *pool, int err)
 	struct bio_vec *bvec, *org_vec;
 	int i;
 
-	if (test_bit(BIO_EOPNOTSUPP, &bio->bi_flags))
-		set_bit(BIO_EOPNOTSUPP, &bio_orig->bi_flags);
+	bio->bi_flags |= bio_orig->bi_flags & (1<<BIO_EOPNOTSUPP);
 
 	/*
 	 * free up bounce indirect pages used
@@ -161,7 +160,7 @@ static void __bounce_end_io_read(struct bio *bio, mempool_t *pool, int err)
 {
 	struct bio *bio_orig = bio->bi_private;
 
-	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
+	if (bio_flagged(bio, BIO_UPTODATE))
 		copy_to_high_bio_irq(bio_orig, bio);
 
 	bounce_end_io(bio, pool, err);
diff --git a/mm/page_io.c b/mm/page_io.c
index 31a3b96..11a16b0 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -42,7 +42,7 @@ static struct bio *get_swap_bio(gfp_t gfp_flags,
 
 static void end_swap_bio_write(struct bio *bio, int err)
 {
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	const bool uptodate = bio_flagged(bio, BIO_UPTODATE);
 	struct page *page = bio->bi_io_vec[0].bv_page;
 
 	if (!uptodate) {
@@ -68,7 +68,7 @@ static void end_swap_bio_write(struct bio *bio, int err)
 
 void end_swap_bio_read(struct bio *bio, int err)
 {
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	const bool uptodate = bio_flagged(bio, BIO_UPTODATE);
 	struct page *page = bio->bi_io_vec[0].bv_page;
 
 	if (!uptodate) {

