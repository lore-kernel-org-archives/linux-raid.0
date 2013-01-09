From: Chris Murphy <lists@colorremedies.com>
Subject: Re: How do I tell which disk failed?
Date: Tue, 8 Jan 2013 17:43:44 -0700
Message-ID: <40AF2260-F675-4394-B669-74AF047AFEE6@colorremedies.com>
References: <1357610701.16366.13.camel@corn.betterworld.us> <50EBAC5D.8080000@hardwarefreak.com> <1357628351.16366.86.camel@corn.betterworld.us> <02B6762C-3755-4CE3-9AB1-A48D3384CACB@colorremedies.com> <1357631996.16366.139.camel@corn.betterworld.us> <3D8A55DE-C4A8-4639-A662-CD3FF228230F@colorremedies.com> <1357682055.3484.34.camel@markov.biostat.ucsf.edu> <44902B51-EBD5-4D22-BC70-5D60F307CC08@colorremedies.com> <1357686788.3484.58.camel@markov.biostat.ucsf.edu>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1357686788.3484.58.camel@markov.biostat.ucsf.edu>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 8, 2013, at 4:13 PM, Ross Boylan <ross@biostat.ucsf.edu> wrote:

> I didn't mean that the disk changed its sector size dynamically, just
> that, e.g., it might have physical sectors of 4k but report that it has
> (logical) sectors of 512.

Reds are AF drives. Any 512e AF drive should be reported as having 512 bytes logical sector size, and 4096 byte physical sector size.


> I'm not sure what you mean by the offset working.  I'm referring to the
> fact that for some drives when you ask for logical sector n you actually
> get physical sector n+1, n-2, or something like that.  This implies that
> aligning on the logical sectors (meaning the ones the drive reports out)
> might misalign on the physical ones.

There are some drives floating around that have a jumper switch, targeted at Windows XP and older, that will do an offset like what you describe. The jumper isn't enabled by default, and you don't want to use it.


>> So you just need to use a more recent partition tool and repartition the disks correctly.
> Correctly = start at multiples of 8?

Don't think of it that way. You can come up with a partition sector start value divisible by 8 that is right in the middle of physical sector, which is what you don't want.

Recent partitioning tools (i.e in the last 3 years at least), do the right thing if you don't 2nd guess them. First partition starts at 2048. Specify partition sizes in MiB. Now you won't have a problem.

> 
> I thought 108 was the scaled smart score, which is between 0 and 255
> with higher being better.  The raw value of 45 seemed more plausible as
> an actual temperature, though I guess there's no guarantee of that.

Yes.


> 
> sdb and sdc have similar numbers for Temperature_Celsius.
> 
> On the logs and sign of disk failure, it's quite possible I don't know
> what I'm looking for.  Given their size and the fact that the drive
> failure seems clear, I think I'll  spare you all the gory details.

I think you just have the one disk that's giving you trouble.


Chris Murphy