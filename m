From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 5/6] md/raid5: Use is_power_of_2() in raid5_reconfig()/raid6_reconfig().
Date: Mon, 25 May 2009 11:27:36 +0200
Message-ID: <1243243657-21855-6-git-send-email-maan@systemlinux.org>
References: <1243243657-21855-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1243243657-21855-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/raid5.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e7952f0..772593d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5167,8 +5167,7 @@ static int raid5_reconfig(mddev_t *mddev, int new_layout, int new_chunk)
 	if (new_layout >= 0 && !algorithm_valid_raid5(new_layout))
 		return -EINVAL;
 	if (new_chunk > 0) {
-		if (new_chunk & (new_chunk-1))
-			/* not a power of 2 */
+		if (!is_power_of_2(new_chunk))
 			return -EINVAL;
 		if (new_chunk < PAGE_SIZE)
 			return -EINVAL;
@@ -5206,8 +5205,7 @@ static int raid6_reconfig(mddev_t *mddev, int new_layout, int new_chunk)
 	if (new_layout >= 0 && !algorithm_valid_raid6(new_layout))
 		return -EINVAL;
 	if (new_chunk > 0) {
-		if (new_chunk & (new_chunk-1))
-			/* not a power of 2 */
+		if (!is_power_of_2(new_chunk))
 			return -EINVAL;
 		if (new_chunk < PAGE_SIZE)
 			return -EINVAL;
-- 
1.5.4.3

