From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 10/16] md/raid5: allow removal for failed replacement
 devices.
Date: Wed, 26 Oct 2011 12:43:01 +1100
Message-ID: <20111026014301.21110.41588.stgit@notabene.brown>
References: <20111026014240.21110.28487.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111026014240.21110.28487.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Enhance raid5_remove_disk to be able to remove ->replacement
as well as ->rdev.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   58 +++++++++++++++++++++++++++++-----------------------
 1 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7d77a38..20f42f6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5068,36 +5068,42 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 	struct r5conf *conf = mddev->private;
 	int err = 0;
 	int number = rdev->raid_disk;
+	struct md_rdev **rdevp;
 	struct disk_info *p = conf->disks + number;
 
 	print_raid5_conf(conf);
-	if (rdev == p->rdev) {
-		if (number >= conf->raid_disks &&
-		    conf->reshape_progress == MaxSector)
-			clear_bit(In_sync, &rdev->flags);
+	if (rdev == p->rdev)
+		rdevp = &p->rdev;
+	else if (rdev == p->replacement)
+		rdevp = &p->replacement;
+	else
+		return 0;
 
-		if (test_bit(In_sync, &rdev->flags) ||
-		    atomic_read(&rdev->nr_pending)) {
-			err = -EBUSY;
-			goto abort;
-		}
-		/* Only remove non-faulty devices if recovery
-		 * isn't possible.
-		 */
-		if (!test_bit(Faulty, &rdev->flags) &&
-		    mddev->recovery_disabled != conf->recovery_disabled &&
-		    !has_failed(conf) &&
-		    number < conf->raid_disks) {
-			err = -EBUSY;
-			goto abort;
-		}
-		p->rdev = NULL;
-		synchronize_rcu();
-		if (atomic_read(&rdev->nr_pending)) {
-			/* lost the race, try later */
-			err = -EBUSY;
-			p->rdev = rdev;
-		}
+	if (number >= conf->raid_disks &&
+	    conf->reshape_progress == MaxSector)
+		clear_bit(In_sync, &rdev->flags);
+
+	if (test_bit(In_sync, &rdev->flags) ||
+	    atomic_read(&rdev->nr_pending)) {
+		err = -EBUSY;
+		goto abort;
+	}
+	/* Only remove non-faulty devices if recovery
+	 * isn't possible.
+	 */
+	if (!test_bit(Faulty, &rdev->flags) &&
+	    mddev->recovery_disabled != conf->recovery_disabled &&
+	    !has_failed(conf) &&
+	    number < conf->raid_disks) {
+		err = -EBUSY;
+		goto abort;
+	}
+	*rdevp = NULL;
+	synchronize_rcu();
+	if (atomic_read(&rdev->nr_pending)) {
+		/* lost the race, try later */
+		err = -EBUSY;
+		*rdevp = rdev;
 	}
 abort:
 


