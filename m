From: Nathan Lewis <nathapl@cs.okstate.edu>
Subject: Re: How are reads and writes kept in order in raid5.c?
Date: Thu, 19 Feb 2004 22:44:35 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <6.0.1.1.2.20040219222725.0290dec0@a.cs.okstate.edu>
References: <6.0.1.1.2.20040219200054.028ffdb0@mail.athenet.net>
 <16437.35927.736212.364976@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16437.35927.736212.364976@notabene.cse.unsw.edu.au>
References: <6.0.1.1.2.20040219200054.028ffdb0@mail.athenet.net>
 <16437.35927.736212.364976@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yes, I think that clears it up.

So, a single stripe (or even a single chunk) could certainly have both 
outstanding read and write requests, but they are guaranteed to not be 
overlapping.

Is it also safe to assume that you'd never have outstanding, overlapping 
write requests either (since order is not maintained within the bio list)?

I always thought the drive/device driver was responsible for keeping 
requests in order.  But you're saying that's been delegated to the 
filesystem, correct?

That certainly makes life easier.  No wonder I've been having a hard time 
wrapping my brain around this code.


At 10:25 PM 2/19/2004, Neil Brown wrote:
>On Thursday February 19, nathapl@cs.okstate.edu wrote:
> > I've gotten through most of handle_stripe, but I'm still confused on one
> > big thing:  The reads and the writes are separated into two separate lists
> > as soon as they come into make_request.  What guarantees they are done in
> > order?  I can't see any mechanism that maintains any specific ordering of
> > the bion.  Just that reads are done first, when possible, then
> > writes.  What am I missing?
>
>You aren't missing anything in the code - no ordering is enforced.
>
>If a filesystem issues a 'write' request and then, before that
>completes, issues a read request, the read could get either the before
>or after values.  But that is probably true of normal disk-drives
>too.  A filesystem simply shouldn't do that.
>
>Does that clear up the question?
>
>NeilBrown

