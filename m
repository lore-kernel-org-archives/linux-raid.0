From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: SATA raid options..
Date: Sat, 03 Jul 2004 13:05:05 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40E6E741.9090800@pobox.com>
References: <1088865298.4974.67.camel@faetterbox.faetter.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1088865298.4974.67.camel@faetterbox.faetter.net>
To: Daniel Kirkegaard Mouritsen <daniel@mouritsen.info>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Daniel Kirkegaard Mouritsen wrote:
> I own a Gigabyte GA-8KNXP motherboard, which has 4 serial-ata ports. Two
> of which features RAID functionality.
> 
> The serial-ata controller on the motherboard is a Silicon Image 3112A (a
> chip which i haven't been able to find much information about,
> siimage.com doesn't even list it as a product).
> 
> I'll soon get a new sata disk(identical to my current disk), and I would
> love to be able to do the following:
> 
> * keep using a 2.6.* kernel
> * Use the RAID BIOS administration interface to stripe/administer the
> disks
> * Have both my grub, /boot / and a NTFS-windows partition reside on
> striped set.
> 
> Is this at all possible? Can GRUB detect devices created with the
> on-board BIOS assisted raid?
> 
> Another thing, I'm getting severely confused what I'm supposed to use as
> a driver for the thing. ATM I found: udev+raiddetect or the
> not-yet-released(or is it? maybe its just me who cant find it :]) dmraid
> is the way to go. Does these both use the device-mapper tool? And can
> anybody tell me if dmraid is 2 or 20 months aways?

dmraid will be required for use, and its 2-4 months away, I would guess.

Why not just use md raid?  BIOS RAID is _always_ crap.

	Jeff



