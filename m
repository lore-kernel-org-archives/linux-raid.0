From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 54/54] md/raid10: Add some spaces for better code readability
Date: Thu, 6 Oct 2016 11:54:09 +0200
Message-ID: <4ca5a445-badc-7365-e7a7-5ce243bc2b27@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 5 Oct 2016 22:22:14 +0200

Use space characters at some source code places according to
the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid10.c | 71 +++++++++++++++++++++++++++--------------------------
 1 file changed, 36 insertions(+), 35 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 09c0e2f..786992c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -224,7 +224,7 @@ static void r10buf_pool_free(void *__r10_bio, void *data)
 	struct r10bio *r10bio = __r10_bio;
 	int j;
 
-	for (j=0; j < conf->copies; j++) {
+	for (j = 0; j < conf->copies; j++) {
 		struct bio *bio = r10bio->devs[j].bio;
 		if (bio) {
 			for (i = 0; i < RESYNC_PAGES; i++) {
@@ -553,7 +553,7 @@ static void raid10_end_write_request(struct bio *bio)
 
 static void __raid10_find_phys(struct geom *geo, struct r10bio *r10bio)
 {
-	int n,f;
+	int n, f;
 	sector_t sector;
 	sector_t chunk;
 	sector_t stripe;
@@ -1937,7 +1937,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	atomic_set(&r10_bio->remaining, 1);
 
 	/* find the first device with a block */
-	for (i=0; i<conf->copies; i++)
+	for (i = 0; i < conf->copies; i++)
 		if (!r10_bio->devs[i].bio->bi_error)
 			break;
 
@@ -1951,7 +1951,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 
 	vcnt = (r10_bio->sectors + (PAGE_SIZE >> 9) - 1) >> (PAGE_SHIFT - 9);
 	/* now find blocks with errors */
-	for (i=0 ; i < conf->copies ; i++) {
+	for (i = 0; i < conf->copies; i++) {
 		int  j, d;
 
 		tbio = r10_bio->devs[i].bio;
@@ -2236,7 +2236,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 {
 	int sect = 0; /* Offset from r10_bio->sector */
 	int sectors = r10_bio->sectors;
-	struct md_rdev*rdev;
+	struct md_rdev *rdev;
 	int max_read_errors = atomic_read(&mddev->max_corr_read_errors);
 	int d = r10_bio->devs[r10_bio->read_slot].devnum;
 
@@ -2265,7 +2265,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 		return;
 	}
 
-	while(sectors) {
+	while (sectors) {
 		int s = sectors;
 		int sl = r10_bio->read_slot;
 		int success = 0;
@@ -2331,7 +2331,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 		while (sl != r10_bio->read_slot) {
 			char b[BDEVNAME_SIZE];
 
-			if (sl==0)
+			if (sl == 0)
 				sl = conf->copies;
 			sl--;
 			d = r10_bio->devs[sl].devnum;
@@ -2368,7 +2368,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 		while (sl != r10_bio->read_slot) {
 			char b[BDEVNAME_SIZE];
 
-			if (sl==0)
+			if (sl == 0)
 				sl = conf->copies;
 			sl--;
 			d = r10_bio->devs[sl].devnum;
@@ -2996,7 +2996,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			raise_barrier(conf, rb2 != NULL);
 			atomic_set(&r10_bio->remaining, 0);
 
-			r10_bio->master_bio = (struct bio*)rb2;
+			r10_bio->master_bio = (struct bio *)rb2;
 			if (rb2)
 				atomic_inc(&rb2->remaining);
 			r10_bio->mddev = mddev;
@@ -3022,7 +3022,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 						      &sync_blocks, still_degraded);
 
 			any_working = 0;
-			for (j=0; j<conf->copies;j++) {
+			for (j = 0; j < conf->copies; j++) {
 				int k;
 				int d = r10_bio->devs[j].devnum;
 				sector_t from_addr, to_addr;
@@ -3063,7 +3063,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				atomic_inc(&rdev->nr_pending);
 				/* and we write to 'i' (if not in_sync) */
 
-				for (k=0; k<conf->copies; k++)
+				for (k = 0; k < conf->copies; k++)
 					if (r10_bio->devs[k].devnum == i)
 						break;
 				BUG_ON(k == conf->copies);
@@ -3165,7 +3165,8 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		if (!biolist) {
 			while (r10_bio) {
 				struct r10bio *rb2 = r10_bio;
-				r10_bio = (struct r10bio*) rb2->master_bio;
+
+				r10_bio = (struct r10bio *) rb2->master_bio;
 				rb2->master_bio = NULL;
 				put_buf(rb2);
 			}
@@ -3268,7 +3269,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		}
 
 		if (count < 2) {
-			for (i=0; i<conf->copies; i++) {
+			for (i = 0; i < conf->copies; i++) {
 				int d = r10_bio->devs[i].devnum;
 				if (r10_bio->devs[i].bio->bi_end_io)
 					rdev_dec_pending(conf->mirrors[d].rdev,
@@ -3295,7 +3296,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			len = (max_sector - sector_nr) << 9;
 		if (len == 0)
 			break;
-		for (bio= biolist ; bio ; bio=bio->bi_next) {
+		for (bio = biolist; bio; bio = bio->bi_next) {
 			struct bio *bio2;
 			page = bio->bi_io_vec[bio->bi_vcnt].bv_page;
 			if (bio_add_page(bio, page, len, 0))
@@ -3765,7 +3766,7 @@ static void raid10_quiesce(struct mddev *mddev, int state)
 {
 	struct r10conf *conf = mddev->private;
 
-	switch(state) {
+	switch (state) {
 	case 1:
 		raise_barrier(conf, 0);
 		break;
@@ -4658,26 +4659,26 @@ static void raid10_finish_reshape(struct mddev *mddev)
 }
 
 static struct md_personality raid10_personality = {
-	.name		= "raid10",
-	.level		= 10,
-	.owner		= THIS_MODULE,
-	.make_request	= raid10_make_request,
-	.run		= raid10_run,
-	.free		= raid10_free,
-	.status		= raid10_status,
-	.error_handler	= raid10_error,
-	.hot_add_disk	= raid10_add_disk,
-	.hot_remove_disk= raid10_remove_disk,
-	.spare_active	= raid10_spare_active,
-	.sync_request	= raid10_sync_request,
-	.quiesce	= raid10_quiesce,
-	.size		= raid10_size,
-	.resize		= raid10_resize,
-	.takeover	= raid10_takeover,
-	.check_reshape	= raid10_check_reshape,
-	.start_reshape	= raid10_start_reshape,
-	.finish_reshape	= raid10_finish_reshape,
-	.congested	= raid10_congested,
+	.name            = "raid10",
+	.level           = 10,
+	.owner           = THIS_MODULE,
+	.make_request    = raid10_make_request,
+	.run             = raid10_run,
+	.free            = raid10_free,
+	.status          = raid10_status,
+	.error_handler   = raid10_error,
+	.hot_add_disk    = raid10_add_disk,
+	.hot_remove_disk = raid10_remove_disk,
+	.spare_active    = raid10_spare_active,
+	.sync_request    = raid10_sync_request,
+	.quiesce         = raid10_quiesce,
+	.size            = raid10_size,
+	.resize          = raid10_resize,
+	.takeover        = raid10_takeover,
+	.check_reshape   = raid10_check_reshape,
+	.start_reshape   = raid10_start_reshape,
+	.finish_reshape  = raid10_finish_reshape,
+	.congested       = raid10_congested,
 };
 
 static int __init raid_init(void)
-- 
2.10.1

