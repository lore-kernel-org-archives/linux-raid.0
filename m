From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 04/13] async_tx: kill needless module_{init|exit}
Date: Wed, 18 Mar 2009 12:20:36 -0700
Message-ID: <20090318192036.20375.67203.stgit@dwillia2-linux.ch.intel.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: neilb@suse.de, Dan Williams <dan.j.wiliams@intel.com>, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

From: Dan Williams <dwillia2@dwillia2-mobl1.amr.corp.intel.com>

If module_init and module_exit are nops then neither need to be defined.

Signed-off-by: Dan Williams <dan.j.wiliams@intel.com>
---
 crypto/async_tx/async_memcpy.c |   13 -------------
 crypto/async_tx/async_memset.c |   13 -------------
 crypto/async_tx/async_tx.c     |   17 +++--------------
 crypto/async_tx/async_xor.c    |   13 -------------
 4 files changed, 3 insertions(+), 53 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index ddccfb0..1a902b9 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -90,19 +90,6 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 }
 EXPORT_SYMBOL_GPL(async_memcpy);
 
-static int __init async_memcpy_init(void)
-{
-	return 0;
-}
-
-static void __exit async_memcpy_exit(void)
-{
-	do { } while (0);
-}
-
-module_init(async_memcpy_init);
-module_exit(async_memcpy_exit);
-
 MODULE_AUTHOR("Intel Corporation");
 MODULE_DESCRIPTION("asynchronous memcpy api");
 MODULE_LICENSE("GPL");
diff --git a/crypto/async_tx/async_memset.c b/crypto/async_tx/async_memset.c
index 5b5eb99..631c3d0 100644
--- a/crypto/async_tx/async_memset.c
+++ b/crypto/async_tx/async_memset.c
@@ -83,19 +83,6 @@ async_memset(struct page *dest, int val, unsigned int offset,
 }
 EXPORT_SYMBOL_GPL(async_memset);
 
-static int __init async_memset_init(void)
-{
-	return 0;
-}
-
-static void __exit async_memset_exit(void)
-{
-	do { } while (0);
-}
-
-module_init(async_memset_init);
-module_exit(async_memset_exit);
-
 MODULE_AUTHOR("Intel Corporation");
 MODULE_DESCRIPTION("asynchronous memset api");
 MODULE_LICENSE("GPL");
diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index f21147f..c3b07cf 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -42,6 +42,9 @@ static void __exit async_tx_exit(void)
 	dmaengine_put();
 }
 
+module_init(async_tx_init);
+module_exit(async_tx_exit);
+
 /**
  * __async_tx_find_channel - find a channel to carry out the operation or let
  *	the transaction execute synchronously
@@ -59,17 +62,6 @@ __async_tx_find_channel(struct dma_async_tx_descriptor *depend_tx,
 	return dma_find_channel(tx_type);
 }
 EXPORT_SYMBOL_GPL(__async_tx_find_channel);
-#else
-static int __init async_tx_init(void)
-{
-	printk(KERN_INFO "async_tx: api initialized (sync-only)\n");
-	return 0;
-}
-
-static void __exit async_tx_exit(void)
-{
-	do { } while (0);
-}
 #endif
 
 
@@ -295,9 +287,6 @@ void async_tx_quiesce(struct dma_async_tx_descriptor **tx)
 }
 EXPORT_SYMBOL_GPL(async_tx_quiesce);
 
-module_init(async_tx_init);
-module_exit(async_tx_exit);
-
 MODULE_AUTHOR("Intel Corporation");
 MODULE_DESCRIPTION("Asynchronous Bulk Memory Transactions API");
 MODULE_LICENSE("GPL");
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 11978a8..0a56fae 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -298,19 +298,6 @@ async_xor_zero_sum(struct page *dest, struct page **src_list,
 }
 EXPORT_SYMBOL_GPL(async_xor_zero_sum);
 
-static int __init async_xor_init(void)
-{
-	return 0;
-}
-
-static void __exit async_xor_exit(void)
-{
-	do { } while (0);
-}
-
-module_init(async_xor_init);
-module_exit(async_xor_exit);
-
 MODULE_AUTHOR("Intel Corporation");
 MODULE_DESCRIPTION("asynchronous xor/xor-zero-sum api");
 MODULE_LICENSE("GPL");

