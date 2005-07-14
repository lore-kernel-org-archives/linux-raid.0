From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: RAID-5 streaming read performance
Date: Thu, 14 Jul 2005 16:13:44 -0400
Message-ID: <1121372024.5544.104.camel@localhost.localdomain>
References: <874qb14btr.fsf@uwo.ca>
	 <1121220487.5552.34.camel@localhost.localdomain> <87mzorfmdx.fsf@uwo.ca>
	 <1121257494.5504.4.camel@localhost.localdomain> <87eka2g9dp.fsf@uwo.ca>
	 <1121259126.5504.14.camel@localhost.localdomain> <87vf3eeqe2.fsf@uwo.ca>
	 <42D5573A.6090801@dgreaves.com> <87r7e23uo5.fsf@uwo.ca>
	 <1121344255.5544.7.camel@localhost.localdomain> <87br55xogl.fsf@uwo.ca>
	 <1121364003.5544.80.camel@localhost.localdomain>
	 <k564vdgt8u.fsf@jdc.math.uwo.ca>
	 <1121364617.5544.83.camel@localhost.localdomain>   <877jftxko7.fsf@uwo.ca>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <877jftxko7.fsf@uwo.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Christensen <jdc@uwo.ca>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

raid5 can not be that smart. :P

ming

On Thu, 2005-07-14 at 15:16 -0400, Dan Christensen wrote:
> bus/controller.  For example, RAID-5 could just do sequential
> reads from 3 of the 4 drives, and use the parity chunks it
> reads to reconstruct the data chunks from the fourth drive.
> If I do parallel reads from 3 of my 4 disks, I can still get
> 106MB/s.
> 

