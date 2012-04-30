From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: async_tx and RAID HW xor engine
Date: Mon, 30 Apr 2012 13:31:41 -0700
Message-ID: <CAA9_cmc0eEW-vjAuoj-ZnbX3vOrpswjVXU-NDw_rSSxqwvpU_w@mail.gmail.com>
References: <CAGA5_H55asVEekOd1ae2OjkK07W5Okf1iTCg10oRSX4+M7FLEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGA5_H55asVEekOd1ae2OjkK07W5Okf1iTCg10oRSX4+M7FLEA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Rajasekhar Pulluru <pullururajasekhar@gmail.com>
Cc: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>, Russell King <rmk@arm.linux.org.uk>
List-Id: linux-raid.ids

[ adding Russell and Neil for comment about the proposed change to async_tx ]

On Mon, Apr 30, 2012 at 3:05 AM, Rajasekhar Pulluru
<pullururajasekhar@gmail.com> wrote:
> Hi,
>
> I am trying to understand how are hardware xor engine's utilized by
> async_tx module. I don't get the exact link that connects async_tx and
> hardware xor engine.
> Could someone help me understand it.
>
> Registration of a RAID HW XOR engine happens in
> drivers/dma/<soc-xor.c> using dma_async_device_register(). Does this
> registration function connect the async_tx api's
> to use the HW XOR engine?

Yes, the channel registers its capabilities with dmaengine, and then
async_tx asks dmaengine (via dma_find_channel) for a resource to carry
out the operation(s).

> Or is there anything we need to support to
> make async_tx api's to take advantage of the hardware XOR engine?

Registration with dma engine should be all that is needed, but a word
of caution that the channel switching mechanism has been found to be
incompatible with the dma mapping api.  So, unless your dma channel
supports all the operations needed for raid, do not rely on async_tx's
channel switching capabilities.

An architecture where this is known to be a problem is ARM, but I
wonder if we should take the following global step until this is fixed
properly?

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index cf9da36..b812b6b 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -280,6 +280,7 @@ config NET_DMA
 config ASYNC_TX_DMA
        bool "Async_tx: Offload support for the async_tx api"
        depends on DMA_ENGINE
+       depends on !ASYNC_TX_ENABLE_CHANNEL_SWITCH
        help
          This allows the async_tx api to take advantage of offload engines for
          memcpy, memset, xor, and raid6 p+q operations.  If your platform has
