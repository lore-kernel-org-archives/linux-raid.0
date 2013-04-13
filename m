From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH 8/8] bcache: use generic helper to set max_discard_sectors
Date: Sat, 13 Apr 2013 22:40:16 +0900
Message-ID: <1365860416-21499-1-git-send-email-linkinjeon@gmail.com>
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
 drivers/md/bcache/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index f3bf310..d87ab31 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -746,7 +746,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size)
 	q->limits.max_sectors		= UINT_MAX;
 	q->limits.max_segment_size	= UINT_MAX;
 	q->limits.max_segments		= BIO_MAX_PAGES;
-	q->limits.max_discard_sectors	= UINT_MAX;
+	blk_queue_max_discard_sectors(q, UINT_MAX >> 9);
 	q->limits.io_min		= block_size;
 	q->limits.logical_block_size	= block_size;
 	q->limits.physical_block_size	= block_size;
-- 
1.7.9.5
