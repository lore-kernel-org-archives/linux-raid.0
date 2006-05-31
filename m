From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID5E
Date: Wed, 31 May 2006 15:03:59 -0400
Message-ID: <447DE89F.6000509@tmr.com>
References: <447D9E72.3000704@tmr.com> <Pine.GSO.4.64.0605311626240.18452@montezuma.acc.umu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.64.0605311626240.18452@montezuma.acc.umu.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mattias Wadenstein <maswan@acc.umu.se>
Cc: Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mattias Wadenstein wrote:

> On Wed, 31 May 2006, Bill Davidsen wrote:
>
>> Where I was working most recently some systems were using RAID5E 
>> (RAID5 with both the parity and hot spare distributed). This seems to 
>> be highly desirable for small arrays, where spreading head motion 
>> over one more drive will improve performance, and in all cases where 
>> a rebuild to the hot spare will avoid a bottleneck on a single drive.
>>
>> Is there any plan to add this capability?
>
>
> What advantage does that have over raid6? You use exactly as many 
> drives (n+2), with the disadvantage of having to do a rebuild without 
> parity when a drive fails and a raid failure at a double disk failure. 

The write overhead of RAID-6 vs. RAID-5 is much higher, both in terms of 
CPU and disk operations generated. See below re double drive failure and 
RAID-5 with spare.

As a starting point consider RAID-4, and four drives, one of which is a 
hot spare (I did clearly note small arrays). For reads you only have 
striping over two drives, for writes the parity drive has double the i/o 
of the data drives. The spare may spin down or not, but if it fails it 
will be just when you need it most.

With RAID-5 the load is evenly spread over the entire array of active 
drives. This improves both read and write performance, but the hot spare 
is still not used in normal operation. Note that in the two drive 
failure mode the only critical time is during the rebuild to hot spare, 
after that a second drive failure is tolerated without loss of data.

With RAID-5E the i/o is spread over all four drives, which gives a 
further improvement in the read and write performance, particularly if 
large reads and writes (relative to clunk size) are common. There is no 
hot spare which is mostly unused, and rebuild to the hot spare is 
distributed over all remaining drives.

Drawbacks: you can't share a single hot spare between multiple arrays. 
That's not really common, and I mention it for completeness. The other 
issue is that when a failed drive is replaced the rebuild appears to be 
somewhat complex because the new drive doesn't just become the new hot 
spare. The same issues apply regarding two drives failing, but the 
rebuild time is usually shorter, so the exposure is less.

And finally, with RAID-6 and the same number of drives, if you have a 
failure there's no hot spare, and the arrray runs in degraded mode until 
the failed drive is replaced. That is a different balance between 
reliability and performance after failure, and needs to be a 
per-instance choice.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

