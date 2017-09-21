From: Shaohua Li <shli@kernel.org>
Subject: [PATCH 2/3] md: fix a race condition for flush request handling
Date: Thu, 21 Sep 2017 10:42:58 -0700
Message-ID: <71bf02053eb983f12561099c4779ae99c06e0098.1506015297.git.shli@fb.com>
References: <cover.1506015297.git.shli@fb.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <cover.1506015297.git.shli@fb.com>
In-Reply-To: <cover.1506015297.git.shli@fb.com>
References: <cover.1506015297.git.shli@fb.com>
Sender: stable-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>, NeilBrown <neilb@suse.com>, stable@vger.kernel.org
List-Id: linux-raid.ids

From: Shaohua Li <shli@fb.com>

md_submit_flush_data calls pers->make_request, which missed the suspend check.
Fix it with the new md_handle_request API.

Reported-by: Nate Dailey <nate.dailey@stratus.com>
Tested-by: Nate Dailey <nate.dailey@stratus.com>
Fix: cc27b0c78c79(md: fix deadlock between mddev_suspend() and md_write_start())
Cc: NeilBrown <neilb@suse.com>
Cc: stable@vger.kernel.org
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1db1a22ed835..0ff1bbf6c90e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -447,16 +447,22 @@ static void md_submit_flush_data(struct work_struct *ws)
 	struct mddev *mddev = container_of(ws, struct mddev, flush_work);
 	struct bio *bio = mddev->flush_bio;
 
+	/*
+	 * must reset flush_bio before calling into md_handle_request to avoid a
+	 * deadlock, because other bios passed md_handle_request suspend check
+	 * could wait for this and below md_handle_request could wait for those
+	 * bios because of suspend check
+	 */
+	mddev->flush_bio = NULL;
+	wake_up(&mddev->sb_wait);
+
 	if (bio->bi_iter.bi_size == 0)
 		/* an empty barrier - all done */
 		bio_endio(bio);
 	else {
 		bio->bi_opf &= ~REQ_PREFLUSH;
-		mddev->pers->make_request(mddev, bio);
+		md_handle_request(mddev, bio);
 	}
-
-	mddev->flush_bio = NULL;
-	wake_up(&mddev->sb_wait);
 }
 
 void md_flush_request(struct mddev *mddev, struct bio *bio)
-- 
2.11.0
