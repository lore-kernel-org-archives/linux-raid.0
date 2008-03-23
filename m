From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 8/8] Kill unused parameter mddev in md_new_event_inintr().
Date: Sun, 23 Mar 2008 16:05:55 +0100
Message-ID: <S1752326AbYGGIdv/20080707083351Z+1938@vger.kernel.org>
References: <20080707075532.GA32617@skl-net.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080707075532.GA32617@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids


Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/md.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0d8f5a3..a601341 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -176,7 +176,7 @@ EXPORT_SYMBOL_GPL(md_new_event);
 /* Alternate version that can be called from interrupts
  * when calling sysfs_notify isn't needed.
  */
-static void md_new_event_inintr(mddev_t *mddev)
+static void md_new_event_inintr(void)
 {
 	atomic_inc(&md_event_count);
 	wake_up(&md_event_waiters);
@@ -5031,7 +5031,7 @@ void md_error(mddev_t *mddev, mdk_rdev_t *rdev)
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
-	md_new_event_inintr(mddev);
+	md_new_event_inintr();
 }
 
 /* seq_file implementation /proc/mdstat */
-- 
1.5.3.8
