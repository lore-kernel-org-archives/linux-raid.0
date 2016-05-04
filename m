From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 2/2] super1: don't update node nums if it is not more than 1
Date: Wed,  4 May 2016 16:33:44 +0800
Message-ID: <1462350824-9872-3-git-send-email-gqjiang@suse.com>
References: <1462350824-9872-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1462350824-9872-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

We at least need two nodes for cluster raid so make the
check before update node nums.

Reported-by: Zhilong Liu <zlliu@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 super1.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/super1.c b/super1.c
index 8d5543f..972b470 100644
--- a/super1.c
+++ b/super1.c
@@ -2394,6 +2394,11 @@ static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update
 			return -EINVAL;
 		}
 
+		if (bms->version == BITMAP_MAJOR_CLUSTERED && st->nodes <= 1) {
+			pr_err("Warning: cluster-md at least needs two nodes\n");
+			return -EINVAL;
+		}
+
 		/* Each node has an independent bitmap, it is necessary to calculate the
 		 * space is enough or not, first get how many bytes for the total bitmap */
 		bm_space_per_node = calc_bitmap_size(bms, 4096);
-- 
2.6.2

