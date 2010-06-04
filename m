From: Matthias Dahl <ml_linux_raid@mortal-soul.de>
Subject: mdadm-3.1.2 causes high udev cpu load (100%) and breaks startup
Date: Fri, 4 Jun 2010 08:57:09 +0200
Message-ID: <201006040857.10099.ml_linux_raid@mortal-soul.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all.

I apologize for the scarce informations in advance and I usually try to debug
things myself but I _need_ my machine and this was really a show stopper for
me. :(

I am using a up2date Gentoo x86_64 system and upgrading mdadm from 3.1.1 to 3.1.2
caused some strange behaviour wrt to udev (154). Once udev fires up, it stalls for
quite some time w/ very high cpu usage. Start up then proceeds w/ a lot of change
events printed to the screen for the three raid 5 devices I have. udev stays @ 100%
cpu usage after that and monitoring it shows there are _a lot of_ raid change events
coming in. The start up eventually stucks completely when the crypt swap is getting
setup.

Reverting back to mdadm 3.1.1 solved this completely. I tried a few dozen
times, gone through the boot process interactively and checked w/ udevadmn but
I was unable to figure out what was actually going wrong. The udev rules coming
from mdadm haven't changed at all. Due the fact that mdadm itself is used while
processing the incoming change events, it sounds reasonable that some required
functionalty is broken or gets stuck (or even issues new events?).

Some hints that might help:

 - I've 3 sw raids (raid1, raid5)
 - the raid5 is a partitioned raid5 setup

After several failed boots I've seen that the raid5 is being resynced. I'm pretty
confident that this was caused by the many failed boots earlier and is not relevant
to this bug. Nevertheless to be complete, I thought I'd mention it.

System specs:

$ uname -a
Linux dreamgate 2.6.33.3 #1 SMP PREEMPT Tue Apr 27 14:15:04 CEST 2010 x86_64 Intel(R)
Core(TM) i7 CPU 860 @ 2.80GHz GenuineIntel GNU/Linux

glibc-2.11.1, udev 154

Last but not least, I also opened a bug report over @ Gentoo's Bugzilla:

 	http://bugs.gentoo.org/show_bug.cgi?id=322711

If there is anything I can do to further help narrow this down and fix it, please
just let me know. Thanks in advance...

So long,
matthias
