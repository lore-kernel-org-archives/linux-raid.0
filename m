From: "majianpeng" <majianpeng@gmail.com>
Subject: md/raid5:Fix a bug about judging the operation is syncing or  replaing in analyse_stripe().
Date: Thu, 29 Mar 2012 11:22:52 +0800
Message-ID: <201203291122488286296@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From 4d79586ebffac308ba11b363d81525882fdf6abe Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Thu, 29 Mar 2012 11:12:59 +0800
Subject: [PATCH] md/raid5:Fix a bug about judging the operation is syncing or
 replaing in analyse_stripe().

When create a raid5 using assume-clean and echo check or repair to
sync_action.Then component disks did not operated IO but the raid
check/resync faster than normal.
Because the judgement in function analyse_stripe():
		if (do_recovery ||
		    sh->sector >= conf->mddev->recovery_cp)
			s->syncing = 1;
		else
			s->replacing = 1;
When check or repair,the recovery_cp == MaxSectore,so syncing equal zero
not one.

Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/raid5.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 23ac880..4d43ad3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3276,12 +3276,14 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 		/* If there is a failed device being replaced,
 		 *     we must be recovering.
 		 * else if we are after recovery_cp, we must be syncing
+		 * else if MD_RECOVERY_REQUESTED is set,we all in syning.
 		 * else we can only be replacing
 		 * sync and recovery both need to read all devices, and so
 		 * use the same flag.
 		 */
 		if (do_recovery ||
-		    sh->sector >= conf->mddev->recovery_cp)
+		    sh->sector >= conf->mddev->recovery_cp ||
+		    test_bit(MD_RECOVERY_REQUESTED, &(conf->mddev->recovery)))
 			s->syncing = 1;
 		else
 			s->replacing = 1;
-- 
1.7.5.4

 				
--------------
majianpeng
2012-03-29

