From: Paul Clements <paul.clements@steeleye.com>
Subject: [BUG / PATCH] raid1: set BIO_UPTODATE after read error
Date: Fri, 10 Sep 2004 16:22:31 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41420D07.4060001@steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050503050304090003090708"
Return-path: <linux-raid-owner@vger.kernel.org>
To: neilb@cse.unsw.edu.au
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------050503050304090003090708
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Neil,

unless you've already done so, I believe there is a little fix needed in 
the raid1 read reschedule code. As the code currently works, a read that 
is retried will continue to fail and cause raid1 to go into an infinite 
retry loop:

Sep 10 14:42:04 fiji kernel: raid1: sdb1: redirecting sector 2 to 
another mirror
Sep 10 14:42:04 fiji kernel: raid1: sdb1: rescheduling sector 2
Sep 10 14:42:04 fiji kernel: raid1: sdb1: redirecting sector 2 to 
another mirror
Sep 10 14:42:04 fiji kernel: raid1: sdb1: rescheduling sector 2
Sep 10 14:42:04 fiji kernel: raid1: sdb1: redirecting sector 2 to 
another mirror

Patch attached.

Thanks,
Paul

--------------050503050304090003090708
Content-Type: text/plain;
 name="md_raid1_bio_uptodate_fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="md_raid1_bio_uptodate_fix.diff"

--- linux/drivers/md/raid1.c.orig	2004-09-10 13:49:58.000000000 -0400
+++ linux/drivers/md/raid1.c	2004-09-10 15:46:47.000000000 -0400
@@ -970,6 +970,8 @@ static void raid1d(mddev_t *mddev)
 				bio->bi_bdev = rdev->bdev;
 				bio->bi_sector = r1_bio->sector + rdev->data_offset;
 				bio->bi_rw = READ;
+				/* clear any previous error */
+				set_bit(BIO_UPTODATE, &bio->bi_flags);
 				unplug = 1;
 				generic_make_request(bio);
 			}

--------------050503050304090003090708--
