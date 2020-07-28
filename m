From: Xiao Ni <xni@redhat.com>
Subject: [PATCH V2 3/3] improve raid10 discard request
Date: Tue, 28 Jul 2020 15:18:23 +0800
Message-ID: <1595920703-6125-4-git-send-email-xni@redhat.com>
References: <1595920703-6125-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1595920703-6125-1-git-send-email-xni@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org, linux-raid@vger.kernel.org
Cc: colyli@suse.de, ncroxon@redhat.com, heinzm@redhat.com
List-Id: linux-raid.ids

Now the discard request is split by chunk size. So it takes a long time
to finish mkfs on disks which support discard function. This patch improve
handling raid10 discard request. It uses the similar way with patch
29efc390b (md/md0: optimize raid0 discard handling).

But it's a little complex than raid0. Because raid10 has different layout.
If raid10 is offset layout and the discard request is smaller than stripe
size. There are some holes when we submit discard bio to underlayer disks.

For example: five disks (disk1 - disk5)
D01 D02 D03 D04 D05
D05 D01 D02 D03 D04
D06 D07 D08 D09 D10
D10 D06 D07 D08 D09
The discard bio just wants to discard from D03 to D10. For disk3, there is
a hole between D03 and D08. For disk4, there is a hole between D04 and D09.
D03 is a chunk, raid10_write_request can handle one chunk perfectly. So
the part that is not aligned with stripe size is still handled by
raid10_write_request.

If reshape is running when discard bio comes and the discard bio spans the
reshape position, raid10_write_request is responsible to handle this
discard bio.

I did a test with this patch set.
Without patch:
time mkfs.xfs /dev/md0
real4m39.775s
user0m0.000s
sys0m0.298s

With patch:
time mkfs.xfs /dev/md0
real0m0.105s
user0m0.000s
sys0m0.007s

nvme3n1           259:1    0   477G  0 disk
└─nvme3n1p1       259:10   0    50G  0 part
nvme4n1           259:2    0   477G  0 disk
└─nvme4n1p1       259:11   0    50G  0 part
nvme5n1           259:6    0   477G  0 disk
└─nvme5n1p1       259:12   0    50G  0 part
nvme2n1           259:9    0   477G  0 disk
└─nvme2n1p1       259:15   0    50G  0 part
nvme0n1           259:13   0   477G  0 disk
└─nvme0n1p1       259:14   0    50G  0 part

v1:
Coly helps to review these patches and give some suggestions:
One bug is found. If discard bio is across one stripe but bio size is bigger
than one stripe size. After spliting, the bio will be NULL. In this version,
it checks whether discard bio size is bigger than 2*stripe_size.
In raid10_end_discard_request, it's better to check R10BIO_Uptodate is set
or not. It can avoid write memory to improve performance.
Add more comments for calculating addresses.

v2:
Fix error by checkpatch.pl
Fix one bug for offset layout. v1 calculates wrongly split size
Add more comments to explain how the discard range of each component disk
is decided.

Reviewed-by: Coly Li <colyli@suse.de>
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/raid10.c | 287 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 286 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 2a7423e..ad56563 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1518,6 +1518,287 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 		raid10_write_request(mddev, bio, r10_bio);
 }
 
