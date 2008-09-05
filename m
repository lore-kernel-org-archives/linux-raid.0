From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH] md: raid10: wake up frozen array
Date: Fri, 05 Sep 2008 12:58:20 -0400
Message-ID: <48C1652C.1080109@tmr.com>
References: <20080725190338.GA27484@ajones-laptop.nbttech.com> <1220131852.19005.77.camel@pc343.objectsoft-systems.ltd.uk> <20080902150703.GA9406@ajones-laptop.nbttech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080902150703.GA9406@ajones-laptop.nbttech.com>
Sender: linux-raid-owner@vger.kernel.org
To: Arthur Jones <ajones@riverbed.com>
Cc: Clive Messer <clive@vacuumtube.org.uk>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Arthur Jones wrote:
> Hi Clive, ...
>
> On Sat, Aug 30, 2008 at 02:30:52PM -0700, Clive Messer wrote:
>   
>> On Fri, 2008-07-25 at 12:03 -0700, Arthur Jones wrote:
>>     
>>> When rescheduling a bio in raid10, we wake up
>>> the md thread, but if the array is frozen, this
>>> will have no effect.  This causes the array to
>>> remain frozen for eternity.  We add a wake_up
>>> to allow the array to de-freeze.  This code is
>>> nearly identical to the raid1 code, which has
>>> this fix already.
>>>       
>> Can someone explain this to me in simple terms?
>>     
>
> The RAID sub-system needs to be able to synchronize
> certain operations, to do this, it "freezes" the
> array, i.e. no I/O will complete until it is un-frozen.
> This bug hit when we failed an I/O while the array
> was frozen.  In this case, we would never tell the
> frozen array that it was time wake up and get back
> to work and the retry would not make progress.
>
>   
>> What will cause a rescheduling of bio?
>>     
>
> If the first bio read attempt failed (e.g. broken
> disk -- or, in my case, using fault injection),
> then raid10 will retry the block I/O.
>
>   
>> Frozen for eternity - what will be the effect assuming my root file
>> system is on raid10?
>>     
>
> The failed I/O will not complete, the process which
> started the I/O will be stuck in an unkillable state
> forever.   Future I/O to the device would be put on
> hold (I guess, I never looked at this directly).
>
>   
>> I have a Fedora Core 9 box using a 4 disk f2 raid10 array. This is the
>> main partition and root file system. Every couple of days the machine
>> would hard lock. Sometimes I could ssh in. Most of the time not. I never
>> managed to catch anything to the logs with SysRq. With the benefit of
>> hindsight - if the kernel was 'jammed' writing to logfiles on a frozen
>> raid10 array that could explain it. I assumed faulty hardware. I have
>> actually replaced one at a time, (and at considerable expense), the
>> power supply, motherboard, processor, all 4 disks in the array. Still
>> the machine would lock-up. What is interesting is that I have managed 5
>> days uptime since I added this one line patch to
>> 2.6.25.14-108.fc9.x86_64. Could someone confirm for me that it is more
>> than likely that the hard locks I experienced on this machine could be
>> resolved by this one line patch? Has this patch now made it into an
>> official kernel release?
>>     
>
> It could be, but since you changed the drives
> and controller, it doesn't seem too likely.  You
> need some sort of failure to trigger this bug.
> Also, Sys-rq still worked fine for me when I
> triggered this bug...
>
> This patch is now in linus' git tree, but it
> looks like it missed 2.6.26, so it won't be in
> an "official" release until 2.6.27...
>   

I would hope that you or Neil would get it into the -stable series ASAP. 
While rare, this bug is a killer when it strikes.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


