From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 07/11] async_tx: kill needless module_{init|exit}
Date: Mon, 18 May 2009 18:00:01 -0700
Message-ID: <20090519010001.4104.24270.stgit@dwillia2-linux.ch.intel.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: maan@systemlinux.org, linux-kernel@vger.kernel.org, yur@emcraft.com, hpa@zytor.com
List-Id: linux-raid.ids

If module_init and module_exit are nops then neither need to be defined.

[ Impact: pure cleanup ]

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 crypto/async_tx/async_memcpy.c |   13 -------------
 crypto/async_tx/async_memset.c |   13 -------------
 crypto/async_tx/async_tx.c     |   17 +++--------------
 3 files changed, 3 insertions(+), 40 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index c9342ae..3ec118d 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -87,19 +87,6 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
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
index e347dbe..ae63140 100644
--- a/crypto/async_tx/async_memset.c
+++ b/crypto/async_tx/async_memset.c
@@ -78,19 +78,6 @@ async_memset(struct page *dest, int val, unsigned int offset, size_t len,
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
index 85e1b44..71f708f 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -42,6 +42,9 @@ static void __exit async_tx_exit(void)
 	async_dmaengine_put();
 }
 
+module_init(async_tx_init);
+module_exit(async_tx_exit);
+
 /**
  * __async_tx_find_channel - find a channel to carry out the operation or let
  *	the transaction execute synchronously
@@ -61,17 +64,6 @@ __async_tx_find_channel(struct async_submit_ctl *submit,
 	return async_dma_find_channel(tx_type);
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
 
 
@@ -293,9 +285,6 @@ void async_tx_quiesce(struct dma_async_tx_descriptor **tx)
 }
 EXPORT_SYMBOL_GPL(async_tx_quiesce);
 
-module_init(async_tx_init);
-module_exit(async_tx_exit);
-
 MODULE_AUTHOR("Intel Corporation");
 MODULE_DESCRIPTION("Asynchronous Bulk Memory Transactions API");
 MODULE_LICENSE("GPL");

