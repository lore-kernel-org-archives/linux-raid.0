From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [RFC] raid5: add a log device to fix raid5/6 write hole issue
Date: Wed, 1 Apr 2015 20:36:30 +0200
Message-ID: <20150401183630.GA3103@lazy.lzy>
References: <20150330222459.GA575371@devbig257.prn2.facebook.com>
 <CAPcyv4jqb+OphP-1sy0dqMYG-uNK-CwtNDmOM4YeQU=MXH72Hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4jqb+OphP-1sy0dqMYG-uNK-CwtNDmOM4YeQU=MXH72Hw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Shaohua Li <shli@fb.com>, Neil Brown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>, Song Liu <songliubraving@fb.com>, Kernel-team@fb.com
List-Id: linux-raid.ids

On Tue, Mar 31, 2015 at 08:47:04PM -0700, Dan Williams wrote:
> On Mon, Mar 30, 2015 at 3:25 PM, Shaohua Li <shli@fb.com> wrote:
> > This is my attempt to fix raid5/6 write hole issue, it's not for merge
> > yet, I post it out for comments. Any comments and suggestions are
> > welcome!
> >
> > Thanks,
> > Shaohua
> >
> > We expect a completed raid5/6 stack with reliability and high
> > performance. Currently raid5/6 has 2 issues:
> >
> > 1. read-modify-write for small size IO. To fix this issue, a cache layer
> > above raid5/6 can be used to aggregate write to full stripe write.
> > 2. write hole issue. A write log below raid5/6 can fix the issue.
> >
> > We plan to use a SSD to fix the two issues. Here we just fix the write
> > hole issue.
> >
> > 1. We don't try to fix the issues together. A cache layer will do write
> > acceleration. A log layer will fix write hole. The seperation will
> > simplify things a lot.
> >
> > 2. Current assumption is flashcache/bcache will be used as the cache
> > layer. If they don't work well, we can fix them or add a simple cache
> > layer for raid write aggregation later. We also assume cache layer will
> > absorb write, so log doesn't worry about write latency.
> 
> It seems neither bcache nor dm-cache are tackling the write-buffering
> problem head on... they still seem to be concerned with some amount of
> read caching which I can see as useful for file servers and
> workstations, but not necessarily scale out storage.
> 
> I'll try to set aside time to take a look at the patch this week.

There is one thing I do not really get.

The target is to avoid the "write hole", which happens,
for example, when there is a sudden power failure.

Now, how can be assured, in that case, that the "cache"
device is safe after the power is restored?

Doesn't this solution just shifts the problem from
the array to a different device (SSD, for example)?

Speaking of SSD, these are quite "power failure"
sensitive, it seems...

Thanks,

bye,

pg

> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

piergiorgio
