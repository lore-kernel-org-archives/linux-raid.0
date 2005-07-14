From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: RAID-5 streaming read performance
Date: Wed, 13 Jul 2005 21:25:31 -0400
Message-ID: <1121304331.5504.162.camel@localhost.localdomain>
References: <874qb14btr.fsf@uwo.ca>
	 <1121220487.5552.34.camel@localhost.localdomain> <87mzorfmdx.fsf@uwo.ca>
	 <1121257494.5504.4.camel@localhost.localdomain> <87eka2g9dp.fsf@uwo.ca>
	 <1121259126.5504.14.camel@localhost.localdomain> <87vf3eeqe2.fsf@uwo.ca>
	 <1121264997.5504.29.camel@localhost.localdomain> <87r7e2egjk.fsf@uwo.ca>
	 <17109.38909.400379.597785@cse.unsw.edu.au>
	 <1121299773.5504.151.camel@localhost.localdomain>
	 <17109.48385.906137.789190@cse.unsw.edu.au>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17109.48385.906137.789190@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Dan Christensen <jdc@uwo.ca>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 2005-07-14 at 11:16 +1000, Neil Brown wrote:
> On Wednesday July 13, mingz@ele.uri.edu wrote:
> > On Thu, 2005-07-14 at 08:38 +1000, Neil Brown wrote:
> > > On Wednesday July 13, jdc@uwo.ca wrote:
> > > > Here's a question for people running software raid-5:  do you get
> > > > significantly better read speed from a raid-5 device than from it's
> > > > component partitions/hard drives, using the simple dd test I did?
> > > 
> > > SCSI-160 bus, using just 4 of the 15000rpm drives:
> > > 
> > > each drive by itself delivers about 67M/s
> > > Three drives in parallel deliver 40M/s each, total of 120M/s
> > > 4 give 30M/s each or a total of 120M/s
> > > 
> > > raid5 over 4 drives delivers 132M/s
> > why here a 132MB/s instead of 120MB/s (3 * 40MB/s) as u mentioned? any
> > factor lead to this increase?
> > 
> > 
> 
> I did another test over 10 times the amount of data, and for 34M/s for
> 4 concurrent individual drives, which multiplies out to 136M/s.  The
> same amount of data of the raid5 gives 137M/s, so I think it was just
> experimental error.
ic. thanks for explanation. yes, agree. 

it seems that u can get a near linear performance with decent SCSI HW
while what we can get from SATA is not good. :P

Ming

> 
> NeilBrown

