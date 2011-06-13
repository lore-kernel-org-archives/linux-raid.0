From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 1/3] md/raid5: fix raid5_set_bi_hw_segments
Date: Mon, 13 Jun 2011 23:48:22 +0900
Message-ID: <1307976504-10215-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

The @bio->bi_phys_segments consists of active stripes count in the
lower 16 bits and processed stripes count in the upper 16 bits. So
logical-OR operator should be bitwise one.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/raid5.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 346e69bfdab3..fa6ac70dc72f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -129,7 +129,7 @@ static inline int raid5_dec_bi_hw_segments(struct bio *bio)
 
 static inline void raid5_set_bi_hw_segments(struct bio *bio, unsigned int cnt)
 {
-	bio->bi_phys_segments = raid5_bi_phys_segments(bio) || (cnt << 16);
+	bio->bi_phys_segments = raid5_bi_phys_segments(bio) | (cnt << 16);
 }
 
 /* Find first data disk in a raid6 stripe */
-- 
1.7.5.2

