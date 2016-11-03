From: Robert LeBlanc <robert@leblancnet.us>
Subject: [PATCH 2/2] mdadm: raid10.c Remove near atomic break
Date: Thu,  3 Nov 2016 17:45:08 -0600
Message-ID: <20161103234508.12641-3-robert@leblancnet.us>
References: <20161103234508.12641-1-robert@leblancnet.us>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161103234508.12641-1-robert@leblancnet.us>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Robert LeBlanc <robert@leblancnet.us>
List-Id: linux-raid.ids

This is always triggered for small reads preventing spreading the reads
across all available drives. The comments are also confusing as it is
supposed to apply only to 'far' layouts, but really only applies to 'near'
layouts. Since there isn't problems with 'far' layouts, there shouldn't
be a problem for 'near' layouts either. This change fairly distributes
reads across all drives where before only came from the first drive.

Signed-off-by: Robert LeBlanc <robert@leblancnet.us>
---
 drivers/md/raid10.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index be1a9fc..8d83802 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -777,13 +777,6 @@ static struct md_rdev *read_balance(struct r10conf *conf,
 		if (!do_balance)
 			break;
 
-		/* This optimisation is debatable, and completely destroys
-		 * sequential read speed for 'far copies' arrays.  So only
-		 * keep it for 'near' arrays, and review those later.
-		 */
-		if (geo->near_copies > 1 && !atomic_read(&rdev->nr_pending))
-			break;
-
 		/* for far > 1 always use the lowest address */
 		if (geo->far_copies > 1)
 			new_distance = r10_bio->devs[slot].addr;
-- 
2.10.1

