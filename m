From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID-5 streaming read performance
Date: Thu, 14 Jul 2005 08:38:53 +1000
Message-ID: <17109.38909.400379.597785@cse.unsw.edu.au>
References: <874qb14btr.fsf@uwo.ca>
	<1121220487.5552.34.camel@localhost.localdomain>
	<87mzorfmdx.fsf@uwo.ca>
	<1121257494.5504.4.camel@localhost.localdomain>
	<87eka2g9dp.fsf@uwo.ca>
	<1121259126.5504.14.camel@localhost.localdomain>
	<87vf3eeqe2.fsf@uwo.ca>
	<1121264997.5504.29.camel@localhost.localdomain>
	<87r7e2egjk.fsf@uwo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Christensen on Wednesday July 13
Sender: linux-raid-owner@vger.kernel.org
To: Dan Christensen <jdc@uwo.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday July 13, jdc@uwo.ca wrote:
> Here's a question for people running software raid-5:  do you get
> significantly better read speed from a raid-5 device than from it's
> component partitions/hard drives, using the simple dd test I did?

SCSI-160 bus, using just 4 of the 15000rpm drives:

each drive by itself delivers about 67M/s
Three drives in parallel deliver 40M/s each, total of 120M/s
4 give 30M/s each or a total of 120M/s

raid5 over 4 drives delivers 132M/s

(We've just ordered a SCSI-320 card to make better use of the drives).

So with top-quality (and price) hardware, it seems to do the right
thing.

NeilBrown
