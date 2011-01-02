From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: [Slightly OT] Cheap 4-port PCI-E SATA card?
Date: Sun, 2 Jan 2011 17:04:44 -0600
Message-ID: <AANLkTimDZR0ZFaXT49UL7DQttEtWJ2X2Rkc40UAD6VkS@mail.gmail.com>
References: <4D20E9F7.2080800@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D20E9F7.2080800@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Jan 2, 2011 at 3:11 PM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> Please could someone suggest a cheap PCI-E SATA card with 4 internal ports?
>
> I currently have 6 motherboard SATA ports and a 5-drive hot-swap chassis, I
> am thinking of adding a second 5-drive hot-swap chassis to my case and would
> need another 4 SATA ports to drive it.
>
> Other requirements: known to work with RHEL/CentOS 5 kernels, even if it
> means installing a driver with DKMS or whatever.

You can also get a SAS card, and an overpriced mini-SAS to SATA cable.
 The LSI SAS 1068e chip is quite common and well supported by Linux.
You can buy LSI-branded cards, or from another OEM that uses the same
chip.  Intel makes such a card, and I just read that IBM does as well,
the ServeRAID BR10i LSI SAS3082E-R.  Covered in detail here:

    http://www.servethehome.com/ibm-serveraid-br10i-lsi-sas3082e-r-pciexpress-sas-raid-controller/

Such a card will actually give you a total of eight SATA ports, but
you obviously don't have to use them all; you can get away with only
buying one of the SAS to 4-SATA port fanout cables.

I grabbed two of those IBM BR10i cards off of ebay for about $50.
Unfortunately, I didn't pay close attention to the listing, and mine
came without PCI brackets.  But so far I've tested one, and it works
just fine.

> Doesn't have to be PCI-E x1 because I've a spare x8 (logical)/x16 (physical)
> slot, but I don't know if anything cheap's going to be anything other than
> PCI-E x1. v2.0 (5GT/s) would be nice though.

If you're using a typical consumer-grade motherboard, watch out that
the PCIe slot supports things other than video cards.  For whatever
reason, particularly on micro-ATX boards, the PCIe x8/x16 slots often
won't work with anything other than video cards.  Trying to use
something else (e.g. a RAID card) will, at best, prohibit the machine
from booting, or at worst, cause very subtle random problems.
