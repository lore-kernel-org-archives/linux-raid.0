From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: Questions answered by Neil Brown
Date: Tue, 25 Feb 2003 10:11:52 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302250911.h1P9Bqw17671@oboe.it.uc3m.es>
References: <15962.56991.813214.12276@notabene.cse.unsw.edu.au>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15962.56991.813214.12276@notabene.cse.unsw.edu.au> from Neil Brown
 at "Feb 25, 2003 02:10:23 pm"
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Paul Clements <Paul.Clements@SteelEye.com>, ptb@it.uc3m.es, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"A month of sundays ago Neil Brown wrote:"
> On Monday February 24, Paul.Clements@SteelEye.com wrote:
> >  
> > So I think this means that we really need to duplicate the buffer memory
> > (bh->b_page, bh->b_data) and point the mirror I/Os to the duplicated
> > buffer, so we can allow the original (master_bh) to be freed before all
> > the I/Os complete. We then free the duplicate when the last mirror I/O
> > completes, right?
> 
> Yes, that is right.

It's early in the morning (for me!), but I believe that page data at
least can be encouraged to stay around by hiking a reference counter
or equivalent.

It really depends how that b_end_io() got hold of its buffer and what
it does with it on completion. The end_buffer_io() fn in buffer.c
will lock the page and walk through the bh chain hanging off
bh->b_this_page (->b_this_page ...) to see if those other bh's have
completed before marking the page up to date and unlocking it.

So it might be enough to chain all the mirror bh's through
bh->b_this_page.

I believe that currently this field is just set to "1" in
raid1_make_request().

Peter
