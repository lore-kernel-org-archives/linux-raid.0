From: Shaohua Li <shli@fb.com>
Subject: Re: [RFC] raid5: add a log device to fix raid5/6 write hole issue
Date: Thu, 9 Apr 2015 09:03:27 -0700
Message-ID: <20150409160327.GA2087406@devbig257.prn2.facebook.com>
References: <20150330222459.GA575371@devbig257.prn2.facebook.com>
 <20150402085312.5ea3d518@notabene.brown>
 <20150401234055.GA3375744@devbig257.prn2.facebook.com>
 <20150402111941.104d0633@notabene.brown>
 <20150402040749.GA4025688@devbig257.prn2.facebook.com>
 <20150409004238.GA186860@devbig257.prn2.facebook.com>
 <20150409150459.320c668a@notabene.brown>
 <20150409061545.GA864165@devbig257.prn2.facebook.com>
 <CAPcyv4j2RjqY=Ns8rXMUypGovU7_beNfpuL-iW0Fx9522ogPkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4j2RjqY=Ns8rXMUypGovU7_beNfpuL-iW0Fx9522ogPkA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>, Song Liu <songliubraving@fb.com>, Kernel-team@fb.com
List-Id: linux-raid.ids

On Thu, Apr 09, 2015 at 08:37:03AM -0700, Dan Williams wrote:
> On Wed, Apr 8, 2015 at 11:15 PM, Shaohua Li <shli@fb.com> wrote:
> > On Thu, Apr 09, 2015 at 03:04:59PM +1000, NeilBrown wrote:
> >> On Wed, 8 Apr 2015 17:43:11 -0700 Shaohua Li <shli@fb.com> wrote:
> >>
> >> > Hi,
> >> > This is what I'm working on now, and hopefully had the basic code
> >> > running next week. The new design will do cache and fix the write hole
> >> > issue too. Before I post the code out, I'd like to check if the design
> >> > has obvious issues.
> >>
> >> I can't say I'm excited about it....
> >>
> >> You still haven't explained why you would ever want to read data from the
> >> "cache"?  Why not just keep everything in the stripe-cache until it is safe
> >> in the RAID.   I asked before and you said:
> >>
> >> >> I'm not enthusiastic to use stripe cache though, we can't keep all data
> >> >> in stripe cache. What we really need is an index.
> >>
> >> which is hardly an answer.  Why cannot you keep all the data in the stripe
> >> cache?  How much data is there? How much memory can you afford to dedicate?
> >>
> >> You must have some very long sustained bursts of writes which are much faster
> >> than the RAID can accept in order to not be able to keep everything in memory.
> >>
> >>
> >> Your cache layout seems very rigid.  I would much rather a layout that was
> >> very general and flexible.  If you want to always allocate a chunk at a time
> >> then fine, but don't force that on the cache layout.
> >>
> >> The log really should be very simple.  A block describing what comes next,
> >> then lots of data/parity.  Then another block and more data etc etc.
> >> Each metadata  block points to the next one.
> >> If you need an index of the cache, you keep that in memory.  On restart, you
> >> read all of the metadata blocks and  built up the index.
> >>
> >> I think that space in the log should be reclaimed in exactly the order that
> >> it is written, so the active part of the log is contiguous.   Obviously
> >> individual blocks become inactive in arbitrary order as they are written to
> >> the RAID, but each extent of the log becomes free in order.
> >> If you want that to happen out of order, you would need to present a very
> >> good reason.
> >
> > I came to the same idea when I'm thinking about a caching layer, but the
> > memory size is the main blocking issue. If the solution requires a large
> > amount of extra memory, it's not cost effective, so a hard sell to
> > replace hardware raid with software raid. The design completely depends
> > on if we can store all data in memory. I don't have an anwser yet how
> > much memory we should use to make the aggregation efficient. Guess only
> > number can talk. I'll try to collect some data and get back to you.
> >
> 
> Another consideration to keep in mind is persistent memory.  I'm
> working on an in-kernel mechanism to claim and map pmem and a
> raid-write-cache is an obvious first application.  I'll include you on
> the initial submission of that capability.

Exactly, we are planing to use pmem in the future when it's mature and
popular. SSD is still the best option before pmem is popular and widely
used.

Thanks,
Shaohua
