From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 1/8] md_ioctl(): Fix misleading indentation.
Date: Fri, 25 Apr 2008 21:06:35 +0200
Message-ID: <S1752554AbYGGId4/20080707083356Z+312@vger.kernel.org>
References: <20080707075532.GA32617@skl-net.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080707075532.GA32617@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids


Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/md.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2580ac1..b16d08d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4807,13 +4807,11 @@ static int md_ioctl(struct inode *inode, struct file *file,
 	 * here and hit the 'default' below, so only disallow
 	 * 'md' ioctls, and switch to rw mode if started auto-readonly.
 	 */
-	if (_IOC_TYPE(cmd) == MD_MAJOR &&
-	    mddev->ro && mddev->pers) {
+	if (_IOC_TYPE(cmd) == MD_MAJOR && mddev->ro && mddev->pers) {
 		if (mddev->ro == 2) {
 			mddev->ro = 0;
-		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-		md_wakeup_thread(mddev->thread);
-
+			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+			md_wakeup_thread(mddev->thread);
 		} else {
 			err = -EROFS;
 			goto abort_unlock;
-- 
1.5.3.8

