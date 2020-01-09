From: jgq516@gmail.com
Subject: [PATCH] raid5: update comment in release_stripe_list
Date: Thu,  9 Jan 2020 15:03:52 +0100
Message-ID: <20200109140352.16263-1-guoqing.jiang@cloud.ionos.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: liu.song.a23@gmail.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids

From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

After commit cf170f3fa451 ("raid5: avoid release list until last
reference of the stripe"), we only set STRIPE_ON_RELEASE_LIST bit
when sh->count is 1.

And no need to mention STRIPE_ON_UNPLUG_LIST here since the related
comment is already in raid5_unplug.

Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
 drivers/md/raid5.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7f8504525435..6a8b5112afa9 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -368,8 +368,7 @@ static int release_stripe_list(struct r5conf *conf,
 		clear_bit(STRIPE_ON_RELEASE_LIST, &sh->state);
 		/*
 		 * Don't worry the bit is set here, because if the bit is set
-		 * again, the count is always > 1. This is true for
-		 * STRIPE_ON_UNPLUG_LIST bit too.
+		 * again, the count is always 1.
 		 */
 		hash = sh->hash_lock_index;
 		__release_stripe(conf, sh, &temp_inactive_list[hash]);
-- 
2.17.1
