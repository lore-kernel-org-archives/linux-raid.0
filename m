From: Ilya Yanok <yanok@emcraft.com>
Subject: [PATCH 01/11] async_tx: don't use src_list argument of async_xor()
	for dma addresses
Date: Thu, 13 Nov 2008 18:15:54 +0300
Message-ID: <1226589364-5619-2-git-send-email-yanok@emcraft.com>
References: <1226589364-5619-1-git-send-email-yanok@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
In-Reply-To: <1226589364-5619-1-git-send-email-yanok@emcraft.com>
List-Unsubscribe: <https://ozlabs.org/mailman/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
To: linux-raid@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, dzu@denx.de, wd@denx.de, Ilya Yanok <yanok@emcraft.com>
List-Id: linux-raid.ids

Using src_list argument of async_xor() as a storage for dma addresses
implies sizeof(dma_addr_t) <= sizeof(struct page *) restriction which is
not always true.

Signed-off-by: Ilya Yanok <yanok@emcraft.com>
---
 crypto/async_tx/async_xor.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index c029d3e..00c74c5 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -42,7 +42,7 @@ do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
 	     dma_async_tx_callback cb_fn, void *cb_param)
 {
 	struct dma_device *dma = chan->device;
-	dma_addr_t *dma_src = (dma_addr_t *) src_list;
+	dma_addr_t dma_src[src_cnt];
 	struct dma_async_tx_descriptor *tx = NULL;
 	int src_off = 0;
 	int i;
@@ -247,7 +247,7 @@ async_xor_zero_sum(struct page *dest, struct page **src_list,
 	BUG_ON(src_cnt <= 1);
 
 	if (device && src_cnt <= device->max_xor) {
-		dma_addr_t *dma_src = (dma_addr_t *) src_list;
+		dma_addr_t dma_src[src_cnt];
 		unsigned long dma_prep_flags = cb_fn ? DMA_PREP_INTERRUPT : 0;
 		int i;
 
@@ -296,16 +296,6 @@ EXPORT_SYMBOL_GPL(async_xor_zero_sum);
 
 static int __init async_xor_init(void)
 {
-	#ifdef CONFIG_DMA_ENGINE
-	/* To conserve stack space the input src_list (array of page pointers)
-	 * is reused to hold the array of dma addresses passed to the driver.
-	 * This conversion is only possible when dma_addr_t is less than the
-	 * the size of a pointer.  HIGHMEM64G is known to violate this
-	 * assumption.
-	 */
-	BUILD_BUG_ON(sizeof(dma_addr_t) > sizeof(struct page *));
-	#endif
-
 	return 0;
 }
 
-- 
1.5.6.1
