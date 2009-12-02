From: Anatolij Gustschin <agust@denx.de>
Subject: Re: [PATCH v2] ppc440spe-adma: adds updated ppc440spe adma driver
Date: Wed, 2 Dec 2009 15:16:12 +0100
Message-ID: <20091202151612.0e903996@wker>
References: <1259186722-15012-1-git-send-email-agust@denx.de>
	<4B1465C1.90606@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <4B1465C1.90606@intel.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>, Yuri Tikhonov <yur@emcraft.com>, "wd@denx.de" <wd@denx.de>, "dzu@denx.de" <dzu@denx.de>
List-Id: linux-raid.ids

Dan Williams <dan.j.williams@intel.com> wrote:

> Anatolij Gustschin wrote:
> > This patch adds new version of the PPC440SPe ADMA driver.
> > 
> > Signed-off-by: Anatolij Gustschin <agust@denx.de>
> > Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
> 
> [minor] Sign-offs are typically in delivery path order, so yours would 
> appear last.

Ok, I'll fix this in the next patch version.

> [..]
> >  drivers/dma/ppc440spe/ppc440spe-adma.c             | 5015 ++++++++++++++++++++
> >  drivers/dma/ppc440spe/ppc440spe_adma.h             |  195 +
> >  drivers/dma/ppc440spe/ppc440spe_dma.h              |  223 +
> >  drivers/dma/ppc440spe/ppc440spe_xor.h              |  110 +
> 
> I belong to the school of thought that says something along the lines of 
> "don't duplicate the directory path in the filename".  You seem to have 
> copied the iop-adma driver's inconsistent use of '-' and '_' let's not 
> carry that forward, i.e. looking for a changelog like:
> 
>    drivers/dma/ppc440spe/adma.c             | 5015 ++++++++++++++++++++
>    drivers/dma/ppc440spe/adma.h             |  195 +
>    drivers/dma/ppc440spe/dma.h              |  223 +
>    drivers/dma/ppc440spe/xor.h              |  110 +

Ok, it indeed looks much better. I think I should use 'ppc4xx' as driver
directory name now as we need to extend the driver to also support 460EX
later.

> > +/**
> > + * ppc440spe_adma_prep_dma_pqzero_sum - prepare CDB group for
> > + * a PQ_ZERO_SUM operation
> > + */
> > +static struct dma_async_tx_descriptor *ppc440spe_adma_prep_dma_pqzero_sum(
> > +               struct dma_chan *chan, dma_addr_t *pq, dma_addr_t *src,
> > +               unsigned int src_cnt, const unsigned char *scf, size_t len,
> > +               enum sum_check_flags *pqres, unsigned long flags)
> > +{
> > +       struct ppc440spe_adma_chan *ppc440spe_chan;
> > +       struct ppc440spe_adma_desc_slot *sw_desc, *iter;
> > +       dma_addr_t pdest, qdest;
> > +       int slot_cnt, slots_per_op, idst, dst_cnt;
> > +
> > +       if (unlikely(!len))
> > +               return NULL;
> > +       if (len > PAGE_SIZE)
> > +               return NULL;
> 
> This won't work, as currently we'll end up in an infinite loop in 
> async_syndrome_val() because all descriptor allocation failures are 
> assumed to be time-limited.  The code just issues any pending operations 
> and waits for descriptor resources to become available.

Yes, in the case 'len > PAGE_SIZE' this is true. I didn't look at
async_syndrome_val() code again before making this change and while
raid6 testing after this change I didn't notice any issues as passed
'len' was always equal to PAGE_SIZE. I must do this 'len' check while
looking for a suitable channel for pq_val operation so that there
will be a fallback to synchronous path in the case passed 'len' is
greater than PAGE_SIZE. I'll fix this.

> What this comes down to is that ppc440spe_adma is essentially fibbing 
> about its support for the pq_val operation.  I think a more generic 
> solution would be to advertise to the async_tx api that the driver has 
> per channel temporary buffers that can be used to store intermediate pq 
> results and let the async_tx api handle the emulation using its 
> knowledge of ->max_pq.  We would also need a mechanism for the async_tx 
> api to lock out other requesters of the temporary buffer until a 
> coherent set of descriptors referencing those temporary buffers has been 
> submitted to the driver.  This would help other drivers like mv_xor 
> which has no val support and ioatdma which currently can only validate 
> up to 8 sources asynchronously.
> 
> Can you clarify what ppc440spe-adma supports in this area?  It looks 
> like it has some hardware support for result checking but always needs 
> to write p and/or q somewhere?  Some devices may be able to do the final 
> comparison against the original parity values asynchronously while 
> others may need to do it synchronously in software.  These details can 
> be handled at the async_tx api level.

ppc440spe-adma supports checking against the original parity values
asynchronously using following approach:
original parity values (as passed to async_syndrome_val()) are copied to
channels temporary p and/or q buffer(s). Then the generation of the
syndrome is performed using this temporary buffer(s) as destination(s).
When DMA engine generates p and/or q parity, it always performs XOR
operation with the destination p and/or q buffer(s) content while
writing to this buffer(s). In the case that the syndrome is valid,
the destination p and/or q buffer(s) will be cleared (set to zero)
after syndrome validation. This is checked by the subsequent DMA
DATACHECK operation which compares a buffer with a data pattern and
stores the comparison result in the Completion Status FIFO. We queue
a subsequent DMA DATACHECK descriptor for this check operation. The
temporary buffers can be immediately re-used, they do not store a
result a subsequent async_tx operation depends on. I think this is
still much better than doing the validation synchronously in software.

Best regards,
Anatolij
