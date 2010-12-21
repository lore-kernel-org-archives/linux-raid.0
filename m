From: Saeed Bishara <saeed@marvell.com>
Subject: [PATCH] mv_xor: fix race in tasklet function
Date: Tue, 21 Dec 2010 16:53:39 +0200
Message-ID: <1292943219-26470-1-git-send-email-saeed@marvell.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: saeed.bishara@gmail.com, Saeed Bishara <saeed@marvell.com>
List-Id: linux-raid.ids

use mv_xor_slot_cleanup() instead of __mv_xor_slot_cleanup() as the former function
aquires the spin lock that needed to protect the drivers data.

Signed-off-by: Saeed Bishara <saeed@marvell.com>
---
 drivers/dma/mv_xor.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 411d5bf..a25f5f6 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -449,7 +449,7 @@ mv_xor_slot_cleanup(struct mv_xor_chan *mv_chan)
 static void mv_xor_tasklet(unsigned long data)
 {
 	struct mv_xor_chan *chan = (struct mv_xor_chan *) data;
-	__mv_xor_slot_cleanup(chan);
+	mv_xor_slot_cleanup(chan);
 }
 
 static struct mv_xor_desc_slot *
-- 
1.6.0.4

