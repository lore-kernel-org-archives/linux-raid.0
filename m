From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID6 growing interrupted, array won't assemble or resume growing
Date: Fri, 07 Jun 2013 08:43:54 -0400
Message-ID: <51B1D58A.3010309@turmel.org>
References: <CAGjXdAhMHEFFc1C0XUSY_K1ZxwaRG-x=NEw9H2Aiv+YtNat-tw@mail.gmail.com> <51B0C769.1070009@turmel.org> <CAGjXdAj+xsW=Ut9EUz65Ha_ZaGwgzJwRG6vh+9S60jpCK1qNpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGjXdAj+xsW=Ut9EUz65Ha_ZaGwgzJwRG6vh+9S60jpCK1qNpA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nic Wolfe <nic@wolfeden.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/07/2013 12:15 AM, Nic Wolfe wrote:
> My original post had an error - sda is my boot drive, it's not part of
> the array. The 6th drive is as follows:
> 
> /dev/sdg:

[trim /]

>       Number   Major   Minor   RaidDevice State
> this     5      65        0        5      active sync

Before you move drives around, please spend some time correlating drive
serial numbers to the "RaidDevice" number for each.  Just in case.  You
may be able to get everything you need from /dev/disk/by-id/, but with a
weird driver, I not sure.

>> Your reshape is barely started.  Presumably you specified a --backup
>> clause in the original --grow command.  You will need that file.
> 
> Embarrassingly I have no backup file from the grow operation.

mdadm should have halted if it knew it was needed.  You may be ok.

>> Modern mdadm should be able to force assemble this and continue without
>> problems.  Rather than operate within a questionable environment, I
>> would strongly encourage you to perform the forced assembly with a
>> recent live cd.  I personally use "SystemRescueCD", and I know it has
>> the appropriate kernel support and tools.
>>
>> But.  You need to share more information about your hardware problems.
>> Dmesg, etc.  There are commonly-encountered configuration problems that
>> appear to be mysterious drive failures.  If you know all about error
>> recovery control, please elaborate.  Otherwise, please share the output
>> of "smartctl -x /dev/sdX" for all of your member devices.
> 
> My drives are connected to the machine through a poorly supported old
> RAID card (rr2522) which required me to build the driver into my
> kernel, so I don't think a live cd will work. I don't have enough SATA
> slots in the machine to connect them all without it.

Hmmm.  That's ugly.

> If it isn't obvious by now, I definitely don't know anything about
> error recovery control.

Well, search the archive for terms like "scterc", "ure", and/or
"timeout".  You'll need to address the issue if you don't have
enterprise drives.

> Since it's a RAID card and not just a hba each drive is presented to
> the OS as a single drive JBOD array which means the OS doesn't see any
> SMART info. I can see (at least some) SMART information through my
> RAID card admin console and it claims they're all fine.

Drives with pending unrecoverable read errors won't make it through a
rebuild, but show "PASSED" to smart.  The details matter.

> I am not having hardware problems at the moment, I only encountered
> them when I had 16 drives running through the RAID card (I have
> another 10 drive array). With the other array disconnected the card
> seems to be behaving - there's nothing suspicious that I can see in
> dmesg.

That sounds like insufficient power.

> In the meantime I will see if I can put together a machine with 6 SATA
> ports and attempt to hook the drives up directly rather than through
> the RAID card so I can use a live CD and get the SMART information for
> you.

Good plan, but do get the serial numbers vs. array role info.  Probably
should finish the reshape in such a machine, too.

Phil
