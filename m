From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 4/6] md/raid1: add failfast handling for writes.
Date: Fri, 18 Nov 2016 16:16:12 +1100
Message-ID: <147944617205.3302.7745455065767031472.stgit@noble>
References: <147944614789.3302.1959091446949640579.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <147944614789.3302.1959091446949640579.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, hare@suse.de
List-Id: linux-raid.ids

When writing to a fastfail device we use MD_FASTFAIL unless
it is the only device being written to.

For resync/recovery, assume there was a working device to
read from so always use REQ_FASTFAIL_DEV.

If a write for resync/recovery fails, we just fail the
device - there is not much else to do.

If a normal failfast write fails, but the device cannot be
failed (must be only one left), we queue for write error
handling.  This will call narrow_write_error() to retry the
write synchronously and without any FAILFAST flags.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid1.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 44f93297698d..731fd9fe79ef 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -423,7 +423,24 @@ static void raid1_end_write_request(struct bio *bio)
 			set_bit(MD_RECOVERY_NEEDED, &
 				conf->mddev->recovery);
 
-		set_bit(R1BIO_WriteError, &r1_bio->state);
+		if (test_bit(FailFast, &rdev->flags) &&
+		    (bio->bi_opf & MD_FAILFAST) &&
+		    /* We never try FailFast to WriteMostly devices */
+		    !test_bit(WriteMostly, &rdev->flags)) {
+			md_error(r1_bio->mddev, rdev);
+			if (!test_bit(Faulty, &rdev->flags))
+				/* This is the only remaining device,
+				 * We need to retry the write without
+				 * FailFast
+				 */
+				set_bit(R1BIO_WriteError, &r1_bio->state);
+			else {
+				/* Finished with this branch */
+				r1_bio->bios[mirror] = NULL;
+				to_put = bio;
+			}
+		} else
+			set_bit(R1BIO_WriteError, &r1_bio->state);
 	} else {
 		/*
 		 * Set R1BIO_Uptodate in our master bio, so that we
@@ -1393,6 +1410,10 @@ static void raid1_make_request(struct mddev *mddev, struct bio * bio)
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		mbio->bi_end_io	= raid1_end_write_request;
 		bio_set_op_attrs(mbio, op, do_flush_fua | do_sync);
+		if (test_bit(FailFast, &conf->mirrors[i].rdev->flags) &&
+		    !test_bit(WriteMostly, &conf->mirrors[i].rdev->flags) &&
+		    conf->raid_disks - mddev->degraded > 1)
+			mbio->bi_opf |= MD_FAILFAST;
 		mbio->bi_private = r1_bio;
 
 		atomic_inc(&r1_bio->remaining);
@@ -2061,6 +2082,9 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
 			continue;
 
 		bio_set_op_attrs(wbio, REQ_OP_WRITE, 0);
+		if (test_bit(FailFast, &conf->mirrors[i].rdev->flags))
+			wbio->bi_opf |= MD_FAILFAST;
+
 		wbio->bi_end_io = end_sync_write;
 		atomic_inc(&r1_bio->remaining);
 		md_sync_acct(conf->mirrors[i].rdev->bdev, bio_sectors(wbio));


