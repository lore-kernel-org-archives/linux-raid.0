From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Questions answered by Neil Brown
Date: Thu, 27 Feb 2003 08:41:44 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15965.13464.469979.763203@notabene.cse.unsw.edu.au>
References: <200302250911.h1P9Bqw17671@oboe.it.uc3m.es>
	<3E5C7079.5C85F1F8@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Wednesday February 26
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: ptb@it.uc3m.es, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday February 26, Paul.Clements@SteelEye.com wrote:
> "Peter T. Breuer" wrote:
> > 
> > "A month of sundays ago Neil Brown wrote:"
> > > On Monday February 24, Paul.Clements@SteelEye.com wrote:
> 
> > So it might be enough to chain all the mirror bh's through
> > bh->b_this_page.

This sort of thing is very much a layering violation and should not be
done.
It is similar in some ways to the design decisions in the 2.2 raid
patches which meant they were un-safe for swap or ext3 (at least while
rebuilding).

The current interface does *not* guarantee that the data will be
around after b_end_io is called, and does not provide any way to ask
for the data to be left around.
You might be able to fake it in some cases, but not all.
A particular example that springs to mind is descriptor block used
when writing out an ext3 journal entry.  Once the block is written,
the descriptor block is of no interest to the kernel and will very
likely be re-used.  You cannot stop this.
You *have* to copy the data.

>  
> > I believe that currently this field is just set to "1" in
> > raid1_make_request().
> 
> Yeah, I sure wish I knew who did that and why. I wonder if someone had a
> clever plan to use that field at some point, but never got around to it.
> Setting that field to something besides a real address sure does seem
> odd...and I can't see that it's ever used anywhere.

The bh which gets b_this_page set to 1 is a bh that is internal to
raid1.  It is allocated by raid1 and never used by any filesystem or
buffer cache or anything.  Thus raid1 can do whatever it pleases with
this field.  No-one else should ever look at it.
I suspect it was set to one so that, if some coding error meant that
the buffer cache saw this buffer, then it would oops pretty quickly.

NeilBrown

> 
> --
> Paul
