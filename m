From: NeilBrown <neilb@suse.de>
Subject: [PATCH md] Make writes to md/safe_mode_delay immediately effective.
Date: Tue,  5 Aug 2008 16:17:29 +1000
Message-ID: <1217917054-1725-2-git-send-email-neilb@suse.de>
References: <1217917054-1725-1-git-send-email-neilb@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1217917054-1725-1-git-send-email-neilb@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

If we reduce the 'safe_mode_delay', it could still wait for the old
delay to completely expire before doing anything about safe_mode.
Thus the effect if the change is delayed.

To make the effect more immediate, run the timeout function
immediately if the delay was reduced.  This may cause it to run
slightly earlier that required, but that is the safer option.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c7aae66..48afe4f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2393,6 +2393,8 @@ static void analyze_sbs(mddev_t * mddev)
 
 }
 
+static void md_safemode_timeout(unsigned long data);
+
 static ssize_t
 safe_delay_show(mddev_t *mddev, char *page)
 {
@@ -2432,9 +2434,12 @@ safe_delay_store(mddev_t *mddev, const char *cbuf, size_t len)
 	if (msec == 0)
 		mddev->safemode_delay = 0;
 	else {
+		unsigned long old_delay = mddev->safemode_delay;
 		mddev->safemode_delay = (msec*HZ)/1000;
 		if (mddev->safemode_delay == 0)
 			mddev->safemode_delay = 1;
+		if (mddev->safemode_delay < old_delay)
+			md_safemode_timeout((unsigned long)mddev);
 	}
 	return len;
 }
-- 
1.5.6.3