+static void wait_blocked_dev(struct mddev *mddev, int cnt)
+{
+	int i;
+	struct r10conf *conf = mddev->private;
+	struct md_rdev *blocked_rdev = NULL;
+
+retry_wait:
+	rcu_read_lock();
+	for (i = 0; i < cnt; i++) {
+		struct md_rdev *rdev = rcu_dereference(conf->mirrors[i].rdev);
+		struct md_rdev *rrdev = rcu_dereference(
+			conf->mirrors[i].replacement);
+		if (rdev == rrdev)
+			rrdev = NULL;
+		if (rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
+			atomic_inc(&rdev->nr_pending);
+			blocked_rdev = rdev;
+			break;
+		}
+		if (rrdev && unlikely(test_bit(Blocked, &rrdev->flags))) {
+			atomic_inc(&rrdev->nr_pending);
+			blocked_rdev = rrdev;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	if (unlikely(blocked_rdev)) {
+		/* Have to wait for this device to get unblocked, then retry */
+		allow_barrier(conf);
+		raid10_log(conf->mddev, "%s wait rdev %d blocked",
+				__func__, blocked_rdev->raid_disk);
+		md_wait_for_blocked_rdev(blocked_rdev, mddev);
+		wait_barrier(conf);
+		goto retry_wait;
+	}
+}
+
+static struct bio *raid10_split_bio(struct r10conf *conf,
+			struct bio *bio, sector_t sectors, bool want_first)
+{
+	struct bio *split;
+
+	split = bio_split(bio, sectors,	GFP_NOIO, &conf->bio_split);
+	bio_chain(split, bio);
+	allow_barrier(conf);
+	if (want_first) {
+		submit_bio_noacct(bio);
+		bio = split;
+	} else
+		submit_bio_noacct(split);
+	wait_barrier(conf);
+
+	return bio;
+}
+
+static void raid10_end_discard_request(struct bio *bio)
+{
+	struct r10bio *r10_bio = bio->bi_private;
+	struct r10conf *conf = r10_bio->mddev->private;
+	struct md_rdev *rdev = NULL;
+	int dev;
+	int slot, repl;
+
+	/*
+	 * We don't care the return value of discard bio
+	 */
+	if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
+		set_bit(R10BIO_Uptodate, &r10_bio->state);
+
+	dev = find_bio_disk(conf, r10_bio, bio, &slot, &repl);
+	if (repl)
+		rdev = conf->mirrors[dev].replacement;
+	if (!rdev) {
+		smp_rmb();
+		repl = 0;
+		rdev = conf->mirrors[dev].rdev;
+	}
+
+	if (atomic_dec_and_test(&r10_bio->remaining)) {
+		md_write_end(r10_bio->mddev);
+		raid_end_bio_io(r10_bio);
+	}
+
+	rdev_dec_pending(rdev, conf->mddev);
+}
+
+/* There are some limitations to handle discard bio
+ * 1st, the discard size is bigger than stripe_size*2.
+ * 2st, if the discard bio spans reshape progress, we use the old way to
+ * handle discard bio
+ */
+static bool raid10_handle_discard(struct mddev *mddev, struct bio *bio)
+{
+	struct r10conf *conf = mddev->private;
+	struct geom geo = conf->geo;
+	struct r10bio *r10_bio;
+
+	int disk;
+	sector_t chunk;
+	int stripe_size, stripe_mask;
+
+	sector_t bio_start, bio_end;
+	sector_t first_stripe_index, last_stripe_index;
+	sector_t start_disk_offset;
+	unsigned int start_disk_index;
+	sector_t end_disk_offset;
+	unsigned int end_disk_index;
+
+	wait_barrier(conf);
+
+	if (conf->reshape_progress != MaxSector &&
+	    ((bio->bi_iter.bi_sector >= conf->reshape_progress) !=
+	     conf->mddev->reshape_backwards))
+		geo = conf->prev;
+
+	stripe_size = (1<<geo.chunk_shift) * geo.raid_disks;
+	stripe_mask = stripe_size - 1;
+
+	bio_start = bio->bi_iter.bi_sector;
+	bio_end = bio_end_sector(bio);
+
+	/* Maybe one discard bio is smaller than strip size or across one stripe
+	 * and discard region is larger than one stripe size. For far offset layout,
+	 * if the discard region is not aligned with stripe size, there is hole
+	 * when we submit discard bio to member disk. For simplicity, we only
+	 * handle discard bio which discard region is bigger than stripe_size*2
+	 */
+	if (bio_sectors(bio) < stripe_size*2)
+		goto out;
+
+	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
+		bio_start < conf->reshape_progress &&
+		bio_end > conf->reshape_progress)
+		goto out;
+
+	/* For far offset layout, if bio is not aligned with stripe size, it splits
+	 * the part that is not aligned with strip size.
+	 */
+	if (geo.far_offset && (bio_start & stripe_mask)) {
+		sector_t split_size;
+		split_size = round_up(bio_start, stripe_size) - bio_start;
+		bio = raid10_split_bio(conf, bio, split_size, false);
+	}
+	if (geo.far_offset && (bio_end & stripe_mask)) {
+		sector_t split_size;
+		split_size = bio_sectors(bio) - (bio_end & stripe_mask);
+		bio = raid10_split_bio(conf, bio, split_size, true);
+	}
+
+	r10_bio = mempool_alloc(&conf->r10bio_pool, GFP_NOIO);
+	r10_bio->mddev = mddev;
+	r10_bio->state = 0;
+	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * conf->geo.raid_disks);
+
+	wait_blocked_dev(mddev, geo.raid_disks);
+
+	r10_bio->master_bio = bio;
+
+	bio_start = bio->bi_iter.bi_sector;
+	bio_end = bio_end_sector(bio);
+
+	/* raid10 uses chunk as the unit to store data. It's similar like raid0.
+	 * One stripe contains the chunks from all member disk (one chunk from
+	 * one disk at the same HAB address). For layout detail, see 'man md 4'
+	 */
+	chunk = bio_start >> geo.chunk_shift;
+	chunk *= geo.near_copies;
+	first_stripe_index = chunk;
+	start_disk_index = sector_div(first_stripe_index, geo.raid_disks);
+	if (geo.far_offset)
+		first_stripe_index *= geo.far_copies;
+	start_disk_offset = (bio_start & geo.chunk_mask) +
+				(first_stripe_index << geo.chunk_shift);
+
+	chunk = bio_end >> geo.chunk_shift;
+	chunk *= geo.near_copies;
+	last_stripe_index = chunk;
+	end_disk_index = sector_div(last_stripe_index, geo.raid_disks);
+	if (geo.far_offset)
+		last_stripe_index *= geo.far_copies;
+	end_disk_offset = (bio_end & geo.chunk_mask) +
+				(last_stripe_index << geo.chunk_shift);
+
+	rcu_read_lock();
+	for (disk = 0; disk < geo.raid_disks; disk++) {
+		struct md_rdev *rdev = rcu_dereference(conf->mirrors[disk].rdev);
+		struct md_rdev *rrdev = rcu_dereference(
+			conf->mirrors[disk].replacement);
+
+		r10_bio->devs[disk].bio = NULL;
+		r10_bio->devs[disk].repl_bio = NULL;
+
+		if (rdev && (test_bit(Faulty, &rdev->flags)))
+			rdev = NULL;
+		if (rrdev && (test_bit(Faulty, &rrdev->flags)))
+			rrdev = NULL;
+		if (!rdev && !rrdev)
+			continue;
+
+		if (rdev) {
+			r10_bio->devs[disk].bio = bio;
+			atomic_inc(&rdev->nr_pending);
+		}
+		if (rrdev) {
+			r10_bio->devs[disk].repl_bio = bio;
+			atomic_inc(&rrdev->nr_pending);
+		}
+	}
+	rcu_read_unlock();
+
+	atomic_set(&r10_bio->remaining, 1);
+	for (disk = 0; disk < geo.raid_disks; disk++) {
+		sector_t dev_start, dev_end;
+		struct bio *mbio, *rbio = NULL;
+		struct md_rdev *rdev = rcu_dereference(conf->mirrors[disk].rdev);
+		struct md_rdev *rrdev = rcu_dereference(
+			conf->mirrors[disk].replacement);
+
+		/*
+		 * Now start to calculate the start and end address for each disk.
+		 * The space between dev_start and dev_end is the discard region.
+		 *
+		 * For dev_start, it needs to consider three conditions:
+		 * 1st, the disk is before start_disk, you can imagine the disk in
+		 * the next stripe. So the dev_start is the start address of next
+		 * stripe.
+		 * 2st, the disk is after start_disk, it means the disk is at the
+		 * same stripe of first disk
+		 * 3st, the first disk itself, we can use start_disk_offset directly
+		 */
+		if (disk < start_disk_index)
+			dev_start = (first_stripe_index + 1) * mddev->chunk_sectors;
+		else if (disk > start_disk_index)
+			dev_start = first_stripe_index * mddev->chunk_sectors;
+		else
+			dev_start = start_disk_offset;
+
+		if (disk < end_disk_index)
+			dev_end = (last_stripe_index + 1) * mddev->chunk_sectors;
+		else if (disk > end_disk_index)
+			dev_end = last_stripe_index * mddev->chunk_sectors;
+		else
+			dev_end = end_disk_offset;
+
+		/* It only handles discard bio which size is >= stripe size, so
+		 * dev_end > dev_start all the time
+		 */
+		if (r10_bio->devs[disk].bio) {
+			mbio = bio_clone_fast(bio, GFP_NOIO, &mddev->bio_set);
+			mbio->bi_end_io = raid10_end_discard_request;
+			mbio->bi_private = r10_bio;
+			r10_bio->devs[disk].bio = mbio;
+			r10_bio->devs[disk].devnum = disk;
+			atomic_inc(&r10_bio->remaining);
+			md_submit_discard_bio(mddev, rdev, mbio, dev_start, dev_end);
+			bio_endio(mbio);
+		}
+		if (r10_bio->devs[disk].repl_bio) {
+			rbio = bio_clone_fast(bio, GFP_NOIO, &mddev->bio_set);
+			rbio->bi_end_io = raid10_end_discard_request;
+			rbio->bi_private = r10_bio;
+			r10_bio->devs[disk].repl_bio = rbio;
+			r10_bio->devs[disk].devnum = disk;
+			atomic_inc(&r10_bio->remaining);
+			md_submit_discard_bio(mddev, rrdev, rbio, dev_start, dev_end);
+			bio_endio(rbio);
+		}
+	}
+
+	if (atomic_dec_and_test(&r10_bio->remaining)) {
+		md_write_end(r10_bio->mddev);
+		raid_end_bio_io(r10_bio);
+	}
+
+	return 0;
+out:
+	allow_barrier(conf);
+	return -EAGAIN;
+}
+
 static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
 {
 	struct r10conf *conf = mddev->private;
@@ -1532,6 +1813,10 @@ static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
 	if (!md_write_start(mddev, bio))
 		return false;
 
+	if (unlikely(bio_op(bio) == REQ_OP_DISCARD))
+		if (!raid10_handle_discard(mddev, bio))
+			return true;
+
 	/*
 	 * If this request crosses a chunk boundary, we need to split
 	 * it.
@@ -3762,7 +4047,7 @@ static int raid10_run(struct mddev *mddev)
 	chunk_size = mddev->chunk_sectors << 9;
 	if (mddev->queue) {
 		blk_queue_max_discard_sectors(mddev->queue,
-					      mddev->chunk_sectors);
+					      UINT_MAX);
 		blk_queue_max_write_same_sectors(mddev->queue, 0);
 		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
 		blk_queue_io_min(mddev->queue, chunk_size);
-- 
2.7.5
