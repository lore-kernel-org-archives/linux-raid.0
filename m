From: jtroan@jt-sw.com
Subject: Resurrecting a Dirty RAID-5
Date: Wed, 8 Jul 2015 08:14:27 -0400
Message-ID: <OFC233BA12.DDED55A2-ON85257E7C.00420655-85257E7C.0043331F@jt-sw.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I've accidentally toasted a software RAID-5 on one of my VM hosts, taking a
small number of VMs with it.  (Fortunately, no unique data was lost as
every server has a "twinned" system or the data can be regenerated from
elsewhere via script.)

Short background --  the system is RHEL 6.5 and has a three-drive RAID-5
with most of the space.  ( /boot is a RAID-1 and it seems to be fine in a
degraded state.)   The system locked up when (presumably) one of the drives
died.  Upon reboot, I saw errors for "ata2", so I naturally forgot that the
drives started at ata0 and unplugged the drive at "SATA2" (DOH!).  The
system errored and halted its boot when the root file system was no longer
available.  I then switched around cables and brought up ata0 and ata1, but
the RAID won't start because of the dirty broken raid.

I booted from the RHEL 6.5 DVD and entered rescue mode.  Using information
from the Linux RAID wiki [1], I was able to confirm that my sd0 and sd1
drives are alive and have all three partitions I had originally deployed to
them -- /boot, /, and swap space.

Following the advice on the wiki [1], I'm asking for some help in using
mdadm via rescue mode in trying to get this dirty RAID-5 back on its feet
with the surviving two drives.  (I've got a third drive already on hand
that's I'll then use to bring the RAID back to full robustness.)

[1] https://raid.wiki.kernel.org/index.php/RAID_Recovery


Many thanks for any assistance that can be provided.....

=======================================================================
John M. Troan  <jtroan@jt-sw.com>
Maintainer: Football Site @ JT-SW.com
  http://www.jt-sw.com/football
Chief of Computer Operations
  U.S.S. Kitty Hawk / NCC-1659
=======================================================================

