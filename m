From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 3] md: Don't clear bits in bitmap when writing to one device fails during recovery.
Date: Thu, 30 Mar 2006 16:52:37 +1100
Message-ID: <1060330055237.25270@suse.de>
References: <20060330164933.25210.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Currently a device failure during recovery leaves bits set in the
bitmap.  This normally isn't a problem as the offending device will be
rejected because of errors.  However if device re-adding is being used
with non-persistent bitmaps, this can be a problem.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2006-03-30 16:48:29.000000000 +1100
+++ ./drivers/md/raid1.c	2006-03-30 16:48:40.000000000 +1100
@@ -1135,8 +1135,19 @@ static int end_sync_write(struct bio *bi
 			mirror = i;
 			break;
 		}
-	if (!uptodate)
+	if (!uptodate) {
+		int sync_blocks = 0;
+		sector_t s = r1_bio->sector;
+		long sectors_to_go = r1_bio->sectors;
+		/* make sure these bits doesn't get cleared. */
+		do {
+			bitmap_end_sync(mddev->bitmap, r1_bio->sector,
+					&sync_blocks, 1);
+			s += sync_blocks;
+			sectors_to_go -= sync_blocks;
+		} while (sectors_to_go > 0);
 		md_error(mddev, conf->mirrors[mirror].rdev);
+	}
 
 	update_head_pos(mirror, r1_bio);
 
