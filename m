From: Gustavo Franco <stratus@acm.org>
Subject: Re: Problems with RAID1 using SATA disks.
Date: Thu, 13 May 2004 21:37:41 -0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40A414D5.1030602@acm.org>
References: <40A255D5.3090602@acm.org> <1084381339.26186.5.camel@localhost>	 <40A2B87B.7050306@acm.org> <1084415482.12530.33.camel@ws101.darkcore.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1084415482.12530.33.camel@ws101.darkcore.net>
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

John Lange wrote:

>My original hunch was that you have a hardware problem of some kind. You
>mentioned that you had a "crash" of some kind related to hardware before
>and this further reinforces my feeling that its a hardware failure.
>
>Your recent tests with dd seem to confirm this. Now its a process of
>elimination. The easiest thing to try first is a memory test so put
>memtest on a bootable CD and try that. I don't think its a RAM problem
>because the times I've had bad RAM it causes a kernel panic, not a
>hard-lock.
>
>If your RAM checks out I'd remove the RAID card and try the drives
>without the card. I don't suspect the drives themselves because you said
>it locked up on all drives.
>
>If you still get hard locks during any of these tests then it could be
>the Motherboard or the CPU. Could the CPU overheating? The one other
>thing that comes to mind is perhaps your power supply is not strong
>enough to power everything? And finally, its a long shot but it could be
>a bad network or video card. Just keep swapping things until the problem
>goes away.
>
>  
>
John, thank you for all your sugestions.I've already done memtest run 
through many hours,
and a new test today that seems to be the end of my posts here. :)

I've tested the same process against a partition "released" from that 
linear array and the machine
still freezes.I can't say if it was a BUG(), a oops, or anything like 
that because i can't go to the
data center check today.I'll look into the patch described by Chrystoph, 
because it's a random
and strange hardware failure (maybe the controller) or a libata bug and 
not only a xfs bug (read
my previous post).I'll try get this machine back to the lab to do all 
the tests necessary and report
to lkml if it isn't a hardware failure.

Thank you,
Gustavo Franco
