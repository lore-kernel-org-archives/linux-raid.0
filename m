From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 3/8] ioat2,3: disable asynchronous error notifications
Date: Fri, 20 Nov 2009 00:06:29 -0700
Message-ID: <20091120070629.13478.67985.stgit@dwillia2-linux.ch.intel.com>
References: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756319AbZKTHGb@vger.kernel.org>
In-Reply-To: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

Error interrupts and error completions may cause channel hangs, so
poll the channel status register after a timeout.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/registers.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ioat/registers.h b/drivers/dma/ioat/registers.h
index 63038e1..f015ec1 100644
--- a/drivers/dma/ioat/registers.h
+++ b/drivers/dma/ioat/registers.h
@@ -92,9 +92,7 @@
 #define IOAT_CHANCTRL_ERR_COMPLETION_EN		0x0004
 #define IOAT_CHANCTRL_INT_REARM			0x0001
 #define IOAT_CHANCTRL_RUN			(IOAT_CHANCTRL_INT_REARM |\
-						 IOAT_CHANCTRL_ERR_COMPLETION_EN |\
-						 IOAT_CHANCTRL_ANY_ERR_ABORT_EN |\
-						 IOAT_CHANCTRL_ERR_INT_EN)
+						 IOAT_CHANCTRL_ANY_ERR_ABORT_EN)
 
 #define IOAT_DMA_COMP_OFFSET			0x02	/* 16-bit DMA channel compatibility */
 #define IOAT_DMA_COMP_V1			0x0001	/* Compatibility with DMA version 1 */
