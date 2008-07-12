From: Gerhard Wiesinger <lists@wiesinger.com>
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
Date: Sat, 12 Jul 2008 10:29:59 +0200 (CEST)
Message-ID: <alpine.LFD.1.10.0807121025310.10748@bbs.intern>
References: <alpine.DEB.1.10.0807051252200.12562@p34.internal.lan> <alpine.LFD.1.10.0807071649340.1160@bbs.intern> <alpine.LFD.1.10.0807071705490.2997@bbs.intern> <alpine.DEB.1.10.0807071149530.32508@p34.internal.lan> <alpine.LFD.1.10.0807080811560.5439@bbs.intern>
 <alpine.DEB.1.10.0807080433550.17980@p34.internal.lan> <alpine.LFD.1.10.0807081232350.32659@bbs.intern> <alpine.DEB.1.10.0807080915040.23688@p34.internal.lan> <alpine.LFD.1.10.0807090726200.686@bbs.intern>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0807090726200.686@bbs.intern>
Sender: linux-ide-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids



On Wed, 9 Jul 2008, Gerhard Wiesinger wrote:

> On Tue, 8 Jul 2008, Justin Piszcz wrote:
>
>>>>>> Hi Gerhard,
>>>> 
>>>> Please run:
>>>> 
>>>> smartctl -t short /dev/sdc
>>>> sleep 300
>>>> smartctl -t long /dev/sdc
>>>> 
>>>> Wait 2-3 hours or more and:
>>>> 
>>>> smartctl -a /dev/sdc
>>> 
>>> 
>>> I'm changing the disk one more time ...
>> 
>> Once you replace the disk please re-run the tests shown above and show us 
>> the output please.
>> 
>> How many SAMSUNG disks have you gone through, do they really fail that 
>> often?
>> 
>
> Hello Justin!
>
> Setup Power suppply:
> sda-sdd are on the same power supply cable, sde, sdf are on a second one.
>
> I changed the disk to a new SAMSUNG disk and the first raid resync did NOT 
> work and I had 1 reallocated sector ...
>
> Also the RMA guy at our very good computer store (http://www.ditech.at/) were 
> helpfull in changing the disks and he hates the SAMSUNG disks because of high 
> RMA rates ...
>
> But:
> smart checks were ok (details see below). The smart checks are shown as 
> aborted, but before running the next tests they were at "Completed without 
> error" (strange).
>
> Now sdc has it's own power cable and I'm running a raid resync now.
>
> Power supply is:
> ATX 385 Watt, ENERMAX PRO82+
>
> Load on power supply measured on 220V side with a true RMS Wattmeter:
> Power off: 6,5W
> Max seen at power up: 196W
> BIOS: 114,1W
> Linux idle: 92,0W
> 100% Disk I/O, 100% CPU load: 149,6W
> => Everything fine and as expected.
>
> I'll keep you up to date ...
>

Hello!

It looks like it works now without any problems:
*) Serveral RAID checks (once a day)
*) smartctl checks were fine
*) Only one reallocated sector
*) Writing the disk full with random data

So the possibilities for the fault are:
*) SATA power connector (most likely I would guess)
*) 4th disk is now ok
*) Other 220V power cable connector through the Wattmeter

Ciao,
Gerhard

--
http://www.wiesinger.com/
