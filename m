From: Yuri Tikhonov <yur@emcraft.com>
Subject: Re: [PATCH] [PPC32] ADMA support for PPC 440SPe processors.
Date: Sat, 17 Mar 2007 11:57:57 +0300
Message-ID: <200703171157.58056.yur@emcraft.com>
References: <20070315232956.37DAB353A6C@atlas.denx.de>
	<e9c3a7c20703161100j70a52e5cg25ff3616a5cda8d5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
In-Reply-To: <e9c3a7c20703161100j70a52e5cg25ff3616a5cda8d5@mail.gmail.com>
Content-Disposition: inline
List-Unsubscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
To: Dan Williams <dan.j.williams@intel.com>, linuxppc-dev@ozlabs.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 Hi Dan,

On Friday 16 March 2007 21:00, you wrote:
> Here are some additional comments/nits:
> > +/*
> > + *  Init DMA0/1 and XOR engines; allocate memory for DMAx FIFOs; set
> > platform_device + * memory resources addresses
> > + */
> > +static void ppc440spe_configure_raid_devices(void)
>
> Any reason not to move most of this function into spe_adma_probe?  
> The "set resource address" section is the only piece that spe_adma_probe
> should not handle.

 Two ppc440spe's DMA1 and DMA2 engines have to be configured together with one 
I2O engine (all these units share the same pointer to the FIFO area in the 
main memory but use different parts of this common area). So, setting-up of 
this common FIFO area should be performed in the 
ppc440spe_configure_raid_devices(). As regarding other code in this function 
(except "set resource address"), it might be moved to the spe_adma_probe() 
indeed.

> > +++ b/drivers/dma/spe-adma.c
...
> > + *
> > + * The full GNU General Public License is included in this distribution
> > in the + * file called COPYING.
> > + */
> > +
> > +/*
> > + *  This driver supports the asynchrounous DMA copy and RAID engines
> > available + * on the AMCC PPC440SPe Processors.
> > + *  Based on the Intel Xscale(R) family of I/O Processors (SPE 32x, 33x,
> > 134x)
>
> SPE should be IOP on this line.

 Correct.
...
> > +
> > +DECLARE_TASKLET(spe_adma0_tasklet, spe_adma0_task, 0);
> > +DECLARE_TASKLET(spe_adma1_tasklet, spe_adma1_task, 0);
> > +DECLARE_TASKLET(spe_adma2_tasklet, spe_adma2_task, 0);
> > +struct tasklet_struct *spe_adma_tasklet[] = {
> > +       &spe_adma0_tasklet,
> > +       &spe_adma1_tasklet,
> > +       &spe_adma2_tasklet,
> > +};
> > +
>
> This is something I am cleaning up in iop-adma by adding a struct
> tasklet * to each channel.    I'll post an incremental diff of my
> iop-adma changes so you can see what I have cleaned up since the
> 2.6.20-rc5 posting.

 Thanks.

> > +static dma_addr_t spe_adma_map_page(struct dma_chan *chan, struct page
> > *page, +                                       unsigned long offset,
> > size_t size, +                                       int direction)
> > +{
> > +       struct spe_adma_chan *spe_chan = to_spe_adma_chan(chan);
> > +       return dma_map_page(&spe_chan->device->pdev->dev, page, offset,
> > size, +                       direction);
> > +}
> > +
> > +static dma_addr_t spe_adma_map_single(struct dma_chan *chan, void
> > *cpu_addr, +                                       size_t size, int
> > direction) +{
> > +       struct spe_adma_chan *spe_chan = to_spe_adma_chan(chan);
> > +       return dma_map_single(&spe_chan->device->pdev->dev, cpu_addr,
> > size, +                       direction);
> > +}
> > +
> > +static void spe_adma_unmap_page(struct dma_chan *chan, dma_addr_t
> > handle, +                               size_t size, int direction)
> > +{
> > +       struct spe_adma_chan *spe_chan = to_spe_adma_chan(chan);
> > +       dma_unmap_page(&spe_chan->device->pdev->dev, handle, size,
> > direction); +}
> > +
> > +static void spe_adma_unmap_single(struct dma_chan *chan, dma_addr_t
> > handle, +                               size_t size, int direction)
> > +{
> > +       struct spe_adma_chan *spe_chan = to_spe_adma_chan(chan);
> > +       dma_unmap_single(&spe_chan->device->pdev->dev, handle, size,
> > direction); +}
> > +
>
> ....these are gone as well in the latest code.
>
> > +static int __devinit spe_adma_probe(struct platform_device *pdev)
>
> .../..
>
> > +       printk(KERN_INFO "Intel(R) SPE ADMA Engine found [%d]: "
>
> Intel(R)? :-)

 Right : )

 Regards, Yuri.
