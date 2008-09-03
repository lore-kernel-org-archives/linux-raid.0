From: Ilya Yanok <yanok@emcraft.com>
Subject: [PATCH] ASYNC_TX: fix the bug in async_tx_run_dependencies
Date: Thu,  4 Sep 2008 01:43:51 +0400
Message-ID: <1220478231-8725-1-git-send-email-yanok@emcraft.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, wd@denx.de, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

From: Yuri Tikhonov <yur@emcraft.com>

Should clear the next pointer of the TX if we are sure that the
next TX (say NXT) will be submitted to the channel too. Overwise,
we break the chain of descriptors, because we lose the information
about the next descriptor to run. So next time, when invoke
async_tx_run_dependencies() with TX, it's TX->next will be NULL, and
NXT will be never submitted.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
---
 crypto/async_tx/async_tx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 85eaf7b..e8362c1 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -137,7 +137,8 @@ async_tx_run_dependencies(struct dma_async_tx_descriptor *tx)
 		spin_lock_bh(&next->lock);
 		next->parent = NULL;
 		_next = next->next;
-		next->next = NULL;
+		if (_next && _next->chan == chan)
+			next->next = NULL;
 		spin_unlock_bh(&next->lock);
 
 		next->tx_submit(next);
-- 
1.5.6.3

