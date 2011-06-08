From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH/RFC] md/raid10: optimize read_balance() for 'far copies' arrays
Date: Wed,  8 Jun 2011 16:00:45 +0900
Message-ID: <1307516445-3208-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If @conf->far_offset > 0, there is only 1 stripe so that we can treat
the array same as 'near' arrays. Furthermore we could calculate new
distance from the previous position even for the real 'far' array
cases if the position of given disk is already in the lowest stripe.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/raid10.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 6e846688962f..9ec4c5f8cd48 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -531,11 +531,19 @@ retry:
 			break;
 
 		/* for far > 1 always use the lowest address */
-		if (conf->far_copies > 1)
-			new_distance = r10_bio->devs[slot].addr;
-		else
+		if (conf->far_copies > 1 && conf->far_offset == 0) {
+			if (conf->mirrors[disk].head_position < conf->stride &&
+			    r10_bio->devs[slot].addr < conf->stride)
+				/* already in the lowest stripe */
+				new_distance = abs(r10_bio->devs[slot].addr -
+						   conf->mirrors[disk].head_position);
+			else
+				new_distance = r10_bio->devs[slot].addr;
+		} else {
 			new_distance = abs(r10_bio->devs[slot].addr -
 					   conf->mirrors[disk].head_position);
+		}
+
 		if (new_distance < best_dist) {
 			best_dist = new_distance;
 			best_slot = slot;
-- 
1.7.5.2

