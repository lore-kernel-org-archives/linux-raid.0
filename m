From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Odd (slow) RAID performance
Date: Sat, 09 Dec 2006 15:16:26 -0500
Message-ID: <457B199A.6080901@tmr.com>
References: <456F4872.2090900@tmr.com>	<20061201092211.4ACDB12EDE@bluewhale.planbit.co.uk>	<45710EDC.9050805@tmr.com>	<e9c3a7c20612041733h5999ac0erc7ab4a7174882683@mail.gmail.com> <17784.65477.993729.508985@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17784.65477.993729.508985@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Dan Williams <dan.j.williams@gmail.com>, Roger Lucas <roger@planbit.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Monday December 4, dan.j.williams@gmail.com wrote:
>   
>> Here is where I step into supposition territory.  Perhaps the
>> discrepancy is related to the size of the requests going to the block
>> layer.  raid5 always makes page sized requests with the expectation
>> that they will coalesce into larger requests in the block layer.
>> Maybe we are missing coalescing opportunities in raid5 compared to
>> what happens in the raid0 case?  Are there any io scheduler knobs to
>> turn along these lines?
>>     
>
> This can be measured.  /proc/diskstats reports the number of requests
> as well as the number of sectors.
> The number of write requests is column 8.  The number of write sectors
> is column 10.  Comparing these you can get an average request size.
>
> I have found that the average request size is proportional to the size
> of the stripe cache (roughly, with limits) but increasing it doesn't
> increase through put.
> I have measured very slow write throughput for raid5 as well, though
> 2.6.18 does seem to have the same problem.  I'll double check and do a
> git bisect and see what I can come up with.
>
> NeilBrown
Agreed, this is an ongoing problem, not a regression in 2.6.19. But I am 
writing 50MB/s to a single drive, 3x that to a three way RAID-0 array of 
those drives, and only 35MB/s to a three drive RAID-5 array. With large 
writes I know no reread is needed, and yet I get consistently slow 
write, which gets worse with smaller data writes (2k vs. 1MB for the 
original test).

Read performance is good, I will measure tomorrow and quantify "good," 
today is shot from ten minutes from now until ~2am, as I have a party to 
attend, followed by a 'cast to watch.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

