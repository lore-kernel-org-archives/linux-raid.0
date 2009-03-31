From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 13/14] md/raid5: minor code cleanups in make_request.
Date: Tue, 31 Mar 2009 15:54:44 +1100
Message-ID: <20090331045444.2589.35103.stgit@notabene.brown>
References: <20090331044827.2589.95894.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090331044827.2589.95894.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

... and to be certain the that make_request doesn't wait forever,
add a 'wake_up' when ->reshape_progress has been set to MaxSector

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index fb11c13..bb4b12e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3637,10 +3637,9 @@ static int make_request(struct request_queue *q, struct bio * bi)
 
 	retry:
 		previous = 0;
+		disks = conf->raid_disks;
 		prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
-		if (likely(conf->reshape_progress == MaxSector))
-			disks = conf->raid_disks;
-		else {
+		if (unlikely(conf->reshape_progress != MaxSector)) {
 			/* spinlock is needed as reshape_progress may be
 			 * 64bit on a 32bit platform, and so it might be
 			 * possible to see a half-updated value
@@ -3650,7 +3649,6 @@ static int make_request(struct request_queue *q, struct bio * bi)
 			 * to check again.
 			 */
 			spin_lock_irq(&conf->device_lock);
-			disks = conf->raid_disks;
 			if (mddev->delta_disks < 0
 			    ? logical_sector < conf->reshape_progress
 			    : logical_sector >= conf->reshape_progress) {
@@ -3679,7 +3677,7 @@ static int make_request(struct request_queue *q, struct bio * bi)
 		sh = get_active_stripe(conf, new_sector, previous,
 				       (bi->bi_rw&RWA_MASK));
 		if (sh) {
-			if (unlikely(conf->reshape_progress != MaxSector)) {
+			if (unlikely(previous)) {
 				/* expansion might have moved on while waiting for a
 				 * stripe, so we must do the range check again.
 				 * Expansion could still move past after this
@@ -3690,10 +3688,9 @@ static int make_request(struct request_queue *q, struct bio * bi)
 				 */
 				int must_retry = 0;
 				spin_lock_irq(&conf->device_lock);
-				if ((mddev->delta_disks < 0
-				     ? logical_sector >= conf->reshape_progress
-				     : logical_sector < conf->reshape_progress)
-				    && previous)
+				if (mddev->delta_disks < 0
+				    ? logical_sector >= conf->reshape_progress
+				    : logical_sector < conf->reshape_progress)
 					/* mismatch, need to try again */
 					must_retry = 1;
 				spin_unlock_irq(&conf->device_lock);
@@ -4977,6 +4974,7 @@ static void end_reshape(raid5_conf_t *conf)
 		conf->previous_raid_disks = conf->raid_disks;
 		conf->reshape_progress = MaxSector;
 		spin_unlock_irq(&conf->device_lock);
+		wake_up(&conf->wait_for_overlap);
 
 		/* read-ahead size must cover two whole stripes, which is
 		 * 2 * (datadisks) * chunksize where 'n' is the number of raid devices


