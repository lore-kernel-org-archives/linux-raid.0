From: Chris Dunlop <chris@onthe.net.au>
Subject: [PATCH] md.c: trivial comment fix
Date: Wed, 19 Oct 2011 16:48:26 +1100
Message-ID: <20111019054826.GA30603@onthe.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Trivial comment fix

Signed-off-by: Chris Dunlop <chris@onthe.net.au>
---
 drivers/md/md.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5c95ccb..1a9bbfc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -744,8 +744,8 @@ static void mddev_unlock(mddev_t * mddev)
 	} else
 		mutex_unlock(&mddev->reconfig_mutex);
 
-	/* was we've dropped the mutex we need a spinlock to
-	 * make sur the thread doesn't disappear
+	/* As we've dropped the mutex we need a spinlock to
+	 * make sure the thread doesn't disappear
 	 */
 	spin_lock(&pers_lock);
 	md_wakeup_thread(mddev->thread);
-- 
1.7.0.4

