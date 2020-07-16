From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 3/4] md: raid5: Fix compilation warning
Date: Thu, 16 Jul 2020 13:54:42 +0900
Message-ID: <20200716045443.662056-4-damien.lemoal@wdc.com>
References: <20200716045443.662056-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200716045443.662056-1-damien.lemoal@wdc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Remove the if statement around the calls to sysfs_link_rdev() to avoid
the compilation warning "suggest braces around empty body in an ‘if’
statement" when compiling with W=1.

Also fix function description comments to avoid kdoc format warnings.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/raid5.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a4fbafa5b8f8..2dad541a60da 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2217,9 +2217,9 @@ static int grow_stripes(struct r5conf *conf, int num)
 /**
  * scribble_alloc - allocate percpu scribble buffer for required size
  *		    of the scribble region
- * @percpu - from for_each_present_cpu() of the caller
- * @num - total number of disks in the array
- * @cnt - scribble objs count for required size of the scribble region
+ * @percpu: from for_each_present_cpu() of the caller
+ * @num: total number of disks in the array
+ * @cnt: scribble objs count for required size of the scribble region
  *
  * The scribble buffer size must be enough to contain:
  * 1/ a struct page pointer for each device in the array +2
@@ -3710,7 +3710,7 @@ static int fetch_block(struct stripe_head *sh, struct stripe_head_state *s,
 	return 0;
 }
 
-/**
+/*
  * handle_stripe_fill - read or compute data to satisfy pending requests.
  */
 static void handle_stripe_fill(struct stripe_head *sh,
@@ -7944,8 +7944,8 @@ static int raid5_start_reshape(struct mddev *mddev)
 					else
 						rdev->recovery_offset = 0;
 
-					if (sysfs_link_rdev(mddev, rdev))
-						/* Failure here is OK */;
+					/* Failure here is OK */
+					sysfs_link_rdev(mddev, rdev);
 				}
 			} else if (rdev->raid_disk >= conf->previous_raid_disks
 				   && !test_bit(Faulty, &rdev->flags)) {
-- 
2.26.2
