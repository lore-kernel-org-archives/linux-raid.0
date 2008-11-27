From: Jody McIntyre <scjody@sun.com>
Subject: Re: [RFC patch 1/1] Track raid5/6 statistics.
Date: Thu, 27 Nov 2008 08:52:48 -0500
Message-ID: <20081127135248.GD29919@clouds>
References: <20081126190452.775333692@sun.com>
 <20081126190854.813151413@sun.com>
 <20081127114748.GE14570@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20081127114748.GE14570@boogie.lpds.sztaki.hu>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Hi Gabor,

On Thu, Nov 27, 2008 at 12:47:48PM +0100, Gabor Gombas wrote:

> Are these values useful for mere mortals trying to create a RAID array
> best suited for a specific workload, or are these only useful for people
> hacking on the RAID code?

I believe the average administrator could understand what most (if not
all) of the statistics mean, but doing something about it might require
a developer or at least someone with a bit of RAID experience.  In our
use, we get customers to report the values to us then make tuning
suggestions (more likely) or provide a patch.

> If the former, then I'd suggest to use sysfs (something like
> /sys/block/<dev>/md/statistics, similar to
> /sys/class/net/<dev>/statistics). If the latter, then debugfs would be
> better.

I was thinking about your first suggestion but note that there is also
/proc/diskstats as well as /sys/block/<dev>/stat.  The advantage of
having everything in one file is that you only have to open one file
when gathering statistics on many arrays, and /proc/mdstat already
exists as a precedent.  I could add individual array statistics files as
well if useful.

I'm also going to investigate tracepoints as suggested by Dan, so all
this is subject to change :)

Cheers,
Jody

> 
> Gabor
> 
> -- 
>      ---------------------------------------------------------
>      MTA SZTAKI Computer and Automation Research Institute
>                 Hungarian Academy of Sciences
>      ---------------------------------------------------------
