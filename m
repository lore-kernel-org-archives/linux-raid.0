From: NeilBrown <neilb@suse.de>
Subject: [PATCH] md: Fix several raid1 bugs which cause a memory leak...
Date: Thu, 9 Mar 2006 14:16:29 +1100
Message-ID: <1060309031629.22478@suse.de>
References: <20060309141537.22458.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932334AbWCIDRe@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

This patch is suitable for 2.6.16
NeilBrown


### Comments for Changeset

- wrong test for 'is this a BARRIER bio'
- not freeing on all possible paths.
- using r1_bio after freeing it.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2006-03-09 14:14:26.000000000 +1100
+++ ./drivers/md/raid1.c	2006-03-09 14:14:26.000000000 +1100
@@ -306,6 +306,7 @@ static int raid1_end_write_request(struc
 	r1bio_t * r1_bio = (r1bio_t *)(bio->bi_private);
 	int mirror, behind = test_bit(R1BIO_BehindIO, &r1_bio->state);
 	conf_t *conf = mddev_to_conf(r1_bio->mddev);
+	struct bio *to_put = NULL;
 
 	if (bio->bi_size)
 		return 1;
@@ -323,6 +324,7 @@ static int raid1_end_write_request(struc
 		 * this branch is our 'one mirror IO has finished' event handler:
 		 */
 		r1_bio->bios[mirror] = NULL;
+		to_put = bio;
 		if (!uptodate) {
 			md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
 			/* an I/O failed, we can't clear the bitmap */
@@ -375,7 +377,7 @@ static int raid1_end_write_request(struc
 			/* Don't dec_pending yet, we want to hold
 			 * the reference over the retry
 			 */
-			return 0;
+			goto out;
 		}
 		if (test_bit(R1BIO_BehindIO, &r1_bio->state)) {
 			/* free extra copy of the data pages */
@@ -392,10 +394,11 @@ static int raid1_end_write_request(struc
 		raid_end_bio_io(r1_bio);
 	}
 
-	if (r1_bio->bios[mirror]==NULL)
-		bio_put(bio);
-
 	rdev_dec_pending(conf->mirrors[mirror].rdev, conf->mddev);
+ out:
+	if (to_put)
+		bio_put(to_put);
+
 	return 0;
 }
 
@@ -857,7 +860,7 @@ static int make_request(request_queue_t 
 	atomic_set(&r1_bio->remaining, 0);
 	atomic_set(&r1_bio->behind_remaining, 0);
 
-	do_barriers = bio->bi_rw & BIO_RW_BARRIER;
+	do_barriers = bio_barrier(bio);
 	if (do_barriers)
 		set_bit(R1BIO_Barrier, &r1_bio->state);
 
