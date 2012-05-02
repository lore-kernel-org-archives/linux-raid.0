From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: async_tx and RAID HW xor engine
Date: Wed, 2 May 2012 12:11:50 -0700
Message-ID: <CAA9_cmfTh=Tx_Q009CdBKiqO-TOBOjrfua759FMwfqChW6mJhw@mail.gmail.com>
References: <CAGA5_H55asVEekOd1ae2OjkK07W5Okf1iTCg10oRSX4+M7FLEA@mail.gmail.com>
	<CAA9_cmc0eEW-vjAuoj-ZnbX3vOrpswjVXU-NDw_rSSxqwvpU_w@mail.gmail.com>
	<20120501104914.4066a38c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120501104914.4066a38c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Rajasekhar Pulluru <pullururajasekhar@gmail.com>, linux-raid@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
List-Id: linux-raid.ids

On Mon, Apr 30, 2012 at 5:49 PM, NeilBrown <neilb@suse.de> wrote:
> On Mon, 30 Apr 2012 13:31:41 -0700 Dan Williams <dan.j.williams@intel=
=2Ecom>
> wrote:
>
>> [ adding Russell and Neil for comment about the proposed change to a=
sync_tx ]
>
> I've managed to avoid learning much about the internal details of asy=
nc_tx
> and adma but I thought I'd have a quick look.
>
> Doesn't this Kconfig change simply disable ASYNC_TX_DMA on any device=
 that
> selects ASNC_TX_ENABLE_CHANNEL_SWITCH. =A0i.e.
> =A0INTEL_IOP_ADMA
> =A0FSL_DMA
> =A0MX_XOR
> =A0AMCC_PPC440_SPA_ADMA
> Is that what you want to do? =A0Disable all of those?
> I guess if they don't work then that is the right thing to do....

Now that I refresh my memory on the full scope of the problem, this
change would help, but would not be sufficient.  The undefined
behavior that the code currently relies on is overlapping dma-mappings
to the same buffer (happens to work on x86, known to be broken on ARM
v6).  So md/raid456 and async_tx actually need to conscious of up to
three dma mapping cases:

1/ pure software raid
2/ offload to a dma domain that can handle a copy+xor/pq+validate
chain (dma map the stripe once)
    2a/ single domain single channel
    2b/ single domain multiple channels - channel switch but reuse the
initial dma mapping for all operations
3/ offload to collection of dma domains with differing capabilities
(channel switch + remap the stripe every time we cross a domain
boundary)

The biggest difference between 2 and 3 is that the entire chain of
operations can be prepped and submitted to hardware up front in 2, but
needs to wait for the completion of the previous operation before
re-mapping in 3.

An ulterior motive of adding "depends on
!ASYNC_TX_ENABLE_CHANNEL_SWITCH" is to elicit some help with this
rework from other driver maintainers since I'm not even sure 3 is a
configuration the current engines will present.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
