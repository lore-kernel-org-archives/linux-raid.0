From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID halting
Date: Fri, 10 Apr 2009 11:31:54 -0400
Message-ID: <49DF666A.7030603@tmr.com>
References: <20090410045146.TNPB12747.cdptpa-omta01.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090410045146.TNPB12747.cdptpa-omta01.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Leslie Rhorer wrote:
>>>  for f in /sys/block/*/queue/scheduler; do
>>>     echo noop > $f
>>>     echo $f "$(cat $f)"
>>>   done
>>>       
>> OK, I did this.  Two questions:
>>     
>
> It doesn't seem to have helped or hindered.  I still get halts, but under
> moderate loads not every time.
>
>   
>>> Leslie: I still think finding out what the kernel is doing during the
>>> stall would be a HUGE hint to the problem. Did you look into oprofile or
>>> ftrace?
>>>       
>> I couldn't find a Debian source for ftrace, but I did download oprofile.
>>     
>
> Something very disturbing is happening now, however.  Just a few minutes
> after loading oprofile, the system did a sudden total shutdown.  The file
> systems were all left dirty, and power was suddenly cut to the main chassis.
> This has never happened before.  I rebooted the system, and the file systems
> replayed their journals.  Some data was lost, of course, but nothing
> serious.  A few hours later, the exact same thing happened again:  A sudden
> shut-down.  Nothing like this has ever happened before.  Of course the
> system can issue a power shutdown from software, but it is supposed to clean
> up the file systems first, and it's not supposed to just do it autonomously.
>   

Just for grins, is this system by any chance on a UPS? Because I found 
an interesting failure mode if that's the case.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


