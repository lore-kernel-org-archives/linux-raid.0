From: Shaohua Li <shli@fb.com>
Subject: Re: [RFC] raid5: add a log device to fix raid5/6 write hole issue
Date: Wed, 1 Apr 2015 10:14:14 -0700
Message-ID: <20150401171413.GA2616460@devbig257.prn2.facebook.com>
References: <20150330222459.GA575371@devbig257.prn2.facebook.com>
 <CAPcyv4jqb+OphP-1sy0dqMYG-uNK-CwtNDmOM4YeQU=MXH72Hw@mail.gmail.com>
 <20150401055309.GA726662@devbig257.prn2.facebook.com>
 <20150401170256.5efebaae@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150401170256.5efebaae@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid <linux-raid@vger.kernel.org>, Song Liu <songliubraving@fb.com>, Kernel-team@fb.com
List-Id: linux-raid.ids

On Wed, Apr 01, 2015 at 05:02:56PM +1100, NeilBrown wrote:
> On Tue, 31 Mar 2015 22:53:21 -0700 Shaohua Li <shli@fb.com> wrote:
> 
> > On Tue, Mar 31, 2015 at 08:47:04PM -0700, Dan Williams wrote:
> > > On Mon, Mar 30, 2015 at 3:25 PM, Shaohua Li <shli@fb.com> wrote:
> > > > This is my attempt to fix raid5/6 write hole issue, it's not for merge
> > > > yet, I post it out for comments. Any comments and suggestions are
> > > > welcome!
> > > >
> > > > Thanks,
> > > > Shaohua
> > > >
> > > > We expect a completed raid5/6 stack with reliability and high
> > > > performance. Currently raid5/6 has 2 issues:
> > > >
> > > > 1. read-modify-write for small size IO. To fix this issue, a cache layer
> > > > above raid5/6 can be used to aggregate write to full stripe write.
> > > > 2. write hole issue. A write log below raid5/6 can fix the issue.
> > > >
> > > > We plan to use a SSD to fix the two issues. Here we just fix the write
> > > > hole issue.
> > > >
> > > > 1. We don't try to fix the issues together. A cache layer will do write
> > > > acceleration. A log layer will fix write hole. The seperation will
> > > > simplify things a lot.
> > > >
> > > > 2. Current assumption is flashcache/bcache will be used as the cache
> > > > layer. If they don't work well, we can fix them or add a simple cache
> > > > layer for raid write aggregation later. We also assume cache layer will
> > > > absorb write, so log doesn't worry about write latency.
> > > 
> > > It seems neither bcache nor dm-cache are tackling the write-buffering
> > > problem head on... they still seem to be concerned with some amount of
> > > read caching which I can see as useful for file servers and
> > > workstations, but not necessarily scale out storage.
> > > 
> > > I'll try to set aside time to take a look at the patch this week.
> > 
> > Thanks! The cache layer is definitely what I'll focus on next. bcache
> > supports writeback, I guess we can add an option to skip read data from
> > backing disks for read caching if it's possible. Another option is
> > writting a simple caching just for raid 5/6 write aggregation. We can
> > append all data to a log, and maintain an index in memory. At raid
> > shutdown, we can flush all data to raid disks, the index doesn't need
> > presistent in disk, which makes the caching fairly simple.
> 
> Surely if the index doesn't need to persist in disk, then the data doesn't
> either, as without the index you cannot find the data...

I mean not just pure data. We can store tuple (disk offset, length,
data) to disk. index will be used to speed up search. If there is a
crash, we can rebuild the index using the tuple.

Thanks,
Shaohua
