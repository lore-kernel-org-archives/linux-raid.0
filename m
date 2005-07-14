From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID-5 streaming read performance
Date: Thu, 14 Jul 2005 11:16:49 +1000
Message-ID: <17109.48385.906137.789190@cse.unsw.edu.au>
References: <874qb14btr.fsf@uwo.ca>
	<1121220487.5552.34.camel@localhost.localdomain>
	<87mzorfmdx.fsf@uwo.ca>
	<1121257494.5504.4.camel@localhost.localdomain>
	<87eka2g9dp.fsf@uwo.ca>
	<1121259126.5504.14.camel@localhost.localdomain>
	<87vf3eeqe2.fsf@uwo.ca>
	<1121264997.5504.29.camel@localhost.localdomain>
	<87r7e2egjk.fsf@uwo.ca>
	<17109.38909.400379.597785@cse.unsw.edu.au>
	<1121299773.5504.151.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ming Zhang on Wednesday July 13
Sender: linux-raid-owner@vger.kernel.org
To: mingz@ele.uri.edu
Cc: Dan Christensen <jdc@uwo.ca>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday July 13, mingz@ele.uri.edu wrote:
> On Thu, 2005-07-14 at 08:38 +1000, Neil Brown wrote:
> > On Wednesday July 13, jdc@uwo.ca wrote:
> > > Here's a question for people running software raid-5:  do you get
> > > significantly better read speed from a raid-5 device than from it's
> > > component partitions/hard drives, using the simple dd test I did?
> > 
> > SCSI-160 bus, using just 4 of the 15000rpm drives:
> > 
> > each drive by itself delivers about 67M/s
> > Three drives in parallel deliver 40M/s each, total of 120M/s
> > 4 give 30M/s each or a total of 120M/s
> > 
> > raid5 over 4 drives delivers 132M/s
> why here a 132MB/s instead of 120MB/s (3 * 40MB/s) as u mentioned? any
> factor lead to this increase?
> 
> 

I did another test over 10 times the amount of data, and for 34M/s for
4 concurrent individual drives, which multiplies out to 136M/s.  The
same amount of data of the raid5 gives 137M/s, so I think it was just
experimental error.

NeilBrown
