From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: RAID1 might_sleep() warning on 3.19-rc7
Date: Fri, 13 Feb 2015 11:27:46 +0100
Message-ID: <20150213102746.GO2896@worktop.programming.kicks-ass.net>
References: <54D3D24E.5060303@cybernetics.com>
 <20150206085133.2c1ab892@notabene.brown>
 <20150206113930.GK23123@twins.programming.kicks-ass.net>
 <20150209121357.29f19d36@notabene.brown>
 <20150209091000.GN5029@twins.programming.kicks-ass.net>
 <20150210135017.7659e49c@notabene.brown>
 <20150210092936.GW21418@twins.programming.kicks-ass.net>
 <20150213162600.059fffb2@notabene.brown>
 <20150213083250.GN2896@worktop.programming.kicks-ass.net>
 <20150213194953.0368355d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150213194953.0368355d@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Tony Battersby <tonyb@cybernetics.com>, linux-raid@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, axboe@kernel.dk, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-raid.ids

On Fri, Feb 13, 2015 at 07:49:53PM +1100, NeilBrown wrote:
> > Like said, that will still recursive call delayacct_blkio_*() and would
> > increase nr_iowait for a second time; while arguably its still the same
> > one io-wait instance.
> 
> No it doesn't.  There is no "blk_flush_plug" call between the
> delayacct_blkio_*() calls.

Duh, clearly I needed to still wake up :/

> I've moved blk_flush_plug to the beginning of the function.

> I wondered if it really make sense to call blk_flush_plug with nr_iowait
> elevated and delayacct_blkio active.  blk_flush_plug() could call schedule()
> for non-"io" reasons and maybe that could upset stuff???

Yeah, good question that. Lemme ponder that a bit.

> I don't really know.  I'm happy with your version.  I don't suppose anyone
> else is paying attention and could give a third opinion....

:-)
