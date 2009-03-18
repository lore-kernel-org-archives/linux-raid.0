From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 03/13] async_tx: provide __async_inline for HAS_DMA=n archs
Date: Wed, 18 Mar 2009 12:20:31 -0700
Message-ID: <20090318192031.20375.37575.stgit@dwillia2-linux.ch.intel.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: neilb@suse.de, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

To allow an async_tx routine to be compiled away on HAS_DMA=n arch it
needs to be declared __always_inline otherwise the compiler may emit
code and cause a link error.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 crypto/async_tx/async_xor.c |    7 ++-----
 include/linux/async_tx.h    |    9 +++++++++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index e1f1f28..11978a8 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -30,11 +30,8 @@
 #include <linux/raid/xor.h>
 #include <linux/async_tx.h>
 
-/* do_async_xor - dma map the pages and perform the xor with an engine.
- * 	This routine is marked __always_inline so it can be compiled away
- * 	when CONFIG_DMA_ENGINE=n
- */
-static __always_inline struct dma_async_tx_descriptor *
+/* do_async_xor - dma map the pages and perform the xor with an engine */
+static __async_inline struct dma_async_tx_descriptor *
 do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
 	     unsigned int offset, int src_cnt, size_t len,
 	     enum async_tx_flags flags,
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 45f6297..5fc2ef8 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -21,6 +21,15 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 
+/* on architectures without dma-mapping capabilities we need to ensure
+ * that the asynchronous path compiles away
+ */
+#ifdef CONFIG_HAS_DMA
+#define __async_inline
+#else
+#define __async_inline __always_inline
+#endif
+
 /**
  * dma_chan_ref - object used to manage dma channels received from the
  *   dmaengine core.

