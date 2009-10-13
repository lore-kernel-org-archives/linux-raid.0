From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Random bit flips - better data integrity needed [Was: Re: 	mismatch_count
 != 0 on multiple hosts]
Date: Tue, 13 Oct 2009 17:45:26 -0400
Message-ID: <4AD4F4F6.7010506@tmr.com>
References: <87f94c370909190910s6992a671re507ddcf91ea623e@mail.gmail.com> <h9abqh$e1m$2@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <h9abqh$e1m$2@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Urlichs <matthias@urlichs.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Matthias Urlichs wrote:
> On Sat, 19 Sep 2009 12:10:34 -0400, Greg Freemyer wrote:
>
>   
>> Specifically you could steal the second parity stripe from a raid 6
>> setup and replace it with this end-to-end data integrity checksum / crc.
>>     
>
> If you're willing to add that kind of overhead, simply read all of the 
> RAID6 stripes into memory and check whether they're consistent.
>
> If not, it's easy to decide (for RAID6) whether the data or the parity is 
> wrong: simply check both P and Q. If only one is broken, fix it. If both 
> are, correct the data according to P and check if Q is now correct. If 
> so, fix it. Otherwise the only thing you can do is to fail the whole 
> array, and to alert the operator that they have major hardware issues. :-/
>
> For RAID45, you can do the same, except that there's no way to fix any 
> problems since you don't know whether data or parity is right. As the 
> error may have crept in upon writing, rereading is of limited use.
>
> For RAID1 (and maybe even multipath), the same idea applies; add majority 
> rule when you have more than two disks.
>
> Adding this kind of checking to the RAID456 driver should be rather easy 
> for somebody who knows its internals. Its effect on read throughput is 
> anyone's guess, of course.
>   

To do this right requires forcing the data to the platter, then reading 
it back (from the platter, not cache) and checking it. Preferably 
reading with ECC off to catch marginal data. In the 60's there were 
drives with read-after-write heads, but the data density was so low you 
could sprinkle oxide on the platter and see data patterns. I can't see 
doing it that way with "heads" any more, but when solid state becomes 
more mainstream it becomes possible with useful transfer rates.

I have the feeling that someone had a patch to do that with a loopback 
mount, but I can't find a pointer.

-- 
Bill Davidsen <davidsen@tmr.com>
  Unintended results are the well-earned reward for incompetence.

