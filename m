From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: RAID1 might_sleep() warning on 3.19-rc7
Date: Fri, 13 Feb 2015 15:48:03 +0100
Message-ID: <20150213144803.GA11574@worktop.ger.corp.intel.com>
References: <20150206085133.2c1ab892@notabene.brown>
 <20150206113930.GK23123@twins.programming.kicks-ass.net>
 <20150209121357.29f19d36@notabene.brown>
 <20150209091000.GN5029@twins.programming.kicks-ass.net>
 <20150210135017.7659e49c@notabene.brown>
 <20150210092936.GW21418@twins.programming.kicks-ass.net>
 <20150213162600.059fffb2@notabene.brown>
 <20150213083250.GN2896@worktop.programming.kicks-ass.net>
 <20150213194953.0368355d@notabene.brown>
 <20150213102746.GO2896@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150213102746.GO2896@worktop.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Tony Battersby <tonyb@cybernetics.com>, linux-raid@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, axboe@kernel.dk, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-raid.ids

On Fri, Feb 13, 2015 at 11:27:46AM +0100, Peter Zijlstra wrote:

> > I've moved blk_flush_plug to the beginning of the function.
> 
> > I wondered if it really make sense to call blk_flush_plug with nr_iowait
> > elevated and delayacct_blkio active.  blk_flush_plug() could call schedule()
> > for non-"io" reasons and maybe that could upset stuff???
> 
> Yeah, good question that. Lemme ponder that a bit.

Yes, I thikn your version makes most sense as, you say, even regular
schedule() call nested in my version would go towards blk delayacct --
and I doubt that was the intent; even though the current kernel works
that way.

I'll move the now rudimentary io_schedule() into sched.h as an inline.
