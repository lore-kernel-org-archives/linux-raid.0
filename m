From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Questions answered by Neil Brown
Date: Mon, 24 Feb 2003 16:58:48 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E5A9598.3AED4AE5@SteelEye.com>
References: <200302242015.h1OKFhA04699@oboe.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: ptb@it.uc3m.es
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

"Peter T. Breuer" wrote:
 
> >
> > 3) it is not clear to me that I am doing accounting right on
> >    async writes (or indeed when resyncing and skipping blocks).
> >
> >    The last end_io always did
> >    io_request_done(bh->b_rsector, conf,
> >                           test_bit(R1BH_SyncPhase, &r1_bh->state));
> >    and now this can be done on the first end_io (along with the
> >    bh->b_end_io(bh, uptodate);) in  an async write. Is that right?

> Once you have called bh->b_end_io, you cannot touch that bh every
> again, as it might not even exist.
 
So I think this means that we really need to duplicate the buffer memory
(bh->b_page, bh->b_data) and point the mirror I/Os to the duplicated
buffer, so we can allow the original (master_bh) to be freed before all
the I/Os complete. We then free the duplicate when the last mirror I/O
completes, right?

--
Paul
