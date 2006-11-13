From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Re[2]: RAID1 submirror failure causes reboot?
Date: Mon, 13 Nov 2006 21:11:05 +0100
Message-ID: <20061113201105.GD15031@kernel.dk>
References: <1007879814.20061110111729@2ka.mipt.ru> <17748.15156.405065.904318@cse.unsw.edu.au> <208777171.20061110155306@2ka.mipt.ru> <17752.7205.373640.220014@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17752.7205.373640.220014@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jim Klimov <klimov@2ka.mipt.ru>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Nov 13 2006, Neil Brown wrote:
> On Friday November 10, klimov@2ka.mipt.ru wrote:
> > Hello Neil,
> > 
> > >> [87398.531579] blk: request botched
> > NB>                  ^^^^^^^^^^^^^^^^^^^^
> > 
> > NB> That looks bad.  Possible some bug in the IDE controller or elsewhere
> > NB> in the block layer.  Jens: What might cause that?
> > 
> > NB> --snip--
> > 
> > NB> That doesn't look like raid was involved.  If it was you would expect
> > NB> to see raid1_end_write_request or raid1_end_read_request in that
> > NB> trace.
> > So that might be the hard or soft part of IDE layer failing the
> > system, or a PCI problem for example?
> 
> What I think is happening here (and Jens: if you could tell me how
> impossible this is, that would be good) is this:
> 
> Some error handling somewhere in the low-level ide driver is getting
> confused and somehow one the sector counts in the 'struct request' is
> getting set wrongly.  blk_recalc_rq_sectors notices this and says
> "blk: request botched".  It tries to auto-correct by increasing
> rq->nr_sectors to be consistent with other counts.
> I'm *guessing* this is the wrong thing to do, and that it has a
> side-effect but bi_end_io is getting called on the Bi twice.
> The second time the bio has been freed and reused and the wrong
> b_end_io is called and it does the wrong thing.

It doesn't sound at all unreasonable. It's most likely either a bug in
the ide driver, or a "bad" bio being passed to the block layer (and
later on to the request and driver). By "bad" I mean one that isn't
entirely consistent, which could be a bug in eg md. The "request
botched" error is usually a sign of something being severly screwed up.
As you mention further down, get slab and page debugging enabled to
potentially catch this earlier. It could be a sign of a freed bio or
request with corrupt contents.

> This sounds a bit far-fetched, but it is the only explanation I can
> come up with for the observed back trace which is:
> 
> [87403.706012]  [<c0103871>] error_code+0x39/0x40
> [87403.710794]  [<c0180e0a>] mpage_end_io_read+0x5e/0x72
> [87403.716154]  [<c0164af9>] bio_endio+0x56/0x7b
> [87403.720798]  [<c0256778>] __end_that_request_first+0x1e0/0x301
> [87403.726985]  [<c02568a4>] end_that_request_first+0xb/0xd
> [87403.732699]  [<c02bd73c>] __ide_end_request+0x54/0xe1
> [87403.738214]  [<c02bd807>] ide_end_request+0x3e/0x5c
> [87403.743382]  [<c02c35df>] task_error+0x5b/0x97
> [87403.748113]  [<c02c36fa>] task_in_intr+0x6e/0xa2
> [87403.753120]  [<c02bf19e>] ide_intr+0xaf/0x12c
> [87403.757815]  [<c013e5a7>] handle_IRQ_event+0x23/0x57
> [87403.763135]  [<c013e66f>] __do_IRQ+0x94/0xfd
> [87403.767802]  [<c0105192>] do_IRQ+0x32/0x68
> [87403.772278]  [<c010372e>] common_interrupt+0x1a/0x20
> 
> i.e. bio_endio goes straight to mpage_end_io despite the face that the
> filesystem is mounted over md/raid1.

What is the workload? Is io to the real device mixed with io that came
through md as well?

> Is the kernel compiled with CONFIG_DEBUG_SLAB=y and
> CONFIG_DEBUG_PAGEALLOC=y ??
> They might help trigger the error earlier and so make the problem more
> obvious.

Agree, that would be a good plan to enable. Other questions: are you
seeing timeouts at any point? The ide timeout code has some request/bio
"resetting" code which might be worrisome.
> 
> NeilBrown

-- 
Jens Axboe

