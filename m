From: Dan Williams <dan.j.williams@intel.com>
Subject: [git pull] ioat/async_tx fixes for 2.6.32
Date: Mon, 21 Sep 2009 14:27:23 -0700
Message-ID: <1253568443.27471.14.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, Maciej Sosnowski <maciej.sosnowski@intel.com>
List-Id: linux-raid.ids

Hi Neil,

Looks like Linus has not pulled your md tree yet.  So, please pull the
async_tx.git/next tree again to get a few incremental updates.
Specifically Andrew corrected my thinking regarding warnings from older
compilers, and there are a few missing dma_unmap calls in the raid6
recovery code.

Thanks,
Dan

---

The following changes since commit 1b6df6930994d5d027375b07ac9da63644eb5758:
  Dan Williams (1):
        raid6test: fix stack overflow

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next

Andrew Morton (1):
      drivers/dma/ioat/dma_v2.c: fix warnings

Dan Williams (2):
      ioat3: fix uninitialized var warnings
      async_tx/raid6: add missing dma_unmap calls to the async fail case

 crypto/async_tx/async_raid6_recov.c |   13 +++++++++++++
 drivers/dma/ioat/dma_v2.c           |    5 +++--
 drivers/dma/ioat/dma_v3.c           |   15 +++++++++------
 3 files changed, 25 insertions(+), 8 deletions(-)

