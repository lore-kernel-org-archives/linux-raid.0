From: Corey Hickey <bugfood-ml@fatooh.org>
Subject: Re: 2.6.20: reproducible hard lockup with RAID-5 resync
Date: Fri, 16 Feb 2007 13:23:33 -0800
Message-ID: <45D620D5.3060805@fatooh.org>
References: <45D55366.4010904@fatooh.org> <17877.25722.404051.470040@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17877.25722.404051.470040@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Thursday February 15, bugfood-ml@fatooh.org wrote:
>> I think I have found an easily-reproducible bug in Linux 2.6.20. I have
>> already applied the "Fix various bugs with aligned reads in RAID5"
>> patch, and that had no effect. It appears to be related to the resync
>> process, and makes the system lock up, hard.
> 
> I'm guessing that the problem is at a lower level than raid.
> What IDE/SATA controllers do you have?  Google to see if anyone else
> has had problems with them in 2.6.20.

I have an nForce3 motherboard. lspci calls my IDE:
nVidia Corporation CK8S Parallel ATA Controller (v2.5) (rev a2)
...and my SATA:
nVidia Corporation CK8S Serial ATA Controller (v2.5) (rev a2)

I'm using libata for my SATA drives and the old IDE driver for my IDE 
drive. For reference, I have uploaded my kernel configuration and the 
output of lspci:
http://fatooh.org/files/tmp/config-2.6.20
http://fatooh.org/files/tmp/lspci-v

Anyway, I googled a bit, and I also looked through the recent threads in 
the linux-kernel archives, but I haven't found anything. I don't follow 
kernel development closely, though, so it's quite possible I missed 
something.

When I get home (late) tonight I'll try running dd and badblocks on the 
corresponding drives and partitions.

>> During the lock up, nothing is printed to the console, and the magic
>> SysRQ key has no effect; I have to poke the reset button.
> 
> Sound's like interrupts are disabled, but x86_64 always enables the
> NMI watchdog which should trigger if interrupts are off for too long. 

How long is "too long"? I waited a few minutes, at least, on the first 
few tries.

> Do you have CONFIG_DETECT_SOFTLOCKUP=y in your .config (it is in the
> kernel debugging options menu I think).  If not, setting that would be
> worth a try.

I do indeed have CONFIG_DETECT_SOFTLOCKUP enabled. The Kconfig 
description says it should detect lockups > 10 seconds, I've waited 
longer than that many times.

> A raid5 resync across 5 sata drives on a couple of different
> silicon-image controllers doesn't lock up for me.

Heck. ;)  Would it by any chance make a difference that I'm running 
RAID-5 across a mixture of drives and partitions?

Thanks again,
Corey
