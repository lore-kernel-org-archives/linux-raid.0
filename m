From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 6 of 8 - Abort the resync of raid1 there is only one device.
Date: Fri, 28 May 2004 16:45:25 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1BTb7N-0002Tz-Ep@notabene.cse.unsw.edu.au>
References: <20040528163700.9426.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


If raid1 decides it needs to resync it will do so even if
there is only one working device.  This is pointless.

With this patch we abort resync if there is nowhere to write to.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

 ----------- Diffstat output ------------
 ./drivers/md/md.c    |    2 +-
 ./drivers/md/raid1.c |   13 +++++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-05-28 16:28:13.000000000 +1000
+++ ./drivers/md/md.c	2004-05-28 16:29:32.000000000 +1000
@@ -3317,7 +3317,7 @@ static void md_do_sync(mddev_t *mddev)
 		j += sectors;
 		if (j>1) mddev->curr_resync = j;
 
-		if (last_check + window > j)
+		if (last_check + window > j || j == max_sectors)
 			continue;
 
 		last_check = j;

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2004-05-28 16:28:13.000000000 +1000
+++ ./drivers/md/raid1.c	2004-05-28 16:28:18.000000000 +1000
@@ -1005,6 +1005,7 @@ static int sync_request(mddev_t *mddev, 
 	sector_t max_sector, nr_sectors;
 	int disk;
 	int i;
+	int write_targets = 0;
 
 	if (!conf->r1buf_pool)
 		if (init_resync(conf))
@@ -1081,12 +1082,24 @@ static int sync_request(mddev_t *mddev, 
 			    sector_nr + RESYNC_SECTORS > mddev->recovery_cp)) {
 			bio->bi_rw = WRITE;
 			bio->bi_end_io = end_sync_write;
+			write_targets ++;
 		} else
 			continue;
 		bio->bi_sector = sector_nr + conf->mirrors[i].rdev->data_offset;
 		bio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		bio->bi_private = r1_bio;
 	}
+	if (write_targets == 0) {
+		/* There is nowhere to write, so all non-sync
+		 * drives must be failed - so we are finished
+		 */
+		int rv = max_sector - sector_nr;
+		md_done_sync(mddev, rv, 1);
+		put_buf(r1_bio);
+		atomic_dec(&conf->mirrors[disk].rdev->nr_pending);
+		return rv;
+	}
+
 	nr_sectors = 0;
 	do {
 		struct page *page;
