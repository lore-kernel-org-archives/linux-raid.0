From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: Questions answered by Neil Brown
Date: Wed, 26 Feb 2003 09:09:28 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302260809.h1Q89Sa20683@oboe.it.uc3m.es>
References: <3E5C7079.5C85F1F8@SteelEye.com>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E5C7079.5C85F1F8@SteelEye.com> from Paul Clements at "Feb 26,
 2003 02:44:57 am"
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: ptb@it.uc3m.es, Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"A month of sundays ago Paul Clements wrote:"
> "Peter T. Breuer" wrote:
> > "A month of sundays ago Neil Brown wrote:"
> > > On Monday February 24, Paul.Clements@SteelEye.com wrote:
> 
> > So it might be enough to chain all the mirror bh's through
> > bh->b_this_page.
> 

> What if the user is waiting on a page and not a buffer (not sure if that
> can/will happen). In that case, we'd be artificially causing him to wait

I'm not the person to answer that kind of question. If I understood the
VMS I wouldn't be asking questions myself!

> when it wasn't necessary. Suppose all the I/O for a page really was
> complete, but we kept the user waiting until all the mirror I/Os
> (including ones to backup devices) for that page had completed. 

You're one up in the abstraction hierarchy from me .. I just am seeing
the concrete b_end_io codes and what they might do. I can offer no
sensible comment.

> Another thing I'm not sure about is whether it's safe for raid1 to
> modify the b_this_page field (for a buffer that was passed in from
> above)...we'd at least have to insert our values into the existing list.
> Is it safe to modify the list without any locks held?

I'm sure it is. We modify it anyway, to write the 1s. And we do it
before submitting any of the bh's involved.

> > I believe that currently this field is just set to "1" in
> > raid1_make_request().
> 
> Yeah, I sure wish I knew who did that and why. I wonder if someone had a

A check of the buffer.c code shows b_this_page is always tested against
real bh addresses in any conditionals in which it appears.  It appears
to potentially be a circular list and they're testing for having got
back to the beginning (or having a trivial circle). What I want to know
is how "1" ever worked. It can't! Not in the buffer.c code, enayway.
That's end_buffer_io_async and discard_bh_page and
__block_write_full_page and __block_prepare_write and
__block_commit_write and  block_read_full_page and ... well, lots.
All of these go chasing through that field trusting it to be the
address of a bh.

> clever plan to use that field at some point, but never got around to it.
> Setting that field to something besides a real address sure does seem
> odd...and I can't see that it's ever used anywhere.

What is also puzzling me is that despite the horrible potential for
what might happen from doing the original users end_io early, I
can't see any consequences in actual tests!

I am writing stuff to a file on a raid1 mirror mount, then dismantling
the mount, the device, and rmmoding the driver. Then I put it all back
again. On remount the data in the file is all perfect. Yet it was built
with plenty of async writes! Surely the buffers in some of those writes
should have been pointing nowhere and been full of rubbish?

   ...
   raid1: async end i/o on sectors 494-495
   raid1: async end i/o on sectors 496-497
   raid1: async end i/o on sectors 498-499
   raid1: async end i/o on sectors 500-501
   raid1: async end i/o on sectors 502-503
   raid1: async end i/o on sectors 504-505
   raid1: async end i/o on sectors 506-507
   raid1: async end i/o on sectors 508-509
   raid1: async end i/o on sectors 510-511
   raid1: async end i/o on sectors 512-513
   ...

Got an idea for a test that might show up corruption accruing from the
suspect mechanism?

Peter
