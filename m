From: Neil Brown <neilb@suse.de>
Subject: Re: softraid and multiple distros
Date: Tue, 16 May 2006 08:08:20 +1000
Message-ID: <17512.64468.813293.673836@cse.unsw.edu.au>
References: <Pine.LNX.4.44.0605141048330.7486-100000@coffee.psychology.mcmaster.ca>
	<200605142000.56659.Dexter.Filmore@gmx.de>
	<17511.46222.221460.337788@cse.unsw.edu.au>
	<200605151454.27974.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dexter Filmore on Monday May 15
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 15, Dexter.Filmore@gmx.de wrote:
> > I always use entire disks if I want the entire disks raided (sounds
> > obvious, doesn't it...)  I only use partitions when I want to vary the
> > raid layout for different parts of the disk (e.g. mirrored root, mirrored
> > swap, raid6 for the rest).   But that certainly doesn't mean it is
> > wrong to use partitions for the whole disk.
> 
> The idea behind this is: let's say a disk fails, and you get a replacement, 
> but it has a different geometry or a few blocks less - won't work. 
> Even the same disk model might vary after a while.
> So I made 0xfd partitions of the size (whole disk minus few megs).
> 

An alternative is to use the --size option of mdadm to make the array
slightly smaller than the smallest drive.  So you don't need
partitions for this (though it is perfectly alright to use them if you
like). 

> > You can tell mdadm where to look.  If you want to be sure that it
> > won't look at entire drives, only partitions, then a line like
> >    DEVICES /dev/[hs]d*[0-1]
> > in /etc/mdadm.conf might be what you want.
> > However as you should be listing the uuids in /etc/mdadm.conf, any
> 
> Umm... yeah, should I?

What else would you use to uniquely identify the arrays?  Not device
names I hope.

> 
> > superblock with an unknown uuid will easily be ignored.
> >
> > If you are relying nf 0xfd autodetect to assemble your arrays, then
> > obviously the entire-disk superblock will be ignored (because they
> > wont be in the right place in any partition).
> 
> So mdadm --assemble --scan is fine for my scenario even with those orphaned 
> superblocks.

I cannot say for sure without seeing your mdadm.conf, but probably.

> 
> Should get me some sedatives for the day when this all explodes :P

Just make sure it happens on your day off, then someone else will
need the sedatives :-)

NeilBrown
