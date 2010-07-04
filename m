From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: List of mismatched blocks?
Date: Sun, 4 Jul 2010 20:29:00 +0200
Message-ID: <slrni31knc.mgo.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <i0nr7l$jge$1@dough.gmane.org>
 <slrni2vate.mgo.Mario.Holbe@darkside.dyn.samba-tng.org>
 <i0pn2r$nir$1@dough.gmane.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Niobos <niobos@dest-unreach.be> wrote:
> I found out about cmp -l, but that gives me roughly 9 million differing
> bytes. They are nicely grouped in ranges, but I was hoping for a way
> that would output "sectors 517-523 and 4554-4559" or similar.

Well, a little awk (or whatever scripting language you prefer) script
afterwards? :)

> For the few mismatches that I calculated manually, the mismatching file
> seems to be the ext3-journal itself.

Yes, also a good bet.

On high-frequent changes this can unfortunately happen with RAID1 due to
the handling of dirty pages (there's a thread back in 2k6 here on the
list where Heinz Mauelshagen explained this quite nice - somewhere below
the Subject: No syncing after crash. Is this a software raid bug?).
I didn't notice it anymore since >2.6.26, so I thought it was fixed, but
this could also be because the probability shrunk due to new hardware.

> I'm running cmp on an active RAID. My guess is that this cause a large
> number of false positives: cmp reading both members at a different time,
> and hence reading a different version. That was the main reason to ask

Not very likely unless your filesystem is under very high load. To be
more specific: I did cmp -l my mirrors regularly before the "check"
sync_action had been developed (and still do it from time to time -
never trust... :)) and never experienced such things.


regards
   Mario
-- 
If you think technology can solve your problems you don't understand
technology and you don't understand your problems.
                                -- Bruce Schneier

