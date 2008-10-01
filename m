From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: SATA errors?
Date: Wed, 1 Oct 2008 18:03:50 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0810011803180.30506@p34.internal.lan>
References: <48E34221.1000008@agenda.si> <20081001100833.3253724847@gemini.denx.de> <48E353D5.1060908@agenda.si> <A20315AE59B5C34585629E258D76A97C02180F8B@34093-C3-EVS3.exchange.rackspace.com> <48E36A61.4020903@dgreaves.com>
 <A20315AE59B5C34585629E258D76A97C021D052A@34093-C3-EVS3.exchange.rackspace.com> <48E3ED4D.6000409@agenda.si>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48E3ED4D.6000409@agenda.si>
Sender: linux-raid-owner@vger.kernel.org
To: Danilo Godec <danilo.godec@agenda.si>
Cc: David Lethe <david@santools.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Wed, 1 Oct 2008, Danilo Godec wrote:

> I don't want to start any holly wars, but I'm not using a RAID controller. 
> It's just a plain old on-board SATA controller (at least that's what I think 
> it is):
>
> 00:1f.2 SATA controller: Intel Corporation 631xESB/632xESB SATA Storage 
> Controller AHCI (rev 09)
>
> David Lethe wrote:
>> If this was my system, I would ...
>> 1) First check into upgrading firmware/bios/drivers of disk controller.
>> 2) Look at cron jobs and see if anything that needs capacity runs around
>> the time the errors are reported.  Something has to run to start this
>> off, so you need to find it.  3) Use logger and a shell script to try to 
>> catch system in the 15 second
>> window when you have this problem, and see what programs are running. 4) 
>> Actually, if this was my system, and if I/O wasn't actually being
>> suspended during those 15 seconds, then I probably would do step 1 only,
>> and if everything is current, then I would move on and not worry about
>> it.   Even if you find the offending program, then that doesn't mean
>> that the author of the program has or will make an acceptable change in
>> their code. 
> 1. I will get a new server in a couple of days and then I'll be able to move 
> the Xen VM's from the 'problematic' server. Then I'll see what can be 
> updated/upgraded.
> 2. The errors are pretty much random and there is nothing in the cron at all. 
> I don't think Xen VM's could do anything with the physical drive, so their 
> crons shouldn't be relevant.
> 3. It's not really a problem that we (the users) would feel. It's just the 
> logs that got me worried (I don't like unexplainable hard drive errors).
> 4. As said before, I changed the scripts to use 'smartctl' with one of the 
> other drives. So far it seems better - there hasn't been a single error in 12 
> hours.
>> The problem you have from SCSI perspective is the bozo who wrote this
>> chunk of code did it the wrong way. The CORRECT way to determine
>> addressable blocks is to send out the READCAP10, look for return value
>> of FFFFFFFFh blocks, then issue a 16-byte (0x9e 0x10) READ CAPACITY,
>> because you have > FFFFFFFE blocks on the disk.  This architect never
>> imagined that the READCAP10 would have to deal with large disks, and
>> assumed if there was a problem, then the disk needs to be reset. 
> If it turns out that 'smartctl' was causing this I'll report it to 
> 'smartmontools' guys.
>
> Thanks for the help, Danilo
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I actually turned off smart(daemon) /etc - the problems still persist for 
me..

Justin.
