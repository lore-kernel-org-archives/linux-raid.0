From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 11/15] md-cluster: Delete four error messages for a failed
 memory allocation
Date: Sat, 1 Oct 2016 16:56:27 +0200
Message-ID: <26a5a1a8-3cbb-381e-1ed4-f6dcfc73d64b@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <3a03df66-92ce-20fb-17f3-fb79b9d43c8e@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3a03df66-92ce-20fb-17f3-fb79b9d43c8e@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>, Wolfram Sang <wsa@the-dreams.de>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 1 Oct 2016 13:46:20 +0200

Omit extra messages for a memory allocation failure in three functions.

Link: http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-Refactor_Strings-WSang_0.pdf
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/md-cluster.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index b91b552..7f82c6b 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -200,17 +200,13 @@ static struct dlm_lock_resource *lockres_init(struct mddev *mddev,
 	res->mode = DLM_LOCK_IV;
 	namelen = strlen(name);
 	res->name = kzalloc(namelen + 1, GFP_KERNEL);
-	if (!res->name) {
-		pr_err("md-cluster: Unable to allocate resource name for resource %s\n", name);
+	if (!res->name)
 		goto out_err;
-	}
 	strlcpy(res->name, name, namelen + 1);
 	if (with_lvb) {
 		res->lksb.sb_lvbptr = kzalloc(LVB_SIZE, GFP_KERNEL);
-		if (!res->lksb.sb_lvbptr) {
-			pr_err("md-cluster: Unable to allocate LVB for resource %s\n", name);
+		if (!res->lksb.sb_lvbptr)
 			goto out_err;
-		}
 		res->flags = DLM_LKF_VALBLK;
 	}
 
@@ -852,10 +848,8 @@ static int join(struct mddev *mddev, int nodes)
 	/* Initiate the communication resources */
 	ret = -ENOMEM;
 	cinfo->recv_thread = md_register_thread(recv_daemon, mddev, "cluster_recv");
-	if (!cinfo->recv_thread) {
-		pr_err("md-cluster: cannot allocate memory for recv_thread!\n");
+	if (!cinfo->recv_thread)
 		goto err;
-	}
 	cinfo->message_lockres = lockres_init(mddev, "message", NULL, 1);
 	if (!cinfo->message_lockres)
 		goto err;
@@ -1191,10 +1185,8 @@ static int lock_all_bitmaps(struct mddev *mddev)
 					      sizeof(*cinfo
 						     ->other_bitmap_lockres),
 					      GFP_KERNEL);
-	if (!cinfo->other_bitmap_lockres) {
-		pr_err("md: can't alloc mem for other bitmap locks\n");
+	if (!cinfo->other_bitmap_lockres)
 		return 0;
-	}
 
 	my_slot = slot_number(mddev);
 	for (slot = 0; slot < mddev->bitmap_info.nodes; slot++) {
-- 
2.10.0
