From: Robert LeBlanc <robert@leblancnet.us>
Subject: [PATCH 1/2] mdadm: raid10.h Fix typo
Date: Thu,  3 Nov 2016 17:45:07 -0600
Message-ID: <20161103234508.12641-2-robert@leblancnet.us>
References: <20161103234508.12641-1-robert@leblancnet.us>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161103234508.12641-1-robert@leblancnet.us>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Robert LeBlanc <robert@leblancnet.us>
List-Id: linux-raid.ids

Fix typo from paste of code from RAID1.

Signed-off-by: Robert LeBlanc <robert@leblancnet.us>
---
 drivers/md/raid10.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index 18ec1f7..1699a6a 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -53,7 +53,7 @@ struct r10conf {
 	sector_t		offset_diff;
 
 	struct list_head	retry_list;
-	/* A separate list of r1bio which just need raid_end_bio_io called.
+	/* A separate list of r10bio which just need raid_end_bio_io called.
 	 * This mustn't happen for writes which had any errors if the superblock
 	 * needs to be written.
 	 */
-- 
2.10.1

