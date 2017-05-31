From: CoolCold <coolthecold@gmail.com>
Subject: Re: RAID10 performance with 20 drives
Date: Wed, 31 May 2017 20:57:13 +0700
Message-ID: <CAGqmV7pdiTKRZY2gnPH0QO7eWLAZVWKZc8tqE1t_rzENVJH8Nw@mail.gmail.com>
References: <CAGqmV7p4_r+ca+Wq_UXcY4RDa7WwE2nWkgXF+Sn3ChwLEmkurQ@mail.gmail.com>
 <da03d962-2baf-66d9-f037-23de38c1ff50@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <da03d962-2baf-66d9-f037-23de38c1ff50@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello!
thanks for reply, tried to answer questions below and with help of
gists of github as Gmail forcibly cuts the lines.
https://gist.github.com/CoolCold/676a6f9df0478c1c2d8ac8f3e6f9e22a

Added vmstat output as well.


On Wed, May 31, 2017 at 8:14 PM, Adam Goryachev
<mailinglists@websitemanagers.com.au> wrote:
>
>
> On 31/5/17 22:20, CoolCold wrote:
>>
>> top stat:
>> top - 12:09:03 up  4:55,  2 users,  load average: 3.33, 3.18, 2.88
>> Tasks: 487 total,   4 running, 483 sleeping,   0 stopped,   0 zombie
>> %Cpu(s):  0.0 us,  4.5 sy,  0.0 ni, 95.3 id,  0.0 wa,  0.0 hi,  0.1 si,
>> 0.0 st
>> KiB Mem : 13174918+total, 13005539+free,  1191212 used,   502584
>> buff/cache
>> KiB Swap:  9764860 total,  9764860 free,        0 used. 13020440+avail Mem
>>
>>    PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+
>> COMMAND
>> 22275 root      20   0       0      0      0 R  99.0  0.0   7:01.01
>> md1_raid10
>>
>> this cpu usage 99-100% is constant.
>>
> Sorry, but doesn't that say 95.3% idle?

No, it says 95.3 busy with right formatting, see
https://gist.github.com/CoolCold/676a6f9df0478c1c2d8ac8f3e6f9e22a#file-gistfile1-txt-L49
>
> Do you have a multi core CPU? Is it multi threaded? What type of CPU is it?
>
> When running top, press 1, it will then show you each individual core and
> the stats for it.
Top provided on the same gist, system has 40 cpu (2x10xhyperthreading) cpus

>
> You might find that creating 10 RAID1 devices, and then using linear raid to
> join them together will perform better, from hearsay and memory, this will
> allow you to use a CPU for each RAID1, and another CPU for the linear, so if
> you had 11 CPU's (or more) then this should get you the best possible
> outcome (from a CPU point of view). In fact, if you have more than one CPU
> it would help.
So, basically you are saying that one should avoid using raid10 for 20 drives?
>
> Also, you might want to run a newer kernel, I think there was a lot of work
> done on the resync parts to optimise that.
Can you please provide keywords/commits to look onto? I've did fast
search through archive, not much found, except may be intent bitmap,
which is not the case here.

 You might also prefer to focus on
> performance measurements *after* the resync has completed, since that would
> be your "normal" status. Though in addition, you should test performance
> with one lost disk, and while replacing that disk to ensure that you are
> still able to sustain the required load during those events.
That's would be my next step with FIO & lvmcache, but just limiting
speed to 1.4GB for resync makes me worry.

>
> Regards,
> Adam



-- 
Best regards,
[COOLCOLD-RIPN]
