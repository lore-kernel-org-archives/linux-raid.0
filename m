From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 02/15] md-cluster: Improve another size determination in
 resync_info_update()
Date: Sat, 1 Oct 2016 16:47:16 +0200
Message-ID: <ad9c71fc-9b13-547c-386e-4a28ddbcf7cb@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <3a03df66-92ce-20fb-17f3-fb79b9d43c8e@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3a03df66-92ce-20fb-17f3-fb79b9d43c8e@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 1 Oct 2016 11:37:24 +0200

Replace the specification of a data structure by a variable name
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/md-cluster.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 0000e3a..c28f596 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1057,7 +1057,7 @@ static int resync_info_update(struct mddev *mddev, sector_t lo, sector_t hi)
 
 	/* do not send zero again, if we have sent before */
 	if (hi == 0) {
-		memcpy(&ri, cinfo->bitmap_lockres->lksb.sb_lvbptr, sizeof(struct resync_info));
+		memcpy(&ri, cinfo->bitmap_lockres->lksb.sb_lvbptr, sizeof(ri));
 		if (le64_to_cpu(ri.hi) == 0)
 			return 0;
 	}
-- 
2.10.0

