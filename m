From: Gaspar Bakos <gbakos@cfa.harvard.edu>
Subject: RAID readonly before final shutdown
Date: Wed, 10 Aug 2005 11:27:24 -0400 (EDT)
Message-ID: <Pine.SOL.4.58.0508101126520.23305@titan.cfa.harvard.edu>
Reply-To: gbakos@cfa.harvard.edu
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

The entire OS I am using is running on software RAID-1. Before killing
the power of the UPS (in case of a power outage), I issue:

/sbin/mdadm --readonly $RAIDDEV
on all the RAID devices I have.

This, however, does not seem to be enough, and when i power the system
back on, the RAID arrays are not clean, and a long syncing starts. A
last step is missing; something like marking the arrays that they are
clean. I see this happening for a flash of a second when i tell the PC
to "/sbin/poweroff", i.e. "halt -p". The very last second, before the
ATX power is turned OFF, the kernel does something to the md arrays.

My questions are:
1. What exactly is this last step?
2. Can I achieve it manually by sth like
 echo *** > /proc/***
or by using mdadm?

Cheers
Gaspar
