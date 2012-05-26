From: "majianpeng" <majianpeng@gmail.com>
Subject: [PATCH 1/2] md/raid456: When readed error and raid was degraded,it try to set badsector, not ejecting the rdev.
Date: Sat, 26 May 2012 10:53:40 +0800
Message-ID: <201205261053373758667@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

In order to prevent the degraded raid from becaming fail,we should first
set badsector instead of ejecting the rdev when read fail.

Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/raid5.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d267672..89cfd73 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1737,6 +1737,7 @@ static void raid5_end_read_request(struct bio * bi, int error)
 	} else {
 		const char *bdn = bdevname(rdev->bdev, b);
 		int retry = 0;
+		int set_bad = 0;
 
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
 		atomic_inc(&rdev->read_errors);
@@ -1748,7 +1749,8 @@ static void raid5_end_read_request(struct bio * bi, int error)
 				mdname(conf->mddev),
 				(unsigned long long)s,
 				bdn);
-		else if (conf->mddev->degraded >= conf->max_degraded)
+		else if (conf->mddev->degraded >= conf->max_degraded) {
+			set_bad = 1;
 			printk_ratelimited(
 				KERN_WARNING
 				"md/raid:%s: read error not correctable "
@@ -1756,6 +1758,7 @@ static void raid5_end_read_request(struct bio * bi, int error)
 				mdname(conf->mddev),
 				(unsigned long long)s,
 				bdn);
+		}
 		else if (test_bit(R5_ReWrite, &sh->dev[i].flags))
 			/* Oh, no!!! */
 			printk_ratelimited(
@@ -1777,7 +1780,10 @@ static void raid5_end_read_request(struct bio * bi, int error)
 		else {
 			clear_bit(R5_ReadError, &sh->dev[i].flags);
 			clear_bit(R5_ReWrite, &sh->dev[i].flags);
-			md_error(conf->mddev, rdev);
+			if (!(set_bad && test_bit(In_sync, &rdev->flags)
+					&& rdev_set_badblocks(rdev,
+					sh->sector, STRIPE_SECTORS, 0)))
+				md_error(conf->mddev, rdev);
 		}
 	}
 	rdev_dec_pending(rdev, conf->mddev);
-- 
1.7.5.4

 				
--------------
majianpeng
2012-05-26

