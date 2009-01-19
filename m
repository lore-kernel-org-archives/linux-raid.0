From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Roadmap for md/raid ???
Date: Mon, 19 Jan 2009 19:41:46 +0100
Message-ID: <20090119184146.GA4419@lazy.lzy>
References: <18763.7881.300921.177207@notabene.brown> <20090111181413.GA24988@lazy.lzy> <18803.55804.905420.503480@nbeee.brown> <20090119181919.GB4290@lazy.lzy> <4974C5DA.3090806@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4974C5DA.3090806@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> Or alternatively you use LVM from the start. Then you only need to
> "cleverly partition" the new drives, use the first partition in the old
> RAID, use the second partition for a new smaller raid, join the new raid
> to the VG of the old raid and voilla - no wasted space.

I think that's exactly what I'm doing right now
with my test array.

Basically I've 7 disks, all, but two, different
in size.
I created partitions, of equal size between disks,
than I configured 4 RAID-6 devices (with 7, 6, 5, 4
partitions respectively) and put everything together
with LVM.

This works fine, it is possible to add HDs, or change
the old ones with bigger new ones.

One issue is that, with time, the larger HDs will
have many partitions, this led to use GPT table
(max 128 partitions) instead of DOS.
Metadata needs to be 1.x, of course.

The second point is the "annoyance" of creating
those partitions on the new HDs and adding them
to the proper md devices.

Of course, nothing particularly difficult, nevertheless
it would be nice to have everything integrated into
the md driver and transparent to the user.

Just an idea of improvement, nothing more.

Side note: if anybody has suggestions on how to script
the complete procedure of adding/replacing an HD in
such configuration, I'll appreciate it a lot!

Thanks,

bye,

-- 

piergiorgio
