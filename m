From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 01:19:34 +0100
Message-ID: <mdora2-n0n.ln1@news.it.uc3m.es>
References: <l1nna2-e9i.ln1@news.it.uc3m.es> <20050104024108.GK99565@caffreys.strugglers.net> <895qa2-0qa.ln1@news.it.uc3m.es> <200501042002.32292.maarten@ultratux.net> <j6dra2-9vs.ln1@news.it.uc3m.es> <16859.6326.605501.431357@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@cse.unsw.edu.au> wrote:
> On Tuesday January 4, ptb@lab.it.uc3m.es wrote:
> > Bits flip on our client disks all the time :(.  
> 
> You seem to be alone in reporting this.  I certainly have never
> experienced anything quite like what you seem to be reporting.

I don't feel the need to prove it to you via actual evidence.  You
already know of mechanisms which produce such an effect:

> Certainly there are reports of flipped bits in memory. 

 .. and that is all the same to your code when it comes to resyncing.
 You don't care whether the change is real or produced in the cpu, on the
bus, or wherever. It still is what you will observe and copy.

> If you have
> non-ecc memory, then this is a real risk and when it happens you
> replace the memory.


Sure.

> Usually it happens with a sufficiently high
> frequency that the computer is effectively unusable.

Well, there are many computers that remain usable. When I see bit flips
the first thing I request the techs to do is check the memory and keep
on checking it until they find a fault. I also ask them to check the
fans, clean out dust and so on.

In a relatively small percentage of cases, it turns out that the changes
are real, on the disk, and persist from reboot to reboot, and move with
the disk when one moves it from place to place.  I don't know where
these come from - perhaps from the drive electronics, perhaps from the
disk. 

> But bits being flipped on disk, without the drive reporting an error,
> and without the filesystem very quickly becoming unusable, is (except
> for your report) unheard of.

As far as I recall it is usually a bit flipped througout a range of
consecutive addresses on disk, when it happens. I haven't been
monitoring this daily check for about a year now, however, so I don't
have any data to show you.

> md/raid would definitely not help that sort of situation at all.

Nor is there any reason to suggest it should - it just doesn't check.
It could.



Peter

