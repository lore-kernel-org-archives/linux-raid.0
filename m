From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID-5 streaming read performance
Date: Thu, 14 Jul 2005 08:42:47 +1000
Message-ID: <17109.39143.863798.150755@cse.unsw.edu.au>
References: <874qb14btr.fsf@uwo.ca>
	<1121220487.5552.34.camel@localhost.localdomain>
	<87mzorfmdx.fsf@uwo.ca>
	<1121257494.5504.4.camel@localhost.localdomain>
	<87eka2g9dp.fsf@uwo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Christensen on Wednesday July 13
Sender: linux-raid-owner@vger.kernel.org
To: Dan Christensen <jdc@uwo.ca>
Cc: mingz@ele.uri.edu, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday July 13, jdc@uwo.ca wrote:
> Question for the list:  if I'm doing a long sequential write, naively
> each parity block will get recalculated and rewritten several times,
> once for each non-parity block in the stripe.  Does the write-caching
> that the kernel does mean that each parity block will only get written
> once?

Raid5 does the best it can.  It delays write requests as long as
possible, and then when it must do the write, it writes every other
block in the stripe that it has been asked to write, so only one
parity update is needed for all those blocks.

My tests suggest that for long sequential writes (Without syncs) this
achieves full-stripe writes most of the time.

NeilBrown
