From: Vishnu Suresh <Vishnu@freescale.com>
Subject: [PATCH v0] fsldma: re-initialize async_tx descriptors
Date: Mon, 14 Dec 2009 19:00:55 +0530
Message-ID: <1260797455-7390-1-git-send-email-Vishnu@freescale.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753527AbZLNNbT@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dan.j.williams@intel.com
Cc: B04825@freescale.com, R58472@freescale.com, Vishnu Suresh <Vishnu@freescale.com>
List-Id: linux-raid.ids

The async_tx descriptors contains dangling pointers.
Hence, re-initialize them to NULL before use.

Signed-off-by: Vishnu Suresh <Vishnu@freescale.com>
---
o. Rebased to linux-next as of 20091214

 drivers/dma/fsldma.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 272097a..779c2b6 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -384,6 +384,8 @@ static struct fsl_desc_sw *fsl_dma_alloc_descriptor(
 		dma_async_tx_descriptor_init(&desc_sw->async_tx,
 						&fsl_chan->common);
 		desc_sw->async_tx.tx_submit = fsl_dma_tx_submit;
+		desc_sw->async_tx.parent = NULL;
+		desc_sw->async_tx.next = NULL;
 		desc_sw->async_tx.phys = pdesc;
 	}
 
-- 
1.6.4.2
