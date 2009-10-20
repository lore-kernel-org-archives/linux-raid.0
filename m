From: Dan Williams <dan.j.williams@intel.com>
Subject: [md PATCH 3/4] async_pq: rename scribble page
Date: Tue, 20 Oct 2009 00:11:33 -0700
Message-ID: <20091020071133.6489.2606.stgit@dwillia2-linux.ch.intel.com>
References: <20091020070627.6489.4006.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091020070627.6489.4006.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The global scribble page is used as a temporary destination buffer when
disabling the P or Q result is requested.  The local scribble buffer
contains memory for performing address conversions.  Rename the global
variable to avoid confusion.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 crypto/async_tx/async_pq.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 6047656..6b5cc4f 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -26,9 +26,10 @@
 #include <linux/async_tx.h>
 
 /**
- * scribble - space to hold throwaway P buffer for synchronous gen_syndrome
+ * pq_scribble_page - space to hold throwaway P or Q buffer for
+ * synchronous gen_syndrome
  */
-static struct page *scribble;
+static struct page *pq_scribble_page;
 
 /* the struct page *blocks[] parameter passed to async_gen_syndrome()
  * and async_syndrome_val() contains the 'P' destination address at
@@ -226,11 +227,11 @@ async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 	async_tx_quiesce(&submit->depend_tx);
 
 	if (!P(blocks, disks)) {
-		P(blocks, disks) = scribble;
+		P(blocks, disks) = pq_scribble_page;
 		BUG_ON(len + offset > PAGE_SIZE);
 	}
 	if (!Q(blocks, disks)) {
-		Q(blocks, disks) = scribble;
+		Q(blocks, disks) = pq_scribble_page;
 		BUG_ON(len + offset > PAGE_SIZE);
 	}
 	do_sync_gen_syndrome(blocks, offset, disks, len, submit);
@@ -384,9 +385,9 @@ EXPORT_SYMBOL_GPL(async_syndrome_val);
 
 static int __init async_pq_init(void)
 {
-	scribble = alloc_page(GFP_KERNEL);
+	pq_scribble_page = alloc_page(GFP_KERNEL);
 
-	if (scribble)
+	if (pq_scribble_page)
 		return 0;
 
 	pr_err("%s: failed to allocate required spare page\n", __func__);
@@ -396,7 +397,7 @@ static int __init async_pq_init(void)
 
 static void __exit async_pq_exit(void)
 {
-	put_page(scribble);
+	put_page(pq_scribble_page);
 }
 
 module_init(async_pq_init);

