From: Neil Brown <neilb@suse.de>
Subject: Re: Reliability of bitmapped resync
Date: Wed, 25 Feb 2009 13:39:12 +1100
Message-ID: <18852.44880.811967.897554@notabene.brown>
References: <20090223194019.GA3488@lazy.lzy>
	<b2460d0414270e6a6be4c91ec2d5a071.squirrel@neil.brown.name>
	<20090223201905.GA7585@lazy.lzy>
	<e3d195aab8b8de113e146e2932996777.squirrel@neil.brown.name>
	<20090223214016.GB18555@lazy.lzy>
	<16ff0082259ce384e30c4a7f9a0e66fb.squirrel@neil.brown.name>
	<20090224193931.GB3470@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Piergiorgio Sartor on Tuesday February 24
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday February 24, piergiorgio.sartor@nexgo.de wrote:
> Hi,
> 
> > I'll wait for these details before I start hunting further.
> 
> OK, here we are.
> Some forewords, the last disk to fail at boot was
> /dev/sda, this data was collected after a "clean"
> add of the /dev/sda3 to the RAID.
> This means the superblock was zeroed and the device
> added, so it should be clean.
> 
....

Thanks a lot for that.

> 
> Now, one thing I do not understand, but maybe it is
> anyway OK, and it is this last line:
> 
>           Bitmap : 945199 bits (chunks), 524289 dirty (55.5%)
> 
> Because the array status was fully recovered (in sync)
> and /dev/sdb3 showed:
> 
>           Bitmap : 945199 bits (chunks), 1 dirty (0.0%)
> 
> Confirmed somehow by /proc/mdstat
> 
> How it could be 55.5% dirty? Is this expected?

This is a bug.  Is fixed by a patch that I have queued for 2.6.30.  As
it doesn't cause a crash or data corruption, it doesn't get to jump
the queue.  It is very small though:

--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -266,7 +266,6 @@ static mdk_rdev_t *next_active_rdev(mdk_rdev_t *rdev, mddev_t *mddev)
        list_for_each_continue_rcu(pos, &mddev->disks) {
                rdev = list_entry(pos, mdk_rdev_t, same_set);
                if (rdev->raid_disk >= 0 &&
-                   test_bit(In_sync, &rdev->flags) &&
                    !test_bit(Faulty, &rdev->flags)) {
                        /* this is a usable devices */
                        atomic_inc(&rdev->nr_pending);


I'm fairly use I have found the bug that caused the problem you first
noticed.  It was introduced in 2.6.25.
Below are two patches for raid10 which I have just submitted for
2.6.29 (As they can cause data corruption and so can jump the queue).

The first solves your problem.  The second solves a similar situation
when the bitmap chunk size is smaller.

If you are able to test and confirm, that would be great.

Thanks a lot for reporting the problem and following through!

NeilBrown

From: NeilBrown <neilb@suse.de>
Subject: [PATCH 2/2] md/raid10: Don't call bitmap_cond_end_sync when we are
	doing recovery.
Date: Wed, 25 Feb 2009 13:38:19 +1100
Message-ID: <20090225023819.28579.20247.stgit@notabene.brown>
In-Reply-To: <20090225023819.28579.71372.stgit@notabene.brown>
References: <20090225023819.28579.71372.stgit@notabene.brown>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

For raid1/4/5/6, resync (fixing inconsistencies between devices) is
very similar to recovery (rebuilding a failed device onto a spare).
The both walk through the device addresses in order.

For raid10 it can be quite different.  resync follows the 'array'
address, and makes sure all copies are the same.  Recover walks
through 'device' addresses and recreates each missing block.

The 'bitmap_cond_end_sync' function allows the write-intent-bitmap
(When present) to be updated to reflect a partially completed resync.
It makes assumptions which mean that it does not work correctly for
raid10 recovery at all.

In particularly, it can cause bitmap-directed recovery of a raid10 to
not recovery some of the blocks that need to be recovered.

So move the call to bitmap_cond_end_sync into the resync path, rather
than being in the common "resync or recovery" path.


Cc: stable@kernel.org
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 118f89e..e1feb87 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1749,8 +1749,6 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 	if (!go_faster && conf->nr_waiting)
 		msleep_interruptible(1000);
 
-	bitmap_cond_end_sync(mddev->bitmap, sector_nr);
-
 	/* Again, very different code for resync and recovery.
 	 * Both must result in an r10bio with a list of bios that
 	 * have bi_end_io, bi_sector, bi_bdev set,
@@ -1886,6 +1884,8 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 		/* resync. Schedule a read for every block at this virt offset */
 		int count = 0;
 
+		bitmap_cond_end_sync(mddev->bitmap, sector_nr);
+
 		if (!bitmap_start_sync(mddev->bitmap, sector_nr,
 				       &sync_blocks, mddev->degraded) &&
 		    !conf->fullsync && !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {


From: NeilBrown <neilb@suse.de>
Subject: [PATCH 1/2] md/raid10: Don't skip more than 1 bitmap-chunk at a time
	during recovery.
Date: Wed, 25 Feb 2009 13:38:19 +1100
Message-ID: <20090225023819.28579.71372.stgit@notabene.brown>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

When doing recovery on a raid10 with a write-intent bitmap, we only
need to recovery chunks that are flagged in the bitmap.

However if we choose to skip a chunk as it isn't flag, the code
currently skips the whole raid10-chunk, thus it might not recovery
some blocks that need recovering.

This patch fixes it.

In case that is confusing, it might help to understand that there
is a 'raid10 chunk size' which guides how data is distributed across
the devices, and a 'bitmap chunk size' which says how much data
corresponds to a single bit in the bitmap.

This bug only affects cases where the bitmap chunk size is smaller
than the raid10 chunk size.



Cc: stable@kernel.org
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 6736d6d..118f89e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2010,13 +2010,13 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 	/* There is nowhere to write, so all non-sync
 	 * drives must be failed, so try the next chunk...
 	 */
-	{
-	sector_t sec = max_sector - sector_nr;
-	sectors_skipped += sec;
+	if (sector_nr + max_sync < max_sector)
+		max_sector = sector_nr + max_sync;
+
+	sectors_skipped += (max_sector - sector_nr);
 	chunks_skipped ++;
 	sector_nr = max_sector;
 	goto skipped;
-	}
 }
 
 static int run(mddev_t *mddev)


