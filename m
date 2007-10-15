From: NeilBrown <neilb@suse.de>
Subject: [PATCH 004 of 5] md: Make sure read errors are auto-corrected during a 'check' resync in raid1
Date: Mon, 15 Oct 2007 14:34:43 +1000
Message-ID: <1071015043443.5517@suse.de>
References: <20071015143136.5200.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Whenever a read error is found, we should attempt to overwrite with
correct data to 'fix' it.

However when do a 'check' pass (which compares data blocks that are
successfully read, but doesn't normally overwrite) we don't do that.
We should.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2007-10-15 14:07:17.000000000 +1000
+++ ./drivers/md/raid1.c	2007-10-15 14:08:55.000000000 +1000
@@ -1214,7 +1214,8 @@ static void sync_request_write(mddev_t *
 					j = 0;
 				if (j >= 0)
 					mddev->resync_mismatches += r1_bio->sectors;
-				if (j < 0 || test_bit(MD_RECOVERY_CHECK, &mddev->recovery)) {
+				if (j < 0 || (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)
+					      && test_bit(BIO_UPTODATE, &sbio->bi_flags))) {
 					sbio->bi_end_io = NULL;
 					rdev_dec_pending(conf->mirrors[i].rdev, mddev);
 				} else {
