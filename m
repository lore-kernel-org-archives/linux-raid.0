From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 3/3] md: export 'frozen' resync state through sysfs
Date: Mon, 25 May 2009 14:33:52 +1000
Message-ID: <20090525043352.3758.60550.stgit@notabene.brown>
References: <20090525042538.3758.7928.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090525042538.3758.7928.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

The md resync engine has a 'frozen' state which ensures that
no resync/recovery.  This is used to avoid races.

Export this state through the 'sync_action' sysfs attribute
so that user-space can benefit and also avoid some races.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index cc46c11..6683b9a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3303,7 +3303,9 @@ static ssize_t
 action_show(mddev_t *mddev, char *page)
 {
 	char *type = "idle";
-	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
+	if (test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
+		type = "frozen";
+	else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
 	    (!mddev->ro && test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))) {
 		if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
 			type = "reshape";
@@ -3326,7 +3328,12 @@ action_store(mddev_t *mddev, const char *page, size_t len)
 	if (!mddev->pers || !mddev->pers->sync_request)
 		return -EINVAL;
 
-	if (cmd_match(page, "idle")) {
+	if (cmd_match(page, "frozen"))
+		set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+	else
+		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+
+	if (cmd_match(page, "idle") || cmd_match(page, "frozen")) {
 		if (mddev->sync_thread) {
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 			md_unregister_thread(mddev->sync_thread);


