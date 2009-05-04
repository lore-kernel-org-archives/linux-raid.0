From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 2/7] md/raid10: don't clear bitmap during recovery if array
	will still be degraded.
Date: Mon, 04 May 2009 16:58:49 +1000
Message-ID: <20090504065849.11688.47998.stgit@notabene.brown>
References: <20090504065540.11688.39505.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090504065540.11688.39505.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: stable@kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

If we have a raid10 with multiple missing devices, and we recover just
one of these to a spare, then we risk (depending on the bitmap and
array chunk size) clearing bits of the bitmap for which recovery isn't
complete (because a device is still missing).

This can lead to a subsequent "re-add" being recovered without
any IO happening, which would result in loss of data.

This patch takes the safe approach of not clearing bitmap bits
if the array will still be degraded.

This patch is suitable for all active -stable kernels.

Cc: stable@kernel.org
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 81a54f1..499620a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1809,17 +1809,17 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 				r10_bio->sector = sect;
 
 				raid10_find_phys(conf, r10_bio);
-				/* Need to check if this section will still be
+
+				/* Need to check if the array will still be
 				 * degraded
 				 */
-				for (j=0; j<conf->copies;j++) {
-					int d = r10_bio->devs[j].devnum;
-					if (conf->mirrors[d].rdev == NULL ||
-					    test_bit(Faulty, &conf->mirrors[d].rdev->flags)) {
+				for (j=0; j<conf->raid_disks; j++)
+					if (conf->mirrors[j].rdev == NULL ||
+					    test_bit(Faulty, &conf->mirrors[j].rdev->flags)) {
 						still_degraded = 1;
 						break;
 					}
-				}
+
 				must_sync = bitmap_start_sync(mddev->bitmap, sect,
 							      &sync_blocks, still_degraded);
 


