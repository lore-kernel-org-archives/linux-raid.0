From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 2/2] FIX: md: Prevent barrier become negative
Date: Fri, 04 Feb 2011 14:18:35 +0100
Message-ID: <20110204131834.6426.36045.stgit@gklab-128-111.igk.intel.com>
References: <20110204130757.6426.81544.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110204130757.6426.81544.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

In some situations barrier counter may become negative.
Calling lower_barrier with barrier=0 results barrier become negative.
It is harm situation and may cause process hang when we call wait_barrier()

This patch introduces additional condition in lower_barrier function-
decrement barrier counter only if it is raised.
It prevents to become barrier variable negative.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 drivers/md/raid1.c  |    3 ++-
 drivers/md/raid10.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a23ffa3..fa7077b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -660,7 +660,8 @@ static void lower_barrier(conf_t *conf)
 	unsigned long flags;
 	BUG_ON(conf->barrier <= 0);
 	spin_lock_irqsave(&conf->resync_lock, flags);
-	conf->barrier--;
+	if (conf->barrier > 0)
+		conf->barrier--;
 	spin_unlock_irqrestore(&conf->resync_lock, flags);
 	wake_up(&conf->wait_barrier);
 }
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 3b607b2..c9e46a9 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -727,7 +727,8 @@ static void lower_barrier(conf_t *conf)
 {
 	unsigned long flags;
 	spin_lock_irqsave(&conf->resync_lock, flags);
-	conf->barrier--;
+	if (conf->barrier > 0)
+		conf->barrier--;
 	spin_unlock_irqrestore(&conf->resync_lock, flags);
 	wake_up(&conf->wait_barrier);
 }

