From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 3/8] do_md_run(): Fix misleading error message.
Date: Wed, 26 Mar 2008 01:07:03 +0100
Message-ID: <S1752204AbYGGIdz/20080707083355Z+1941@vger.kernel.org>
References: <20080707075532.GA32617@skl-net.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080707075532.GA32617@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

In case pers->run() succeeds but creating the bitmap fails, we
print an error message stating that pers->run() has failed.

Print this message only if pers->run() really failed.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/md.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f94ebe6..2384266 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3519,7 +3519,9 @@ static int do_md_run(mddev_t * mddev)
 		mddev->ro = 2; /* read-only, but switch on first write */
 
 	err = mddev->pers->run(mddev);
-	if (!err && mddev->pers->sync_request) {
+	if (err)
+		printk(KERN_ERR "md: pers->run() failed ...\n");
+	else if (mddev->pers->sync_request) {
 		err = bitmap_create(mddev);
 		if (err) {
 			printk(KERN_ERR "%s: failed to create bitmap (%d)\n",
@@ -3528,7 +3530,6 @@ static int do_md_run(mddev_t * mddev)
 		}
 	}
 	if (err) {
-		printk(KERN_ERR "md: pers->run() failed ...\n");
 		module_put(mddev->pers->owner);
 		mddev->pers = NULL;
 		bitmap_destroy(mddev);
-- 
1.5.3.8

