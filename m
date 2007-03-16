From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [PATCH] [PPC32] ADMA support for PPC 440SPe processors.
Date: Fri, 16 Mar 2007 11:00:30 -0700
Message-ID: <e9c3a7c20703161100j70a52e5cg25ff3616a5cda8d5@mail.gmail.com>
References: <20070315232956.37DAB353A6C@atlas.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070315232956.37DAB353A6C@atlas.denx.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: linuxppc-dev@ozlabs.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here are some additional comments/nits:

> +/*
> + *  Init DMA0/1 and XOR engines; allocate memory for DMAx FIFOs; set platform_device
> + * memory resources addresses
> + */
> +static void ppc440spe_configure_raid_devices(void)

Any reason not to move most of this function into spe_adma_probe?  The
"set resource address" section is the only piece that spe_adma_probe
should not handle.

> +++ b/drivers/dma/spe-adma.c
> @@ -0,0 +1,1071 @@
> +/*
> + * Copyright(c) 2006 DENX Engineering. All rights reserved.
> + *
> + * Author: Yuri Tikhonov <yur@emcraft.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program; if not, write to the Free Software Foundation, Inc., 59
> + * Temple Place - Suite 330, Boston, MA  02111-1307, USA.
> + *
> + * The full GNU General Public License is included in this distribution in the
> + * file called COPYING.
> + */
> +
> +/*
> + *  This driver supports the asynchrounous DMA copy and RAID engines available
> + * on the AMCC PPC440SPe Processors.
> + *  Based on the Intel Xscale(R) family of I/O Processors (SPE 32x, 33x, 134x)
SPE should be IOP on this line.

../..

> +static inline void
> +spe_adma_slot_cleanup(struct spe_adma_chan *spe_chan)
> +{
> +       spin_lock_bh(&spe_chan->lock);
> +       __spe_adma_slot_cleanup(spe_chan);
> +       spin_unlock_bh(&spe_chan->lock);
> +}
> +
> +static struct spe_adma_chan *spe_adma_chan_array[3];
> +static void spe_adma0_task(unsigned long data)
> +{
> +       __spe_adma_slot_cleanup(spe_adma_chan_array[0]);
> +}
> +
> +static void spe_adma1_task(unsigned long data)
> +{
> +       __spe_adma_slot_cleanup(spe_adma_chan_array[1]);
> +}
> +
> +static void spe_adma2_task(unsigned long data)
> +{
> +       __spe_adma_slot_cleanup(spe_adma_chan_array[2]);
> +}
> +
> +DECLARE_TASKLET(spe_adma0_tasklet, spe_adma0_task, 0);
> +DECLARE_TASKLET(spe_adma1_tasklet, spe_adma1_task, 0);
> +DECLARE_TASKLET(spe_adma2_tasklet, spe_adma2_task, 0);
> +struct tasklet_struct *spe_adma_tasklet[] = {
> +       &spe_adma0_tasklet,
> +       &spe_adma1_tasklet,
> +       &spe_adma2_tasklet,
> +};
> +
This is something I am cleaning up in iop-adma by adding a struct
tasklet * to each channel.    I'll post an incremental diff of my
iop-adma changes so you can see what I have cleaned up since the
2.6.20-rc5 posting.

> +static dma_addr_t spe_adma_map_page(struct dma_chan *chan, struct page *page,
> +                                       unsigned long offset, size_t size,
> +                                       int direction)
> +{
> +       struct spe_adma_chan *spe_chan = to_spe_adma_chan(chan);
> +       return dma_map_page(&spe_chan->device->pdev->dev, page, offset, size,
> +                       direction);
> +}
> +
> +static dma_addr_t spe_adma_map_single(struct dma_chan *chan, void *cpu_addr,
> +                                       size_t size, int direction)
> +{
> +       struct spe_adma_chan *spe_chan = to_spe_adma_chan(chan);
> +       return dma_map_single(&spe_chan->device->pdev->dev, cpu_addr, size,
> +                       direction);
> +}
> +
> +static void spe_adma_unmap_page(struct dma_chan *chan, dma_addr_t handle,
> +                               size_t size, int direction)
> +{
> +       struct spe_adma_chan *spe_chan = to_spe_adma_chan(chan);
> +       dma_unmap_page(&spe_chan->device->pdev->dev, handle, size, direction);
> +}
> +
> +static void spe_adma_unmap_single(struct dma_chan *chan, dma_addr_t handle,
> +                               size_t size, int direction)
> +{
> +       struct spe_adma_chan *spe_chan = to_spe_adma_chan(chan);
> +       dma_unmap_single(&spe_chan->device->pdev->dev, handle, size, direction);
> +}
> +
...these are gone as well in the latest code.

> +static int __devinit spe_adma_probe(struct platform_device *pdev)
../..

> +       printk(KERN_INFO "Intel(R) SPE ADMA Engine found [%d]: "
Intel(R)? :-)

Regards,
Dan
