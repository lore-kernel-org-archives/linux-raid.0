From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 10 of 12] Fix bug when raid1 attempts a partial reconstruct.
Date: Wed, 23 Mar 2005 16:47:11 +1100
Message-ID: <E1DDyhz-0004Gy-Kd@notabene.cse.unsw.edu.au>
References: <20050323164208.16240.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


The logic here is wrong.  if fullsync is 0, it WILL BUG.


Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid1.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-03-22 17:11:00.000000000 +1100
+++ ./drivers/md/raid1.c	2005-03-22 17:24:57.000000000 +1100
@@ -1243,13 +1243,16 @@ static sector_t sync_request(mddev_t *md
 			len = (max_sector - sector_nr) << 9;
 		if (len == 0)
 			break;
-		if (!conf->fullsync && sync_blocks == 0)
-			if (!bitmap_start_sync(mddev->bitmap,
-					       sector_nr, &sync_blocks))
-				break;
-		if (sync_blocks < (PAGE_SIZE>>9))
-			BUG();
-		if (len > (sync_blocks<<9)) len = sync_blocks<<9;
+		if (!conf->fullsync) {
+			if (sync_blocks == 0) {
+				if (!bitmap_start_sync(mddev->bitmap,
+						       sector_nr, &sync_blocks))
+					break;
+				if (sync_blocks < (PAGE_SIZE>>9))
+					BUG();
+				if (len > (sync_blocks<<9)) len = sync_blocks<<9;
+			}
+		}
 
 		for (i=0 ; i < conf->raid_disks; i++) {
 			bio = r1_bio->bios[i];
