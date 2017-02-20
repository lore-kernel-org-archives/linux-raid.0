From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH V3 1/2] RAID1: a new I/O barrier implementation to remove
 resync window
Date: Sun, 19 Feb 2017 23:04:30 -0800
Message-ID: <20170220070430.4mca7clpaw7kpj4j@kernel.org>
References: <1487176523-109075-1-git-send-email-colyli@suse.de>
 <87shnevcpr.fsf@notabene.neil.brown.name>
 <2f6b3d68-1536-3167-7362-78fdfa91e149@suse.de>
 <87shn9spsy.fsf@notabene.neil.brown.name>
 <87k28lshg5.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87k28lshg5.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Coly Li <colyli@suse.de>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

On Mon, Feb 20, 2017 at 01:51:22PM +1100, Neil Brown wrote:
> On Mon, Feb 20 2017, NeilBrown wrote:
> 
> > On Fri, Feb 17 2017, Coly Li wrote:
> >
> >> On 2017/2/16 下午3:04, NeilBrown wrote:
> >>> I know you are going to change this as Shaohua wantsthe spitting to
> >>> happen in a separate function, which I agree with, but there is 
> >>> something else wrong here. Calling bio_split/bio_chain repeatedly
> >>> in a loop is dangerous. It is OK for simple devices, but when one
> >>> request can wait for another request to the same device it can
> >>> deadlock. This can happen with raid1.  If a resync request calls
> >>> raise_barrier() between one request and the next, then the next has
> >>> to wait for the resync request, which has to wait for the first
> >>> request. As the first request will be stuck in the queue in 
> >>> generic_make_request(), you get a deadlock.
> >>
> >> For md raid1, queue in generic_make_request(), can I understand it as
> >> bio_list_on_stack in this function? And queue in underlying device,
> >> can I understand it as the data structures like plug->pending and
> >> conf->pending_bio_list ?
> >
> > Yes, the queue in generic_make_request() is the bio_list_on_stack.  That
> > is the only queue I am talking about.  I'm not referring to
> > plug->pending or conf->pending_bio_list at all.
> >
> >>
> >> I still don't get the point of deadlock, let me try to explain why I
> >> don't see the possible deadlock. If a bio is split, and the first part
> >> is processed by make_request_fn(), and then a resync comes and it will
> >> raise a barrier, there are 3 possible conditions,
> >> - the resync I/O tries to raise barrier on same bucket of the first
> >> regular bio. Then the resync task has to wait to the first bio drops
> >> its conf->nr_pending[idx]
> >
> > Not quite.
> > First, the resync task (in raise_barrier()) will wait for ->nr_waiting[idx]
> > to be zero.  We can assume this happens immediately.
> > Then the resync_task will increment ->barrier[idx].
> > Only then will it wait for the first bio to drop ->nr_pending[idx].
> > The processing of that first bio will have submitted bios to the
> > underlying device, and they will be in the bio_list_on_stack queue, and
> > will not be processed until raid1_make_request() completes.
> >
> > The loop in raid1_make_request() will then call make_request_fn() which
> > will call wait_barrier(), which will wait for ->barrier[idx] to be
> > zero.
> 
> Thinking more carefully about this.. the 'idx' that the second bio will
> wait for will normally be different, so there won't be a deadlock after
> all.
> 
> However it is possible for hash_long() to produce the same idx for two
> consecutive barrier_units so there is still the possibility of a
> deadlock, though it isn't as likely as I thought at first.

Wrapped the function pointer issue Neil pointed out into Coly's original patch.
Also fix a 'use-after-free' bug. For the deadlock issue, I'll add below patch,
please check.

Thanks,
Shaohua

From ee9c98138bcdf8bceef384a68f49258b6b8b8c6d Mon Sep 17 00:00:00 2001
Message-Id: <ee9c98138bcdf8bceef384a68f49258b6b8b8c6d.1487573888.git.shli@fb.com>
From: Shaohua Li <shli@fb.com>
Date: Sun, 19 Feb 2017 22:18:32 -0800
Subject: [PATCH] md/raid1/10: fix potential deadlock

Neil Brown pointed out a potential deadlock in raid 10 code with
bio_split/chain. The raid1 code could have the same issue, but recent
barrier rework makes it less likely to happen. The deadlock happens in
below sequence:

1. generic_make_request(bio), this will set current->bio_list
2. raid10_make_request will split bio to bio1 and bio2
3. __make_request(bio1), wait_barrer, add underlayer disk bio to
current->bio_list
4. __make_request(bio2), wait_barrer

