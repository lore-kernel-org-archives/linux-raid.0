From: "Vincze, Tamas" <vincze@neb.com>
Subject: Dirty flag during resync
Date: Thu, 05 Jul 2007 17:34:13 -0400
Message-ID: <468D63D5.8010006@neb.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Could someone tell me whether the dirty flag is kept set during the
entire resync of a raid-5 array? (using FC5 kernel 2.6.15)

And why isn't a resync aborted when it sees disk errors?

Here's the story:
A drive was kicked out of the array after reporting a parity error.
I ran the short, conveyance and long SMART tests and no errors were
found so I thought it must be the cable. I replaced the cable and
re-added the failed drive, unfortunately in full multiuser mode.
The HDD led came on and a few seconds later it became unresponsive
(mouse pointer wouldn't move, ctrl+alt+f1 had no effect) so powered
the box down (has no reset button). The next boot failed because I had
a dirty degraded array. I booted from the FC5 rescue CD and used mdadm -A
--force to clear it and also ran fsck that fixed a pageful of errors.
I haven't tried to add the disk back to the raid-5 array.

I also have a small (200MB) raid-1 setup on the same disks for the boot
partition and while on the rescue CD I experimented with that a bit.
When I ran mdadm -A --force on this raid-1 array I also experienced
an unresponsiveness: cat /proc/mdstat was hanging for several seconds
before displaying mdstat. The parity error messages were appearing
in syslog in about 1 minute intervals, but the resync continued
according to mdstat. I couldn't do a clean shutdown this time either
because that was hanging too for several minutes before I hit the
power switch.

My main concern is silent corruption. I figured if the dirty bits
got set when the raid-5 resync started and it was just hanging while
trying to write the re-added disk then chances of a silent corruption
should be really low. Am I right?

-Tamas
