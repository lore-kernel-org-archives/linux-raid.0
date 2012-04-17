From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 24/24] md/raid5: Allow reshape while a bitmap is present.
Date: Tue, 17 Apr 2012 18:43:43 +1000
Message-ID: <20120417084342.6433.44955.stgit@notabene.brown>
References: <20120417084324.6433.68345.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417084324.6433.68345.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We always should have allowed this.  A raid5 reshape doesn't change
the size of the bitmap, so not need to restrict it.

Also add a test to make sure we don't try to start a reshape on a
failed array.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index eab6168..8fba57e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5559,9 +5559,6 @@ static int check_reshape(struct mddev *mddev)
 	    mddev->new_layout == mddev->layout &&
 	    mddev->new_chunk_sectors == mddev->chunk_sectors)
 		return 0; /* nothing to do */
-	if (mddev->bitmap)
-		/* Cannot grow a bitmap yet */
-		return -EBUSY;
 	if (has_failed(conf))
 		return -EINVAL;
 	if (mddev->delta_disks < 0) {
@@ -5596,6 +5593,9 @@ static int raid5_start_reshape(struct mddev *mddev)
 	if (!check_stripe_cache(mddev))
 		return -ENOSPC;
 
+	if (has_failed(conf))
+		return -EINVAL;
+
 	rdev_for_each(rdev, mddev) {
 		if (!test_bit(In_sync, &rdev->flags)
 		    && !test_bit(Faulty, &rdev->flags))


