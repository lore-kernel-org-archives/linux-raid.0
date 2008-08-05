From: NeilBrown <neilb@suse.de>
Subject: [PATCH md] Don't let a blocked_rdev interfere with read request in raid5/6
Date: Tue,  5 Aug 2008 16:17:32 +1000
Message-ID: <1217917054-1725-5-git-send-email-neilb@suse.de>
References: <1217917054-1725-1-git-send-email-neilb@suse.de>
 <1217917054-1725-2-git-send-email-neilb@suse.de>
 <1217917054-1725-3-git-send-email-neilb@suse.de>
 <1217917054-1725-4-git-send-email-neilb@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1217917054-1725-4-git-send-email-neilb@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

When we have externally managed metadata, we need to mark a failed
device as 'Blocked' and not allow any writes until that device
have been marked as faulty in the metadata and the Blocked flag has
been removed.

However it is perfectly OK to allow read requests when there is a
Blocked device, and with a readonly array, there may not be any
metadata-handler watching for blocked devices.

So in raid5/raid6 only allow a Blocked device to interfere with
Write request or resync.  Read requests go through untouched.

raid1 and raid10 already differentiate between read and write
properly.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid5.c |   29 +++++++++++++++++++++--------
 1 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 17e0953..224de02 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2568,10 +2568,10 @@ static bool handle_stripe5(struct stripe_head *sh)
 		if (dev->written)
 			s.written++;
 		rdev = rcu_dereference(conf->disks[i].rdev);
-		if (rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
+		if (blocked_rdev == NULL &&
+		    rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
 			blocked_rdev = rdev;
 			atomic_inc(&rdev->nr_pending);
-			break;
 		}
 		if (!rdev || !test_bit(In_sync, &rdev->flags)) {
 			/* The ReadError flag will just be confusing now */
@@ -2588,8 +2588,14 @@ static bool handle_stripe5(struct stripe_head *sh)
 	rcu_read_unlock();
 
 	if (unlikely(blocked_rdev)) {
-		set_bit(STRIPE_HANDLE, &sh->state);
-		goto unlock;
+		if (s.syncing || s.expanding || s.expanded ||
+		    s.to_write || s.written) {
+			set_bit(STRIPE_HANDLE, &sh->state);
+			goto unlock;
+		}
+		/* There is nothing for the blocked_rdev to block */
+		rdev_dec_pending(blocked_rdev, conf->mddev);
+		blocked_rdev = NULL;
 	}
 
 	if (s.to_fill && !test_bit(STRIPE_BIOFILL_RUN, &sh->state)) {
@@ -2832,10 +2838,10 @@ static bool handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 		if (dev->written)
 			s.written++;
 		rdev = rcu_dereference(conf->disks[i].rdev);
-		if (rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
+		if (blocked_rdev == NULL &&
+		    rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
 			blocked_rdev = rdev;
 			atomic_inc(&rdev->nr_pending);
-			break;
 		}
 		if (!rdev || !test_bit(In_sync, &rdev->flags)) {
 			/* The ReadError flag will just be confusing now */
@@ -2853,9 +2859,16 @@ static bool handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	rcu_read_unlock();
 
 	if (unlikely(blocked_rdev)) {
-		set_bit(STRIPE_HANDLE, &sh->state);
-		goto unlock;
+		if (s.syncing || s.expanding || s.expanded ||
+		    s.to_write || s.written) {
+			set_bit(STRIPE_HANDLE, &sh->state);
+			goto unlock;
+		}
+		/* There is nothing for the blocked_rdev to block */
+		rdev_dec_pending(blocked_rdev, conf->mddev);
+		blocked_rdev = NULL;
 	}
+
 	pr_debug("locked=%d uptodate=%d to_read=%d"
 	       " to_write=%d failed=%d failed_num=%d,%d\n",
 	       s.locked, s.uptodate, s.to_read, s.to_write, s.failed,
-- 
1.5.6.3

