From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 15/15] md-cluster: Delete unnecessary braces in
 unlock_all_bitmaps()
Date: Sat, 1 Oct 2016 17:00:07 +0200
Message-ID: <ba60b210-40c6-b021-780c-33ecea7bee9e@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <3a03df66-92ce-20fb-17f3-fb79b9d43c8e@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <3a03df66-92ce-20fb-17f3-fb79b9d43c8e@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 1 Oct 2016 16:15:55 +0200

Do not use curly brackets at one source code place
where a single statement should be sufficient.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/md-cluster.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 0cade1a..a9bf13d 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1223,11 +1223,10 @@ static void unlock_all_bitmaps(struct mddev *mddev)
 
 	/* release other node's bitmap lock if they are existed */
 	if (cinfo->other_bitmap_lockres) {
-		for (i = 0; i < mddev->bitmap_info.nodes - 1; i++) {
-			if (cinfo->other_bitmap_lockres[i]) {
+		for (i = 0; i < mddev->bitmap_info.nodes - 1; i++)
+			if (cinfo->other_bitmap_lockres[i])
 				lockres_free(cinfo->other_bitmap_lockres[i]);
-			}
-		}
+
 		kfree(cinfo->other_bitmap_lockres);
 	}
 }
-- 
2.10.0

