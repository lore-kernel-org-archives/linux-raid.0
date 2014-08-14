From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Sleepy drives and MD RAID 6
Date: Thu, 14 Aug 2014 14:10:15 -0400
Message-ID: <53ECFB87.3010700@tmr.com>
References: <CAH_2GheOOaJRp7YimEsorFzGUJyObG2QsOpu87CYvwLPwz-V+A@mail.gmail.com> <20140812092901.60f007e6@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140812092901.60f007e6@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Roman Mamedov wrote:
> On Mon, 11 Aug 2014 18:03:17 -0700
> Adam Talbot <ajtalbot1@gmail.com> wrote:
>
>> I need help from the Linux RAID pros.
>>
>> To make a very long story short; I have a 7 disk in a RAID 6 array.  I
>> put the drives to sleep after 7 minutes of inactivity.
>
> It is well known that repeatedly spinning a drive down/up is absolutely the
> worst possible thing you can do to it, from a long term reliability standpoint.
> So my personal suggestion would be to reconsider if you really want this. The
> power consumption from 7 spinning drives with no access should be no higher
> than 60-70 watt; IMHO saving that amount, is not something that's worth risking
> your disks and data for.
>
Unless you live in someplace really cold, there's the cost of pumping that heat 
out of the room. Running A/C can almost double your power cost, and running the 
room hot shortens your component life. In other words there's more cost than the 
power for most people. Even if my hardware can run at 90F, I can't.

There appears to be a partial solution, get a small SDD (<$100) and put the 
journal on it. Get two, run RAID1 if you must. Then configure the system to 
write the journal with all data (data=journal), and the write will be really 
fast, even if they don't fully complete for a minute or so. Doesn't help reads, 
of course. Turns the journal into cache, sort of.

I have the feeling that sequential spin is an option in a driver, but I can't 
remember or quickly find where. I say this because I had to set it on one 
machine I had, spinning up the whole array at one caused the power supply to 
overload, and until I could get a bigger one which would fit I set an option. 
That was long enough that I can't remember where I found that. Turn it off and 
all seven drives will ask for power at once, which probably isn't a great thing, 
but not my system.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
