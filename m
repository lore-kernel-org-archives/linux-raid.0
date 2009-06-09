From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 1/3] md/raid5: use conf->raid_disks in preference to
	mddev->raid_disk
Date: Tue, 09 Jun 2009 16:39:57 +1000
Message-ID: <20090609063957.11737.41860.stgit@notabene.brown>
References: <20090609063828.11737.65814.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090609063828.11737.65814.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

mddev->raid_disks can be changed and any time by a request from
user-space.  It is a suggestion as to what number of raid_disks is
desired.

conf->raid_disks can only be changed by the raid5 module with suitable
locks in place.  It is a statement as to the current number of
raid_disks.

There are two places where the latter should be used, but the former
is used.  This can lead to a crash when reshaping an array.

This patch changes to mddev-> to conf->

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5d400ae..75469e6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3288,7 +3288,7 @@ static void unplug_slaves(mddev_t *mddev)
 	int i;
 
 	rcu_read_lock();
-	for (i=0; i<mddev->raid_disks; i++) {
+	for (i = 0; i < conf->raid_disks; i++) {
 		mdk_rdev_t *rdev = rcu_dereference(conf->disks[i].rdev);
 		if (rdev && !test_bit(Faulty, &rdev->flags) && atomic_read(&rdev->nr_pending)) {
 			struct request_queue *r_queue = bdev_get_queue(rdev->bdev);
@@ -4034,7 +4034,7 @@ static inline sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *ski
 	 * We don't need to check the 'failed' flag as when that gets set,
 	 * recovery aborts.
 	 */
-	for (i=0; i<mddev->raid_disks; i++)
+	for (i = 0; i < conf->raid_disks; i++)
 		if (conf->disks[i].rdev == NULL)
 			still_degraded = 1;
 


