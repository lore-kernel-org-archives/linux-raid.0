From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: 2.6.11-rc4 md loops on missing drives
Date: Wed, 16 Feb 2005 11:27:20 +1100
Message-ID: <16914.37736.570163.440284@cse.unsw.edu.au>
References: <4211FB59.7090104@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Brad Campbell on Tuesday February 15
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday February 15, brad@wasp.net.au wrote:
> G'day all,
> 
> I'm not really sure how it's supposed to cope with losing more disks than planned, but filling the 
> syslog with nastiness is not very polite.

Thanks for the bug report.  There are actually a few problems relating
to resync/recovery when an array (raid 5 or 6) has lost too many
devices.
This patch should fix them.

NeilBrown

------------------------------------------------
Make raid5 and raid6 robust against failure during recovery.

Two problems are fixed here.
1/ if the array is known to require a resync (parity update),
  but there are too many failed devices,  the resync cannot complete
  but will be retried indefinitedly.
2/ if the array has two many failed drives to be usable and a spare is
  available, reconstruction will be attempted, but cannot work.  This
  also is retried indefinitely.


Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c        |   12 ++++++------
 ./drivers/md/raid5.c     |   13 +++++++++++++
 ./drivers/md/raid6main.c |   12 ++++++++++++
 3 files changed, 31 insertions(+), 6 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-02-16 11:25:25.000000000 +1100
+++ ./drivers/md/md.c	2005-02-16 11:25:31.000000000 +1100
@@ -3655,18 +3655,18 @@ void md_check_recovery(mddev_t *mddev)
 
 		/* no recovery is running.
 		 * remove any failed drives, then
-		 * add spares if possible
+		 * add spares if possible.
+		 * Spare are also removed and re-added, to allow
+		 * the personality to fail the re-add.
 		 */
-		ITERATE_RDEV(mddev,rdev,rtmp) {
+		ITERATE_RDEV(mddev,rdev,rtmp)
 			if (rdev->raid_disk >= 0 &&
-			    rdev->faulty &&
+			    (rdev->faulty || ! rdev->in_sync) &&
 			    atomic_read(&rdev->nr_pending)==0) {
 				if (mddev->pers->hot_remove_disk(mddev, rdev->raid_disk)==0)
 					rdev->raid_disk = -1;
 			}
-			if (!rdev->faulty && rdev->raid_disk >= 0 && !rdev->in_sync)
-				spares++;
-		}
+
 		if (mddev->degraded) {
 			ITERATE_RDEV(mddev,rdev,rtmp)
 				if (rdev->raid_disk < 0

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-02-16 11:25:25.000000000 +1100
+++ ./drivers/md/raid5.c	2005-02-16 11:25:31.000000000 +1100
@@ -1491,6 +1491,15 @@ static int sync_request (mddev_t *mddev,
 		unplug_slaves(mddev);
 		return 0;
 	}
+	/* if there is 1 or more failed drives and we are trying
+	 * to resync, then assert that we are finished, because there is
+	 * nothing we can do.
+	 */
+	if (mddev->degraded >= 1 && test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
+		int rv = (mddev->size << 1) - sector_nr;
+		md_done_sync(mddev, rv, 1);
+		return rv;
+	}
 
 	x = sector_nr;
 	chunk_offset = sector_div(x, sectors_per_chunk);
@@ -1882,6 +1891,10 @@ static int raid5_add_disk(mddev_t *mddev
 	int disk;
 	struct disk_info *p;
 
+	if (mddev->degraded > 1)
+		/* no point adding a device */
+		return 0;
+
 	/*
 	 * find the disk ...
 	 */

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-02-16 11:25:25.000000000 +1100
+++ ./drivers/md/raid6main.c	2005-02-16 11:25:31.000000000 +1100
@@ -1650,6 +1650,15 @@ static int sync_request (mddev_t *mddev,
 		unplug_slaves(mddev);
 		return 0;
 	}
+	/* if there are 2 or more failed drives and we are trying
+	 * to resync, then assert that we are finished, because there is
+	 * nothing we can do.
+	 */
+	if (mddev->degraded >= 2 && test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
+		int rv = (mddev->size << 1) - sector_nr;
+		md_done_sync(mddev, rv, 1);
+		return rv;
+	}
 
 	x = sector_nr;
 	chunk_offset = sector_div(x, sectors_per_chunk);
@@ -2048,6 +2057,9 @@ static int raid6_add_disk(mddev_t *mddev
 	int disk;
 	struct disk_info *p;
 
+	if (mddev->degraded > 2)
+		/* no point adding a device */
+		return 0;
 	/*
 	 * find the disk ...
 	 */
