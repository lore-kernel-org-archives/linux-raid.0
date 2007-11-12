From: Neil Brown <neilb@suse.de>
Subject: Re: Building a new raid6 with bitmap does not clear bits during resync
Date: Mon, 12 Nov 2007 17:30:02 +1100
Message-ID: <18231.62186.908021.981786@notabene.brown>
References: <87lk98ad7e.fsf@informatik.uni-tuebingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Goswin von Brederlow on Thursday November 8
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday November 8, brederlo@informatik.uni-tuebingen.de wrote:
> Hi,
> 
> I have created a new raid6:
> 
> md0 : active raid6 sdb1[0] sdl1[5] sdj1[4] sdh1[3] sdf1[2] sdd1[1]
>       6834868224 blocks level 6, 512k chunk, algorithm 2 [6/6] [UUUUUU]
>       [====>................]  resync = 21.5% (368216964/1708717056) finish=448.5min speed=49808K/sec
>       bitmap: 204/204 pages [816KB], 4096KB chunk
> 
> The raid is totally idle, not mounted and nothing.
> 
> So why does the "bitmap: 204/204" not sink? I would expect it to clear
> bits as it resyncs so it should count slowly down to 0. As a side
> effect of the bitmap being all dirty the resync will restart from the
> beginning when the system is hard reset. As you can imagine that is
> pretty anoying.
> 
> On the other hand on a clean shutdown it seems the bitmap gets updated
> before stopping the array:
> 
> md3 : active raid6 sdc1[0] sdm1[5] sdk1[4] sdi1[3] sdg1[2] sde1[1]
>       6834868224 blocks level 6, 512k chunk, algorithm 2 [6/6] [UUUUUU]
>       [=======>.............]  resync = 38.4% (656155264/1708717056) finish=17846.4min speed=982K/sec
>       bitmap: 187/204 pages [748KB], 4096KB chunk
> 
> Consequently the rebuild did restart and is already further along.
> 

Thanks for the report.

> 
> Any ideas why that is so?

Yes.  The following patch should explain (a bit tersely) why this was
so, and should also fix it so it will no longer be so.  Test reports
always welcome.

NeilBrown

Status: ok

Update md bitmap during resync.

Currently and md array with a write-intent bitmap does not updated
that bitmap to reflect successful partial resync.  Rather the entire
bitmap is updated when the resync completes.

This is because there is no guarentee that resync requests will
complete in order, and tracking each request individually is
unnecessarily burdensome.

However there is value in regularly updating the bitmap, so add code
to periodically pause while all pending sync requests complete, then
update the bitmap.  Doing this only every few seconds (the same as the
bitmap update time) does not notciable affect resync performance.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c         |   34 +++++++++++++++++++++++++++++-----
 ./drivers/md/raid1.c          |    1 +
 ./drivers/md/raid10.c         |    2 ++
 ./drivers/md/raid5.c          |    3 +++
 ./include/linux/raid/bitmap.h |    3 +++
 5 files changed, 38 insertions(+), 5 deletions(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2007-10-22 16:55:52.000000000 +1000
+++ ./drivers/md/bitmap.c	2007-11-12 16:36:30.000000000 +1100
@@ -1349,14 +1349,38 @@ void bitmap_close_sync(struct bitmap *bi
 	 */
 	sector_t sector = 0;
 	int blocks;
-	if (!bitmap) return;
+	if (!bitmap)
+		return;
 	while (sector < bitmap->mddev->resync_max_sectors) {
 		bitmap_end_sync(bitmap, sector, &blocks, 0);
-/*
-		if (sector < 500) printk("bitmap_close_sync: sec %llu blks %d\n",
-					 (unsigned long long)sector, blocks);
-*/		sector += blocks;
+		sector += blocks;
+	}
+}
+
+void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector)
+{
+	sector_t s = 0;
+	int blocks;
+
+	if (!bitmap)
+		return;
+	if (sector == 0) {
+		bitmap->last_end_sync = jiffies;
+		return;
+	}
+	if (time_before(jiffies, (bitmap->last_end_sync
+				  + bitmap->daemon_sleep * HZ)))
+		return;
+	wait_event(bitmap->mddev->recovery_wait,
+		   atomic_read(&bitmap->mddev->recovery_active) == 0);
+
+	sector &= ~((1ULL << CHUNK_BLOCK_SHIFT(bitmap)) - 1);
+	s = 0;
+	while (s < sector && s < bitmap->mddev->resync_max_sectors) {
+		bitmap_end_sync(bitmap, s, &blocks, 0);
+		s += blocks;
 	}
+	bitmap->last_end_sync = jiffies;
 }
 
 static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int needed)

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2007-10-30 13:50:45.000000000 +1100
+++ ./drivers/md/raid10.c	2007-11-12 16:06:39.000000000 +1100
@@ -1671,6 +1671,8 @@ static sector_t sync_request(mddev_t *md
 	if (!go_faster && conf->nr_waiting)
 		msleep_interruptible(1000);
 
+	bitmap_cond_end_sync(mddev->bitmap, sector_nr);
+
 	/* Again, very different code for resync and recovery.
 	 * Both must result in an r10bio with a list of bios that
 	 * have bi_end_io, bi_sector, bi_bdev set,

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2007-10-30 13:50:45.000000000 +1100
+++ ./drivers/md/raid1.c	2007-11-12 16:06:12.000000000 +1100
@@ -1685,6 +1685,7 @@ static sector_t sync_request(mddev_t *md
 	if (!go_faster && conf->nr_waiting)
 		msleep_interruptible(1000);
 
+	bitmap_cond_end_sync(mddev->bitmap, sector_nr);
 	raise_barrier(conf);
 
 	conf->next_resync = sector_nr;

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-10-30 13:50:45.000000000 +1100
+++ ./drivers/md/raid5.c	2007-11-12 16:07:05.000000000 +1100
@@ -4331,6 +4331,9 @@ static inline sector_t sync_request(mdde
 		return sync_blocks * STRIPE_SECTORS; /* keep things rounded to whole stripes */
 	}
 
+
+	bitmap_cond_end_sync(mddev->bitmap, sector_nr);
+
 	pd_idx = stripe_to_pdidx(sector_nr, conf, raid_disks);
 
 	sh = wait_for_inactive_cache(conf, sector_nr, raid_disks, pd_idx);

diff .prev/include/linux/raid/bitmap.h ./include/linux/raid/bitmap.h
--- .prev/include/linux/raid/bitmap.h	2007-11-12 14:55:51.000000000 +1100
+++ ./include/linux/raid/bitmap.h	2007-11-12 16:08:41.000000000 +1100
@@ -244,6 +244,8 @@ struct bitmap {
 	 */
 	unsigned long daemon_lastrun; /* jiffies of last run */
 	unsigned long daemon_sleep; /* how many seconds between updates? */
+	unsigned long last_end_sync; /* when we lasted called end_sync to
+				      * update bitmap with resync progress */
 
 	atomic_t pending_writes; /* pending writes to the bitmap file */
 	wait_queue_head_t write_wait;
@@ -275,6 +277,7 @@ void bitmap_endwrite(struct bitmap *bitm
 int bitmap_start_sync(struct bitmap *bitmap, sector_t offset, int *blocks, int degraded);
 void bitmap_end_sync(struct bitmap *bitmap, sector_t offset, int *blocks, int aborted);
 void bitmap_close_sync(struct bitmap *bitmap);
+void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector);
 
 void bitmap_unplug(struct bitmap *bitmap);
 void bitmap_daemon_work(struct bitmap *bitmap);
