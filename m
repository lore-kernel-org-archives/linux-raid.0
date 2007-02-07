From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [RFC][PATCH 00/12] md raid acceleration and performance analysis
Date: Wed, 7 Feb 2007 15:36:52 -0700
Message-ID: <e9c3a7c20702071436s3e481c13ue1fe70cc68f19f27@mail.gmail.com>
References: <e9c3a7c20701222016q6e06dee6y7977f1525eacf042@mail.gmail.com>
	 <BD524EA7912ED5469DFD0BAEF6BC752F0136DE23@orsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BD524EA7912ED5469DFD0BAEF6BC752F0136DE23@orsmsx411.amr.corp.intel.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Leech, Christopher" <christopher.leech@intel.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On 2/6/07, Leech, Christopher <christopher.leech@intel.com> wrote:
> Hi Dan,
>
> I've been looking over how your patches change the ioatdma driver.  I
> like the idea of removing the multiple entry points for virtual address
> vs. page struct arguments, and just using dma_addr_t for the driver
> interfaces.
>
> But, I don't think having both ioatdma and iop-adma implement map_page,
> map_single, unmap_page, and unmap_single entry points is much better.
> Do you see a reason why it wouldn't work to expose the generic device
> for a DMA channel, and replace instances of
>
>         dma_device->map_single(dma_chan, src, len, DMA_TO_DEVICE)
>
> with
>
>         dma_map_single(dma_device->dev, src, len, DMA_TO_DEVICE)
>

I was initially concerned about a case where dma_map_single was not
equivalent to pci_map_single.  Looking now, it appears that case would
be a bug, so I will integrate this change.

> I am a little concerned about having the DMA mapping happen outside of
> the driver, but the unmapping is still in the driver cleanup routine.
> I'm not sure if it's really a problem, or how I'd change it though.
>
> - Chris

Thanks,
Dan
