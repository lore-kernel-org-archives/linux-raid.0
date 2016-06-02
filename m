From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 02/18] md/raid1,
 raid10: don't recheck "Faulty" flag in read-balance.
Date: Thu, 02 Jun 2016 16:19:52 +1000
Message-ID: <20160602061952.2939.41358.stgit@noble>
References: <20160602061319.2939.72280.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160602061319.2939.72280.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Re-checking the faulty flag here brings no value.
The comment about "risk" refers to the risk that the device could
be in the process of being removed by ->hot_remove_disk().
However providing that the ->nr_pending count is incremented inside
an rcu_read_locked() region, there is no risk of that happening.

This is because the rdev pointer (in the personalities array) is set
to NULL before synchronize_rcu(), and ->nr_pending is tested
afterwards.  If the rcu_read_locked region happens before the
synchronize_rcu(), the test will see that nr_pending has been incremented.
If it happens afterwards, the rdev pointer will be NULL so there is nothing
to increment.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid1.c  |    7 -------
 drivers/md/raid10.c |    8 --------
 2 files changed, 15 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index c7c8cde0ab21..a54edbe741ff 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -689,13 +689,6 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
 		if (!rdev)
 			goto retry;
 		atomic_inc(&rdev->nr_pending);
-		if (test_bit(Faulty, &rdev->flags)) {
-			/* cannot risk returning a device that failed
-			 * before we inc'ed nr_pending
-			 */
-			rdev_dec_pending(rdev, conf->mddev);
-			goto retry;
-		}
 		sectors = best_good_sectors;
 
 		if (conf->mirrors[best_disk].next_seq_sect != this_sector)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c7de2a53e625..cc9e3813e1a4 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -707,7 +707,6 @@ static struct md_rdev *read_balance(struct r10conf *conf,
 
 	raid10_find_phys(conf, r10_bio);
 	rcu_read_lock();
-retry:
 	sectors = r10_bio->sectors;
 	best_slot = -1;
 	best_rdev = NULL;
@@ -804,13 +803,6 @@ retry:
 
 	if (slot >= 0) {
 		atomic_inc(&rdev->nr_pending);
-		if (test_bit(Faulty, &rdev->flags)) {
-			/* Cannot risk returning a device that failed
-			 * before we inc'ed nr_pending
-			 */
-			rdev_dec_pending(rdev, conf->mddev);
-			goto retry;
-		}
 		r10_bio->read_slot = slot;
 	} else
 		rdev = NULL;


