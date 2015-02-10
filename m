From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: RAID1 might_sleep() warning on 3.19-rc7
Date: Tue, 10 Feb 2015 12:01:16 +0100
Message-ID: <20150210110116.GP24151@twins.programming.kicks-ass.net>
References: <54D3D24E.5060303@cybernetics.com>
 <20150206085133.2c1ab892@notabene.brown>
 <20150206113930.GK23123@twins.programming.kicks-ass.net>
 <20150209121357.29f19d36@notabene.brown>
 <20150209091000.GN5029@twins.programming.kicks-ass.net>
 <20150210135017.7659e49c@notabene.brown>
 <20150210092936.GW21418@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150210092936.GW21418@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Tony Battersby <tonyb@cybernetics.com>, linux-raid@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, axboe@kernel.dk, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-raid.ids

On Tue, Feb 10, 2015 at 10:29:36AM +0100, Peter Zijlstra wrote:
> On Tue, Feb 10, 2015 at 01:50:17PM +1100, NeilBrown wrote:
> > On Mon, 9 Feb 2015 10:10:00 +0100 Peter Zijlstra <peterz@infradead.org> wrote:
> > > > However, when io_schedule() explicitly calls blk_flush_plug(), then
> > > > @from_schedule=false variant is used, and the unplug functions are allowed to
> > > > allocate memory and block and maybe even call mempool_alloc() which might
> > > > call io_schedule().

Note that as it stands recursively calling io_schedule() is already
broken. Things like delayacct_blkio_{start,end}() do not nest properly.
