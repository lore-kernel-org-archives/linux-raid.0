From: NeilBrown <neilb@suse.de>
Subject: [PATCH 006 of 6] md: Add error reporting to superblock write failure
Date: Fri, 29 Sep 2006 12:53:32 +1000
Message-ID: <1060929025332.15323@suse.de>
References: <20060929125047.14064.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964993AbWI2Cxp@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2006-09-29 11:49:00.000000000 +1000
+++ ./drivers/md/md.c	2006-09-29 11:51:39.000000000 +1000
@@ -389,8 +389,12 @@ static int super_written(struct bio *bio
 	if (bio->bi_size)
 		return 1;
 
-	if (error || !test_bit(BIO_UPTODATE, &bio->bi_flags))
+	if (error || !test_bit(BIO_UPTODATE, &bio->bi_flags)) {
+		printk("md: super_written gets error=%d, uptodate=%d\n",
+		       error, test_bit(BIO_UPTODATE, &bio->bi_flags));
+		WARN_ON(test_bit(BIO_UPTODATE, &bio->bi_flags));
 		md_error(mddev, rdev);
+	}
 
 	if (atomic_dec_and_test(&mddev->pending_writes))
 		wake_up(&mddev->sb_wait);
