From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: RAID-5 streaming read performance
Date: Wed, 13 Jul 2005 17:55:18 -0400
Message-ID: <1121291718.5504.110.camel@localhost.localdomain>
References: <874qb14btr.fsf@uwo.ca>
	 <1121220487.5552.34.camel@localhost.localdomain> <87mzorfmdx.fsf@uwo.ca>
	 <1121257494.5504.4.camel@localhost.localdomain> <87eka2g9dp.fsf@uwo.ca>
	 <1121259126.5504.14.camel@localhost.localdomain> <87vf3eeqe2.fsf@uwo.ca>
	 <42D5573A.6090801@dgreaves.com>
	 <1121278451.5504.79.camel@localhost.localdomain>
	 <42D58541.7000702@dgreaves.com>
	 <1121291045.5504.108.camel@localhost.localdomain>
	 <42D58C93.3070602@dgreaves.com>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42D58C93.3070602@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Dan Christensen <jdc@uwo.ca>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 2005-07-13 at 22:50 +0100, David Greaves wrote:
> Ming Zhang wrote:
> 
> >On Wed, 2005-07-13 at 22:18 +0100, David Greaves wrote:
> >  
> >
> >>Ming Zhang wrote:
> >>
> >>    
> >>
> >>>>component partitions, e.g. /dev/sda7: 39MB/s
> >>>>raid device /dev/md2:                 31MB/s
> >>>>lvm device /dev/main/media:           53MB/s
> >>>>
> >>>>(oldish system - but note that lvm device is *much* faster)
> >>>>   
> >>>>
> >>>>        
> >>>>
> >>>this is so interesting to see! seems that some read ahead parameters
> >>>have negative impact.
> >>> 
> >>>
> >>>      
> >>>
> >>I guess each raw device does some readahead, then the md0 does some
> >>readahead and then the lvm does some readahead. Theoretically the md0
> >>and lvm should overlap - but I guess that much of the raw device level
> >>readahead is discarded.
> >>
> >>David
> >>
> >>    
> >>
> >for a streaming read, what you readahead now will always be used exact
> >once in near future. at least i think raw device readahead can be turned
> >on at the same time with one of OS components, raid or lvm, readahead
> >being turned on. but in your case, u get best result when turn only one
> >on.
> >
> >ming
> >
> >
> >
> >  
> >
> I doubt it's just me - what results do others get with that script?
> 
> David
> 

my box is in use now. i might try it tomorrow to see what happen. :P

Ming


