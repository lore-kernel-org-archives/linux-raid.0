From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: How are reads and writes kept in order in raid5.c?
Date: Fri, 20 Feb 2004 15:49:38 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16437.37346.830231.698727@notabene.cse.unsw.edu.au>
References: <6.0.1.1.2.20040219200054.028ffdb0@mail.athenet.net>
	<16437.35927.736212.364976@notabene.cse.unsw.edu.au>
	<6.0.1.1.2.20040219222725.0290dec0@a.cs.okstate.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nathan Lewis on Thursday February 19
To: Nathan Lewis <nathapl@cs.okstate.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday February 19, nathapl@cs.okstate.edu wrote:
> Yes, I think that clears it up.
> 
> So, a single stripe (or even a single chunk) could certainly have both 
> outstanding read and write requests, but they are guaranteed to not be 
> overlapping.
> 
> Is it also safe to assume that you'd never have outstanding, overlapping 
> write requests either (since order is not maintained within the bio
> list)?

I think the code tries to keep writes in order - at least it used to.
Maybe it doesn't in 2.6
It would also warn if there were two concurrent writes.  This warning
did trigger a couple of times, and it was always due to a bug in the
filesystem.


> 
> I always thought the drive/device driver was responsible for keeping 
> requests in order.  But you're saying that's been delegated to the 
> filesystem, correct?

Device drivers are expected to re-order requests to make best use of
the device, though re-ordering two requests for the same block doesn't
make a lot of sense.

But yes, the filesystem is expected not to do anything silly, and have
two concurrent IO requests for the same block fits in the category of
"silly".

NeilBrown
