From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: bad performance on RAID 5
Date: Sun, 21 Jan 2007 14:09:07 -0500
Message-ID: <45B3BA53.1030206@tmr.com>
References: <45AE9640.1040500@start.no> <45AFBC85.8020500@maine.edu>	<45AFFE72.8070709@tmr.com> <87wt3gtiih.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87wt3gtiih.fsf@hades.wkstn.nix>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Steve Cousins <steve.cousins@maine.edu>, Sevrin Robstad <quackyo@start.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nix wrote:
> On 18 Jan 2007, Bill Davidsen spake thusly:
>   
>> ) Steve Cousins wrote:
>>     
>>> time dd if=/dev/zero of=/mount-point/test.dat bs=1024k count=1024
>>>       
>> That doesn't give valid (repeatable) results due to caching issues. Go
>> back to the thread I started on RAID-5 write, and see my results. More
>> important, the way I got rid of the cache effects (beside an unloaded
>> systems) was:
>>  sync; time bash -c "dd if=/dev/zero bs=1024k count=2048 of=/mnt/point/file; sync"
>> I empty the cache, then time the dd including the sync at the
>> end. Results are far more repeatable.
>>     
>
> Recent versions of dd have `oflag=direct' as well, to open the output
> with O_DIRECT. (I'm not sure what the state of O_DIRECT on regular files
> is though.)
>
>   
Doing the write using page cache and then just a single sync at the end 
gives a closer estimate of what can be written to the array in general. 
By going to O_DIRECT every i/o take place unbuffered, which is more 
typical of database use or similar. My original problem was capturing 
real data at 75MB/s and not being able to write it to an array that 
fast, taking advantage of page cache. By going to huge stripe cache, 
about 20x larger than default, performance was boosted to a more useful 
level.

I think both measurements are useful, but they aren't measuring the same 
thing.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

