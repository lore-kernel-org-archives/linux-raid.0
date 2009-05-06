From: Jody McIntyre <scjody@sun.com>
Subject: Re: [PATCH] md: Track raid5/6 statistics
Date: Wed, 06 May 2009 16:05:03 -0400
Message-ID: <20090506200502.GK25233@clouds>
References: <20090312205754.GH8732@clouds>
 <e9c3a7c20903141007h5fea439co70e4ea9ea4a10ec1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-disposition: inline
In-reply-to: <e9c3a7c20903141007h5fea439co70e4ea9ea4a10ec1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Hi Dan,

On Sat, Mar 14, 2009 at 10:07:49AM -0700, Dan Williams wrote:

> I am curious, can you say a bit more about the performance problems
> you solved with this data?  Is there a corresponding userspace tool
> that interprets these numbers?  

With the original patch there was no need for a tool - statistics were
in /proc/mdstat and were fairly easy to understand.  The patch I
recently submitted would need a small tool, but one has not been
written.

I've looked into how we've used this data in the past, and while our
support team often requests /proc/mdstat from customers experiencing
RAID performance problems, they rarely receive it.  The original
statistics patch (which has been shipping with Lustre for about 3 years)
seems to have been useful for 2 things:

1. Analyzing RAID IO patterns when developing our RAID performance
improvements (which seem to be completely obsolete now thanks to the
more extensive improvements you and Neil have done, so I won't be
submitting them.)  Of course, this is now a good reason to merge the
patch - if anyone (including us) wants to do similar studies, they can 
develop their own internal patch.

2. The out_of_stripes tracking is useful - we've found several cases
where stripe_cache_size was set too low and performance suffered as a
result.  Monitoring stripe_cache_active during IO is difficult so it's
far better to have a counter like this.

So if we can solve the second problem somehow - maybe just introduce a
read-only counter under /sys/block/md*/md/out_of_stripes - the need for
the rest of the patch goes away IMO.

> [...]

> So, my original suggestion/question should have been why not extend
> blktrace to understand these incremental MD events?

Regarding blktrace specifically, it's really geared towards developers.
I played with it a bit and it looks like it might be useful to me at
some point, but I wouldn't expect a customer to use it.  It would need a
much better frontend tool and a more supported kernel interface than
debugfs.  But as I said, our customers aren't using our existing
/proc/mdstat information very much anyway so I don't think this problem
needs to be solved.

Cheers,
Jody

> Regards,
> Dan
