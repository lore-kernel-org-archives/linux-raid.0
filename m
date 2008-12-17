From: "David Lethe" <david@santools.com>
Subject: RE: detection/correction of corruption with raid6
Date: Wed, 17 Dec 2008 15:47:50 -0600
Message-ID: <A20315AE59B5C34585629E258D76A97C0314B70C@34093-C3-EVS3.exchange.rackspace.com>
References: <1229464713.6159.16.camel@localhost.localdomain> <49491157.9060805@tmr.com> <A20315AE59B5C34585629E258D76A97C030D4913@34093-C3-EVS3.exchange.rackspace.com> <494960E8.8020407@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <494960E8.8020407@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Bill Davidsen [mailto:davidsen@tmr.com] 
Sent: Wednesday, December 17, 2008 2:28 PM
To: David Lethe
Cc: Piergiorgio Sartor; linux-raid@vger.kernel.org
Subject: Re: detection/correction of corruption with raid6

David Lethe wrote: 
-----Original Message-----
From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
owner@vger.kernel.org] On Behalf Of Bill Davidsen
Sent: Wednesday, December 17, 2008 8:49 AM
To: Piergiorgio Sartor
Cc: linux-raid@vger.kernel.org
Subject: Re: detection/correction of corruption with raid6

Piergiorgio Sartor wrote:
    
Why a RAID system might have inconsistencies?
Why do we have a "check" command at all, to run weekly or monthly?

      
Because alpha particles fly by, most systems don't have ECC memory, a
passing truck and noisy jet create a beat frequency that causes a once
in a century bit flip on a good cable connection, power line noise
creeps in, or maybe an angel farts.

My question is why we don't use available techniques to fix this since
we have the software to find it for us.

--
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will
still
  be valid when the war is over..." Otto von Bismark


--
To unsubscribe from this list: send the line "unsubscribe linux-raid"
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
    

EEtimes published results from a 10-year IBM study.  They found that
alpha particles created  a bit flip once a month per 256 MB of DRAM
alone at sea level.  I can't remember what it was in high altitude, but
I think it was twice as bad. If you have 4GB of RAM in your computer,
then even if you have parity memory, then you are going to have
undetectable bit flips several times a month.
  

Why undetectable with parity? Even with Hamming Code, not the most
modern, you could correct all one bit errors and detect all two bit
errors, using 1+log2(N) parity bits, for 2^N data bits. Last I checked
parity memory had 8d+1p, and you have 8 parity bits available on a 64
bit fetch, more than enough. You would have to get three flips in a
fetch before you wouldn't see it, and using some of the better ECC
schemes I bet you would see three as well.


-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 

There is much more to it than that..   Your analysis doesn't factor in
that DRAM must refresh and it never gets read.  

Here is a great paper that explains everything, and gets into details,
and it avoids the calculus. 

http://www.tezzaron.com/about/papers/soft_errors_1_1_secure.pdf

To take a few quotes from it
"Memory errors occur mostly during read/write activity, so the SER rises
with memory speed and with the intensity of memory use; "memory cycling
at 100 nanoseconds can give soft error rates 100 times that of memory
idling in refresh mode (15 microseconds). Error rates rise with
altitude: SER is 5 times as high at 2600 feet as at sea level, and 10
times as high in Denver (5280 feet) as at sea level. SRAM tested at
10,000 feet above sea level will record SERs that are 14 times the rate
tested at sea level"

Quite aside from soft errors, particles with high energies can cause
permanent damage to memory cells. These "hard" errors exhibit error
rates that are strongly related to soft error rates, variously estimated
at 2% of total errors ...

Conclusions
Soft errors are a matter of increasing concern as memories get larger
and memory technologies get smaller. Even using a relatively
conservative error rate (500 FIT/Mbit), a system with 1 GByte of RAM can
expect an error every two weeks; a hypothetical Terabyte system would
experience a soft error every few minutes. Existing ECC technologies can
greatly reduce the error rate, but they may have unacceptable tradeoffs
in power, speed, price, or size. 

Soft errors can be disastrous for systems with large memories, critical
applications, or high altitude locations. Some type of error
detection/correction is mandatory in these cases, in spite of the cost
in price and/or performance."

David




