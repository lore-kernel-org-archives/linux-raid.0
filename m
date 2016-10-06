From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 20/54] md/raid1: Add some spaces for better code readability
Date: Thu, 6 Oct 2016 11:18:09 +0200
Message-ID: <ab97fe08-ce31-0b20-34eb-a183ed5515a6@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 4 Oct 2016 20:42:25 +0200

Use space characters at some source code places according to
the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid1.c | 62 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 32 insertions(+), 30 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 9754b7d..3a03d19 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -136,8 +136,8 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 	}
 	/* If not user-requests, copy the page pointers to all bios */
 	if (!test_bit(MD_RECOVERY_REQUESTED, &pi->mddev->recovery)) {
-		for (i=0; i<RESYNC_PAGES ; i++)
-			for (j=1; j<pi->raid_disks; j++)
+		for (i = 0; i < RESYNC_PAGES ; i++)
+			for (j = 1; j < pi->raid_disks; j++)
 				r1_bio->bios[j]->bi_io_vec[i].bv_page =
 					r1_bio->bios[0]->bi_io_vec[i].bv_page;
 	}
@@ -160,7 +160,7 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 static void r1buf_pool_free(void *__r1_bio, void *data)
 {
 	struct pool_info *pi = data;
-	int i,j;
+	int i, j;
 	struct r1bio *r1bio = __r1_bio;
 
 	for (i = 0; i < RESYNC_PAGES; i++)
@@ -170,7 +170,7 @@ static void r1buf_pool_free(void *__r1_bio, void *data)
 			    r1bio->bios[0]->bi_io_vec[i].bv_page)
 				safe_put_page(r1bio->bios[j]->bi_io_vec[i].bv_page);
 		}
-	for (i=0 ; i < pi->raid_disks; i++)
+	for (i = 0 ; i < pi->raid_disks; i++)
 		bio_put(r1bio->bios[i]);
 
 	r1bio_pool_free(r1bio, data);
@@ -1785,7 +1785,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 	int sectors = r1_bio->sectors;
 	int idx = 0;
 
-	while(sectors) {
+	while (sectors) {
 		int s = sectors;
 		int d = r1_bio->read_disk;
 		int success = 0;
@@ -2040,7 +2040,8 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 			   sector_t sect, int sectors)
 {
 	struct mddev *mddev = conf->mddev;
-	while(sectors) {
+
+	while (sectors) {
 		int s = sectors;
 		int d = read_disk;
 		int success = 0;
@@ -2087,7 +2088,7 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 		/* write it back and re-read */
 		start = d;
 		while (d != read_disk) {
-			if (d==0)
+			if (d == 0)
 				d = conf->raid_disks * 2;
 			d--;
 			rcu_read_lock();
@@ -2105,7 +2106,8 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 		d = start;
 		while (d != read_disk) {
 			char b[BDEVNAME_SIZE];
-			if (d==0)
+
+			if (d == 0)
 				d = conf->raid_disks * 2;
 			d--;
 			rcu_read_lock();
@@ -2942,7 +2944,7 @@ static int raid1_run(struct mddev *mddev)
 	}
 
 	mddev->degraded = 0;
-	for (i=0; i < conf->raid_disks; i++)
+	for (i = 0; i < conf->raid_disks; i++)
 		if (!conf->mirrors[i].rdev ||
 		    !test_bit(In_sync, &conf->mirrors[i].rdev->flags) ||
 		    test_bit(Faulty, &conf->mirrors[i].rdev->flags))
@@ -3067,8 +3069,8 @@ static int raid1_reshape(struct mddev *mddev)
 	raid_disks = mddev->raid_disks + mddev->delta_disks;
 
 	if (raid_disks < conf->raid_disks) {
-		cnt=0;
-		for (d= 0; d < conf->raid_disks; d++)
+		cnt = 0;
+		for (d = 0; d < conf->raid_disks; d++)
 			if (conf->mirrors[d].rdev)
 				cnt++;
 		if (cnt > raid_disks)
@@ -3139,7 +3141,7 @@ static void raid1_quiesce(struct mddev *mddev, int state)
 {
 	struct r1conf *conf = mddev->private;
 
-	switch(state) {
+	switch (state) {
 	case 2: /* wake for suspend */
 		wake_up(&conf->wait_barrier);
 		break;
@@ -3172,24 +3174,24 @@ static void *raid1_takeover(struct mddev *mddev)
 }
 
 static struct md_personality raid1_personality = {
-	.name		= "raid1",
-	.level		= 1,
-	.owner		= THIS_MODULE,
-	.make_request	= raid1_make_request,
-	.run		= raid1_run,
-	.free		= raid1_free,
-	.status		= raid1_status,
-	.error_handler	= raid1_error,
-	.hot_add_disk	= raid1_add_disk,
-	.hot_remove_disk= raid1_remove_disk,
-	.spare_active	= raid1_spare_active,
-	.sync_request	= raid1_sync_request,
-	.resize		= raid1_resize,
-	.size		= raid1_size,
-	.check_reshape	= raid1_reshape,
-	.quiesce	= raid1_quiesce,
-	.takeover	= raid1_takeover,
-	.congested	= raid1_congested,
+	.name            = "raid1",
+	.level           = 1,
+	.owner           = THIS_MODULE,
+	.make_request    = raid1_make_request,
+	.run             = raid1_run,
+	.free            = raid1_free,
+	.status          = raid1_status,
+	.error_handler   = raid1_error,
+	.hot_add_disk    = raid1_add_disk,
+	.hot_remove_disk = raid1_remove_disk,
+	.spare_active    = raid1_spare_active,
+	.sync_request    = raid1_sync_request,
+	.resize          = raid1_resize,
+	.size            = raid1_size,
+	.check_reshape   = raid1_reshape,
+	.quiesce         = raid1_quiesce,
+	.takeover        = raid1_takeover,
+	.congested       = raid1_congested,
 };
 
 static int __init raid_init(void)
-- 
2.10.1
