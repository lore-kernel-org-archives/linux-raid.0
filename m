From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: building a large/fast server
Date: Wed, 29 Jan 2003 15:31:54 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0301291529530.12434-100000@chaos.egr.duke.edu>
References: <Pine.LNX.4.44.0301292117410.24750-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0301292117410.24750-100000@uplift.swm.pp.se>
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Andy Arvai <arvai@scripps.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 29 Jan 2003 at 9:22pm, Mikael Abrahamsson wrote

> On Wed, 29 Jan 2003, Andy Arvai wrote:
> 
> > I'm in the process of designing a large server system. The primary
> > consideration will be i/o performance (block read and write of large
> > files and maximum i/o's per second) and a filesystem size of 2TB. I'm
> > planning to go with 2 3ware 7500-8's, 16 Maxtor 4G160J8's (160GB) and
> > do software raid0 between the 7500-8's (raid5). The filesystem will
> > either be Reiser or Ext3. Any suggestions for fast dual cpu
> > motherboards or comments are welcome. Thanks for any information.
> 
> 1:st up if you want high write speeds:
> 
> Don't use the internal RAID5 of the 3wares, use software RAID5. Hmm, if 
> you really want high write speeds, skip RAID5 altogether and go for 
> mirroring.

That depends on your definition of high, and the application.  Using XFS, 
I can get 55MB/s writing to a single 3ware in hardware RAID5 (bonnie++).  
Stripe across two of those, and you're over 100MB/s (I've tested this, 
seen it, but don't have the data handy), which is more than enough to fill 
a gigabit pipe.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University

