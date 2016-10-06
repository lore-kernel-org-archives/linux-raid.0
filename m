From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 38/54] md/raid5: Move four asterisks
Date: Thu, 6 Oct 2016 11:38:03 +0200
Message-ID: <8850ab8d-efeb-0f26-d6af-62ad3cbec7bf@users.sourceforge.net>
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
Date: Wed, 5 Oct 2016 15:00:23 +0200

The script "checkpatch.pl" pointed information out like the following.

ERROR: "foo* bar" should be "foo *bar"

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid5.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7a825c0..5bcc1ff 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2306,7 +2306,7 @@ static void shrink_stripes(struct r5conf *conf)
 	conf->slab_cache = NULL;
 }
 
-static void raid5_end_read_request(struct bio * bi)
+static void raid5_end_read_request(struct bio *bi)
 {
 	struct stripe_head *sh = bi->bi_private;
 	struct r5conf *conf = sh->raid_conf;
@@ -4760,7 +4760,7 @@ static struct bio *remove_bio_from_retry(struct r5conf *conf)
  */
 static void raid5_align_endio(struct bio *bi)
 {
-	struct bio* raid_bi  = bi->bi_private;
+	struct bio *raid_bi = bi->bi_private;
 	struct mddev *mddev;
 	struct r5conf *conf;
 	struct md_rdev *rdev;
@@ -4793,7 +4793,7 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 {
 	struct r5conf *conf = mddev->private;
 	int dd_idx;
-	struct bio* align_bi;
+	struct bio *align_bi;
 	struct md_rdev *rdev;
 	sector_t end_sector;
 
@@ -5149,7 +5149,7 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 	}
 }
 
-static void raid5_make_request(struct mddev *mddev, struct bio * bi)
+static void raid5_make_request(struct mddev *mddev, struct bio *bi)
 {
 	struct r5conf *conf = mddev->private;
 	int dd_idx;
-- 
2.10.1

