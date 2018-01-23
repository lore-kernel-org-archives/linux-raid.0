From: Lidong Zhong <lzhong@suse.com>
Subject: [PATCH] md-cluster: choose correct label when clustered layout is not supported
Date: Tue, 23 Jan 2018 23:06:12 +0800
Message-ID: <20180123150612.7325-1-lzhong@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: gqjiang@suse.com
List-Id: linux-raid.ids

r10conf is already successfully allocated before checking the layout

Signed-off-by: Lidong Zhong <lzhong@suse.com>
---
 drivers/md/raid10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c131835cf008..c2b2fbeec7b2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3770,7 +3770,7 @@ static int raid10_run(struct mddev *mddev)
 		if (fc > 1 || fo > 0) {
 			pr_err("only near layout is supported by clustered"
 				" raid10\n");
-			goto out;
+			goto out_free_conf;
 		}
 	}
 
-- 
2.13.6

