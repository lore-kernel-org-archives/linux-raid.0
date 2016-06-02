From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 11/18] md/raid1: small code cleanup in end_sync_write
Date: Thu, 02 Jun 2016 16:19:52 +1000
Message-ID: <20160602061952.2939.80261.stgit@noble>
References: <20160602061319.2939.72280.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160602061319.2939.72280.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

'mirror' is only used to find 'rdev', several times.
So just find 'rdev' once, and use it instead.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid1.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 9585a6b62123..cc53120e4d68 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1709,11 +1709,9 @@ static void end_sync_write(struct bio *bio)
 	struct r1bio *r1_bio = bio->bi_private;
 	struct mddev *mddev = r1_bio->mddev;
 	struct r1conf *conf = mddev->private;
-	int mirror=0;
 	sector_t first_bad;
 	int bad_sectors;
-
-	mirror = find_bio_disk(r1_bio, bio);
+	struct md_rdev *rdev = conf->mirrors[find_bio_disk(r1_bio, bio)].rdev;
 
 	if (!uptodate) {
 		sector_t sync_blocks = 0;
@@ -1726,16 +1724,12 @@ static void end_sync_write(struct bio *bio)
 			s += sync_blocks;
 			sectors_to_go -= sync_blocks;
 		} while (sectors_to_go > 0);
-		set_bit(WriteErrorSeen,
-			&conf->mirrors[mirror].rdev->flags);
-		if (!test_and_set_bit(WantReplacement,
-				      &conf->mirrors[mirror].rdev->flags))
+		set_bit(WriteErrorSeen, &rdev->flags);
+		if (!test_and_set_bit(WantReplacement, &rdev->flags))
 			set_bit(MD_RECOVERY_NEEDED, &
 				mddev->recovery);
 		set_bit(R1BIO_WriteError, &r1_bio->state);
-	} else if (is_badblock(conf->mirrors[mirror].rdev,
-			       r1_bio->sector,
-			       r1_bio->sectors,
+	} else if (is_badblock(rdev, r1_bio->sector, r1_bio->sectors,
 			       &first_bad, &bad_sectors) &&
 		   !is_badblock(conf->mirrors[r1_bio->read_disk].rdev,
 				r1_bio->sector,


