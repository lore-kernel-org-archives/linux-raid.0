From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH] raid1: factor out a common routine to handle the completion of sync write
Date: Sat, 27 Jul 2019 14:02:58 +0800
Message-ID: <20190727060258.63036-1-houtao1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: songliubraving@fb.com, linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

It's just code clean-up.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 drivers/md/raid1.c | 39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 1755d2233e4d..d73ed94764c1 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1904,6 +1904,22 @@ static void abort_sync_write(struct mddev *mddev, struct r1bio *r1_bio)
 	} while (sectors_to_go > 0);
 }
 
+static void put_sync_write_buf(struct r1bio *r1_bio, int uptodate)
+{
+	if (atomic_dec_and_test(&r1_bio->remaining)) {
+		struct mddev *mddev = r1_bio->mddev;
+		int s = r1_bio->sectors;
+
+		if (test_bit(R1BIO_MadeGood, &r1_bio->state) ||
+		    test_bit(R1BIO_WriteError, &r1_bio->state))
+			reschedule_retry(r1_bio);
+		else {
+			put_buf(r1_bio);
+			md_done_sync(mddev, s, uptodate);
+		}
+	}
+}
+
 static void end_sync_write(struct bio *bio)
 {
 	int uptodate = !bio->bi_status;
@@ -1930,16 +1946,7 @@ static void end_sync_write(struct bio *bio)
 		)
 		set_bit(R1BIO_MadeGood, &r1_bio->state);
 
-	if (atomic_dec_and_test(&r1_bio->remaining)) {
-		int s = r1_bio->sectors;
-		if (test_bit(R1BIO_MadeGood, &r1_bio->state) ||
-		    test_bit(R1BIO_WriteError, &r1_bio->state))
-			reschedule_retry(r1_bio);
-		else {
-			put_buf(r1_bio);
-			md_done_sync(mddev, s, uptodate);
-		}
-	}
+	put_sync_write_buf(r1_bio, uptodate);
 }
 
 static int r1_sync_page_io(struct md_rdev *rdev, sector_t sector,
@@ -2222,17 +2229,7 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
 		generic_make_request(wbio);
 	}
 
-	if (atomic_dec_and_test(&r1_bio->remaining)) {
-		/* if we're here, all write(s) have completed, so clean up */
-		int s = r1_bio->sectors;
-		if (test_bit(R1BIO_MadeGood, &r1_bio->state) ||
-		    test_bit(R1BIO_WriteError, &r1_bio->state))
-			reschedule_retry(r1_bio);
-		else {
-			put_buf(r1_bio);
-			md_done_sync(mddev, s, 1);
-		}
-	}
+	put_sync_write_buf(r1_bio, 1);
 }
 
 /*
-- 
2.22.0
