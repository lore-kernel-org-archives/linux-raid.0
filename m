From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing
 repeatedly and hard)
Date: Mon, 3 Jan 2005 10:30:12 +0100 (MET)
Message-ID: <200501030930.j039UCF24358@inv.it.uc3m.es>
Reply-To: ptb@inv.it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

"Also sprach Guy:"
> "Well, you can make somewhere. You only require an 8MB (one cylinder)
> partition."
> 
> So, it is ok for your system to fail when this disk fails?

You lose the journal.  I don't remember what ext3fs does in that case.
I seem to recall that it feels ill and goes into read-only mode, but it
may feel sicker and just go toes up.  I don't recall.  That journals
kept dying on me for systems like /var taught me to put them on
disposable media when I did use to use them there ...

You can definitely react with a simple tune2fs -O ^journal or whatever
is appropriate. I know that because Ted Tso added the "force" option to
tune2fs at my request, when I showed him a system that had lost its
journal and wouldn't remove it from its metadata BECAUSE the journal
was not there to be removed.

> I don't want system failures when a disk fails,

Your scenario seems to be that you have the disks of your mirror on the
ame physical system.  That's fundamentally dangerous - they're both
subject to damage when the system blows up.  I instead have an array
node (where the journal is kept), and a local mirror component and a
remote mirror component.

That system is doubled, and each half of the double hosts the others
remote mirror component. Each half fails over to the other.

There it makes sense to have the journal separate, but local on the
array node(s), not mirrored.  The FS on the remote mirror is guaranteed
consuistent, becuase of the local journal.  That's what I want.  I don't
know precisely what would be in the journal on the remote side if I
mirrored it, but I am sure I would want to roll it back, not complete it
(the completer just died!), so why have it there at all?

> so mirror (or RAID5)
> everything required to keep your system running.
> 
> "And there is a risk of silent corruption on all raid systems - that is
> well known."
> I question this....

?

> I bet a non-mirror disk has similar risk as a RAID1.  But with a RAID1, you

The corruption risk is doubled for a 2-way mirror, and there is a 50%
chance of it not being detected at all even if you try and check for it,
because you may be reading from the wrong mirror at the time you pass
over the imperfection in the check.

Isn't that simply the most naive calculation? So why would you make
your bet!

And then you don't generally check at all, ever.

But whether you check or not, corruptions simply have only a 50% chancce
of being seen (you look on the wrong mirror when you look), and a 200%
chance of occuring (twice as much real estate) wrt normal rate.

In contrast, on a single disk they have a 100% chance of detection (if
you look!) and a 100% chance of occuring, wrt normal rate.

> know when a difference occurs, if you want.

How!

Peter

