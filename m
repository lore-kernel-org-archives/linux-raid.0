From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 3 of 3 - change 'or' to 'plus' in raid1
Date: Tue, 23 Sep 2003 09:27:00 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1A1a56-0004CI-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet

Silly typo.

 ----------- Diffstat output ------------
 ./drivers/md/raid1.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2003-09-23 09:10:56.000000000 +1000
+++ ./drivers/md/raid1.c	2003-09-23 09:12:05.000000000 +1000
@@ -830,7 +830,7 @@ static void sync_request_write(mddev_t *
 		mbio = bio_clone(bio, GFP_NOIO);
 		r1_bio->write_bios[i] = mbio;
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
-		mbio->bi_sector = r1_bio->sector | conf->mirrors[i].rdev->data_offset;
+		mbio->bi_sector = r1_bio->sector + conf->mirrors[i].rdev->data_offset;
 		mbio->bi_end_io	= end_sync_write;
 		mbio->bi_rw = WRITE;
 		mbio->bi_private = r1_bio;
