From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] async_tx: deprecate broken support for channel switching
Date: Wed, 15 Feb 2017 18:42:09 -0800
Message-ID: <148721292971.19343.10618932473668163270.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinod.koul@intel.com
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>, Anup Patel <anup.patel@broadcom.com>, Rameshwar Prasad Sahu <rsahu@apm.com>, Russell King <linux@armlinux.org.uk>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dmaengine@vger.kernel.org, Anatolij Gustschin <agust@denx.de>, Saeed Bishara <saeed.bishara@gmail.com>
List-Id: linux-raid.ids

Back in 2011, Russell pointed out that the "async_tx channel switch"
capability was violating expectations of the dma mapping api [1]. At the
time the existing uses were reviewed as still usable, but that longer
term we needed a rework of the raid offload implementation. While some
of the framework for a fixed implementation was introduced in 2012 [2],
the wider rewrite never materialized.

There continues to be interest in raid offload with new dma/raid engine
drivers being submitted. Those drivers must not build on top of the
broken channel switching capability.

Prevent async_tx from using an offload engine if the channel switching
capability is enabled. This still allows the engine to be used for other
purposes, but the broken way async_tx uses these engines for raid will
be disabled. For configurations where this causes a performance
regression the only solution is to start the work of eliminating the
async_tx api and moving channel management into the raid code directly
where it can manage marshalling an operation stream between multiple dma
channels.

[1]: http://lists.infradead.org/pipermail/linux-arm-kernel/2011-January/036753.html
[2]: https://lkml.org/lkml/2012/12/6/71

Cc: Anatolij Gustschin <agust@denx.de>
Cc: Anup Patel <anup.patel@broadcom.com>
Cc: Rameshwar Prasad Sahu <rsahu@apm.com>
Cc: Saeed Bishara <saeed.bishara@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Reported-by: Russell King <linux@armlinux.org.uk>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/async_tx.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 388574ea38ed..28e3cf1465ab 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -87,7 +87,7 @@ struct async_submit_ctl {
 	void *scribble;
 };
 
-#ifdef CONFIG_DMA_ENGINE
+#if defined(CONFIG_DMA_ENGINE) && !defined(CONFIG_ASYNC_TX_CHANNEL_SWITCH)
 #define async_tx_issue_pending_all dma_issue_pending_all
 
 /**
