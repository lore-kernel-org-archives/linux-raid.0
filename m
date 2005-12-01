From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 005 of 14] raid10 read-error handling - resync and read-only
Date: Thu, 1 Dec 2005 14:23:11 +1100
Message-ID: <1051201032311.29605@suse.de>
References: <20051201141508.29384.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Add in correct read-error handling for resync and read-only
situations.
When read-only, we don't over-write, so we need to mark the failed
drive in the r10_bio so we don't re-try it.
During resync, we always read all blocks, so if there is a read error,
we simply over-write it with the good block that we found (assuming
we found one).

Note that the recovery case still isn't handled in an interesting way.
There is nothing useful to do for the 2-copies case.  If there are 3
or more copies, then we could try reading from one of the non-missing
copies, but this is a bit complicated and very rarely would be used,
so I'm leaving it for now.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid10.c         |   56 ++++++++++++++++++++++++++----------------
 ./include/linux/raid/raid10.h |    7 +++++
 2 files changed, 42 insertions(+), 21 deletions(-)

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2005-11-29 14:07:05.000000000 +1100
+++ ./drivers/md/raid10.c	2005-11-29 14:11:01.000000000 +1100
@@ -172,7 +172,7 @@ static void put_all_bios(conf_t *conf, r
 
 	for (i = 0; i < conf->copies; i++) {
 		struct bio **bio = & r10_bio->devs[i].bio;
-		if (*bio)
+		if (*bio && *bio != IO_BLOCKED)
 			bio_put(*bio);
 		*bio = NULL;
 	}
@@ -500,6 +500,7 @@ static int read_balance(conf_t *conf, r1
 		disk = r10_bio->devs[slot].devnum;
 
 		while ((rdev = rcu_dereference(conf->mirrors[disk].rdev)) == NULL ||
+		       r10_bio->devs[slot].bio == IO_BLOCKED ||
 		       !test_bit(In_sync, &rdev->flags)) {
 			slot++;
 			if (slot == conf->copies) {
@@ -517,6 +518,7 @@ static int read_balance(conf_t *conf, r1
 	slot = 0;
 	disk = r10_bio->devs[slot].devnum;
 	while ((rdev=rcu_dereference(conf->mirrors[disk].rdev)) == NULL ||
+	       r10_bio->devs[slot].bio == IO_BLOCKED ||
 	       !test_bit(In_sync, &rdev->flags)) {
 		slot ++;
 		if (slot == conf->copies) {
@@ -537,6 +539,7 @@ static int read_balance(conf_t *conf, r1
 
 
 		if ((rdev=rcu_dereference(conf->mirrors[ndisk].rdev)) == NULL ||
+		    r10_bio->devs[nslot].bio == IO_BLOCKED ||
 		    !test_bit(In_sync, &rdev->flags))
 			continue;
 
@@ -1104,7 +1107,6 @@ abort:
 
 static int end_sync_read(struct bio *bio, unsigned int bytes_done, int error)
 {
-	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	r10bio_t * r10_bio = (r10bio_t *)(bio->bi_private);
 	conf_t *conf = mddev_to_conf(r10_bio->mddev);
 	int i,d;
@@ -1119,7 +1121,10 @@ static int end_sync_read(struct bio *bio
 		BUG();
 	update_head_pos(i, r10_bio);
 	d = r10_bio->devs[i].devnum;
-	if (!uptodate)
+
+	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
+		set_bit(R10BIO_Uptodate, &r10_bio->state);
+	else if (!test_bit(MD_RECOVERY_SYNC, &conf->mddev->recovery))
 		md_error(r10_bio->mddev,
 			 conf->mirrors[d].rdev);
 
@@ -1209,25 +1214,30 @@ static void sync_request_write(mddev_t *
 	fbio = r10_bio->devs[i].bio;
 
 	/* now find blocks with errors */
-	for (i=first+1 ; i < conf->copies ; i++) {
-		int vcnt, j, d;
+	for (i=0 ; i < conf->copies ; i++) {
+		int  j, d;
+		int vcnt = r10_bio->sectors >> (PAGE_SHIFT-9);
 
-		if (!test_bit(BIO_UPTODATE, &r10_bio->devs[i].bio->bi_flags))
-			continue;
-		/* We know that the bi_io_vec layout is the same for
-		 * both 'first' and 'i', so we just compare them.
-		 * All vec entries are PAGE_SIZE;
-		 */
 		tbio = r10_bio->devs[i].bio;
-		vcnt = r10_bio->sectors >> (PAGE_SHIFT-9);
-		for (j = 0; j < vcnt; j++)
-			if (memcmp(page_address(fbio->bi_io_vec[j].bv_page),
-				   page_address(tbio->bi_io_vec[j].bv_page),
-				   PAGE_SIZE))
-				break;
-		if (j == vcnt)
+
+		if (tbio->bi_end_io != end_sync_read)
+			continue;
+		if (i == first)
 			continue;
-		mddev->resync_mismatches += r10_bio->sectors;
+		if (test_bit(BIO_UPTODATE, &r10_bio->devs[i].bio->bi_flags)) {
+			/* We know that the bi_io_vec layout is the same for
+			 * both 'first' and 'i', so we just compare them.
+			 * All vec entries are PAGE_SIZE;
+			 */
+			for (j = 0; j < vcnt; j++)
+				if (memcmp(page_address(fbio->bi_io_vec[j].bv_page),
+					   page_address(tbio->bi_io_vec[j].bv_page),
+					   PAGE_SIZE))
+					break;
+			if (j == vcnt)
+				continue;
+			mddev->resync_mismatches += r10_bio->sectors;
+		}
 		if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
 			/* Don't fix anything. */
 			continue;
@@ -1308,7 +1318,10 @@ static void recovery_request_write(mddev
 
 	atomic_inc(&conf->mirrors[d].rdev->nr_pending);
 	md_sync_acct(conf->mirrors[d].rdev->bdev, wbio->bi_size >> 9);
-	generic_make_request(wbio);
+	if (test_bit(R10BIO_Uptodate, &r10_bio->state))
+		generic_make_request(wbio);
+	else
+		bio_endio(wbio, wbio->bi_size, -EIO);
 }
 
 
@@ -1445,7 +1458,8 @@ static void raid10d(mddev_t *mddev)
 			unfreeze_array(conf);
 
 			bio = r10_bio->devs[r10_bio->read_slot].bio;
-			r10_bio->devs[r10_bio->read_slot].bio = NULL;
+			r10_bio->devs[r10_bio->read_slot].bio =
+				mddev->ro ? IO_BLOCKED : NULL;
 			bio_put(bio);
 			mirror = read_balance(conf, r10_bio);
 			if (mirror == -1) {

diff ./include/linux/raid/raid10.h~current~ ./include/linux/raid/raid10.h
--- ./include/linux/raid/raid10.h~current~	2005-11-29 14:07:05.000000000 +1100
+++ ./include/linux/raid/raid10.h	2005-11-29 12:09:11.000000000 +1100
@@ -104,6 +104,13 @@ struct r10bio_s {
 	} devs[0];
 };
 
+/* when we get a read error on a read-only array, we redirect to another
+ * device without failing the first device, or trying to over-write to
+ * correct the read error.  To keep track of bad blocks on a per-bio
+ * level, we store IO_BLOCKED in the appropriate 'bios' pointer
+ */
+#define IO_BLOCKED ((struct bio*)1)
+
 /* bits for r10bio.state */
 #define	R10BIO_Uptodate	0
 #define	R10BIO_IsSync	1
