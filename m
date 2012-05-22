From: "majianpeng" <majianpeng@gmail.com>
Subject: [PATCH] md/raid456:When degraded raid read error, not remove disk but set badsector
Date: Tue, 22 May 2012 16:38:55 +0800
Message-ID: <201205221638484847156@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 In function raid5_end_read_request(),when degraded raid read failed,it
will call md_error in order to remove this disk. If so,the degraded raid
will become failed raid and lost all data.
Then using badsector function to avoid.

Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/raid5.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f351422..337eb03 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1695,6 +1695,7 @@ static void raid5_end_read_request(struct bio * bi, int error)
 	} else {
 		const char *bdn = bdevname(rdev->bdev, b);
 		int retry = 0;
+		int set_bad = 0;
 
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
 		atomic_inc(&rdev->read_errors);
@@ -1707,7 +1708,9 @@ static void raid5_end_read_request(struct bio * bi, int error)
 				(unsigned long long)(sh->sector
 						     + rdev->data_offset),
 				bdn);
-		else if (conf->mddev->degraded >= conf->max_degraded)
+		else if (conf->mddev->degraded >= conf->max_degraded) {
+			/*Not remove disk,instead of set badblocks */
+			set_bad = 1;
 			printk_ratelimited(
 				KERN_WARNING
 				"md/raid:%s: read error not correctable "
@@ -1716,6 +1719,7 @@ static void raid5_end_read_request(struct bio * bi, int error)
 				(unsigned long long)(sh->sector
 						     + rdev->data_offset),
 				bdn);
+		}
 		else if (test_bit(R5_ReWrite, &sh->dev[i].flags))
 			/* Oh, no!!! */
 			printk_ratelimited(
@@ -1738,7 +1742,9 @@ static void raid5_end_read_request(struct bio * bi, int error)
 		else {
 			clear_bit(R5_ReadError, &sh->dev[i].flags);
 			clear_bit(R5_ReWrite, &sh->dev[i].flags);
-			md_error(conf->mddev, rdev);
+			if (!(set_bad && rdev_set_badblocks(rdev, sh->sector,
+					STRIPE_SECTORS, 0)))
+				md_error(conf->mddev, rdev);
 		}
 	}
 	rdev_dec_pending(rdev, conf->mddev);
-- 
1.7.5.4

 				
--------------
majianpeng
2012-05-22

