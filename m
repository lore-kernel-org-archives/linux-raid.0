From: Gordon Henderson <gordon@drogon.net>
Subject: Re: 8-port SATA PCI/PCIX adaptor
Date: Sat, 2 Apr 2005 16:04:48 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0504021552250.30253@lion.drogon.net>
References: <d2mae1$ii$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d2mae1$ii$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2 Apr 2005, Max Waterman wrote:

> http://www.sonnettech.com/product/tempo-x_esata8.html
>
> do you think this will work with Linux?
>
> what about Linux on an Intel platform?

Hard to tell without knowing the actual chip-set on-board.

> I wonder how it performs - esp. compared to the supermicro card
> http://supermicro.com/products/accessories/addon/DAC-SATA-MV8.cfm which
> which is a fair bit cheaper at ~$99 and presents the ports internally. I
> know the Supermicro has a linux driver (they emailed it to me), but I
> haven't tried it.
>
> Anyone tried these cards?

What are you after? Card for internal drives, or external drives? If
Internal drives, unless you can identify the chipset, I'd avoid this card
and go for something else.

If external drives, then it's worth trying to find-out what the underlying
chip-set is.

Personally, if you have 8 external drives, I'd consider SCSI, just to
cut-down on the number of cables! (Although the cost of the drives might
well be a factor for you, as it is offten for me )-:

If internally, I'd go for a board that has open-source drivers. I've just
been trying the Highpoint 4-port card - no open source driver, and their
own supplied Linux driver is some 10-15% slower than another SATA card
(SII chipset) and didn't support SMART command pass-through.

If your motherboard has multiple PCI buses, you might want to look at 2 x
4-port cards which will probably improve performance somewhat if you can
get them on separate busses.

The cheaper cards that I've used seem to have mostly the SII chipset - and
that appears to be well supported by Linux. The 3112 is a dual-port card,
the 3114, quad. There are RAID and non-RAID variants, and all the ones
I've used seem to have a JBOD mode anyway (so you use s/w RAID rather than
their supplied h/w RAID) (The exception would seem to be the Dell/Adaptec
6-port SATA card I had recently - it has 3 x SII 3112 chips on it, and a
big Adaptec/Dell chip which hides them from bus )-:

Gordon
