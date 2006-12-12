From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Odd (slow) RAID performance
Date: Tue, 12 Dec 2006 12:44:45 -0500
Message-ID: <457EEA8D.1080103@tmr.com>
References: <456F4872.2090900@tmr.com>	<20061201092211.4ACDB12EDE@bluewhale.planbit.co.uk>	<45710EDC.9050805@tmr.com>	<e9c3a7c20612041733h5999ac0erc7ab4a7174882683@mail.gmail.com>	<17784.65477.993729.508985@cse.unsw.edu.au> <17785.5135.749830.180388@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17785.5135.749830.180388@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Dan Williams <dan.j.williams@gmail.com>, Roger Lucas <roger@planbit.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Friday December 8, neilb@suse.de wrote:
>   
>> I have measured very slow write throughput for raid5 as well, though
>> 2.6.18 does seem to have the same problem.  I'll double check and do a
>> git bisect and see what I can come up with.
>>     
>
> Correction... it isn't 2.6.18 that fixes the problem.  It is compiling
> without LOCKDEP or PROVE_LOCKING.  I remove those and suddenly a
> 3 drive raid5 is faster than a single drive rather than much slower.
>
> Bill:  Do you have LOCKDEP or PROVE_LOCKING enabled in your .config ??

YES and NO respectively. I did try increasing the stripe_cache_size and 
got better but not anywhere near max performance, perhaps the 
PROVE_LOCKING is still at fault, although performance of RAID-0 is as 
expected, so I'm dubious. In any case, by pushing the size from 256 to 
1024, 4096, and finally 10240 I was able to raise the speed to 82MB/s, 
which is right at the edge of what I need. I want to read the doc on 
stripe_cache_size before going huge, if that's K 10MB is a LOT of cache 
when 256 works perfectly in RAID-0.

I noted that the performance really was bad using 2k write, before 
increasing the stripe_cache, I will repeat that after doing some other 
"real work" things.

Any additional input appreciated, I would expect the speed to be (Ndisk 
- 1)*SingleDiskSpeed without a huge buffer, so the fact that it isn't 
makes me suspect there's unintended serialization or buffering, even 
when not need (and NOT wanted).

Thanks for the feedback, I'm updating the files as I type.
http://www.tmr.com/~davidsen/RAID_speed
http://www.tmr.com/~davidsen/FC6-config

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

