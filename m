From: Info@quantum-sci.net
Subject: RAID10 Layouts
Date: Fri, 21 Aug 2009 06:27:06 -0700
Message-ID: <200908210627.06241.Info@quantum-sci.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello list,

Researching RAID10, trying to learn the most advanced system for a 2 SATA drive system.  Have two WD 2TB drives for a media computer, and the most important requirement is data redundancy.  I realize that RAID is no substitute for backups, but this is a backup for the backups and the purpose here is data safety.  The secondary goal is speed enhancement.  It appears that RAID10 can give both.

First question is on layout of RAID10.  In studying the man pages it seems that Far mode gives 95% of the speed of RAID0, but with increased seek for writes.  And that Offset retains much of this benefit while increasing efficiency of writes.  What should be the preference, Far or Offset?  Are they equally as robust?

How safe is the data in Far or Offset mode?  If a drive fails, will a complete, usable, bootable system exist on the other drive?  (These two are the only drives in the system, which is Debian Testing, Debian kernel 2.6.30-5)  Need I make any special Grub settings?

What about this Intel firmware 'RAID'?  Would this assist in any way?  How does it relate (if it does) to the linux md system?  Should I set in BIOS to RAID, or leave it at ACPI?

How does this look:
# mdadm --create /dev/md0 --level=raid10 --layout=o2 --metadata=1.2 --chunk=64 --raid-disks=2 missing /dev/sdb1

