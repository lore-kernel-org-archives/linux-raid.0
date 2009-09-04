From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 09/18] ioat3: enable dca for completion writes
Date: Thu, 03 Sep 2009 23:45:20 -0700
Message-ID: <20090904064520.7141.62811.stgit@dwillia2-linux.ch.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

Tag completion writes for direct cache access to reduce the latency of
checking for descriptor completions.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dma_v3.c    |    3 ++-
 drivers/dma/ioat/registers.h |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 22af78e..0913d11 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -167,7 +167,8 @@ static void ioat3_cleanup_tasklet(unsigned long data)
 	struct ioat2_dma_chan *ioat = (void *) data;
 
 	ioat3_cleanup(ioat);
-	writew(IOAT_CHANCTRL_RUN, ioat->base.reg_base + IOAT_CHANCTRL_OFFSET);
+	writew(IOAT_CHANCTRL_RUN | IOAT3_CHANCTRL_COMPL_DCA_EN,
+	       ioat->base.reg_base + IOAT_CHANCTRL_OFFSET);
 }
 
 static void ioat3_restart_channel(struct ioat2_dma_chan *ioat)
diff --git a/drivers/dma/ioat/registers.h b/drivers/dma/ioat/registers.h
index 85d04b8..97d26ea 100644
--- a/drivers/dma/ioat/registers.h
+++ b/drivers/dma/ioat/registers.h
@@ -84,6 +84,7 @@
 /* DMA Channel Registers */
 #define IOAT_CHANCTRL_OFFSET			0x00	/* 16-bit Channel Control Register */
 #define IOAT_CHANCTRL_CHANNEL_PRIORITY_MASK	0xF000
+#define IOAT3_CHANCTRL_COMPL_DCA_EN		0x0200
 #define IOAT_CHANCTRL_CHANNEL_IN_USE		0x0100
 #define IOAT_CHANCTRL_DESCRIPTOR_ADDR_SNOOP_CONTROL	0x0020
 #define IOAT_CHANCTRL_ERR_INT_EN		0x0010

