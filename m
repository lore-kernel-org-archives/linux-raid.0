From: hpa@zytor.com (H. Peter Anvin)
Subject: Re: Digging into raid5.c and raid6main.c...
Date: Tue, 24 Feb 2004 22:25:09 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <c1gj05$17g$1@terminus.zytor.com>
References: <6.0.1.1.2.20040217232659.0211de48@mail.athenet.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <6.0.1.1.2.20040217232659.0211de48@mail.athenet.net>
By author:    Nathan Lewis <nathapl@cs.okstate.edu>
In newsgroup: linux.dev.raid
>
> I've decided to base my rs-raid work on 2.6, and thus raid5.c and 
> raid6main.c.  I'm pretty sure I can utilize all the stripe buffer code 
> pretty much verbatim, and most of the rework will need to be done to 
> handle_stripe().  I've dug through most of it, updating things to 
> correspond to m parity disks instead of 1 or 2.  However, I've encountered 
> something strange.  From what I can tell, after a call to compute_block_1 
> or compute_block_2, I assumed that all the data in the stripe (including 
> parity) was valid.  However, around line 1270 in raid6main.c, 
> compute_block_1 or 2 may be called, then immediately after the PRINTK, it 
> calls compute_parity too.  Isn't this redundant somehow?  The logic that 
> sets must_compute is also really complicated - can anyone explain this 
> section to me?
> 

must_compute counts the number of drives for which (a) we don't have
data already in memory and (b) we can't perform I/O, and (c) we need
data from.

You're absolutely correct in that invoking compute_parity() there in
the case ( must_compute > 0 ) is redundant.  In fact, so is using
(failed) rather than (must_compute) in the switch statement
(since must_compute <= failed.)  None of these are significant for
performance, however, and it made the already complex bookkeeping
slightly easier.  Once I'm more convinced the code is actually stable
I will try to clean up stuff like this.

	-hpa






