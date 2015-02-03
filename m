From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 14/26] md/bitmap: protect clearing of ->bitmap by
 mddev->lock
Date: Wed, 04 Feb 2015 08:42:29 +1100
Message-ID: <20150203214229.3448.64267.stgit@notabene.brown>
References: <20150203213948.3448.80258.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150203213948.3448.80258.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This makes it safe to inspect the struct while holding only
the spinlock.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/bitmap.c |    2 ++
 drivers/md/md.h     |    1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 1695ee5f3ffc..3424b1915fc4 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1619,7 +1619,9 @@ void bitmap_destroy(struct mddev *mddev)
 		return;
 
 	mutex_lock(&mddev->bitmap_info.mutex);
+	spin_lock(&mddev->lock);
 	mddev->bitmap = NULL; /* disconnect from the md device */
+	spin_unlock(&mddev->lock);
 	mutex_unlock(&mddev->bitmap_info.mutex);
 	if (mddev->thread)
 		mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index e41559dccdc9..8770308a8052 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -392,6 +392,7 @@ struct mddev {
 	 *   clearing MD_CHANGE_*
 	 *   in_sync - and related safemode and MD_CHANGE changes
 	 *   pers (also protected by reconfig_mutex and pending IO).
+	 *   clearing ->bitmap
 	 */
 	spinlock_t			lock;
 	wait_queue_head_t		sb_wait;	/* for waiting on superblock updates */


