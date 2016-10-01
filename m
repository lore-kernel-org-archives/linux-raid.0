From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 01/15] md-cluster: Use kcalloc() in lock_all_bitmaps()
Date: Sat, 1 Oct 2016 16:46:01 +0200
Message-ID: <8344fb76-896d-e593-dccc-f77df0900ad1@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <3a03df66-92ce-20fb-17f3-fb79b9d43c8e@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3a03df66-92ce-20fb-17f3-fb79b9d43c8e@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 1 Oct 2016 11:18:40 +0200

* A multiplication for the size determination of a memory allocation
  indicated that an array data structure should be processed.
  Thus reuse the corresponding function "kcalloc".

  This issue was detected by using the Coccinelle software.

* Replace the specification of a data type by a pointer dereference
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/md-cluster.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 2b13117..0000e3a 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1188,9 +1188,10 @@ static int lock_all_bitmaps(struct mddev *mddev)
 	char str[64];
 	struct md_cluster_info *cinfo = mddev->cluster_info;
 
-	cinfo->other_bitmap_lockres = kzalloc((mddev->bitmap_info.nodes - 1) *
-					     sizeof(struct dlm_lock_resource *),
-					     GFP_KERNEL);
+	cinfo->other_bitmap_lockres = kcalloc(mddev->bitmap_info.nodes - 1,
+					      sizeof(*cinfo
+						     ->other_bitmap_lockres),
+					      GFP_KERNEL);
 	if (!cinfo->other_bitmap_lockres) {
 		pr_err("md: can't alloc mem for other bitmap locks\n");
 		return 0;
-- 
2.10.0
