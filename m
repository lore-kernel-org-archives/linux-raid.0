From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: No syncing after crash. Is this a software raid bug?
Date: Fri, 3 Mar 2006 15:30:29 +0100
Message-ID: <du9ju5$6c5$1@sea.gmane.org>
References: <20060301124432.GA3591@hactar.lan> <20060301215641.GA27042@hactar.lan> <du6t39$be5$1@sea.gmane.org> <20060303133952.GA2976@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Heinz Mauelshagen <mauelshagen@redhat.com> wrote:
> The fact that mirrors in a RAID1 set partially differ even on propper
> shutdown is caused by the ability to change dirty pages *while* they
> are being accessed (ie. by a mirroring driver).

That's quite the scenario what I thought about, but more clear now,
thanks.
But when a dirty page is modified while it's being accessed, it stays
dirty and gets cleaned (i.e. written to disk) later again, right? This
would imply that the mirrors should always be equal after a clean
shutdown, which in fact is not true.

> Mind you that this is a block level inconsistency only, because the
...
> An example for a filesystem causing this is a file write followed
> by a file truncation.

Yes, this is also quite similar to the scenario what I thought about -
especially it suggests that this case happens only on "free" space.

However, Kaspers case is a bit different, since it involves swap space,
which leads to the suspicion that there are cases where mirror
differences could occur also on "non-free" space (although there is
of course also something like "free" space on swap and one had to
analyze if it's such space that is affected, which most likely isn't
the simplest thing at all :)). While swap is probably quite robust
against such a scenario, since it's not valid after a reboot anymore,
I could imagine other cases (i.e. database raw devices) where subsequent
reads lead to different data due to the different mirrors, isn't it?
And couldn't this happen even on swap without reboot inbetween when a
page really needs to be read from disk?


regards
   Mario
-- 
File names are infinite in length where infinity is set to 255 characters.
                                -- Peter Collinson, "The Unix File System"

