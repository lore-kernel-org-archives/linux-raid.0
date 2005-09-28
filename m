From: Neil Brown <neilb@suse.de>
Subject: Re: maximum size
Date: Wed, 28 Sep 2005 10:56:49 +0200
Message-ID: <17210.23249.826375.668486@cse.unsw.edu.au>
References: <43394753.9040107@bppiac.hu>
	<17209.18879.583532.761762@cse.unsw.edu.au>
	<43394E4E.4060702@bppiac.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Farkas Levente on Tuesday September 27
Sender: linux-raid-owner@vger.kernel.org
To: Farkas Levente <lfarkas@bppiac.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday September 27, lfarkas@bppiac.hu wrote:
> Neil Brown wrote:
> > On Tuesday September 27, lfarkas@bppiac.hu wrote:
> > 
> >>hi,
> >>i'd been already asked, but don't get any answer. what is the maximum 
> >>size of a raid5 and raid5 partition in kerenel 2.6? i try to find the 
> >>answer but found only kernel 2.4 info.
> >>thanks in advance.
> >>
> > 
> > 
> > Providing you are using either 64bit hardware, or the 'LBD' (large
> > block device) config, then raid5 arrays can be up to 2^64 -
> > i.e. enormous - no practical limit.
> 
> huu, i don't know. we use 3ware 7506 controller. on it onw homepage it 
> said:
> ---------------------------
> Supports up to 12 drives with a single PCI card enabling up to 3.6 
> terabytes of storage (dependent on drive capacity, 2TB per array maximum)
> ---------------------------
> but it's all about the hardware raid5. so it's native hardware raid5 
> can't be larger than 2TB.

Quite possibly.  I was talking about 'md' software raid.  It don't not
have a 2TB limit in 2.6

> > I don't know what you mean by 'raid5 partition'.  If you mean like a
> > regular partition of a device, then the partition can be nearly as bit
> > as the array....
> 
> suppose i create the raid device with:
> mdadm --create /dev/md0--level=5 --raid-devices=8 --spare-devices=1 
> /dev/sd[abcdefgh]1
> then what is the maximum size for /dev/md0?
> (or more precisely after a mkfs.ext3 /dev/md0).

The /dev/sdX1 cannot be larger than 2TB.  The /dev/md0 can be as big
as you like.  The filesystem can be as big as your filesystem allows.
I don't think ext3 can exceed 2 TB (I could be wrong).  Other
filesystems (reiser, xfs) can certainly use whatever you can through
at them.

NeilBrown
