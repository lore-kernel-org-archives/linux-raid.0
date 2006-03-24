From: Jim Klimov <klimov@2ka.mipt.ru>
Subject: Concept problem with RAID1?
Date: Fri, 24 Mar 2006 13:16:59 +0300
Message-ID: <212703968.20060324131659@2ka.mipt.ru>
Reply-To: Jim Klimov <klimov@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello linux-raid,

  In this rather long letter to the community of Linux RAID developers
  I would like to express some ideas on how to make the basic RAID1
  layer more reliable.

  I support a number of cheap-hardware servers for a campus network,
  and last year we decided to transfer our servers to mirrored hard
  disk partitions to improve reliability. As a matter of fact, seems
  it got worse, at least on one server. We do have problems with some
  data going corrupt while the submirrors are considered valid and are
  not moved out from the RAID metadevice for a rebuild/resync. Matters
  get worse when the problems are not detected by any layer below RAID
  and don't trigger an error, so the corrupt data seems valid to RAID.

  Most of our servers run a system based on linux-2.6.15, some older
  ones (and the problematic one in particular) run linux-2.4.31 or
  2.4.32 based on VIA Apollo 133 (694/694T) chipset, Dual P-III or
  Tualatin CPUs, some with additional Promise PCI IDE controllers.

  As far as I can tell, some events can cause corruption of data on
  the hard disk. We know, that's why we built RAID1 :)

  Events in particular are bad shutdowns/power surges, when the
  hardware might feel free to write random signal to the surface,
  and kernel panics which occur for uncertain reasons and sometimes
  leave the server frozen in the middle of some operation. In fact,
  some our disks are old and their data may dissipate over time :)
  We have an UPS so the former problem is rare, but the latter
  ones happen to occur.

  I understand that rolling in newer hardware for servers may help,
  but I want Linux to be reliable too :) I feel that the raid driver
  trusts too much to the data it has on disks which are not very
  trustworthy in the first place. It is also not right to believe
  that hardware errors will always be detected by SMART and remapped:
  really old disks may run out of spare sectors, for example.

  The problem is, that one of the disks in the mirror may have a
  newer timestamp, so when the system restarts, the metadevice
  rebuilds from it over a disk with an older time stamp. The
  source disk might in fact have corrupt data in some location
  where the destination disk had valid data, and vice versa,
  so the data loss occurs and propagates.

  I have even seen a case where the metadevice of the root file
  system was force-rebuilt from two inconsistent halves and the
  binaries were read in ok at some moment, then not executable
  trash just a bit later, then executable again.

  At least the reliable way of repairing a system was to leave
  it in single-user mode for a several hours to resync all its
  mirrored partitions, then fsck all metadevices and reboot to
  multiuser. Otherwise random problems can happen. With nearly
  a workday of downtime it is not exactly a reliable server...

  I hope I have depicted the problem we have as bad as it is.
  I also think I have a solution idea which can make mirroring
  a reliable option at the cost of space and/or write speed.
  In my case server IO is rare (like collecting syslogs from
  smart switches) so IO speed doesn't matter much.

  Alas, I am more of an administrator than a programmer, so I
  hope that the gurus who made the fine Linux OS can conjure
  up some solution faster and better than I would :)

  1) Idea #1 - make transactions. Write to submirror-1, verify,
     update timestamp, write to submirror-2, verify, update, etc.
     In this case since the write-verify part takes some long
     time, the kernel might want to define the more available
     device as a master for the current write (in case of parallel
     writes to different mirrors on same hardware).
  2) Idea #2 - In case we have more than two halves of a mirror,
     perhaps it is correct to check data on all of the halves
     (if their timestamps have close values) and rebuild not just
     the data from the most recently updated submirror, but the
     data which is the same on most submirrors?
  3) Idea #3 - follow the Sun. Metadevices in Solaris rely on
     "metadevice database replicas" which have some information
     about all the metadevices in the system - paths, timestamps,
     etc. and can be kept on several devices, not just the ones
     we have in the metadevice itself (i.e. in Linux we could
     keep a spare replica on a CF disk-on-chip). In case of a
     problem with disks, Solaris checks how many up-to-date
     replicas it has and if it has a quorum (more than 50% and at
     least 3 replicas), it rebuilds the meta devices automatically.
     Otherwise it waits for an administrator to decide which half
     of a mirror is more correct, because data is considered more
     important than the downtime.

  4) Here's an idea which stands off from the others a bit: make
     mirrors over a meta-layer of blocks with short CRCs (and perhaps
     personal timestamps). In case of rebuilding a device from
     submirrors which had random corrupted trash in a few blocks
     (i.e. noise from a landing HDD head) we can compare whichever
     parts of the two (or more) submirrors are valid and keep the
     consistent data in a repaired device.
     A shortcoming of this approach is that we won't be able to
     mount raw data of the partitions as we can now with a mirror.
     We'd have to make at least a metadevice of CRC'd blocks and
     mount it. In particular, support for such devices should be
     built in OS loaders (lilo, grub)...
     I believe that several hardware RAID controllers follow some
     similar logic. I.e. HP SmartArray mirrors are by some 5% smaller
     than the disks they are made of, according to diagnostics.

  5) And a little optimisation idea from Sun Solaris as well: could
     we define rebuild priorities for our metadevices? For example,
     if my system rebuilds the mirrors, I want it to complete small
     system partitions first (in case it fails again soon) and then
     go on to large partitions and rebuild them for hours. Currently
     it seems to pick them somewhat randomly.

  Ideas #1 and #2 can be an option for the current raid1 driver,
  ideas #3 and #5 are general LVM/RAID concepts, and idea #4
  is probably best made as a separate LVM device type (but raid1
  and bootloaders should take it into consideration for rebuilds).
  
  I hope that my ideas can help make the good Linux even better :)
     
-- 
Best regards,
 Jim Klimov                          mailto:klimov@2ka.mipt.ru

