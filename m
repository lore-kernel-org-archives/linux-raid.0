From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID halting
Date: Sat, 11 Apr 2009 09:02:39 -0400
Message-ID: <49E094EF.6030206@tmr.com>
References: <20090411013735.VDNG2520.cdptpa-omta04.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090411013735.VDNG2520.cdptpa-omta04.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Leslie Rhorer wrote:
>>> Something very disturbing is happening now, however.  Just a few minutes
>>> after loading oprofile, the system did a sudden total shutdown.  The
>>>       
>> file
>>     
>>> systems were all left dirty, and power was suddenly cut to the main
>>>       
>> chassis.
>>     
>>> This has never happened before.  I rebooted the system, and the file
>>>       
>> systems
>>     
>>> replayed their journals.  Some data was lost, of course, but nothing
>>> serious.  A few hours later, the exact same thing happened again:  A
>>>       
>> sudden
>>     
>>> shut-down.  Nothing like this has ever happened before.  Of course the
>>> system can issue a power shutdown from software, but it is supposed to
>>>       
>> clean
>>     
>>> up the file systems first, and it's not supposed to just do it
>>>       
>> autonomously.
>>     
>> Just for grins, is this system by any chance on a UPS? Because I found
>> an interesting failure mode if that's the case.
>>     
>
> Yeah, you bet.  Indeed, the first thing I considered was a false Low Battery
> indication causing the system to shut down, but in that case it should have
> been a clean shut-down.
>   

Actually what I saw was that the load exceeded the charge capacity, so 
the battery gradually discharged, and at some point the UPS just shut 
off (or the output voltage got so low the system crashed). The cause was 
not too much load, but a failure of a diode in the charging circuit, 
such that the full wave rectifier became a half wave rectifier, and in 
addition to the other problems there was a lot of noise on the output 
voltage.

Anyway, just a thought, if this falls over often I would take a chance 
on losing power and run on just a surge protector for a little bit to 
see if any UPS issue might be involved.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


