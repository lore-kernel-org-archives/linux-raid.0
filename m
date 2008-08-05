From: NeilBrown <neilb@suse.de>
Subject: [PATCH md] Fail safely when trying to grow an array with a write-intent bitmap.
Date: Tue,  5 Aug 2008 16:17:31 +1000
Message-ID: <1217917054-1725-4-git-send-email-neilb@suse.de>
References: <1217917054-1725-1-git-send-email-neilb@suse.de>
 <1217917054-1725-2-git-send-email-neilb@suse.de>
 <1217917054-1725-3-git-send-email-neilb@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1217917054-1725-3-git-send-email-neilb@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

We cannot currently change the size of a write-intent bitmap.
So if we change the size of an array which has such a bitmap, it
tries to set bits beyond the end of the bitmap.

For now, simply reject any request to change the size of an array
which has a bitmap.  mdadm can remove the bitmap and add a new one
after the array has changed size.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c    |    5 +++++
 drivers/md/raid5.c |    3 +++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8d11cd1..6eb9545 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4639,6 +4639,11 @@ static int update_size(mddev_t *mddev, sector_t num_sectors)
 	 */
 	if (mddev->sync_thread)
 		return -EBUSY;
+	if (mddev->bitmap)
+		/* Sorry, cannot grow a bitmap yet, just remove it,
+		 * grow, and re-add.
+		 */
+		return -EBUSY;
 	rdev_for_each(rdev, tmp, mddev) {
 		sector_t avail;
 		avail = rdev->size * 2;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 40e9396..17e0953 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4446,6 +4446,9 @@ static int raid5_check_reshape(mddev_t *mddev)
 		return -EINVAL; /* Cannot shrink array or change level yet */
 	if (mddev->delta_disks == 0)
 		return 0; /* nothing to do */
+	if (mddev->bitmap)
+		/* Cannot grow a bitmap yet */
+		return -EBUSY;
 
 	/* Can only proceed if there are plenty of stripe_heads.
 	 * We need a minimum of one full stripe,, and for sensible progress
-- 
1.5.6.3

