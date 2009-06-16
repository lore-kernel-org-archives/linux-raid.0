From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject:[PATCH 002:013]: raid0: find_zone to return NULL
Date: Wed, 17 Jun 2009 00:52:29 +0300
Message-ID: <1245189149.3478.96.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Have the caller decide whether to report BUG() 
	when zone is incorrect

 raid0.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Signed-off-by: razb <raziebe@gmail.com>
---
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 851e631..8870acc 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -377,7 +377,7 @@ static struct strip_zone *find_zone(struct raid0_private_data *conf,
 				*sectorp = sector - z[i-1].zone_end;
 			return z + i;
 		}
-	BUG();
+	return NULL;
 }
 
 /*
@@ -481,6 +481,8 @@ static int raid0_make_request(struct request_queue *q, struct bio *bio)
 
 	sector_offset = bio->bi_sector;
 	zone =  find_zone(mddev->private, &sector_offset);
+	if (!zone)
+		BUG();
 	tmp_dev = map_sector(mddev, zone, bio->bi_sector,
 			     &sector_offset);
 	bio->bi_bdev = tmp_dev->bdev;





