From: Vitaly Mayatskikh <vmayatskikh@digitalocean.com>
Subject: [PATCH 1/1] md/raid10: avoid deadlock on recovery.
Date: Tue,  3 Mar 2020 13:14:40 -0500
Message-ID: <1583259280-124995-2-git-send-email-vmayatskikh@digitalocean.com>
References: <1583259280-124995-1-git-send-email-vmayatskikh@digitalocean.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1583259280-124995-1-git-send-email-vmayatskikh@digitalocean.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When disk failure happens and the array has a spare drive, resync thread
kicks in and starts to refill the spare. However it may get blocked by
a retry thread that resubmits failed IO to a mirror and itself can get
blocked on a barrier raised by the resync thread.

Signed-off-by: Vitaly Mayatskikh <vmayatskikh@digitalocean.com>
---
 drivers/md/raid10.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ec136e4..f1a8e26 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -980,6 +980,7 @@ static void wait_barrier(struct r10conf *conf)
 {
 	spin_lock_irq(&conf->resync_lock);
 	if (conf->barrier) {
+		struct bio_list *bio_list = current->bio_list;
 		conf->nr_waiting++;
 		/* Wait for the barrier to drop.
 		 * However if there are already pending
@@ -994,9 +995,16 @@ static void wait_barrier(struct r10conf *conf)
 		wait_event_lock_irq(conf->wait_barrier,
 				    !conf->barrier ||
 				    (atomic_read(&conf->nr_pending) &&
-				     current->bio_list &&
-				     (!bio_list_empty(&current->bio_list[0]) ||
-				      !bio_list_empty(&current->bio_list[1]))),
+				     bio_list &&
+				     (!bio_list_empty(&bio_list[0]) ||
+				      !bio_list_empty(&bio_list[1]))) ||
+				     /* move on if recovery thread is
+				      * blocked by us
+				      */
+				     (conf->mddev->thread->tsk == current &&
+				      test_bit(MD_RECOVERY_RUNNING,
+					       &conf->mddev->recovery) &&
+				      conf->nr_queued > 0),
 				    conf->resync_lock);
 		conf->nr_waiting--;
 		if (!conf->nr_waiting)
-- 
1.8.3.1
