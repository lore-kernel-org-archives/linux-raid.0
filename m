From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: OT: silent data corruption reading from hard drives
Date: Wed, 01 Aug 2012 22:23:52 -0500
Message-ID: <5019F2C8.2070503@hardwarefreak.com>
References: <50191ADE.10809@fastmail.fm> <5019D052.4000409@hardwarefreak.com> <5019D78E.30609@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5019D78E.30609@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/1/2012 8:27 PM, Adam Goryachev wrote:

> On a related note, is there a specific model card you would suggest that
> fits the following:
> a) 4 or 8 ports
> b) PCI (for older systems)
> c) affordable (note, not cheap, but not expensive)
> d) does not need to support RAID since we will use software raid anyway

If you're stuck with PCI I'd stick with a more recognized vendor such as
Promise Tech.  They still sell a 4 port PCI card.  $70 USD at Newegg.

> I am always unsure, and see very cheap SATA cards (around $50) and worry
> as you suggest, and very expensive (around $1000), and feel that is a
> waste of money for what should be a fairly simple card.

A "very cheap" SATA card is a 2-port SiI 3512 based card--Syba,
Rosewill, Koutech, etc-- for $15 on sale, $20 regular price, all prices
USD.  A $50 card with the same port count *should* hopefully be much
higher quality.

> Also, would you use on board controller, or prefer to always use an
> external controller? Or is it worthwhile using a combination (in case of
> controller failure)?

Motherboard-down SATA controllers are usually fine for md/RAID as
they're part of an Intel or AMD chipset, and of high quality.  But this
also depends on the quality of the board as well--there have been plenty
of boards with good chipsets but also a buggy BIOS.  Overall they're
usually much better than a $20 card.

In 20+ years of computing I've never had an HBA or RAID card fail on me.
 I've had plenty of mobos go toes up and plenty of NICs and VGA cards
burn out.  I have a 128MB 3-channel AMI MegaRAID 428 UW-SCSI built in
1998 that still works and an Adaptec 1542 ISA SCSI card from 1993 that
still works.  I've tossed piles of dead mobos over the same period.

-- 
Stan