If raise_barrier happens between 3 & 4, since wait_barrier runs at 3,
raise_barrier waits for IO completion from 3. And since raise_barrier
sets barrier, 4 waits for raise_barrier. But IO from 3 can't be
dispatched because raid10_make_request() doesn't finished yet.

The solution is to adjust the IO ordering. Quotes from Neil:
"
It is much safer to:

    if (need to split) {
        split = bio_split(bio, ...)
        bio_chain(...)
        make_request_fn(split);
        generic_make_request(bio);
   } else
        make_request_fn(mddev, bio);

This way we first process the initial section of the bio (in 'split')
which will queue some requests to the underlying devices.  These
requests will be queued in generic_make_request.
Then we queue the remainder of the bio, which will be added to the end
of the generic_make_request queue.
Then we return.
generic_make_request() will pop the lower-level device requests off the
queue and handle them first.  Then it will process the remainder
of the original bio once the first section has been fully processed.
"

Cc: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org (v3.14+, only the raid10 part)
Suggested-by: NeilBrown <neilb@suse.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid1.c  | 28 ++++++++++++++--------------
 drivers/md/raid10.c | 41 ++++++++++++++++++++---------------------
 2 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 676f72d..e55d865 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1566,21 +1566,21 @@ static void raid1_make_request(struct mddev *mddev, struct bio *bio)
 	sector_t sectors;
 
 	/* if bio exceeds barrier unit boundary, split it */
-	do {
-		sectors = align_to_barrier_unit_end(
-				bio->bi_iter.bi_sector, bio_sectors(bio));
-		if (sectors < bio_sectors(bio)) {
-			split = bio_split(bio, sectors, GFP_NOIO, fs_bio_set);
-			bio_chain(split, bio);
-		} else {
-			split = bio;
-		}
+	sectors = align_to_barrier_unit_end(
+			bio->bi_iter.bi_sector, bio_sectors(bio));
+	if (sectors < bio_sectors(bio)) {
+		split = bio_split(bio, sectors, GFP_NOIO, fs_bio_set);
+		bio_chain(split, bio);
+	} else {
+		split = bio;
+	}
 
-		if (bio_data_dir(split) == READ)
-			raid1_read_request(mddev, split);
-		else
-			raid1_write_request(mddev, split);
-	} while (split != bio);
+	if (bio_data_dir(split) == READ)
+		raid1_read_request(mddev, split);
+	else
+		raid1_write_request(mddev, split);
+	if (split != bio)
+		generic_make_request(bio);
 }
 
 static void raid1_status(struct seq_file *seq, struct mddev *mddev)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a1f8e98..b495049 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1551,28 +1551,27 @@ static void raid10_make_request(struct mddev *mddev, struct bio *bio)
 		return;
 	}
 
-	do {
-
-		/*
-		 * If this request crosses a chunk boundary, we need to split
-		 * it.
-		 */
-		if (unlikely((bio->bi_iter.bi_sector & chunk_mask) +
-			     bio_sectors(bio) > chunk_sects
-			     && (conf->geo.near_copies < conf->geo.raid_disks
-				 || conf->prev.near_copies <
-				 conf->prev.raid_disks))) {
-			split = bio_split(bio, chunk_sects -
-					  (bio->bi_iter.bi_sector &
-					   (chunk_sects - 1)),
-					  GFP_NOIO, fs_bio_set);
-			bio_chain(split, bio);
-		} else {
-			split = bio;
-		}
+	/*
+	 * If this request crosses a chunk boundary, we need to split
+	 * it.
+	 */
+	if (unlikely((bio->bi_iter.bi_sector & chunk_mask) +
+		     bio_sectors(bio) > chunk_sects
+		     && (conf->geo.near_copies < conf->geo.raid_disks
+			 || conf->prev.near_copies <
+			 conf->prev.raid_disks))) {
+		split = bio_split(bio, chunk_sects -
+				  (bio->bi_iter.bi_sector &
+				   (chunk_sects - 1)),
+				  GFP_NOIO, fs_bio_set);
+		bio_chain(split, bio);
+	} else {
+		split = bio;
+	}
 
-		__make_request(mddev, split);
-	} while (split != bio);
+	__make_request(mddev, split);
+	if (split != bio)
+		generic_make_request(bio);
 
 	/* In case raid10d snuck in to freeze_array */
 	wake_up(&conf->wait_barrier);
-- 
2.9.3

