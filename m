From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Odd (slow) RAID performance
Date: Thu, 07 Dec 2006 10:51:25 -0500
Message-ID: <4578387D.4010209@tmr.com>
References: <456F4872.2090900@tmr.com>	 <20061201092211.4ACDB12EDE@bluewhale.planbit.co.uk>	 <45710EDC.9050805@tmr.com> <e9c3a7c20612041733h5999ac0erc7ab4a7174882683@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20612041733h5999ac0erc7ab4a7174882683@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: Roger Lucas <roger@planbit.co.uk>, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Dan Williams wrote:
> On 12/1/06, Bill Davidsen <davidsen@tmr.com> wrote:
>> Thank you so much for verifying this. I do keep enough room on my drives
>> to run tests by creating any kind of whatever I need, but the point is
>> clear: with N drives striped the transfer rate is N x base rate of one
>> drive; with RAID-5 it is about the speed of one drive, suggesting that
>> the md code serializes writes.
>>
>> If true, BOO, HISS!
>>
>> Can you explain and educate us, Neal? This look like terrible 
>> performance.
>>
> Just curious what is your stripe_cache_size setting in sysfs?
> 
> Neil, please include me in the education if what follows is incorrect:
> 
> Read performance in kernels up to and including 2.6.19 is hindered by
> needing to go through the stripe cache.  This situation should improve
> with the stripe-cache-bypass patches currently in -mm.  As Raz
> reported in some cases the performance increase of this approach is
> 30% which is roughly equivalent to the performance difference I see of
> a 4-disk raid5 versus a 3-disk raid0.
> 
> For the write case I can say that MD does not serialize writes.  If by
> serialize you mean that there is 1:1 correlation between writes to the
> parity disk and writes to a data disk.  To illustrate I instrumented
> MD to count how many times it issued a write to the parity disk and
> compared that to how many writes it performed to the member disks for
> the workload "dd if=/dev/zero of=/dev/md0 bs=1024k count=100".  I
> recorded 8544 parity writes and 25600 member disk writes which is
> about 3 member disk writes per parity write, or pretty close to
> optimal for a 4-disk array.  So, serialization is not the cause,
> performing sub-stripe width writes is not the cause as >98% of the
> writes happened without needing to read old data from the disks.
> However, I see the same performance on my system, about equal to a
> single disk.

But the number of writes isn't an indication of serialization. If I 
write disk A, then B, then C, then D, you can't tell if I waited for 
each write to finish before starting the next, or did them in parallel. 
And since the write speed is equal to the speed of a single drive, 
effectively that's what happens, even though I can't see it in the code.

I also suspect that write are not being combined, since writing the 2GB 
test runs at one-drive speed writing 1MB blocks, but floppy speed 
writing 2k blocks. And no, I'm not running out of CPU to do the 
overhead, it jumps from 2-4% to 30% of one CPU, but on an unloaded SMP 
system it's not CPU bound.
> 
> Here is where I step into supposition territory.  Perhaps the
> discrepancy is related to the size of the requests going to the block
> layer.  raid5 always makes page sized requests with the expectation
> that they will coalesce into larger requests in the block layer.
> Maybe we are missing coalescing opportunities in raid5 compared to
> what happens in the raid0 case?  Are there any io scheduler knobs to
> turn along these lines?

Good thought, I had already tried that but not reported it, changing 
schedulers make no significant difference. In the range of 2-3%, which 
is close to the measurement jitter due to head position or whatever.

I changed my swap to RAID-10, but RAID-5 just can't keep up with 
70-100MB/s data bursts which I need. I'm probably going to scrap 
software RAID and go back to a controller, the write speeds are simply 
not even close to what they should be. I have one more thing to try, a 
tool I wrote to chase another problem a few years ago. I'll report if I 
find something.

-- 
bill davidsen <davidsen@tmr.com>
   CTO TMR Associates, Inc
   Doing interesting things with small computers since 1979
