From: dean gaudet <dean@arctic.org>
Subject: Re: 2.6.24-rc6 reproducible raid5 hang
Date: Sat, 29 Dec 2007 08:48:29 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0712290842530.21114@twinlark.arctic.org>
References: <alpine.DEB.0.999999.0712270845150.5207@twinlark.arctic.org>
 <alpine.DEB.0.999999.0712270938160.5207@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.0.999999.0712270938160.5207@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hmm bummer, i'm doing another test (rsync 3.5M inodes from another box) on 
the same 64k chunk array and had raised the stripe_cache_size to 1024... 
and got a hang.  this time i grabbed stripe_cache_active before bumping 
the size again -- it was only 905 active.  as i recall the bug we were 
debugging a year+ ago the active was at the size when it would hang.  so 
this is probably something new.

anyhow raising it to 2048 got it unstuck, but i'm guessing i'll be able to 
hit that limit too if i try harder :)

btw what units are stripe_cache_size/active in?  is the memory consumed 
equal to (chunk_size * raid_disks * stripe_cache_size) or (chunk_size * 
raid_disks * stripe_cache_active)?

-dean

On Thu, 27 Dec 2007, dean gaudet wrote:

> hmm this seems more serious... i just ran into it with chunksize 64KiB and 
> while just untarring a bunch of linux kernels in parallel... increasing 
> stripe_cache_size did the trick again.
> 
> -dean
> 
> On Thu, 27 Dec 2007, dean gaudet wrote:
> 
> > hey neil -- remember that raid5 hang which me and only one or two others 
> > ever experienced and which was hard to reproduce?  we were debugging it 
> > well over a year ago (that box has 400+ day uptime now so at least that 
> > long ago :)  the workaround was to increase stripe_cache_size... i seem to 
> > have a way to reproduce something which looks much the same.
> > 
> > setup:
> > 
> > - 2.6.24-rc6
> > - system has 8GiB RAM but no swap
> > - 8x750GB in a raid5 with one spare, chunksize 1024KiB.
> > - mkfs.xfs default options
> > - mount -o noatime
> > - dd if=/dev/zero of=/mnt/foo bs=4k count=2621440
> > 
> > that sequence hangs for me within 10 seconds... and i can unhang / rehang 
> > it by toggling between stripe_cache_size 256 and 1024.  i detect the hang 
> > by watching "iostat -kx /dev/sd? 5".
> > 
> > i've attached the kernel log where i dumped task and timer state while it 
> > was hung... note that you'll see at some point i did an xfs mount with 
> > external journal but it happens with internal journal as well.
> > 
> > looks like it's using the raid456 module and async api.
> > 
> > anyhow let me know if you need more info / have any suggestions.
> > 
> > -dean
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
