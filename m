From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 22/26] md: minor cleanup in safe_delay_store.
Date: Wed, 04 Feb 2015 08:42:30 +1100
Message-ID: <20150203214230.3448.45051.stgit@notabene.brown>
References: <20150203213948.3448.80258.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150203213948.3448.80258.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There isn't really much room for races with ->safemode_delay.
But as I am trying to clean up any racy code and will soon
be removing reconfig_mutex protection from most _store()
functions:
 - only set mddev->safemode_delay once, to ensure no code
   can see an intermediate value
 - use safemode_timer to call md_safemode_timeout() rather than
   calling it directly, to ensure it never races with itself.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f11aff6bd5e2..e68824d2d21e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3242,11 +3242,13 @@ safe_delay_store(struct mddev *mddev, const char *cbuf, size_t len)
 		mddev->safemode_delay = 0;
 	else {
 		unsigned long old_delay = mddev->safemode_delay;
-		mddev->safemode_delay = (msec*HZ)/1000;
-		if (mddev->safemode_delay == 0)
-			mddev->safemode_delay = 1;
-		if (mddev->safemode_delay < old_delay || old_delay == 0)
-			md_safemode_timeout((unsigned long)mddev);
+		unsigned long new_delay = (msec*HZ)/1000;
+
+		if (new_delay == 0)
+			new_delay = 1;
+		mddev->safemode_delay = new_delay;
+		if (new_delay < old_delay || old_delay == 0)
+			mod_timer(&mddev->safemode_timer, jiffies+1);
 	}
 	return len;
 }


