From: Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v2 2/2] md: enable io polling
Date: Sat, 22 Feb 2020 01:34:32 +0900
Message-ID: <20200221163432.GA15420@redsun51.ssa.fujisawa.hgst.com>
References: <20200211191729.4745-1-andrzej.jakowski@linux.intel.com>
 <20200211191729.4745-3-andrzej.jakowski@linux.intel.com>
 <20200211211334.GB3837@redsun51.ssa.fujisawa.hgst.com>
 <e9941d4d-c403-4177-526d-b3086207f31a@linux.intel.com>
 <20200212214207.GA6409@redsun51.ssa.fujisawa.hgst.com>
 <f516e2b2-1988-03ca-f966-5f26771717ff@linux.intel.com>
 <20200214192526.GA10991@redsun51.ssa.fujisawa.hgst.com>
 <db131d8e-b622-ec80-411e-2ca7643997a7@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <db131d8e-b622-ec80-411e-2ca7643997a7@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrzej Jakowski <andrzej.jakowski@linux.intel.com>
Cc: axboe@kernel.dk, song@kernel.org, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

On Fri, Feb 21, 2020 at 08:25:47AM -0700, Andrzej Jakowski wrote:
> Your proposal makes sense to me, yet still it requires significant rework
> in generic_make_request(). I believe that generic_make_request() would 
> have to return/store cookie for each subordinate bio. I'm wondering why 
> cookie is needed for polling at all? From my understanding it looks 
> like cookie info is used to find HW context which to poll on. Hybrid
> polling uses it to find particular IO request and set its 'RQF_MQ_POLL_SLEPT'
> flag. 

The cookie encodes the hctx and tag of a submitted request, but the
cookies is kind of broken if the original bio gets split:

If the bio that created that request was split, the driver only knows to
look for one tag and may end polling too early while chained bios remain
outstanding. That is mostly okay since we'll just poll the same hctx
again until all the chained bio's complete, but the tag we're polling
for isn't associated with the original bio anymore.

In case of hybrid sleep, if a new request is allocated with the same tag,
the poll function will incorrectly sleep again, and set the "SLEPT"
flag on someone else's request. It also looks like that may corrupt
rq_flags since two threads may set it at the same time (this may
actually be a real problem, but I haven't successfully made it happen
yet).

> Now, if we assume that cookie is not passed to polling function, poll_fn
> would need to find HW context to poll on in different way. Perhaps reference
> to it could be stored in request_queue itself?

A device may provide many polled hardware contexts. Different threads
may want to poll different contexts at the same time, so the poll_fn()
needs to know which one. How would you encode that into the
request_queue?

> Polling in stackable block
> drivers would be much simpler -- they would call polling for underlying MQ
> device, which in turn would poll on correct HW context.
> 
> Does this approach sound reasonable? 
