From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Questions answered by Neil Brown
Date: Wed, 26 Feb 2003 02:44:57 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E5C7079.5C85F1F8@SteelEye.com>
References: <200302250911.h1P9Bqw17671@oboe.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: ptb@it.uc3m.es
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Peter T. Breuer" wrote:
> 
> "A month of sundays ago Neil Brown wrote:"
> > On Monday February 24, Paul.Clements@SteelEye.com wrote:

> So it might be enough to chain all the mirror bh's through
> bh->b_this_page.

That's an interesting idea. I looked through the code and I have some
questions:

What if the user is waiting on a page and not a buffer (not sure if that
can/will happen). In that case, we'd be artificially causing him to wait
when it wasn't necessary. Suppose all the I/O for a page really was
complete, but we kept the user waiting until all the mirror I/Os
(including ones to backup devices) for that page had completed. 

Another thing I'm not sure about is whether it's safe for raid1 to
modify the b_this_page field (for a buffer that was passed in from
above)...we'd at least have to insert our values into the existing list.
Is it safe to modify the list without any locks held?

 
> I believe that currently this field is just set to "1" in
> raid1_make_request().

Yeah, I sure wish I knew who did that and why. I wonder if someone had a
clever plan to use that field at some point, but never got around to it.
Setting that field to something besides a real address sure does seem
odd...and I can't see that it's ever used anywhere.

--
Paul
