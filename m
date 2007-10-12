From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid5: degraded after reboot
Date: Fri, 12 Oct 2007 14:58:22 -0400
Message-ID: <470FC3CE.7030904@tmr.com>
References: <cccedfc60710120838nd2bb38pf57f03faa803b6c6@mail.gmail.com> <20071012154755.GE21133@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071012154755.GE21133@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andre Noll wrote:
> On 10:38, Jon Nelson wrote:
>   
>> <4>md: kicking non-fresh sda4 from array!
>>
>> what does that mean?
>>     
>
> sda4 was not included because the array has been assembled previously
> using only sdb4 and sdc4. So the data on sda4 is out of date.
>
>   
>> I also have this:
>>
>> raid5: raid level 5 set md0 active with 2 out of 3 devices, algorithm 2
>> RAID5 conf printout:
>>  --- rd:3 wd:2 fd:1
>>  disk 1, o:1, dev:sdb4
>>  disk 2, o:1, dev:sdc4
>>     
>
> This looks normal. The array is up with two working disks.
>
>   
>> Why was /dev/sda4 kicked?
>>     
>
> Because it was non-fresh ;)
>
>   
>> md0 : active raid5 sda4[3] sdb4[1] sdc4[2]
>>       613409664 blocks level 5, 64k chunk, algorithm 2 [3/2] [_UU]
>>       [==>..................]  recovery = 13.1% (40423368/306704832)
>> finish=68.8min speed=64463K/sec
>>     
>
> Seems like your init scripts re-added sda4.
>
>   
>> 65-70KB/s is about what these drives can do so the rebuild speed is just peachy.
>>     
>
> If the rebuild completes successfully, you're ok again.  There's
> nothing you have to do.
>   

What you didn't say is that "doing nothing" is not only all that's 
required, but where possible it's the best thing *to* do, avoiding any 
testing of the "recover while active" logic, any extra seeking, etc.

And I would be sure I understood why the system had to be force booted. 
If sysreq is working I would assume using 's' before 'b' is normal. 'Tis 
on my systems!


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

