From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] md/raid5: fix possible NULL pointer dereference in debug routine
Date: Fri, 24 Jun 2011 14:04:00 +0900
Message-ID: <1308891840-5683-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

When I ran dynamic debug, I encountered a NULL pointer dereference
bug in add_stripe_bio(). Prior to second call to pr_debug(), @bi
was reused in order to check whether the request is partial write
or not, and it could lead to set @bi to NULL.

Since we save original @bi pointer into local variable 'bip', use
it instead of NULL-able @bi.

Also changed confusing 'bh' to 'bi' in the first message.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/raid5.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 82c07fb38961..c814a6075c79 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2139,7 +2139,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 	raid5_conf_t *conf = sh->raid_conf;
 	int firstwrite=0;
 
-	pr_debug("adding bh b#%llu to stripe s#%llu\n",
+	pr_debug("adding bi b#%llu to stripe s#%llu\n",
 		(unsigned long long)bi->bi_sector,
 		(unsigned long long)sh->sector);
 
@@ -2181,7 +2181,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 	spin_unlock_irq(&conf->device_lock);
 
 	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
-		(unsigned long long)bi->bi_sector,
+		(unsigned long long)(*bip)->bi_sector,
 		(unsigned long long)sh->sector, dd_idx);
 
 	if (conf->mddev->bitmap && firstwrite) {
-- 
1.7.5.2

