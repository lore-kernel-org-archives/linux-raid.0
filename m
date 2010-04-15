From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 26/28] md: don't unregister the thread in mddev_suspend
Date: Thu, 15 Apr 2010 16:21:08 +1000
Message-ID: <20100415062108.5126.57118.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is
 - unnecessary because mddev_suspend is always followed by a call to
   ->stop, and each ->stop unregisters the thread, and
 - a problem as it makes it awkwards to suspend and then resume a
   device as we will want later.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 59bf6aa..ad7e2b8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -254,6 +254,12 @@ static int md_make_request(struct request_queue *q, struct bio *bio)
 	return rv;
 }
 
+/* mddev_suspend makes sure no new requests are submitted
+ * to the device, and that any requests that have been submitted
+ * are completely handled.
+ * Once ->stop is called and completes, the module will be completely
+ * unused.
+ */
 static void mddev_suspend(mddev_t *mddev)
 {
 	BUG_ON(mddev->suspended);
@@ -261,13 +267,6 @@ static void mddev_suspend(mddev_t *mddev)
 	synchronize_rcu();
 	wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) == 0);
 	mddev->pers->quiesce(mddev, 1);
-	md_unregister_thread(mddev->thread);
-	mddev->thread = NULL;
-	/* we now know that no code is executing in the personality module,
-	 * except possibly the tail end of a ->bi_end_io function, but that
-	 * is certain to complete before the module has a chance to get
-	 * unloaded
-	 */
 }
 
 static void mddev_resume(mddev_t *mddev)


