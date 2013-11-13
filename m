From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 4/4] raid6test: add new corner case for ioatdma driver
Date: Wed, 13 Nov 2013 12:12:41 -0800
Message-ID: <20131113201241.12667.99547.stgit@viggo.jf.intel.com>
References: <20131113200146.12667.19447.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131113200146.12667.19447.stgit@viggo.jf.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: dmaengine@vger.kernel.org
Cc: vinod.koul@intel.com, linux-raid@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>
List-Id: linux-raid.ids

With 24 disks and an ioatdma instance with 16 source support there is a
corner case where the driver needs to be careful to account for the
number of implied sources in the continuation case.

Also bump the default case to test more than 16 sources now that it
triggers different paths in offload drivers.

Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 crypto/async_tx/raid6test.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/crypto/async_tx/raid6test.c b/crypto/async_tx/raid6test.c
index 4a92bac744dc..dad95f45b88f 100644
--- a/crypto/async_tx/raid6test.c
+++ b/crypto/async_tx/raid6test.c
@@ -28,7 +28,7 @@
 #undef pr
 #define pr(fmt, args...) pr_info("raid6test: " fmt, ##args)
 
-#define NDISKS 16 /* Including P and Q */
+#define NDISKS 64 /* Including P and Q */
 
 static struct page *dataptrs[NDISKS];
 static addr_conv_t addr_conv[NDISKS];
@@ -219,6 +219,14 @@ static int raid6_test(void)
 		err += test(11, &tests);
 		err += test(12, &tests);
 	}
+
+	/* the 24 disk case is special for ioatdma as it is the boudary point
+	 * at which it needs to switch from 8-source ops to 16-source
+	 * ops for continuation (assumes DMA_HAS_PQ_CONTINUE is not set)
+	 */
+	if (NDISKS > 24)
+		err += test(24, &tests);
+
 	err += test(NDISKS, &tests);
 
 	pr("\n");

