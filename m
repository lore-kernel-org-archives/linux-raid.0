From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 1 of 7 - Fix possible hang in raid shutdown.
Date: Fri, 23 Jan 2004 11:14:23 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1Ajoxr-0000jH-00@notabene>
References: <20040123105615.2237.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


If a raid array was syncing on shutdown, it would hang on shutdown,
constantly re-entering md_enter_safemade.  This fixes it.

 ----------- Diffstat output ------------
 ./drivers/md/md.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-01-23 10:30:08.000000000 +1100
+++ ./drivers/md/md.c	2004-01-23 10:32:24.000000000 +1100
@@ -3106,7 +3106,8 @@ static inline void md_enter_safemode(mdd
 {
 	if (!mddev->safemode) return;
 	if (mddev->safemode == 2 &&
-	    (atomic_read(&mddev->writes_pending) || mddev->in_sync))
+	    (atomic_read(&mddev->writes_pending) || mddev->in_sync ||
+		    mddev->recovery_cp != MaxSector))
 		return; /* avoid the lock */
 	mddev_lock_uninterruptible(mddev);
 	if (mddev->safemode && !atomic_read(&mddev->writes_pending) &&
