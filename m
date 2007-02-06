From: "Leech, Christopher" <christopher.leech@intel.com>
Subject: RE: [RFC][PATCH 00/12] md raid acceleration and performance analysis
Date: Tue, 6 Feb 2007 15:49:03 -0800
Message-ID: <BD524EA7912ED5469DFD0BAEF6BC752F0136DE23@orsmsx411.amr.corp.intel.com>
References: <e9c3a7c20701222016q6e06dee6y7977f1525eacf042@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <e9c3a7c20701222016q6e06dee6y7977f1525eacf042@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Hi Dan,

I've been looking over how your patches change the ioatdma driver.  I
like the idea of removing the multiple entry points for virtual address
vs. page struct arguments, and just using dma_addr_t for the driver
interfaces.

But, I don't think having both ioatdma and iop-adma implement map_page,
map_single, unmap_page, and unmap_single entry points is much better.
Do you see a reason why it wouldn't work to expose the generic device
for a DMA channel, and replace instances of

	dma_device->map_single(dma_chan, src, len, DMA_TO_DEVICE)

with

	dma_map_single(dma_device->dev, src, len, DMA_TO_DEVICE)

I am a little concerned about having the DMA mapping happen outside of
the driver, but the unmapping is still in the driver cleanup routine.
I'm not sure if it's really a problem, or how I'd change it though.

- Chris
