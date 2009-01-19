From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Roadmap for md/raid ???
Date: Mon, 19 Jan 2009 19:19:19 +0100
Message-ID: <20090119181919.GB4290@lazy.lzy>
References: <18763.7881.300921.177207@notabene.brown> <20090111181413.GA24988@lazy.lzy> <18803.55804.905420.503480@nbeee.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18803.55804.905420.503480@nbeee.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> > RAID-5/6 with heterogeneous devices.
[...]
> I've thought about this occasionally but don't think much of the idea.
> It seems nice until you think about what happens when devices fail
> and you need to integrate hot spares.
> Clearly any spare will need to be as big as the largest device.
> When that get integrated in place of a small device, you will be
> wasting space on it, and then someone will want to be able to
> grow the array to use that extra space, which would be rather
> messy.
> 
> I think it is best to assume that all devices are the same size.
> Trying to support anything else in a useful way would just add
> complexity with little value.

I see your point and I also agree that complexity
might be too much.

Nevertheless I disagree about the "wasting space",
since I can see a scenario where there is even
more wasting.

Let's assume we have a RAID-5 with 7 disks.
Each time an HD fails, we will replace it with a
larger one, since this will be cheaper.
Once we replaced 3 HDs, with could use the unused
space in RAID-5 again.
Unfortunately, with the current features, we will
have to wait to fail all the 7 disks.
So, with 6 HDs replaced with larger ones, we will
have a lot of wasted space.
Of course, unless we did a clever partitioning at
very the beginning.

But again, I do agree the complexity might not
pay off the advantages, maybe better the "clever
partitioning".

Thanks,

bye,

-- 

piergiorgio
