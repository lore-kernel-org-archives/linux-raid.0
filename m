From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5/8] ioat2,3: report all uncorrectable errors
Date: Fri, 20 Nov 2009 00:06:39 -0700
Message-ID: <20091120070639.13478.27278.stgit@dwillia2-linux.ch.intel.com>
References: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756643AbZKTHGi@vger.kernel.org>
In-Reply-To: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

Modify is_ioat_bug() to catch all errors that are uncorrectable, or not
currently handled.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dma.h    |    4 +---
 drivers/dma/ioat/dma_v2.c |    2 ++
 drivers/dma/ioat/dma_v3.c |    2 ++
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index c14fdfe..45edde9 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -297,9 +297,7 @@ static inline bool is_ioat_suspended(unsigned long status)
 /* channel was fatally programmed */
 static inline bool is_ioat_bug(unsigned long err)
 {
-	return !!(err & (IOAT_CHANERR_SRC_ADDR_ERR|IOAT_CHANERR_DEST_ADDR_ERR|
-			 IOAT_CHANERR_NEXT_ADDR_ERR|IOAT_CHANERR_CONTROL_ERR|
-			 IOAT_CHANERR_LENGTH_ERR));
+	return !!err;
 }
 
 static inline void ioat_unmap(struct pci_dev *pdev, dma_addr_t addr, size_t len,
diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index 96ffab7..8f1f7f0 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -279,6 +279,8 @@ void ioat2_timer_event(unsigned long data)
 			u32 chanerr;
 
 			chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
+			dev_err(to_dev(chan), "%s: Channel halted (%x)\n",
+				__func__, chanerr);
 			BUG_ON(is_ioat_bug(chanerr));
 		}
 
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index fad2e9f..252cf2d 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -378,6 +378,8 @@ static void ioat3_timer_event(unsigned long data)
 			u32 chanerr;
 
 			chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
+			dev_err(to_dev(chan), "%s: Channel halted (%x)\n",
+				__func__, chanerr);
 			BUG_ON(is_ioat_bug(chanerr));
 		}
 
