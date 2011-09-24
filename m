From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: potentially lost largeish raid5 array..
Date: Fri, 23 Sep 2011 18:11:07 -0600
Message-ID: <201109231811.08061.tfjellstrom@shaw.ca>
References: <201109221950.36910.tfjellstrom@shaw.ca> <201109231022.59437.tfjellstrom@shaw.ca> <4E7D152C.9080704@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E7D152C.9080704@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On September 23, 2011, Stan Hoeppner wrote:
> On 9/23/2011 11:22 AM, Thomas Fjellstrom wrote:
> > I'd love to switch, but I didn't really have the money for the card then,
> > and now I have less money. I suppose if I ebayed this card first, and
> > then bought a new one that would work out, but yeah, It will have to
> > wait a bit (things are VERY tight right now).
> 
> Which is why you purchased the cheapest SAS card on the market at that
> time. :)
> 
> > So this Intel card, looks like a good option, but how much faster is it?
> > I get 500MB/s read off this SASLP. Probably a bit more now that there's
> > 7 drives in the array. Off of XFS, it gets at least 200MB/s read (the
> > discrepancy between raw and over xfs really bugs me, something there
> > can't be right can it?).
> 
> When properly configured XFS will achieve near spindle throughput.
> Recent versions of mkfs.xfs read the mdraid configuration and configure
> the filesystem automatically for sw, swidth, number of allocation
> groups, etc.  Thus you should get max performance out of the gate.

What happens when you add a drive and reshape? Is it enough just to tweak the 
mount options?

> If you really would like to fix this, you'll need to post on the XFS
> list.  Much more data will be required than simply stating "it's slower
> by x than 'raw' read".  This will include your mdadm config, testing
> methodology, and xfs_info output at minimum.  There is no simple "check
> this box" mega solution with XFS.

I tweaked a crap load of settings before settling on what I have. Its 
reasonable, a balance between raw throughput and directory access/modification 
performance. Read performance atm isn't as bad as I remember, about 423MB/s 
according to bonnie++. Write performance is 153MB/s which seems a tad low to 
me, but still not horrible. Faster than I generally need at any given time.

> > Thank you for the suggestion though, I will have to book mark that link.
> 
> You're welcome.
> 
> You can't find a better value for an 8 port SAS or SATA solution that
> actually works well with Linux.  Not to my knowledge anyway.  You could
> buy two PCIe x1 4 port Marvell based SATA only cards for $20-30 less
> maybe, but would be limited to 500MB/s raw unidirectional PCIe b/w vs
> 2GB/s with an x4 card, have less features, eat two slots, etc.  That
> would be more reliable than what you have now though.  The Marvell SATA
> driver in Linux is much more solid that the SAS driver, from what I've
> read anyway.  I've never used/owned any Marvell based cards.  If I go
> cheap I go Silicon Image.  It's too bad they don't have a 4 port PCIe
> ASIC in their line up.  The only 4 port chip they have is PCI based.
> Addonics sells a Silicon Image expander, but the total cost for a 2 port
> card and two expanders is quite a bit higher than the better Intel
> single card solution.

I appreciate the tips. That intel/LSI card seems like the best bet.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
