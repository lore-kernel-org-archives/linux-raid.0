From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 22/54] md/raid1: Delete three unwanted spaces before increment
 operators
Date: Thu, 6 Oct 2016 11:20:37 +0200
Message-ID: <bd57e346-3dea-02e9-7c6e-c6d44dff423b@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 4 Oct 2016 21:10:37 +0200

The script "checkpatch.pl" pointed information out like the following.

ERROR: space prohibited before that '++' (ctx:WxO)

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid1.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index fc9d600..95f6098 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -220,7 +220,7 @@ static void reschedule_retry(struct r1bio *r1_bio)
 
 	spin_lock_irqsave(&conf->device_lock, flags);
 	list_add(&r1_bio->retry_list, &conf->retry_list);
-	conf->nr_queued ++;
+	conf->nr_queued++;
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 
 	wake_up(&conf->wait_barrier);
@@ -1878,7 +1878,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 		}
 		sectors -= s;
 		sect += s;
-		idx ++;
+		idx++;
 	}
 	set_bit(R1BIO_Uptodate, &r1_bio->state);
 	bio->bi_error = 0;
@@ -2570,7 +2570,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		} else if (!test_bit(In_sync, &rdev->flags)) {
 			bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 			bio->bi_end_io = end_sync_write;
-			write_targets ++;
+			write_targets++;
 		} else {
 			/* may need to read from here */
 			sector_t first_bad = MaxSector;
-- 
2.10.1

