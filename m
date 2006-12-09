From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Odd (slow) RAID performance
Date: Sat, 09 Dec 2006 15:20:18 -0500
Message-ID: <457B1A82.6070105@tmr.com>
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
>   
I have to check tomorrow, I'm using the Fedora kernel (as noted in the 
first post on this) rather than one I built, just so others could verify 
my results as several have been kind enough to do. Have to run, but I 
will check tomorrow or Monday morning early at the latest.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

