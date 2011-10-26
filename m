From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 03/16] md: remove test for duplicate device when setting
 slot number.
Date: Wed, 26 Oct 2011 12:43:00 +1100
Message-ID: <20111026014300.21110.97985.stgit@notabene.brown>
References: <20111026014240.21110.28487.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111026014240.21110.28487.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When setting the slot number on a device in an active array we
currently check that the number is not already in use.
We then call into the personality's hot_add_disk function
which performs the same test and returns the same error.

Thus the common test is not needed.

As we will shortly be changing some personalities to allow duplicates
in some cases (to support hot-replace), the common test will become
inconvenient.

So remove the common test.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5905526..5164856 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2699,7 +2699,6 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 		set_bit(MD_RECOVERY_NEEDED, &rdev->mddev->recovery);
 		md_wakeup_thread(rdev->mddev->thread);
 	} else if (rdev->mddev->pers) {
-		struct md_rdev *rdev2;
 		/* Activating a spare .. or possibly reactivating
 		 * if we ever get bitmaps working here.
 		 */
@@ -2713,10 +2712,6 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 		if (rdev->mddev->pers->hot_add_disk == NULL)
 			return -EINVAL;
 
-		list_for_each_entry(rdev2, &rdev->mddev->disks, same_set)
-			if (rdev2->raid_disk == slot)
-				return -EEXIST;
-
 		if (slot >= rdev->mddev->raid_disks &&
 		    slot >= rdev->mddev->raid_disks + rdev->mddev->delta_disks)
 			return -ENOSPC;


