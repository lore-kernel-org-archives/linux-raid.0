From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 2/2] md: simplify the code with md_kick_rdev_from_array
Date: Thu,  2 Jun 2016 23:32:05 -0400
Message-ID: <1464924725-18096-2-git-send-email-gqjiang@suse.com>
References: <1464924725-18096-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1464924725-18096-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 25d4542..459f189 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2478,8 +2478,7 @@ static int add_bound_rdev(struct md_rdev *rdev)
 		if (add_journal)
 			mddev_resume(mddev);
 		if (err) {
-			unbind_rdev_from_array(rdev);
-			export_rdev(rdev);
+			md_kick_rdev_from_array(rdev);
 			return err;
 		}
 	}
-- 
2.6.6

