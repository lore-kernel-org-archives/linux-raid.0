From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 07/23] md: allow re-add to failed arrays.
Date: Wed, 14 Mar 2012 15:40:40 +1100
Message-ID: <20120314044039.7978.16558.stgit@notabene.brown>
References: <20120314043555.7978.75486.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120314043555.7978.75486.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When an array is failed (some data inaccessible) then there is no
point attempting to add a spare as it could not possibly be recovered.

However that may be value in re-adding a recently removed device.
e.g. if there is a write-intent-bitmap and it is clear, then access
to the data could be restored by this action.

So don't reject a re-add to a failed array for RAID10 and RAID5 (the
only arrays  types that check for a failed array).

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |    2 +-
 drivers/md/raid5.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1497cd6..ca1ea25 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1484,7 +1484,7 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		 * very different from resync
 		 */
 		return -EBUSY;
-	if (!enough(conf, -1))
+	if (rdev->saved_raid_disk < 0 && !enough(conf, -1))
 		return -EINVAL;
 
 	if (rdev->raid_disk >= 0)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d3b2fbf..34f3b5c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5361,7 +5361,7 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	if (mddev->recovery_disabled == conf->recovery_disabled)
 		return -EBUSY;
 
-	if (has_failed(conf))
+	if (rdev->saved_raid_disk < 0 && has_failed(conf))
 		/* no point adding a device */
 		return -EINVAL;
 


