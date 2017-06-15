From: Guoqing Jiang <gqjiang@suse.com>
Subject: [RFC PATCH] md/raid1: remove unused bio in sync_request_write
Date: Thu, 15 Jun 2017 17:00:25 +0800
Message-ID: <20170615090025.22826-1-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com, neilb@suse.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

The "bio" is not used in sync_request_write after commit a68e58703575
("md/raid1: split out two sub-functions from sync_request_write").

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
Not sure if my understanding is right, so it is for RFC. 

 drivers/md/raid1.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 6701993..9c51e31 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2181,9 +2181,7 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
 	struct r1conf *conf = mddev->private;
 	int i;
 	int disks = conf->raid_disks * 2;
-	struct bio *bio, *wbio;
-
-	bio = r1_bio->bios[r1_bio->read_disk];
+	struct bio *wbio;
 
 	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
 		/* ouch - failed to read all of that. */
-- 
2.10.0

