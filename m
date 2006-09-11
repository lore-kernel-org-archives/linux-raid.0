From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 12/19] dmaengine: dma_async_memcpy_err for DMA engines
 that do not support memcpy
Date: Mon, 11 Sep 2006 19:51:12 -0400
Message-ID: <4505F670.9020605@garzik.org>
References: <1158015632.4241.31.camel@dwillia2-linux.ch.intel.com> <20060911231838.4737.6812.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060911231838.4737.6812.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, christopher.leech@intel.com
List-Id: linux-raid.ids

Dan Williams wrote:
> From: Dan Williams <dan.j.williams@intel.com>
> 
> Default virtual function that returns an error if the user attempts a
> memcpy operation.  An XOR engine is an example of a DMA engine that does
> not support memcpy.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> 
>  drivers/dma/dmaengine.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index fe62237..33ad690 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -593,6 +593,18 @@ void dma_async_device_unregister(struct 
>  }
>  
>  /**
> + * dma_async_do_memcpy_err - default function for dma devices that
> + *	do not support memcpy
> + */
> +dma_cookie_t dma_async_do_memcpy_err(struct dma_chan *chan,
> +		union dmaengine_addr dest, unsigned int dest_off,
> +		union dmaengine_addr src, unsigned int src_off,
> +                size_t len, unsigned long flags)
> +{
> +	return -ENXIO;
> +}

Further illustration of how this API growth is going wrong.  You should 
create an API such that it is impossible for an XOR transform to ever 
call non-XOR-transform hooks.

	Jeff



