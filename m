From: mwilck@arcor.de
Subject: [PATCH 6/8] monitor: read_and_act: handle race conditions for resync_start
Date: Mon, 25 Mar 2013 23:11:24 +0000 (UTC)
Message-ID: <1382695659-6231-7-git-send-email-mwilck@arcor.de>
References: <1382695659-6231-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Date: Fri, 25 Oct 2013 12:07:37 +0200
In-Reply-To: <1382695659-6231-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

When arrays are stopped, sysfs attributes may be deleted by
the kernel, and attempts to read these attributes will fail.

Setting resync_start to 0 is wrong in this case, because it
may make is_resync_complete() erroneously return
FALSE for a clean array. It is better to leave resync_start
untouched (the previously read value for this array).

Otherwise set_array_state() will pass thewrong state information
to the metadata handler, which will write it to disk, and at
the next restart an unnecessary recovery is started for the
array.

It is also possible that resync_start is actually *not* deleted
yet when read_and_act is running, and an apparently valid
value of "0" is read from it, with the same effect as described
above. This happens if the kernel has already called md_clean()
on the array (setting recovery_cp = 0), but the delayed removal
of "resync_start" hasn't happened yet. Therefore, in "clear"
state, "resync_start" shouldn't be read at all.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 monitor.c |   24 +++++++++++++++++-------
 1 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/monitor.c b/monitor.c
index 3cb4214..60c5d5a 100644
--- a/monitor.c
+++ b/monitor.c
@@ -75,18 +75,21 @@ static int read_attr(char *buf, int len, int fd)
 	return n;
 }
 
-static unsigned long long read_resync_start(int fd)
+static void read_resync_start(int fd, unsigned long long *v)
 {
 	char buf[30];
 	int n;
 
 	n = read_attr(buf, 30, fd);
-	if (n <= 0)
-		return 0;
+	if (n <= 0) {
+		dprintf("%s: Failed to read resync_start (%d)\n",
+			__func__, fd);
+		return;
+	}
 	if (strncmp(buf, "none", 4) == 0)
-		return MaxSector;
+		*v = MaxSector;
 	else
-		return strtoull(buf, NULL, 10);
+		*v = strtoull(buf, NULL, 10);
 }
 
 static unsigned long long read_sync_completed(int fd)
@@ -237,13 +240,20 @@ static int read_and_act(struct active_array *a)
 
 	a->curr_state = read_state(a->info.state_fd);
 	a->curr_action = read_action(a->action_fd);
-	a->info.resync_start = read_resync_start(a->resync_start_fd);
+	if (a->curr_state != clear)
+		/*
+		 * In "clear" state, resync_start may wrongly be set to "0"
+		 * when the kernel called md_clean but didn't remove the
+		 * sysfs attributes yet
+		 */
+		read_resync_start(a->resync_start_fd, &a->info.resync_start);
 	sync_completed = read_sync_completed(a->sync_completed_fd);
 	for (mdi = a->info.devs; mdi ; mdi = mdi->next) {
 		mdi->next_state = 0;
 		mdi->curr_state = 0;
 		if (mdi->state_fd >= 0) {
-			mdi->recovery_start = read_resync_start(mdi->recovery_fd);
+			read_resync_start(mdi->recovery_fd,
+					  &mdi->recovery_start);
 			mdi->curr_state = read_dev_state(mdi->state_fd);
 		}
 	}
-- 
1.7.1
