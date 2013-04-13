From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH 4/8] loop: use generic helper to set max_discard_sectors
Date: Sat, 13 Apr 2013 22:39:00 +0900
Message-ID: <1365860340-21329-1-git-send-email-linkinjeon@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dwmw2@infradead.org, axboe@kernel.dk, shli@kernel.org, Paul.Clements@steeleye.com, npiggin@kernel.dk, neilb@suse.de, cjb@laptop.org, adrian.hunter@intel.com
Cc: linux-mtd@lists.infradead.org, nbd-general@lists.sourceforge.net, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, Vivek Trivedi <t.vivek@samsung.com>
List-Id: linux-raid.ids

From: Namjae Jeon <namjae.jeon@samsung.com>

It is better to use blk_queue_max_discard_sectors helper
function to set max_discard_sectors as it checks
max_discard_sectors upper limit UINT_MAX >> 9

similar issue was reported for mmc in below link
https://lkml.org/lkml/2013/4/1/292

If multiple discard requests get merged, merged discard request's
size exceeds 4GB, there is possibility that merged discard request's
__data_len field may overflow.

This patch fixes this issue.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
---
 drivers/block/loop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index b2955b3..21f3233 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -806,7 +806,7 @@ static void loop_config_discard(struct loop_device *lo)
 	    lo->lo_encrypt_key_size) {
 		q->limits.discard_granularity = 0;
 		q->limits.discard_alignment = 0;
-		q->limits.max_discard_sectors = 0;
+		blk_queue_max_discard_sectors(q, 0);
 		q->limits.discard_zeroes_data = 0;
 		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, q);
 		return;
@@ -814,7 +814,7 @@ static void loop_config_discard(struct loop_device *lo)
 
 	q->limits.discard_granularity = inode->i_sb->s_blocksize;
 	q->limits.discard_alignment = 0;
-	q->limits.max_discard_sectors = UINT_MAX >> 9;
+	blk_queue_max_discard_sectors(q, UINT_MAX >> 9);
 	q->limits.discard_zeroes_data = 1;
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
 }
-- 
1.7.9.5
