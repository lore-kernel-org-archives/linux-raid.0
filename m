From: John Lange <john.lange@bighostbox.com>
Subject: Re: Problems with RAID1 using SATA disks.
Date: Wed, 12 May 2004 21:31:22 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1084415482.12530.33.camel@ws101.darkcore.net>
References: <40A255D5.3090602@acm.org> <1084381339.26186.5.camel@localhost>
	 <40A2B87B.7050306@acm.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40A2B87B.7050306@acm.org>
To: Gustavo Franco <stratus@acm.org>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

My original hunch was that you have a hardware problem of some kind. You
mentioned that you had a "crash" of some kind related to hardware before
and this further reinforces my feeling that its a hardware failure.

Your recent tests with dd seem to confirm this. Now its a process of
elimination. The easiest thing to try first is a memory test so put
memtest on a bootable CD and try that. I don't think its a RAM problem
because the times I've had bad RAM it causes a kernel panic, not a
hard-lock.

If your RAM checks out I'd remove the RAID card and try the drives
without the card. I don't suspect the drives themselves because you said
it locked up on all drives.

If you still get hard locks during any of these tests then it could be
the Motherboard or the CPU. Could the CPU overheating? The one other
thing that comes to mind is perhaps your power supply is not strong
enough to power everything? And finally, its a long shot but it could be
a bad network or video card. Just keep swapping things until the problem
goes away.

John

On Wed, 2004-05-12 at 18:51, Gustavo Franco wrote:
> John Lange wrote:
> 
> >On Wed, 2004-05-12 at 11:50, Gustavo Franco wrote:
> >  
> >
> >>linears, but i haven't assembled it yet, i'm having problems when i put
> >>heavy i/o on the linear array cited before.
> >>    
> >>
> >
> >You don't say what the problems are. Can you provide more details?
> >
> >Is it ONLY on the linear array?
> >  
> >
> Hi,
> 
> Sorry i've not clarified it on my post to linux-raid, only to 
> lkml[0].I've seen two oops
> and the kernel BUG (posted to lkml), and already comented here by 
> Christoph, only
> when i run the rsync clients against the rsync server running on this 
> machine storing
> files on a linear array. I can try to reproduce it again to post the 
> oops (one using xfs
> and the later with ext3) here, but i was hoping that someone have 
> already hit that.
> 
> By the way...Christoph can you give more details about that patch? Was 
> it merged
> on some kernel already released, i haven't checked it. Isn't strange 
> that a similar
> problem can be seen using ext3? FYI, at the moment i'm running on a 
> partition without
> raid linear, only xfs and in two days i'll report if the heavy i/o load 
> breaks it again or not.
> It seems that i've reached more than one bug through this process.
> 
>  <http://marc.theaimsgroup.com/?l=linux-raid&m=108438093424360&w=2#-0>[0] = http://www.uwsg.iu.edu/hypermail/linux/kernel/0404.1/0706.html
> 
> Thanks again,
> Gustavo Franco
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
John Lange
BigHostBox.com
(204) 885 0872

