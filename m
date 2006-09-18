From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Slackware and RAID
Date: Mon, 18 Sep 2006 19:45:03 -0400
Message-ID: <450F2F7F.6090108@tmr.com>
References: <200609161230.22530.Dexter.Filmore@gmx.de> <450C33BA.2000208@tmr.com> <200609162032.07509.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200609162032.07509.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dexter Filmore wrote:

>Am Samstag, 16. September 2006 19:26 schrieb Bill Davidsen:
>  
>
>>Dexter Filmore wrote:
>>    
>>
>>>Is anyone here who runs a soft raid on Slackware?
>>>Out of the box there are no raid scripts, the ones I made myself seem a
>>>little rawish, barely more than mdadm --assemble/--stop.
>>>      
>>>
>>I'm pretty much off Slack now, but I have run, the scripts you describe
>>are about 2/3 of what you need, see the thread(s) here about monitoring.
>>mdadm doesn't need a lot of direction...
>>    
>>
>
>What's the remaining third?
>  
>
Monitoring... where I pointed you.

>I fumbled it into rc.S and rc.6, reason why I ask is that array degraded about 
>6 times in the few months I run it and I can't figure why. Only thing I know 
>is that it degrades somewhere in the reboot process, so I suspect it might 
>not properly shutdown.
>

Since I haven't had problems I'll pass on trying to guess what's 
happening. When I have any problem usually a whole drive hits the floor, 
and I know what to fix and how. I assume you look at mdstat after boot? 
If it's clean before you shut down and dirty on boot, something isn't 
shutting down clean, OR that autodetect stuff isn't working as you want 
it to. I do NOT run lvm, I avoid stuff like that unless I really need it.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

