From: Robert L Mathews <lists@tigertech.com>
Subject: Re: RAID 1 failure on single disk causes disk subsystem to lock up
Date: Wed, 02 Apr 2008 11:33:23 -0700
Message-ID: <47F3D173.8060502@tigertech.com>
References: <47F020C6.1060809@tigertech.com>	<47F0281F.1070404@harddata.com>	<47F11F12.7010309@tigertech.com> <18417.16752.269484.583258@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18417.16752.269484.583258@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Peter Grandi wrote:

 > If you have high availability requirements perhaps you should buy
 > from an established storage vendor a storage system designed by
 > integration engineers and guaranteed by the vendor for some high
 > availability level.

Actually, I don't trust such systems. That's our main reason for using 
software RAID 1: if all else fails with regard to RAID, we can take one 
of the disks and mount it as a non-RAID ext3 file system. No 
"guaranteed" proprietary system can offer that.

(And other than this one perplexing problem, we've been extremely happy 
with software RAID for many years -- thanks, Neal and everyone else 
involved.)


 > Perhaps without realizing it you have engaged in storage system
 > design and integration and there are many, many, many, many subtle
 > pitfalls in that (as the archives of this list show abundantly).
 >
 > You cannot just slap things together and it all works. Have you
 > done even sketchy common mode failure analysis?

Ouch!  :-)

Just for the record, this isn't "slapped together" hardware. They're 
off-the-shelf, server-grade, currently sold, genuine Intel, etc. 
SuperMicro servers, with no modifications, specifically chosen because 
they're widely used. The only storage system design we've done is 
connect a SATA drive to each of the two motherboard SATA ports and use 
software RAID 1 (yeah, I know that's "design", and we did think about it 
and test it, but still).

We've done many stress/failure tests for data storage, all of which pass 
as expected. What I unfortunately can't test in advance is how they 
behave when a working hard disk suddenly has a mechanical failure, which 
is the only time we've seen a problem.

I could sacrifice a working disk by opening it up while running and 
poking the platters with a screwdriver (I've seriously considered this), 
but repeating the test more than a few times would get expensive.


 > Also putting two drives belonging to a RAID set on the same
 > IDE/ATA channel is usually a bad idea for performance too.

They're SATA drives. There's no actual IDE hardware involved.

-- 
Robert L Mathews
