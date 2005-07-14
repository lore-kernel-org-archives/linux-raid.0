From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: RAID-5 streaming read performance
Date: Thu, 14 Jul 2005 14:10:16 -0400
Message-ID: <1121364617.5544.83.camel@localhost.localdomain>
References: <874qb14btr.fsf@uwo.ca>
	 <1121220487.5552.34.camel@localhost.localdomain> <87mzorfmdx.fsf@uwo.ca>
	 <1121257494.5504.4.camel@localhost.localdomain> <87eka2g9dp.fsf@uwo.ca>
	 <1121259126.5504.14.camel@localhost.localdomain> <87vf3eeqe2.fsf@uwo.ca>
	 <42D5573A.6090801@dgreaves.com> <87r7e23uo5.fsf@uwo.ca>
	 <1121344255.5544.7.camel@localhost.localdomain> <87br55xogl.fsf@uwo.ca>
	 <1121364003.5544.80.camel@localhost.localdomain>
	 <k564vdgt8u.fsf@jdc.math.uwo.ca>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <k564vdgt8u.fsf@jdc.math.uwo.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Christensen <jdc@uwo.ca>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 2005-07-14 at 14:03 -0400, Dan Christensen wrote:
> [Ming, could you trim quoted material down a bit more, and leave a
> blank line between quoted material and your new text?  Thanks.]

thanks. sorry about that.

> 
> Ming Zhang <mingz@ele.uri.edu> writes:
> 
> > On Thu, 2005-07-14 at 13:54 -0400, Dan Christensen wrote:
> >> 
> > agree. but what if your controller is a bottleneck? u need to have
> > another card to find out.
> 
> The controller and/or bus *is* the bottleneck, but I've already shown
> that I can get 106MB/s through them.
> 
> Dan

then can u test RAID0 a bit? That is easier to analyze.

Ming


