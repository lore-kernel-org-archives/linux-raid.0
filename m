From: Neil Brown <neilb@suse.de>
Subject: Re: Detecting array parameters
Date: Thu, 17 Jun 2010 15:52:03 +1000
Message-ID: <20100617155203.0512f6c5@notabene.brown>
References: <20100609211340.GA12172@lazy.lzy>
	<20100610083112.47aa2200@notabene.brown>
	<20100612095821.GA14727@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100612095821.GA14727@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 12 Jun 2010 11:58:21 +0200
Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> wrote:

> Hi,
> 
> thanks for the answer.
> 
> The "--export" option is a good advice, unfortunately
> it seems to be quite "conservative" in the amount of
> information, probably it is following some "udev"
> requirements, I guess.
> 
> I'll try to explain what I'm trying to do, so, maybe,
> there will be some other good advices.
> 
> I've a bunch (10) of different (in size too) HDDs.
> These HDDs are partitioned in a way so that equal
> partitions can compose several RAID-6 arrays.
> So, for example, there are 5x 120GB and 5x 80GB HDDs.
> The firsts are partitioned in 80+40, and there are 2
> RAID-6, one made of 10 80GB "segments" and another
> made of 5 40GB "segments".
> So far, so good.
> 
> What I would like to do is a script, which, given an
> HDD as parameter will *properly* add it to the array.
> Where *properly* means, it will partition it properly,
> add the partitions to the respectively arrays, and
> perform, if necessary (non-degraded case) a grow.
> 
> My idea would be to go over the several arrays, check
> the partition size, create a partition on the new HDD,
> if possible, then add it and grow the array (if required).
> 
> The first step would be to find out the partition size,
> which does seem to be avaialable in:
> 
> /sys/class/block/mdX/md/rdX/block/size
> 
> I was wondering if this would be the best option to get
> this information, or there are better solutions.
> 
> Trying "mdadm -E /dev/sdX" returns also similar information,
> namely the available device size and the offset, which sum
> up to the partition size.
> 
> In /sys/class/block/mdX/md/rdX there are also two files,
> carrying similar information: "size" and "offset".
> In this case, strangely, the size is in KiB while the
> offset in sectors (seems a bug to me).
> 
> Any suggestions on how to do this in a *correct* way?
> 
> Thanks a lot in advance for any advice and, please,
> feel free to ask if you need more information.

I'm not sure there is a "correct" way.  Your requirements seem fairly
specific to your system and so you just need to code to match those.

One thought: when deciding how to partition a new device it might make more
sense to look at the partitioning of other devices and try to match that,
rather than to look at md arrays and try to match them.
Maybe. ??

NeilBrown
