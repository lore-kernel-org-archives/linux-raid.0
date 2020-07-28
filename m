From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH 3/5] md: print errno in super_written
Date: Tue, 28 Jul 2020 12:01:41 +0200
Message-ID: <20200728100143.17813-4-guoqing.jiang@cloud.ionos.com>
References: <20200728100143.17813-1-guoqing.jiang@cloud.ionos.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200728100143.17813-1-guoqing.jiang@cloud.ionos.com>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids

It is better to print errno instead of bi_status.

Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
 drivers/md/md.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0c2a0e65b4f1..8f9a89b4c7ba 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -978,7 +978,8 @@ static void super_written(struct bio *bio)
 	struct mddev *mddev = rdev->mddev;
 
 	if (bio->bi_status) {
-		pr_err("md: super_written gets error=%d\n", bio->bi_status);
+		pr_err("md: %s gets error=%d\n", __func__,
+		       blk_status_to_errno(bio->bi_status));
 		md_error(mddev, rdev);
 		if (!test_bit(Faulty, &rdev->flags)
 		    && (bio->bi_opf & MD_FAILFAST)) {
-- 
2.17.1
