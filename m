From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 09/13] iop-adma: P+Q self test
Date: Fri, 20 Mar 2009 11:14:53 +1100
Message-ID: <18882.57341.196519.507194@notabene.brown>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
	<20090318192102.20375.36540.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Wednesday March 18
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

On Wednesday March 18, dan.j.williams@intel.com wrote:
> Even though the intent is to extend dmatest with P+Q tests there is
> still value in having an always-on sanity check to prevent an
> unintentionally broken driver from registering.
> 
> This depends on raid6_pq.ko for verification, the side effect being that
> PQ capable channels will fail to register when raid6 is disabled.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/dma/iop-adma.c |  182 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 181 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
> index 0cdb333..2b014b6 100644
> --- a/drivers/dma/iop-adma.c
> +++ b/drivers/dma/iop-adma.c
> @@ -31,6 +31,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/memory.h>
>  #include <linux/ioport.h>
> +#include <linux/raid/raid6.h>

???
 <linux/raid/pq.h>  Maybe?

NeilBrown
