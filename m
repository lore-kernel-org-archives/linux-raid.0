From: Dan Christensen <jdc@uwo.ca>
Subject: Re: RAID-5 streaming read performance
Date: Thu, 14 Jul 2005 14:03:29 -0400
Message-ID: <k564vdgt8u.fsf@jdc.math.uwo.ca>
References: <874qb14btr.fsf@uwo.ca>
 <1121220487.5552.34.camel@localhost.localdomain> <87mzorfmdx.fsf@uwo.ca>
 <1121257494.5504.4.camel@localhost.localdomain> <87eka2g9dp.fsf@uwo.ca>
 <1121259126.5504.14.camel@localhost.localdomain> <87vf3eeqe2.fsf@uwo.ca>
 <42D5573A.6090801@dgreaves.com> <87r7e23uo5.fsf@uwo.ca>
 <1121344255.5544.7.camel@localhost.localdomain> <87br55xogl.fsf@uwo.ca>
 <1121364003.5544.80.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <1121364003.5544.80.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: mingz@ele.uri.edu
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[Ming, could you trim quoted material down a bit more, and leave a
blank line between quoted material and your new text?  Thanks.]

Ming Zhang <mingz@ele.uri.edu> writes:

> On Thu, 2005-07-14 at 13:54 -0400, Dan Christensen wrote:
>> 
>> Yes, there will be a seek, or internal drive readahead, so each drive
>> will operate at around 75% efficiency.  But since that shouldn't
>> affect bus/controller traffic, I still would expect to get over
>> 100MB/s with my hardware.
>
> agree. but what if your controller is a bottleneck? u need to have
> another card to find out.

The controller and/or bus *is* the bottleneck, but I've already shown
that I can get 106MB/s through them.

Dan
