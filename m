From: maarten <maarten@ultratux.net>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Mon, 3 Jan 2005 19:30:36 +0100
Message-ID: <200501031930.36356.maarten@ultratux.net>
References: <m3is6k4oeu.fsf@reason.gnu-hamburg> <41D93657.7090908@tls.msk.ru> <a41oa2-fr7.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a41oa2-fr7.ln1@news.it.uc3m.es>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 03 January 2005 15:23, Peter T. Breuer wrote:
> Michael Tokarev <mjt@tls.msk.ru> wrote:
> > Peter T. Breuer wrote:

> Therefore, I have learned not to build a system that is more complicated
> than the most simple human being that may administer it. This always
> works - if it breaks AND they cannot fix it, then THEY get the blame.
>
> So I "prefer" to not have a raided boot partition, but instead to rsync
> the root partition every day to a spare on a differet disk, or/and at the
> other end of the same disk. This also saves the system from sysadmin
> gaffes - I don't WANT an instantaneous copy of every error made by the
> humans.

There certainly is something to be said for that...  
However, I do expect an admin to know about the raid system that's being used, 
else they would have no business being near that server in the first place. 

> > disks are really 35Gb or 37Gb; in case they're differ, "extra" space
> > on large disk isn't used); root and /boot are on small raid1 partition
> > which is mirrored on *every* disk; swap is on raid1; the rest (/usr,
>
> I like this - except of course that I rsync them, not raid them. I
> don't mind if I have to reboot a server. Nobody will notice the tcp
> outage and the other one of the pair will failover for it, albeit in
> readonly mode, for the maximum of the few minutes required.

I tend to agree, but it varies widely with the circumstances.  I've had 
servers in unattended colo facilties, and your approach will not work too 
well there.

> That's actually not so. Over new year I accidently booted my home
> server (222 days uptime!) and discovered its boot sector had evaporated.

We've all been there...  :-(

> Well, maybe I moved the kernels ..  anyway, it has no floppy and the
> nearest boot cd was an hour's journey away in the cold, on new year.  Uh
> uh.  It took me about 8 hrs, but I booted it via PXE DHCP TFTP
> wake-on-lan and the wireless network, from my laptop, without leaving
> the warm.

Congrats, but I do hope you did that for your home server...!  Cause I'd have 
severe moral and practical difficulties selling that to a paying customer:  
"So instead of billing me a cab fare and two hours, you spent eight hours to 
fix this.  And you seriously expect me to pay for those extra hours ?" 

> > to allocate that space on every of 2 or 3 or 4 or 5 disks).  So
> > it isn't quite relevant how fast the filesystem will be on writes,
> > and hence it's ok to place it on raid1 composed from 5 components.
>
> That is, uh, paranoid.

We also did use three-way raid-1 mirrors as a rule.
(but I am indeed somewhat paranoid ;-)


> > In case of some problem
> > (yes I dislike any additional layers for critical system components
> > as any layer may fail to start during boot etc), you can easily
> > bring the system up by booting off the underlying root-raid partiton
> > to repair the system -- all the utilities are here.  More, you can
>
> Well, you could, and I could, but I doubt if the standard tech could.

I've said it before and I'll say it again:  An admin has to be competent. If 
not, there is little you can do.  You can't have fresh MCSE people fix linux 
problems, and you cannot have a carpenter selling stock on wall street.

A "standard tech" as you say, has a skill level that enables him to swap a 
drive of a hotswap server if so directed, but anything beyond that is 
unrealistic, and he will need adequate help (be it remote by telephone, or 
whatever means).  Or very extensive onsite step by step documentation.

> But why bother? If you didn't have raid there on root you wouldn't
> need to repair it. Nothing is quite as horrible as having a
> fubarred root partition.  That's why I also always have two! But I
> don't see that having the copy made by raid rather than rsync wins
> you anything in the situaton where you have to  reboot - rather, it
> puts off that moment to a moment of your choosing, which may be good,
> but is not an unqualified bonus, given the cons.

Both approaches have their merits.  In one case the danger lies in not having 
updated the rsync mirror recently enough, in the other a rogue change will 
affect all your mirrors.  Without further info on the specific circumstances 
no choice can be made, it really depends on too many factors. 

> > And yes I'm aware of mdp devices (partitions inside the raid
> > arrays).. but that's just another layer "which may fail": if
> > raid5 array won't start, I at least can reconstruct filesystem
> > image by reading chunks of data from appropriate places from
> > all drives and try to recover that image; with any additional
>
> Now that is just perverse.

Not neccessarily.  I've had to rely on using dd_rescue to get data back at 
some point is time. In such scenarios, any additional layer can quickly 
complicate things beyond reasonable recourse.
As you noted yourself, keeping a backup stategy can be hard work. ;-|

> > Note above about swap: in all my
> > systems, swap is also on raid (raid1 in this case).  At the first
> > look, that can be a nonsense: having swap on raid.  But we had
> > enouth cases when due to a failed drive swap becomes corrupt
> > (unreadable really), and the system goes havoc, *damaging*
> > other data which was unaffected by the disk failure!  With
>
> Yes, this used to be quite common when swap had that size bug.

When you have swap on a failed disk, often the safer way is to stop the 
machine by using the reset button instead of attempting a shutdown.
The shutdown would probably fail halfway through anyway...

Maarten

