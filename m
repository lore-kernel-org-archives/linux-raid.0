From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: How are reads and writes kept in order in raid5.c?
Date: Fri, 20 Feb 2004 15:25:59 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16437.35927.736212.364976@notabene.cse.unsw.edu.au>
References: <6.0.1.1.2.20040219200054.028ffdb0@mail.athenet.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nathan Lewis on Thursday February 19
To: Nathan Lewis <nathapl@cs.okstate.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday February 19, nathapl@cs.okstate.edu wrote:
> I've gotten through most of handle_stripe, but I'm still confused on one 
> big thing:  The reads and the writes are separated into two separate lists 
> as soon as they come into make_request.  What guarantees they are done in 
> order?  I can't see any mechanism that maintains any specific ordering of 
> the bion.  Just that reads are done first, when possible, then 
> writes.  What am I missing?

You aren't missing anything in the code - no ordering is enforced.

If a filesystem issues a 'write' request and then, before that
completes, issues a read request, the read could get either the before
or after values.  But that is probably true of normal disk-drives
too.  A filesystem simply shouldn't do that.

Does that clear up the question?

NeilBrown