commit f477f5b3316f39c841aa121a219b82b3a56e7da7
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Mon Sep 21 09:17:58 2009 -0700

    drivers/dma/ioat/dma_v2.c: fix warnings
    
    drivers/dma/ioat/dma_v2.c: In function 'ioat2_dma_prep_memcpy_lock':
    drivers/dma/ioat/dma_v2.c:680: warning: 'hw' may be used uninitialized in this function
    drivers/dma/ioat/dma_v2.c:681: warning: 'desc' may be used uninitialized in this function
    
    Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index 8fd0b59..96ffab7 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -692,7 +692,8 @@ ioat2_dma_prep_memcpy_lock(struct dma_chan *c, dma_addr_t dma_dest,
 		/* pass */;
 	else
 		return NULL;
-	for (i = 0; i < num_descs; i++) {
+	i = 0;
+	do {
 		size_t copy = min_t(size_t, len, 1 << ioat->xfercap_log);
 
 		desc = ioat2_get_ring_ent(ioat, idx + i);
@@ -707,7 +708,7 @@ ioat2_dma_prep_memcpy_lock(struct dma_chan *c, dma_addr_t dma_dest,
 		dst += copy;
 		src += copy;
 		dump_desc_dbg(ioat, desc);
-	}
+	} while (++i < num_descs);
 
 	desc->txd.flags = flags;
 	desc->len = total_len;

commit cdef57dbb618608bfffda2fc32c8d0a4012a1d3a
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Sep 21 09:22:29 2009 -0700

    ioat3: fix uninitialized var warnings
    
    drivers/dma/ioat/dma_v3.c: In function 'ioat3_prep_memset_lock':
    drivers/dma/ioat/dma_v3.c:439: warning: 'fill' may be used uninitialized in this function
    drivers/dma/ioat/dma_v3.c:437: warning: 'desc' may be used uninitialized in this function
    drivers/dma/ioat/dma_v3.c: In function '__ioat3_prep_xor_lock':
    drivers/dma/ioat/dma_v3.c:489: warning: 'xor' may be used uninitialized in this function
    drivers/dma/ioat/dma_v3.c:486: warning: 'desc' may be used uninitialized in this function
    drivers/dma/ioat/dma_v3.c: In function '__ioat3_prep_pq_lock':
    drivers/dma/ioat/dma_v3.c:631: warning: 'pq' may be used uninitialized in this function
    drivers/dma/ioat/dma_v3.c:628: warning: 'desc' may be used uninitialized in this function
    
    gcc-4.0, unlike gcc-4.3, does not see that these variables are
    initialized before use.  Convert the descriptor loops to do-while make
    this initialization apparent.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 3686ddd..35d1e33 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -448,7 +448,8 @@ ioat3_prep_memset_lock(struct dma_chan *c, dma_addr_t dest, int value,
 		/* pass */;
 	else
 		return NULL;
-	for (i = 0; i < num_descs; i++) {
+	i = 0;
+	do {
 		size_t xfer_size = min_t(size_t, len, 1 << ioat->xfercap_log);
 
 		desc = ioat2_get_ring_ent(ioat, idx + i);
@@ -463,7 +464,7 @@ ioat3_prep_memset_lock(struct dma_chan *c, dma_addr_t dest, int value,
 		len -= xfer_size;
 		dest += xfer_size;
 		dump_desc_dbg(ioat, desc);
-	}
+	} while (++i < num_descs);
 
 	desc->txd.flags = flags;
 	desc->len = total_len;
@@ -518,7 +519,8 @@ __ioat3_prep_xor_lock(struct dma_chan *c, enum sum_check_flags *result,
 		/* pass */;
 	else
 		return NULL;
-	for (i = 0; i < num_descs; i += 1 + with_ext) {
+	i = 0;
+	do {
 		struct ioat_raw_descriptor *descs[2];
 		size_t xfer_size = min_t(size_t, len, 1 << ioat->xfercap_log);
 		int s;
@@ -546,7 +548,7 @@ __ioat3_prep_xor_lock(struct dma_chan *c, enum sum_check_flags *result,
 		len -= xfer_size;
 		offset += xfer_size;
 		dump_desc_dbg(ioat, desc);
-	}
+	} while ((i += 1 + with_ext) < num_descs);
 
 	/* last xor descriptor carries the unmap parameters and fence bit */
 	desc->txd.flags = flags;
@@ -664,7 +666,8 @@ __ioat3_prep_pq_lock(struct dma_chan *c, enum sum_check_flags *result,
 		/* pass */;
 	else
 		return NULL;
-	for (i = 0; i < num_descs; i += 1 + with_ext) {
+	i = 0;
+	do {
 		struct ioat_raw_descriptor *descs[2];
 		size_t xfer_size = min_t(size_t, len, 1 << ioat->xfercap_log);
 
@@ -703,7 +706,7 @@ __ioat3_prep_pq_lock(struct dma_chan *c, enum sum_check_flags *result,
 
 		len -= xfer_size;
 		offset += xfer_size;
-	}
+	} while ((i += 1 + with_ext) < num_descs);
 
 	/* last pq descriptor carries the unmap parameters and fence bit */
 	desc->txd.flags = flags;

commit 1f6672d44c1ae7408b43c06170ec34eb0a0e9b9f
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Sep 21 10:47:40 2009 -0700

    async_tx/raid6: add missing dma_unmap calls to the async fail case
    
    If we are unable to offload async_mult() or async_sum_product(), then
    unmap the buffers before falling through to the synchronous path.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index 822a42d..6d73dde 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -55,6 +55,13 @@ async_sum_product(struct page *dest, struct page **srcs, unsigned char *coef,
 			async_tx_submit(chan, tx, submit);
 			return tx;
 		}
+
+		/* could not get a descriptor, unmap and fall through to
+		 * the synchronous path
+		 */
+		dma_unmap_page(dev, dma_dest[1], len, DMA_BIDIRECTIONAL);
+		dma_unmap_page(dev, dma_src[0], len, DMA_TO_DEVICE);
+		dma_unmap_page(dev, dma_src[1], len, DMA_TO_DEVICE);
 	}
 
 	/* run the operation synchronously */
@@ -101,6 +108,12 @@ async_mult(struct page *dest, struct page *src, u8 coef, size_t len,
 			async_tx_submit(chan, tx, submit);
 			return tx;
 		}
+
+		/* could not get a descriptor, unmap and fall through to
+		 * the synchronous path
+		 */
+		dma_unmap_page(dev, dma_dest[1], len, DMA_BIDIRECTIONAL);
+		dma_unmap_page(dev, dma_src[0], len, DMA_TO_DEVICE);
 	}
 
 	/* no channel available, or failed to allocate a descriptor, so


