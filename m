From: "kedacomkernel" <kedacomkernel@gmail.com>
Subject: [Patch]use atomic_dec_return() instead of atomic_dec() and atomic_read()
Date: Wed, 29 Feb 2012 15:07:52 +0800
Message-ID: <201202291507476878071@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From ebdcb976dc5c7aa992f8bd682babffbbb143de18 Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Wed, 29 Feb 2012 15:05:17 +0800
Subject: [PATCH] md:use atomic_dec_return() instead of atomic_dec() and
 atomic_read().


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/raid5.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 360f2b9..9b58d05 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -208,11 +208,9 @@ static void __release_stripe(struct r5conf *conf, struct stripe_head *sh)
 			md_wakeup_thread(conf->mddev->thread);
 		} else {
 			BUG_ON(stripe_operations_active(sh));
-			if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-				atomic_dec(&conf->preread_active_stripes);
-				if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD)
-					md_wakeup_thread(conf->mddev->thread);
-			}
+			if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state) &&
+				(atomic_dec_return(&conf->preread_active_stripes) < IO_THRESHOLD))
+				md_wakeup_thread(conf->mddev->thread);
 			atomic_dec(&conf->active_stripes);
 			if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
 				list_add_tail(&sh->lru, &conf->inactive_list);
-- 
1.7.5.4

 				
--------------
kedacomkernel
2012-02-29

