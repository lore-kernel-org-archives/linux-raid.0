From: "Marcus Williams" <marcus@quintic.co.uk>
Subject: RAID1 and auto-detect flag
Date: Thu, 12 Feb 2003 14:38:46 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <b2dm72$6s4$1@main.gmane.org>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi -
I have a RAID1, 2 disk mirror set that contains a drive that fails
intermittently (or at least gets disk errors intermittently and so
gets marked as failed). Obviously I want to swap the failing drive for
a new spare (we arent running with a spare currently).
So, I shutdown when the drive failed, replaced the drive and rebooted.
What this got me was a degraded root partition (md0) and a non-working
/export area (where the md1 device is mounted).
md0 (root device) is hda1 and hdc1
md1 (/export) is hda3 and hdc3
hda1 and hdc1 are tagged as bootable, and of type raid-autodetect. On
reboot the root partition gets auto-detected as raid, issues an error
about "invalid raid superblock magic on hda1" and automagically sorts
itself out mounting md0 in degraded mode.
However, md1 does not. The only difference I can think of is that the
md1 device is made up of two hd partitions that have not been set to
the auto-detect type (the raidtab entries for md0 and md1 are
identical bar the devices they use). When I reboot I get:
Feb 10 18:58:05 bart kernel: md: invalid raid superblock magic on hda3
Feb 10 18:58:05 bart kernel: md: hda3 has invalid sb, not importing!
Feb 10 18:58:05 bart kernel: md: could not import hda3!
Feb 10 18:58:05 bart kernel: md: autostart hda3 failed!
If I set the type to autodetect, will this device come up in degraded
mode instead of failing like this?
What I want is a system where, if a drive fails, someone can shut it
down, replace the failed drive, reboot in degraded mode (at this point
everyone else can start working again) and then partition the new
drive and raidhotadd it back into the set. At the moment I've got a
system thats got a more long winded process to repair (and requires
knowledge of the RAID setup).
Obviously having a spare in the set would be even better, but thats
not an option at the moment.
Thanks
Marcus
-- 
Marcus Williams - http://www.onq2.com
Quintic Ltd, 39 Newnham Road, Cambridge, UK


