From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2] ppc440spe-adma: adds updated ppc440spe adma driver
Date: Mon, 30 Nov 2009 17:39:29 -0700
Message-ID: <4B1465C1.90606@intel.com>
References: <1259186722-15012-1-git-send-email-agust@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1259186722-15012-1-git-send-email-agust@denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Anatolij Gustschin <agust@denx.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>, "wd@denx.de" <wd@denx.de>, "dzu@denx.de" <dzu@denx.de>, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

Anatolij Gustschin wrote:
> This patch adds new version of the PPC440SPe ADMA driver.
> 
> Signed-off-by: Anatolij Gustschin <agust@denx.de>
> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>

[minor] Sign-offs are typically in delivery path order, so yours would 
appear last.

[..]
>  drivers/dma/ppc440spe/ppc440spe-adma.c             | 5015 ++++++++++++++++++++
>  drivers/dma/ppc440spe/ppc440spe_adma.h             |  195 +
>  drivers/dma/ppc440spe/ppc440spe_dma.h              |  223 +
>  drivers/dma/ppc440spe/ppc440spe_xor.h              |  110 +

I belong to the school of thought that says something along the lines of 
"don't duplicate the directory path in the filename".  You seem to have 
copied the iop-adma driver's inconsistent use of '-' and '_' let's not 
carry that forward, i.e. looking for a changelog like:

   drivers/dma/ppc440spe/adma.c             | 5015 ++++++++++++++++++++
   drivers/dma/ppc440spe/adma.h             |  195 +
   drivers/dma/ppc440spe/dma.h              |  223 +
   drivers/dma/ppc440spe/xor.h              |  110 +

> +/**
> + * ppc440spe_adma_prep_dma_pqzero_sum - prepare CDB group for
> + * a PQ_ZERO_SUM operation
> + */
> +static struct dma_async_tx_descriptor *ppc440spe_adma_prep_dma_pqzero_sum(
> +               struct dma_chan *chan, dma_addr_t *pq, dma_addr_t *src,
> +               unsigned int src_cnt, const unsigned char *scf, size_t len,
> +               enum sum_check_flags *pqres, unsigned long flags)
> +{
> +       struct ppc440spe_adma_chan *ppc440spe_chan;
> +       struct ppc440spe_adma_desc_slot *sw_desc, *iter;
> +       dma_addr_t pdest, qdest;
> +       int slot_cnt, slots_per_op, idst, dst_cnt;
> +
> +       if (unlikely(!len))
> +               return NULL;
> +       if (len > PAGE_SIZE)
> +               return NULL;

This won't work, as currently we'll end up in an infinite loop in 
async_syndrome_val() because all descriptor allocation failures are 
assumed to be time-limited.  The code just issues any pending operations 
and waits for descriptor resources to become available.

What this comes down to is that ppc440spe_adma is essentially fibbing 
about its support for the pq_val operation.  I think a more generic 
solution would be to advertise to the async_tx api that the driver has 
per channel temporary buffers that can be used to store intermediate pq 
results and let the async_tx api handle the emulation using its 
knowledge of ->max_pq.  We would also need a mechanism for the async_tx 
api to lock out other requesters of the temporary buffer until a 
coherent set of descriptors referencing those temporary buffers has been 
submitted to the driver.  This would help other drivers like mv_xor 
which has no val support and ioatdma which currently can only validate 
up to 8 sources asynchronously.

Can you clarify what ppc440spe-adma supports in this area?  It looks 
like it has some hardware support for result checking but always needs 
to write p and/or q somewhere?  Some devices may be able to do the final 
comparison against the original parity values asynchronously while 
others may need to do it synchronously in software.  These details can 
be handled at the async_tx api level.

Until this is resolved I would prefer that ppe440spe-adma use the 
existing pq_val emulation by not setting DMA_PQ_VAL in the capability mask.

--
Dan

