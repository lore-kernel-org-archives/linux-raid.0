From: Stefan Roese <sr@denx.de>
Subject: Re: [PATCH] [PPC32] ADMA support for PPC 440SPe processors.
Date: Sat, 17 Mar 2007 09:09:13 +0100
Message-ID: <200703170909.13869.sr@denx.de>
References: <20070315232956.37DAB353A6C@atlas.denx.de> <e9c3a7c20703161100j70a52e5cg25ff3616a5cda8d5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20703161100j70a52e5cg25ff3616a5cda8d5@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linuxppc-dev@ozlabs.org, Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dan,

I just noticed that your patch "dmaengine: add the async_tx api":

@@ -22,6 +22,17 @@ config NET_DMA
 	  Since this is the main user of the DMA engine, it should be enabled;
 	  say Y here.
 
+config ASYNC_TX_DMA
+	tristate "Asynchronous Bulk Memory Transfers/Transforms API"
+	default y
+	---help---
+	  This enables the async_tx management layer for dma engines.
+	  Subsystems coded to this API will use offload engines for bulk
+	  memory operations where present.  Software implementations are
+	  called when a dma engine is not present or fails to allocate
+	  memory to carry out the transaction.
+	  Current subsystems ported to async_tx: MD_RAID4,5
+

adds ASYNC_TX_DMA unconditionally to _all_ platforms. You might what to bundle 
this with something like DMA_ENGINE.

Best regards,
Stefan
