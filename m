From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2.6.23-rc7 2/3] async_tx: fix dma_wait_for_async_tx
Date: Thu, 20 Sep 2007 18:27:45 -0700
Message-ID: <20070921012745.17157.18043.stgit@dwillia2-linux.ch.intel.com>
References: <20070921012141.17157.65717.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070921012141.17157.65717.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
Cc: akpm@linux-foundation.org, yur@emcraft.com, saeed.bishara@gmail.com, shannon.nelson@intel.com
List-Id: linux-raid.ids

Fix dma_wait_for_async_tx to not loop forever in the case where a
dependency chain is longer than two entries.  This condition will not
happen with current in-kernel drivers, but fix it for future drivers.

Found-by: Saeed Bishara <saeed.bishara@gmail.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 crypto/async_tx/async_tx.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 0350071..bc18cbb 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -80,6 +80,7 @@ dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
 {
 	enum dma_status status;
 	struct dma_async_tx_descriptor *iter;
+	struct dma_async_tx_descriptor *parent;
 
 	if (!tx)
 		return DMA_SUCCESS;
@@ -87,8 +88,15 @@ dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
 	/* poll through the dependency chain, return when tx is complete */
 	do {
 		iter = tx;
-		while (iter->cookie == -EBUSY)
-			iter = iter->parent;
+
+		/* find the root of the unsubmitted dependency chain */
+		while (iter->cookie == -EBUSY) {
+			parent = iter->parent;
+			if (parent && parent->cookie == -EBUSY)
+				iter = iter->parent;
+			else
+				break;
+		}
 
 		status = dma_sync_wait(iter->chan, iter->cookie);
 	} while (status == DMA_IN_PROGRESS || (iter != tx));
