From: Matt Thrailkill <xwred1@modestolan.com>
Subject: Re: libata
Date: Sun, 15 Feb 2004 00:30:40 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1076833840.28006.3.camel@stoneburner.xwredwing.net>
References: <402F2A22.8080204@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <402F2A22.8080204@wasp.net.au>
To: Brad Campbell <brad@wasp.net.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is the same card I've got in my box, the one I happened to trip a
hpt366 driver bug with that I mention in my other mailing.

Does the Highpoint driver do hotswap and all that goodness?  My
understanding is that the 1540 card is just a hpt374 with pata->sata
converters soldered on, rather than a "true" sata controller.

I think for a short time I tried doing some simple hotswapping in
Windows and it didn't work, does that (or any hotswapping) work for you?

The e.sata ports on the back of the card is just begging for hotswap
support.

Linux-ide.org is where the libsata work is at, I think.  Do they have a
dedicated list?

On Sun, 2004-02-15 at 00:13, Brad Campbell wrote:
> G'day all.
> 
> I have a pair of HPT1540 SATA cards that I'm currently using with the Highpoint supplied driver
> (Sans raid proprietary binary - Complete source compile) on a 2.4 kernel.
> I have been looking at libata as I'd like to move to an in-kernel driver and I'm having issues with
> the in-kernel hpt366 ide driver. Plus, given all my drives are in Supermicro Hotswap bays I'm hoping
> that one day we may realise seamless hotswap and I can swap out faulty software raid disks on the
> fly and I guess libata is the best way to work towards this :p)
> 
> I think I get the idea of how libata goes together and I'd like to have a crack at writing a
> sata_hpt module. Has anyone done any ground work on this or is already working on it or do I start
> from scratch?
> 
> Are there any known reasons as to why it will / will not work or anything else that would preclude
> me from getting it going?
> 
> Is there a better place to discuss this?
> 
> Regards,
> Brad
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

