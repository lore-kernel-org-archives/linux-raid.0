From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: linux disk access when idle
Date: Fri, 21 Aug 2009 18:00:43 -0400
Message-ID: <4A8F190B.9010406@tmr.com>
References: <20090820163522.GA29215@sewage>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090820163522.GA29215@sewage>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Matt Garman wrote:
> The scope of this question is probably broader than Linux RAID, but
> I thought I'd try here before going to the LKML...
>
> I have a fileserver/NAS box that has four Western Digital GreenPower
> drives in software RAID-5 (i.e. Linux md).  There was some noise
> about these drives not too long ago: when used under Linux, they
> tend to have really high (and rapidly increasing) SMART
> Load_Cycle_Count values[1].
>
> Basically, in order to save power, these drives park the read/write
> heads after so many seconds of inactivity.  According to
> SilentPCReview[2], the 1 TB model uses 5.7W when idle and only 3.7W
> when the heads are unloaded.  Apparantly, each head parking event
> causes teh Load_Cycle_Count value to increase.
>
> Most people seek to disable this head parking behavior to stop that
> Load_Cycle_Count value from growing alarmingly high.  I actually
> want to use it to it's full potential.
>
> I've got a Kill-A-Watt electricity meter connected to my NAS box.  I
> see a difference of 10 watts power usage when the heads park (I can
> hear them unload, so I know when it happens).  Allowing for some
> power supply inefficiency, I'd say my observation is consistent with
> SPCR's numbers.
>
> The problem is, the drives don't stay in this parked state very
> long.  I haven't actually timed the state changes, but average power
> consumption over a long time (e.g. a week or more) is at the higher
> (i.e. +10) level.
>
> So I figure, something is accessing these drives shortly after the
> heads park, causing them to un-park (and increasing power
> consumption).  But this machine is idle 95% of the time.  And even
> then, the overwhelming majority of the accesses are reads, with very
> few writes (literally, a handful of writes per week).
>
>   
/proc/sys/vm/dirty_expire_centisecs still set to 30 sec?

> So what I'm trying to figure out is, what is causing the disk
> access?  It could be any one of:
>
>     - Kernel
>     - RAID subsystem (i.e. md)
>     - XFS filesystem
>     - NFS
>     - Samba
>     - ???
>
> I'm hoping someone has enough knowledge of these systems to point me
> in the right direction for tuning things.  The goal is that when the
> machine is idle, it is "truly" idle, meaning, no disk accesses take
> place and the heads can stay parked (thus saving energy).
>
> Thank you,
> Matt
>
> LINKS:
> [1] http://groups.google.com/group/linux.kernel/browse_thread/thread/505ccf760023d132/7e4f4e996f911efd
>
> [2] http://www.silentpcreview.com/article804-page2.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


