From: NeilBrown <neilb@suse.de>
Subject: [PATCH 004 of 5] md: Improve detection of lack of barrier support in raid1
Date: Fri, 28 Apr 2006 12:51:50 +1000
Message-ID: <1060428025150.30782@suse.de>
References: <20060428124313.29510.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965204AbWD1CwN@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Move the test for 'do barrier work' down a bit so that if the first
write to a raid1 is a BIO_RW_BARRIER write, the checking done by
superblock writes will cause the right thing to happen.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2006-04-28 12:17:27.000000000 +1000
+++ ./drivers/md/raid1.c	2006-04-28 12:17:40.000000000 +1000
@@ -753,18 +753,24 @@ static int make_request(request_queue_t 
 	const int rw = bio_data_dir(bio);
 	int do_barriers;
 
-	if (unlikely(!mddev->barriers_work && bio_barrier(bio))) {
-		bio_endio(bio, bio->bi_size, -EOPNOTSUPP);
-		return 0;
-	}
-
 	/*
 	 * Register the new request and wait if the reconstruction
 	 * thread has put up a bar for new requests.
 	 * Continue immediately if no resync is active currently.
+	 * We test barriers_work *after* md_write_start as md_write_start
+	 * may cause the first superblock write, and that will check out
+	 * if barriers work.
 	 */
+
 	md_write_start(mddev, bio); /* wait on superblock update early */
 
+	if (unlikely(!mddev->barriers_work && bio_barrier(bio))) {
+		if (rw == WRITE)
+			md_write_end(mddev);
+		bio_endio(bio, bio->bi_size, -EOPNOTSUPP);
+		return 0;
+	}
+
 	wait_barrier(conf);
 
 	disk_stat_inc(mddev->gendisk, ios[rw]);
