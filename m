From: NeilBrown <neilb@suse.de>
Subject: [PATCH 007 of 12] md: Fix usage of wrong variable in raid1
Date: Tue, 27 Jun 2006 17:05:42 +1000
Message-ID: <1060627070542.26034@suse.de>
References: <20060627170010.25835.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Though it rarely matters, we should be using 's' rather than
r1_bio->sector here.

### Diffstat output
 ./drivers/md/raid1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2006-06-27 12:15:16.000000000 +1000
+++ ./drivers/md/raid1.c	2006-06-27 12:17:33.000000000 +1000
@@ -1145,7 +1145,7 @@ static int end_sync_write(struct bio *bi
 		long sectors_to_go = r1_bio->sectors;
 		/* make sure these bits doesn't get cleared. */
 		do {
-			bitmap_end_sync(mddev->bitmap, r1_bio->sector,
+			bitmap_end_sync(mddev->bitmap, s,
 					&sync_blocks, 1);
 			s += sync_blocks;
 			sectors_to_go -= sync_blocks;
