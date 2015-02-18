From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: RAID1 might_sleep() warning on 3.19-rc7
Date: Wed, 18 Feb 2015 14:47:27 +0100
Message-ID: <20150218134727.GX5029@twins.programming.kicks-ass.net>
References: <20150209121357.29f19d36@notabene.brown>
 <20150209091000.GN5029@twins.programming.kicks-ass.net>
 <20150210135017.7659e49c@notabene.brown>
 <20150210092936.GW21418@twins.programming.kicks-ass.net>
 <20150213162600.059fffb2@notabene.brown>
 <20150213083250.GN2896@worktop.programming.kicks-ass.net>
 <20150213194953.0368355d@notabene.brown>
 <20150213102746.GO2896@worktop.programming.kicks-ass.net>
 <20150213144803.GA11574@worktop.ger.corp.intel.com>
 <20150218120936.3c7beed2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150218120936.3c7beed2@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Tony Battersby <tonyb@cybernetics.com>, linux-raid@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, axboe@kernel.dk, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-raid.ids

On Wed, Feb 18, 2015 at 12:09:36PM +1100, NeilBrown wrote:
> On Fri, 13 Feb 2015 15:48:03 +0100 Peter Zijlstra <peterz@infradead.org>
> wrote:
> 
> > On Fri, Feb 13, 2015 at 11:27:46AM +0100, Peter Zijlstra wrote:
> > 
> > > > I've moved blk_flush_plug to the beginning of the function.
> > > 
> > > > I wondered if it really make sense to call blk_flush_plug with nr_iowait
> > > > elevated and delayacct_blkio active.  blk_flush_plug() could call schedule()
> > > > for non-"io" reasons and maybe that could upset stuff???
> > > 
> > > Yeah, good question that. Lemme ponder that a bit.
> > 
> > Yes, I thikn your version makes most sense as, you say, even regular
> > schedule() call nested in my version would go towards blk delayacct --
> > and I doubt that was the intent; even though the current kernel works
> > that way.
> > 
> > I'll move the now rudimentary io_schedule() into sched.h as an inline.
> 
> Thanks.
> 
> Are you OK with this going to -stable for 3.19?

OK, lets do that.
