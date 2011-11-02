From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 17/17] md/raid1: Mark device replaceable when we see a
 write error.
Date: Wed, 02 Nov 2011 16:25:45 +1100
Message-ID: <20111102052545.17566.36436.stgit@notabene.brown>
References: <20111102051851.17566.52748.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102051851.17566.52748.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Now that Replaceable drives are replaced cleanly, mark a drive
as replaceable when we see a write error.  It might get failed soon so
the Replaceable flag is irrelevant, but if the write error is recorded
in the bad block log, we still want to activate any spare that might
be available.

Signed-off-by:  NeilBrown <neilb@suse.de>
---

 drivers/md/raid1.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 968428e..c717480 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -390,6 +390,11 @@ static void raid1_end_write_request(struct bio *bio, int error)
 	if (!uptodate) {
 		set_bit(WriteErrorSeen,
 			&conf->mirrors[mirror].rdev->flags);
+		if (!test_and_set_bit(Replaceable,
+				      &conf->mirrors[mirror].rdev->flags))
+			set_bit(MD_RECOVERY_NEEDED, &
+				conf->mddev->recovery);
+
 		set_bit(R1BIO_WriteError, &r1_bio->state);
 	} else {
 		/*
@@ -1461,6 +1466,10 @@ static void end_sync_write(struct bio *bio, int error)
 		} while (sectors_to_go > 0);
 		set_bit(WriteErrorSeen,
 			&conf->mirrors[mirror].rdev->flags);
+		if (!test_and_set_bit(Replaceable,
+				      &conf->mirrors[mirror].rdev->flags))
+			set_bit(MD_RECOVERY_NEEDED, &
+				mddev->recovery);
 		set_bit(R1BIO_WriteError, &r1_bio->state);
 	} else if (is_badblock(conf->mirrors[mirror].rdev,
 			       r1_bio->sector,
@@ -1491,8 +1500,13 @@ static int r1_sync_page_io(struct md_rdev *rdev, sector_t sector,
 	if (sync_page_io(rdev, sector, sectors << 9, page, rw, false))
 		/* success */
 		return 1;
-	if (rw == WRITE)
+	if (rw == WRITE) {
 		set_bit(WriteErrorSeen, &rdev->flags);
+		if (!test_and_set_bit(Replaceable,
+				      &rdev->flags))
+			set_bit(MD_RECOVERY_NEEDED, &
+				rdev->mddev->recovery);
+	}
 	/* need to record an error - either for the block or the device */
 	if (!rdev_set_badblocks(rdev, sector, sectors, 0))
 		md_error(rdev->mddev, rdev);


