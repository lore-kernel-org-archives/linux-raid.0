From: <linux-raid.vger.kernel.org@atu.cjb.net>
Subject: =?UTF-8?B?UkFJRC02IG1kYWRtIGRpc2tzIG91dCBvZiBzeW5jIGlzc3VlIChsb25nIGUtbWFpbCk=?=
Date: Wed, 10 Jun 2009 02:52:20 -0600
Message-ID: <200906100852.n5A8qPbB034265@cjb.net>
References: <S1752989AbZFJCy5/20090610025457Z+40@vger.kernel.org>
Reply-To: <linux-raid.vger.kernel.org@atu.cjb.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <S1752989AbZFJCy5/20090610025457Z+40@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello Linux-RAID mailing list.

Any help from those with more knowledge than myself would
be greatly appreciated.

I apologise if this e-mail is overly long or if this isn't
the right place to post it.  I feel very brain-dead right
now, as I am quite worried about losing the data and have
been poking away at it for the past 14 hours today and 5
hours last night.

I use Linux software RAID (mdadm) to manage two disk
arrays, a RAID-6 data array with 8x1TB disks (large
partitions on each disk), and a RAID-5 swap array with
the same 8 disks (small partitions at the end of each
disk).  On top of the RAID arrays are a layer of Linux
Device-Mapper encryption, which I don't think is important
to this e-mail, but adding it just in case.

I am currently using an Ubuntu 64bit distro.  Before this
problem happened, I had not rebooted the computer for 4.5
months, and was using Ubuntu 8.10 with Linux kernel 2.6.17.
I upgraded this to Ubuntu 9.04 while the system was up,
and had not yet rebooted into the newly installed system
(with kernel 2.6.28).  On June 3rd one of the eight disks
disconnected.  I was too busy with work to deal with it,
and didn't think there would be any problem waiting a few
days to get to it.

On the morning of June 7th another disk disconnected, which
I first noticed when I got home from work late last night
(there was an issue in the mdadm.conf which was preventing
me from receiving mdadm notification e-mails, which has
been resolved now).

(You can safely skip the end of the e-mail if you want,
where I give a current status summary of the array).

I am not sure what caused the disconnects, either an issue
in the kernel or loose connecting wires (more likely,
as I moved the computer a couple feet the day before the
first disk dissappeared).

Main devices:

   /dev/sdi1 is an old 160GB IDE disk with my "/"
   partition, where my distro lives.

   /dev/md13 is the RAID-6 data array, the important one,
   comprised of /dev/sda1 through /dev/sdh1.

   /dev/md9 is the RAID-5 swap array, which my friend and
   I have been playing with today, so it should be ignored,
   comprised of /dev/sda2 through /dev/sdh2.

   /dev/md0 was apparently created as a result of Ubuntu
   upgrading, as it wasn't there before I rebooted last
   night.  It doesn't show up in /proc/mdstats.

At that point I was substantially worried, with only
6 of 8 disks working.  So, I went to single user mode
(telinit 1) at 1:20AM on June 9th.  In single user mode
I tried unmounting the filesystem on the RAID-6 array,
and was eventually able to do so once I unmounted some
stuff that was mounted inside it.

After unmounting the filesystem, the mdadm still reported
that it was in the state "clean, degraded" with 6 of 8
disks working.  I used "cryptsetup remove" to remove the
hard drive encryption layer, and so the RAID-6 array was
(I thought) cleanly taken care of and safe to shut down
the computer.  I couldn't see how any more changes could
happen to the RAID-6 array, as nothing was using the
disks anymore.

After this I did "swapoff -a" and the 180MB of swap went
away without error.  I didn't realise it at the time,
but I don't know how the swapoff worked -- it was a RAID-5
array, and 2 of the disks had failed, so it shouldn't have
been usable.  I didn't care about the swap, so I didn't
look at it too closely then.

A little before 2:AM, perhaps fifteen minutes after
turning the swap off, I did a "shutdown -h now" and Ubuntu
proceeded to do its shutdown process.  At this point I
saw some errors from either the RAID array (mdadm) or
hard disk(s) flash by very briefly before it rebooted --
I think it mentioned I/O problems, but it was gone too
quickly to take note of it.

After the shutdown, I rearranged the drives slightly (4 of
the 8 disks were close together, and were running hot to
the touch, so I moved the one from this group a few inches
away), the other four disks were not close together and
were only slightly warm.  I snugged up all of the power
and data cables, and powered up the system around 2:30AM
on June 9th.

The BIOS detected that four SATA disks were connected to
the motherboard, and the 32bit PCI SATA controller card
detected the remaining 4 SATA disks.  All seemed well
and I booted the upgraded Ubuntu 9.10 with kernel 2.6.28,
which resides on a separate IDE hard disk.

When it booted up, the RAID-6 was not active.  I tried to
make it automatically detect and start up, and it informed
me that it couldn't activate with only 3 of 8 disks.
This was rather surprising to me, as I had unmounted
the filesystem and mdadm reported it as having 6/8 disks
working 30 minutes after that.

Since that time I have been trying, with the help of
a friend, all sorts of non-destructive things to try
to figure out more about what is wrong.  I am extremely
hesitant to try anything with the array that could cause
the data to become corrupted.  If I knew of any Linux
software RAID experts in my area, I would be very happy
to pay them to come look at the system, but I don't know
any and have found nothing searching online (Vancouver,
BC, Canada).

One possibility of what happened is that perhaps
Ubuntu updated something controlling the RAID (such as
/etc/init.d/mdadm), and when I went to shutdown it didn't
properly shut off the array.  I have no idea if this is the
case, but I've had similar problems updating software on
Ubuntu where handling of the running app breaks because
newer support files have been installed which can't
communicate with the older app.

# /var/log/messages content from errors related to the
  RAID-6 array from BEFORE rebooting last night:

   Jun  6 18:16:42 gqq kernel: ata7: EH complete
   Jun  6 18:16:45 gqq kernel: ata7.00: configured for UDMA/100
   Jun  6 18:16:45 gqq kernel: sd 6:0:0:0: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
   Jun  6 18:16:45 gqq kernel: sd 6:0:0:0: [sde] Sense Key : Medium Error [current] [descriptor]
   Jun  6 18:16:45 gqq kernel: Descriptor sense data with sense descriptors (in hex):
   Jun  6 18:16:45 gqq kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
   Jun  6 18:16:45 gqq kernel:         73 77 61 9e 
   Jun  6 18:16:45 gqq kernel: sd 6:0:0:0: [sde] Add. Sense: Unrecovered read error - auto reallocate failed
   Jun  6 18:16:45 gqq kernel: ata7: EH complete
   Jun  6 18:16:45 gqq kernel: sd 6:0:0:0: [sde] 1953525168 512-byte hardware sectors (1000205 MB)
   Jun  6 18:16:45 gqq kernel: sd 6:0:0:0: [sde] Write Protect is off
   Jun  6 18:16:45 gqq kernel: sd 6:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
   Jun  6 18:16:45 gqq kernel: sd 6:0:0:0: [sde] 1953525168 512-byte hardware sectors (1000205 MB)
   Jun  6 18:16:45 gqq kernel: sd 6:0:0:0: [sde] Write Protect is off
   Jun  6 18:16:45 gqq kernel: sd 6:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
   Jun  6 18:16:47 gqq kernel: raid5:md13: read error corrected (8 sectors at 1937203488 on sde1)
   Jun  6 18:16:47 gqq kernel: raid5:md13: read error corrected (8 sectors at 1937203496 on sde1)
   Jun  6 18:16:47 gqq kernel: raid5:md13: read error corrected (8 sectors at 1937203504 on sde1)
   Jun  6 18:16:47 gqq kernel: raid5:md13: read error corrected (8 sectors at 1937203512 on sde1)
   Jun  6 18:16:47 gqq kernel: raid5:md13: read error corrected (8 sectors at 1937203520 on sde1)
   Jun  6 18:16:47 gqq kernel: raid5:md13: read error corrected (8 sectors at 1937203528 on sde1)
   Jun  6 18:16:47 gqq kernel: raid5:md13: read error corrected (8 sectors at 1937203536 on sde1)
   Jun  6 18:16:47 gqq kernel: raid5:md13: read error corrected (8 sectors at 1937203544 on sde1)
   Jun  6 18:16:47 gqq kernel: raid5:md13: read error corrected (8 sectors at 1937203552 on sde1)
   Jun  6 18:16:47 gqq kernel: raid5:md13: read error corrected (8 sectors at 1937203560 on sde1)

   Jun  7 05:34:05 gqq kernel: ata3.00: configured for UDMA/133
   Jun  7 05:34:05 gqq kernel: ata3: EH complete
   Jun  7 05:34:05 gqq kernel: sd 2:0:0:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
   Jun  7 05:34:05 gqq kernel: sd 2:0:0:0: [sdb] Write Protect is off
   Jun  7 05:34:05 gqq kernel: sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
   Jun  7 05:34:06 gqq kernel: ata3.00: configured for UDMA/133
   Jun  7 05:34:06 gqq kernel: ata3: EH complete
   Jun  7 05:34:06 gqq kernel: sd 2:0:0:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
   Jun  7 05:34:06 gqq kernel: sd 2:0:0:0: [sdb] Write Protect is off
   Jun  7 05:34:06 gqq kernel: sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
   Jun  7 05:34:08 gqq kernel: ata3.00: configured for UDMA/133
   Jun  7 05:34:08 gqq kernel: ata3: EH complete
   Jun  7 05:34:08 gqq kernel: sd 2:0:0:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
   Jun  7 05:34:08 gqq kernel: sd 2:0:0:0: [sdb] Write Protect is off
   Jun  7 05:34:08 gqq kernel: sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
   Jun  7 05:34:09 gqq kernel: ata3.00: configured for UDMA/133
   Jun  7 05:34:09 gqq kernel: ata3: EH complete
   Jun  7 05:34:09 gqq kernel: sd 2:0:0:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
   Jun  7 05:34:09 gqq kernel: sd 2:0:0:0: [sdb] Write Protect is off
   Jun  7 05:34:09 gqq kernel: sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
   Jun  7 05:34:11 gqq kernel: ata3.00: configured for UDMA/133
   Jun  7 05:34:11 gqq kernel: ata3: EH complete
   Jun  7 05:34:11 gqq kernel: sd 2:0:0:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
   Jun  7 05:34:11 gqq kernel: sd 2:0:0:0: [sdb] Write Protect is off
   Jun  7 05:34:11 gqq kernel: sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
   Jun  7 05:34:12 gqq kernel: ata3.00: configured for UDMA/133
   Jun  7 05:34:12 gqq kernel: sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
   Jun  7 05:34:12 gqq kernel: sd 2:0:0:0: [sdb] Sense Key : Medium Error [current] [descriptor]
   Jun  7 05:34:12 gqq kernel: Descriptor sense data with sense descriptors (in hex):
   Jun  7 05:34:12 gqq kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
   Jun  7 05:34:12 gqq kernel:         27 eb 8b 8c 
   Jun  7 05:34:12 gqq kernel: sd 2:0:0:0: [sdb] Add. Sense: Unrecovered read error - auto reallocate failed
   Jun  7 05:34:12 gqq kernel: __ratelimit: 2 callbacks suppressed
   Jun  7 05:34:12 gqq kernel: raid5:md13: read error not correctable (sector 669748040 on sdb1).
   Jun  7 05:34:12 gqq kernel: raid5:md13: read error not correctable (sector 669748048 on sdb1).
   Jun  7 05:34:12 gqq kernel: raid5:md13: read error not correctable (sector 669748056 on sdb1).
   Jun  7 05:34:12 gqq kernel: raid5:md13: read error not correctable (sector 669748064 on sdb1).
   Jun  7 05:34:12 gqq kernel: raid5:md13: read error not correctable (sector 669748072 on sdb1).
   Jun  7 05:34:12 gqq kernel: raid5:md13: read error not correctable (sector 669748080 on sdb1).
   Jun  7 05:34:12 gqq kernel: raid5:md13: read error not correctable (sector 669748088 on sdb1).
   Jun  7 05:34:12 gqq kernel: raid5:md13: read error not correctable (sector 669748096 on sdb1).
   Jun  7 05:34:12 gqq kernel: raid5:md13: read error not correctable (sector 669748104 on sdb1).
   Jun  7 05:34:12 gqq kernel: raid5:md13: read error not correctable (sector 669748112 on sdb1).
   Jun  7 05:34:12 gqq kernel: ata3: EH complete
   Jun  7 05:34:12 gqq kernel: sd 2:0:0:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
   Jun  7 05:34:12 gqq kernel: sd 2:0:0:0: [sdb] Write Protect is off
   Jun  7 05:34:12 gqq kernel: sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
   Jun  7 05:34:12 gqq kernel: md: md13: data-check done.
   Jun  7 05:34:12 gqq kernel: md: data-check of RAID array md9
   Jun  7 05:34:12 gqq kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
   Jun  7 05:34:12 gqq kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
   Jun  7 05:34:12 gqq kernel: md: using 128k window, over a total of 1269056 blocks.
   Jun  7 05:34:12 gqq kernel: md: md9: data-check done.
   Jun  7 05:34:12 gqq kernel: RAID5 conf printout:
   Jun  7 05:34:12 gqq kernel:  --- rd:8 wd:6
   Jun  7 05:34:12 gqq kernel:  disk 0, o:0, dev:sdb1
   Jun  7 05:34:12 gqq kernel:  disk 1, o:1, dev:sdf1
   Jun  7 05:34:12 gqq kernel:  disk 2, o:1, dev:sde1
   Jun  7 05:34:12 gqq kernel:  disk 3, o:1, dev:sda1
   Jun  7 05:34:12 gqq kernel:  disk 5, o:1, dev:sdh1
   Jun  7 05:34:12 gqq kernel:  disk 6, o:1, dev:sdc1
   Jun  7 05:34:12 gqq kernel:  disk 7, o:1, dev:sdg1
   Jun  7 05:34:12 gqq kernel: RAID5 conf printout:
   Jun  7 05:34:12 gqq kernel:  --- rd:8 wd:6
   Jun  7 05:34:12 gqq kernel:  disk 1, o:1, dev:sdf1
   Jun  7 05:34:12 gqq kernel:  disk 2, o:1, dev:sde1
   Jun  7 05:34:12 gqq kernel:  disk 3, o:1, dev:sda1
   Jun  7 05:34:12 gqq kernel:  disk 5, o:1, dev:sdh1
   Jun  7 05:34:12 gqq kernel:  disk 6, o:1, dev:sdc1
   Jun  7 05:34:12 gqq kernel:  disk 7, o:1, dev:sdg1

# /var/log/messages content from errors related to the
  RAID-6 array from AFTER rebooting last night (Note:
  a couple of the disk devices changed at this point,
  as I moved a disk and swapped cables):

   Jun  9 02:35:11 gqq kernel: md: md13 still in use.
   Jun  9 02:35:16 gqq kernel: md: md13 stopped.
   Jun  9 02:35:16 gqq kernel: md: unbind<sdf1>
   Jun  9 02:35:16 gqq kernel: md: export_rdev(sdf1)
   Jun  9 02:35:16 gqq kernel: md: unbind<sdg1>
   Jun  9 02:35:16 gqq kernel: md: export_rdev(sdg1)
   Jun  9 02:35:16 gqq kernel: md: unbind<sde1>
   Jun  9 02:35:16 gqq kernel: md: export_rdev(sde1)
   Jun  9 02:35:16 gqq kernel: md: unbind<sdd1>
   Jun  9 02:35:16 gqq kernel: md: export_rdev(sdd1)
   Jun  9 02:35:16 gqq kernel: md: unbind<sdc1>
   Jun  9 02:35:16 gqq kernel: md: export_rdev(sdc1)
   Jun  9 02:35:16 gqq kernel: md: unbind<sdb1>
   Jun  9 02:35:16 gqq kernel: md: export_rdev(sdb1)
   Jun  9 02:35:16 gqq kernel: md: unbind<sda1>
   Jun  9 02:35:16 gqq kernel: md: export_rdev(sda1)
   Jun  9 02:35:16 gqq kernel: md: unbind<sdh1>
   Jun  9 02:35:16 gqq kernel: md: export_rdev(sdh1)
   Jun  9 02:35:16 gqq kernel: md: bind<sdb1>
   Jun  9 02:35:16 gqq kernel: md: bind<sda1>
   Jun  9 02:35:16 gqq kernel: md: bind<sdf1>
   Jun  9 02:35:16 gqq kernel: md: bind<sdd1>
   Jun  9 02:35:16 gqq kernel: md: bind<sdh1>
   Jun  9 02:35:16 gqq kernel: md: bind<sdc1>
   Jun  9 02:35:16 gqq kernel: md: bind<sdg1>
   Jun  9 02:35:16 gqq kernel: md: bind<sde1>

# I then went to sleep and continued today at 11:AM

# This was when we tried using the auto-detection of
  the array

   Jun  9 12:30:55 gqq kernel: md: Autodetecting RAID arrays.
   Jun  9 12:30:55 gqq kernel: md: Scanned 0 and added 0 devices.
   Jun  9 12:30:55 gqq kernel: md: autorun ...
   Jun  9 12:30:55 gqq kernel: md: ... autorun DONE.
   Jun  9 12:31:01 gqq kernel: md: Autodetecting RAID arrays.
   Jun  9 12:31:01 gqq kernel: md: Scanned 0 and added 0 devices.
   Jun  9 12:31:01 gqq kernel: md: autorun ...
   Jun  9 12:31:01 gqq kernel: md: ... autorun DONE.

# I don't remember what we were doing when these happened,
  but it did it several times and we didn't know what
  it meant

   Jun  9 13:02:40 gqq kernel: md: md13 stopped.
   Jun  9 13:02:40 gqq kernel: md: unbind<sde1>
   Jun  9 13:02:40 gqq kernel: md: export_rdev(sde1)
   Jun  9 13:02:40 gqq kernel: md: unbind<sdg1>
   Jun  9 13:02:40 gqq kernel: md: export_rdev(sdg1)
   Jun  9 13:02:40 gqq kernel: md: unbind<sdc1>
   Jun  9 13:02:40 gqq kernel: md: export_rdev(sdc1)
   Jun  9 13:02:40 gqq kernel: md: unbind<sdh1>
   Jun  9 13:02:40 gqq kernel: md: export_rdev(sdh1)
   Jun  9 13:02:40 gqq kernel: md: unbind<sdd1>
   Jun  9 13:02:40 gqq kernel: md: export_rdev(sdd1)
   Jun  9 13:02:40 gqq kernel: md: unbind<sdf1>
   Jun  9 13:02:40 gqq kernel: md: export_rdev(sdf1)
   Jun  9 13:02:40 gqq kernel: md: unbind<sda1>
   Jun  9 13:02:40 gqq kernel: md: export_rdev(sda1)
   Jun  9 13:02:40 gqq kernel: md: unbind<sdb1>
   Jun  9 13:02:40 gqq kernel: md: export_rdev(sdb1)
   Jun  9 13:02:40 gqq kernel: md: bind<sdb1>
   Jun  9 13:02:40 gqq kernel: md: bind<sda1>
   Jun  9 13:02:40 gqq kernel: md: bind<sdf1>
   Jun  9 13:02:40 gqq kernel: md: bind<sdd1>
   Jun  9 13:02:40 gqq kernel: md: bind<sdh1>
   Jun  9 13:02:40 gqq kernel: md: bind<sdc1>
   Jun  9 13:02:40 gqq kernel: md: bind<sdg1>
   Jun  9 13:02:40 gqq kernel: md: bind<sde1>

   Repeat at Jun  9 13:02:51

   Repeat at Jun  9 13:03:10

   Repeat at Jun  9 13:03:13

   Repeat at Jun  9 13:41:08

   Jun  9 14:00:30 gqq kernel: md: md13 stopped.
   Jun  9 14:00:30 gqq kernel: md: unbind<sde1>
   Jun  9 14:00:30 gqq kernel: md: export_rdev(sde1)
   Jun  9 14:00:30 gqq kernel: md: unbind<sdg1>
   Jun  9 14:00:30 gqq kernel: md: export_rdev(sdg1)
   Jun  9 14:00:30 gqq kernel: md: unbind<sdc1>
   Jun  9 14:00:30 gqq kernel: md: export_rdev(sdc1)
   Jun  9 14:00:30 gqq kernel: md: unbind<sdh1>
   Jun  9 14:00:30 gqq kernel: md: export_rdev(sdh1)
   Jun  9 14:00:30 gqq kernel: md: unbind<sdd1>
   Jun  9 14:00:30 gqq kernel: md: export_rdev(sdd1)
   Jun  9 14:00:30 gqq kernel: md: unbind<sdf1>
   Jun  9 14:00:30 gqq kernel: md: export_rdev(sdf1)
   Jun  9 14:00:30 gqq kernel: md: unbind<sda1>
   Jun  9 14:00:30 gqq kernel: md: export_rdev(sda1)
   Jun  9 14:00:30 gqq kernel: md: unbind<sdb1>
   Jun  9 14:00:30 gqq kernel: md: export_rdev(sdb1)
   Jun  9 14:00:30 gqq kernel: md: bind<sda1>
   Jun  9 14:00:30 gqq kernel: md: bind<sdf1>
   Jun  9 14:00:30 gqq kernel: md: bind<sdh1>
   Jun  9 14:00:30 gqq kernel: md: md_import_device returned -16
   Jun  9 14:00:30 gqq kernel: md: bind<sdg1>
   Jun  9 14:00:30 gqq kernel: md: md_import_device returned -16
   Jun  9 14:00:30 gqq kernel: md: bind<sde1>
   Jun  9 14:00:30 gqq kernel: md: bind<sdc1>

# Not sure if these are related, but there are a bunch of
  this type of message throughout the day, including during
  the middle of some disk errors

   Jun  9 16:42:02 gqq kernel: __ratelimit: 16 callbacks suppressed
   Jun  9 16:42:17 gqq kernel: __ratelimit: 13 callbacks suppressed
   Jun  9 18:58:09 gqq kernel: __ratelimit: 36 callbacks suppressed

# When we tested the disks, either through playing with a
  recreated /dev/md9 or using cat /dev/sd?1 > /dev/null,
  two of the disks (/dev/sdb and /dev/sdh) had a lot of
  errors, and the others have remained error-free

   Jun  9 18:58:08 gqq kernel: ata3: EH complete
   Jun  9 18:58:09 gqq kernel: ata3.00: configured for UDMA/133
   Jun  9 18:58:09 gqq kernel: sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
   Jun  9 18:58:09 gqq kernel: sd 2:0:0:0: [sdb] Sense Key : Medium Error [current] [descriptor]
   Jun  9 18:58:09 gqq kernel: Descriptor sense data with sense descriptors (in hex):
   Jun  9 18:58:09 gqq kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
   Jun  9 18:58:09 gqq kernel:         74 70 55 63
   Jun  9 18:58:09 gqq kernel: sd 2:0:0:0: [sdb] Add. Sense: Unrecovered read error - auto reallocate failed
   Jun  9 18:58:09 gqq kernel: __ratelimit: 36 callbacks suppressed
   Jun  9 18:58:09 gqq kernel: ata3: EH complete
   Jun  9 18:58:09 gqq kernel: sd 2:0:0:0: [sdb] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
   Jun  9 18:58:09 gqq kernel: sd 2:0:0:0: [sdb] Write Protect is off
   Jun  9 18:58:09 gqq kernel: sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

   Jun  9 18:58:27 gqq kernel: ata10: EH complete
   Jun  9 18:58:29 gqq kernel: ata10.00: configured for UDMA/100
   Jun  9 18:58:29 gqq kernel: sd 9:0:0:0: [sdh] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
   Jun  9 18:58:29 gqq kernel: sd 9:0:0:0: [sdh] Sense Key : Medium Error [current] [descriptor]
   Jun  9 18:58:29 gqq kernel: Descriptor sense data with sense descriptors (in hex):
   Jun  9 18:58:29 gqq kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
   Jun  9 18:58:29 gqq kernel:         74 70 55 d9 
   Jun  9 18:58:29 gqq kernel: sd 9:0:0:0: [sdh] Add. Sense: Unrecovered read error - auto reallocate failed
   Jun  9 18:58:29 gqq kernel: ata10: EH complete
   Jun  9 18:58:29 gqq kernel: sd 9:0:0:0: [sdh] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
   Jun  9 18:58:31 gqq kernel: ata10.00: configured for UDMA/100
   Jun  9 18:58:31 gqq kernel: ata10: EH complete

   etc.

Here's all the information I can think to gather about
the system, if I missed anything just let me know:

# cat /etc/lsb-release 

   DISTRIB_ID=Ubuntu
   DISTRIB_RELEASE=9.04
   DISTRIB_CODENAME=jaunty
   DISTRIB_DESCRIPTION="Ubuntu 9.04"

# uname -a

   Linux gqq 2.6.28-11-generic #42-Ubuntu SMP Fri Apr 17 01:58:03 UTC 2009 x86_64 GNU/Linux

# lspci | grep -i sata

   00:09.0 SATA controller: nVidia Corporation MCP78S [GeForce 8200] AHCI Controller (rev a2)
   01:08.0 RAID bus controller: Silicon Image, Inc. SiI 3114 [SATALink/SATARaid] Serial ATA Controller (rev 02)

# fdisk -l

   Disk /dev/sda: 1000 GB, 1000202273280 bytes
   255 heads, 63 sectors/track, 121601 cylinders
   Units = cylinders of 16065 * 512 = 8225280 bytes

      Device Boot      Start         End      Blocks   Id  System 
   /dev/sda1               1      121443   975490866   83  Linux
   /dev/sda2          121444      121601     1261102   83  Linux

   Disk /dev/sdb: 1000 GB, 1000202273280 bytes
   255 heads, 63 sectors/track, 121601 cylinders
   Units = cylinders of 16065 * 512 = 8225280 bytes

      Device Boot      Start         End      Blocks   Id  System 
   /dev/sdb1               1      121443   975490866   83  Linux
   /dev/sdb2          121444      121601     1261102   83  Linux

   Disk /dev/sdc: 1000 GB, 1000202273280 bytes
   255 heads, 63 sectors/track, 121601 cylinders
   Units = cylinders of 16065 * 512 = 8225280 bytes

      Device Boot      Start         End      Blocks   Id  System 
   /dev/sdc1               1      121443   975490866   83  Linux
   /dev/sdc2          121444      121601     1261102   83  Linux

   Disk /dev/sdd: 1000 GB, 1000202273280 bytes
   255 heads, 63 sectors/track, 121601 cylinders
   Units = cylinders of 16065 * 512 = 8225280 bytes

      Device Boot      Start         End      Blocks   Id  System 
   /dev/sdd1               1      121443   975490866   83  Linux
   /dev/sdd2          121444      121601     1261102   83  Linux

   Disk /dev/sde: 1000 GB, 1000202273280 bytes
   255 heads, 63 sectors/track, 121601 cylinders
   Units = cylinders of 16065 * 512 = 8225280 bytes

      Device Boot      Start         End      Blocks   Id  System 
   /dev/sde1               1      121443   975490866   83  Linux
   /dev/sde2          121444      121601     1261102   83  Linux

   Disk /dev/sdf: 1000 GB, 1000202273280 bytes
   255 heads, 63 sectors/track, 121601 cylinders
   Units = cylinders of 16065 * 512 = 8225280 bytes

      Device Boot      Start         End      Blocks   Id  System 
   /dev/sdf1               1      121443   975490866   83  Linux
   /dev/sdf2          121444      121601     1261102   83  Linux

   Disk /dev/sdg: 1000 GB, 1000202273280 bytes
   255 heads, 63 sectors/track, 121601 cylinders
   Units = cylinders of 16065 * 512 = 8225280 bytes

      Device Boot      Start         End      Blocks   Id  System 
   /dev/sdg1               1      121443   975490866   83  Linux
   /dev/sdg2          121444      121601     1261102   83  Linux

   Disk /dev/sdh: 1000 GB, 1000202273280 bytes
   255 heads, 63 sectors/track, 121601 cylinders
   Units = cylinders of 16065 * 512 = 8225280 bytes

      Device Boot      Start         End      Blocks   Id  System 
   /dev/sdh1               1      121443   975490866   83  Linux
   /dev/sdh2          121444      121601     1261102   83  Linux

   Disk /dev/sdi: 163 GB, 163921605120 bytes
   255 heads, 63 sectors/track, 19929 cylinders
   Units = cylinders of 16065 * 512 = 8225280 bytes

      Device Boot      Start         End      Blocks   Id  System 
   /dev/sdi1   *           1       19929   160079661   83  Linux

   Error: /dev/md13: unrecognised disk label
   Error: /dev/md9: unrecognised disk label
   Error: /dev/md0: unrecognised disk label

# ls -l /dev/disk/by-id/scsi-SATA_* | sed 's/.*scsi-SATA_\([^ ]*\) .. ......\(.*\)/\2 = \1/; /part/d' | sort

   sda = ST31000340AS_9QJ1PKKS
   sdb = SAMSUNG_HD103UJS13PJDWQ204841
   sdc = ST31000340AS_9QJ0V24S
   sdd = ST31000340AS_9QJ0TTHZ
   sde = ST31000340AS_9QJ0M5J4
   sdf = ST31000340AS_9QJ0V1F5
   sdg = Hitachi_HDS7210_GTA0L0PAJGGZHF
   sdh = SAMSUNG_HD103UJS13PJDWQ204844
   sdi = Maxtor_6Y160P0_Y44ENMKE

# cat /proc/mdstat

   Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
   md9 : inactive sdd2[8](S) sdf2[3](S) sdg2[7](S) sde2[2](S) sdc2[0](S) sda2[4](S) sdh2[6](S) sdb2[5](S)
         10152448 blocks

   md13 : inactive sdd1[4](S) sdb1[0](S) sdc1[6](S) sde1[2](S) sdg1[7](S) sdh1[5](S) sdf1[3](S) sda1[1](S)
         7803926016 blocks

   unused devices: <none>

# cat /sys/module/md_mod/parameters/start_ro 

   1

# for disk in /dev/sd{a,b,c,d,e,f,g,h}1; do printf "$disk"; mdadm --examine "$disk" | tac | \grep -E '(Up|Ev)' | tr -d \\n; echo; done | sort --key=4

   /dev/sdd1         Events : 1107965    Update Time : Wed Jun  3 03:16:51 2009
   /dev/sdb1         Events : 1847298    Update Time : Sun Jun  7 05:34:03 2009
   /dev/sda1         Events : 2186232    Update Time : Tue Jun  9 01:36:59 2009
   /dev/sdf1         Events : 2186232    Update Time : Tue Jun  9 01:36:59 2009
   /dev/sdg1         Events : 2186232    Update Time : Tue Jun  9 01:36:59 2009
   /dev/sdc1         Events : 2186236    Update Time : Tue Jun  9 02:02:37 2009
   /dev/sde1         Events : 2186236    Update Time : Tue Jun  9 02:02:37 2009
   /dev/sdh1         Events : 2186236    Update Time : Tue Jun  9 02:02:37 2009

# for disk in /dev/sd{a,b,c,d,e,f,g,h}1; do mdadm --examine "$disk"; echo; done

   /dev/sda1:
             Magic : a92b4efc
           Version : 00.90.00
              UUID : 7f6da4ce:2ddbe010:f7481424:9a8f8874 (local to host gqq)
     Creation Time : Sun Aug  3 10:21:28 2008
        Raid Level : raid6
     Used Dev Size : 975490752 (930.30 GiB 998.90 GB)
        Array Size : 5852944512 (5581.80 GiB 5993.42 GB)
      Raid Devices : 8
     Total Devices : 8
   Preferred Minor : 13

       Update Time : Tue Jun  9 01:36:59 2009
             State : clean
    Active Devices : 6
   Working Devices : 6
    Failed Devices : 1
     Spare Devices : 0
          Checksum : b57902ef - correct
            Events : 2186232

        Chunk Size : 64K

         Number   Major   Minor   RaidDevice State
   this     1       8       81        1      active sync   /dev/sdf1

      0     0       0        0        0      removed
      1     1       8       81        1      active sync   /dev/sdf1
      2     2       8       65        2      active sync   /dev/sde1
      3     3       8        1        3      active sync   /dev/sda1
      4     4       0        0        4      faulty removed
      5     5       8      113        5      active sync   /dev/sdh1
      6     6       8       33        6      active sync   /dev/sdc1
      7     7       8       97        7      active sync   /dev/sdg1

   /dev/sdb1:
             Magic : a92b4efc
           Version : 00.90.00
              UUID : 7f6da4ce:2ddbe010:f7481424:9a8f8874 (local to host gqq)
     Creation Time : Sun Aug  3 10:21:28 2008
        Raid Level : raid6
     Used Dev Size : 975490752 (930.30 GiB 998.90 GB)
        Array Size : 5852944512 (5581.80 GiB 5993.42 GB)
      Raid Devices : 8
     Total Devices : 8
   Preferred Minor : 13

       Update Time : Sun Jun  7 05:34:03 2009
             State : clean
    Active Devices : 7
   Working Devices : 7
    Failed Devices : 1
     Spare Devices : 0
          Checksum : b56c3f3e - correct
            Events : 1847298

        Chunk Size : 64K

         Number   Major   Minor   RaidDevice State
   this     0       8       17        0      active sync   /dev/sdb1

      0     0       8       17        0      active sync   /dev/sdb1
      1     1       8       81        1      active sync   /dev/sdf1
      2     2       8       65        2      active sync   /dev/sde1
      3     3       8        1        3      active sync   /dev/sda1
      4     4       0        0        4      faulty removed
      5     5       8      113        5      active sync   /dev/sdh1
      6     6       8       33        6      active sync   /dev/sdc1
      7     7       8       97        7      active sync   /dev/sdg1

   /dev/sdc1:
             Magic : a92b4efc
           Version : 00.90.00
              UUID : 7f6da4ce:2ddbe010:f7481424:9a8f8874 (local to host gqq)
     Creation Time : Sun Aug  3 10:21:28 2008
        Raid Level : raid6
     Used Dev Size : 975490752 (930.30 GiB 998.90 GB)
        Array Size : 5852944512 (5581.80 GiB 5993.42 GB)
      Raid Devices : 8
     Total Devices : 8
   Preferred Minor : 13

       Update Time : Tue Jun  9 02:02:37 2009
             State : clean
    Active Devices : 3
   Working Devices : 3
    Failed Devices : 4
     Spare Devices : 0
          Checksum : b579091e - correct
            Events : 2186236

        Chunk Size : 64K

         Number   Major   Minor   RaidDevice State
   this     6       8       33        6      active sync   /dev/sdc1

      0     0       0        0        0      removed
      1     1       0        0        1      faulty removed
      2     2       8       65        2      active sync   /dev/sde1
      3     3       0        0        3      faulty removed
      4     4       0        0        4      faulty removed
      5     5       8      113        5      active sync   /dev/sdh1
      6     6       8       33        6      active sync   /dev/sdc1
      7     7       0        0        7      faulty removed

   /dev/sdd1:
             Magic : a92b4efc
           Version : 00.90.00
              UUID : 7f6da4ce:2ddbe010:f7481424:9a8f8874 (local to host gqq)
     Creation Time : Sun Aug  3 10:21:28 2008
        Raid Level : raid6
     Used Dev Size : 975490752 (930.30 GiB 998.90 GB)
        Array Size : 5852944512 (5581.80 GiB 5993.42 GB)
      Raid Devices : 8
     Total Devices : 8
   Preferred Minor : 13

       Update Time : Wed Jun  3 03:16:51 2009
             State : active
    Active Devices : 8
   Working Devices : 8
    Failed Devices : 0
     Spare Devices : 0
          Checksum : b53f6123 - correct
            Events : 1107965

        Chunk Size : 64K

         Number   Major   Minor   RaidDevice State
   this     4       8       49        4      active sync   /dev/sdd1

      0     0       8       17        0      active sync   /dev/sdb1
      1     1       8       81        1      active sync   /dev/sdf1
      2     2       8       65        2      active sync   /dev/sde1
      3     3       8        1        3      active sync   /dev/sda1
      4     4       8       49        4      active sync   /dev/sdd1
      5     5       8      113        5      active sync   /dev/sdh1
      6     6       8       33        6      active sync   /dev/sdc1
      7     7       8       97        7      active sync   /dev/sdg1

   /dev/sde1:
             Magic : a92b4efc
           Version : 00.90.00
              UUID : 7f6da4ce:2ddbe010:f7481424:9a8f8874 (local to host gqq)
     Creation Time : Sun Aug  3 10:21:28 2008
        Raid Level : raid6
     Used Dev Size : 975490752 (930.30 GiB 998.90 GB)
        Array Size : 5852944512 (5581.80 GiB 5993.42 GB)
      Raid Devices : 8
     Total Devices : 8
   Preferred Minor : 13

       Update Time : Tue Jun  9 02:02:37 2009
             State : clean
    Active Devices : 3
   Working Devices : 3
    Failed Devices : 4
     Spare Devices : 0
          Checksum : b5790936 - correct
            Events : 2186236

        Chunk Size : 64K

         Number   Major   Minor   RaidDevice State
   this     2       8       65        2      active sync   /dev/sde1

      0     0       0        0        0      removed
      1     1       0        0        1      faulty removed
      2     2       8       65        2      active sync   /dev/sde1
      3     3       0        0        3      faulty removed
      4     4       0        0        4      faulty removed
      5     5       8      113        5      active sync   /dev/sdh1
      6     6       8       33        6      active sync   /dev/sdc1
      7     7       0        0        7      faulty removed

   /dev/sdf1:
             Magic : a92b4efc
           Version : 00.90.00
              UUID : 7f6da4ce:2ddbe010:f7481424:9a8f8874 (local to host gqq)
     Creation Time : Sun Aug  3 10:21:28 2008
        Raid Level : raid6
     Used Dev Size : 975490752 (930.30 GiB 998.90 GB)
        Array Size : 5852944512 (5581.80 GiB 5993.42 GB)
      Raid Devices : 8
     Total Devices : 8
   Preferred Minor : 13

       Update Time : Tue Jun  9 01:36:59 2009
             State : clean
    Active Devices : 6
   Working Devices : 6
    Failed Devices : 1
     Spare Devices : 0
          Checksum : b57902a3 - correct
            Events : 2186232

        Chunk Size : 64K

         Number   Major   Minor   RaidDevice State
   this     3       8        1        3      active sync   /dev/sda1

      0     0       0        0        0      removed
      1     1       8       81        1      active sync   /dev/sdf1
      2     2       8       65        2      active sync   /dev/sde1
      3     3       8        1        3      active sync   /dev/sda1
      4     4       0        0        4      faulty removed
      5     5       8      113        5      active sync   /dev/sdh1
      6     6       8       33        6      active sync   /dev/sdc1
      7     7       8       97        7      active sync   /dev/sdg1

   /dev/sdg1:
             Magic : a92b4efc
           Version : 00.90.00
              UUID : 7f6da4ce:2ddbe010:f7481424:9a8f8874 (local to host gqq)
     Creation Time : Sun Aug  3 10:21:28 2008
        Raid Level : raid6
     Used Dev Size : 975490752 (930.30 GiB 998.90 GB)
        Array Size : 5852944512 (5581.80 GiB 5993.42 GB)
      Raid Devices : 8
     Total Devices : 8
   Preferred Minor : 13

       Update Time : Tue Jun  9 01:36:59 2009
             State : clean
    Active Devices : 6
   Working Devices : 6
    Failed Devices : 1
     Spare Devices : 0
          Checksum : b579030b - correct
            Events : 2186232

        Chunk Size : 64K

         Number   Major   Minor   RaidDevice State
   this     7       8       97        7      active sync   /dev/sdg1

      0     0       0        0        0      removed
      1     1       8       81        1      active sync   /dev/sdf1
      2     2       8       65        2      active sync   /dev/sde1
      3     3       8        1        3      active sync   /dev/sda1
      4     4       0        0        4      faulty removed
      5     5       8      113        5      active sync   /dev/sdh1
      6     6       8       33        6      active sync   /dev/sdc1
      7     7       8       97        7      active sync   /dev/sdg1

   /dev/sdh1:
             Magic : a92b4efc
           Version : 00.90.00
              UUID : 7f6da4ce:2ddbe010:f7481424:9a8f8874 (local to host gqq)
     Creation Time : Sun Aug  3 10:21:28 2008
        Raid Level : raid6
     Used Dev Size : 975490752 (930.30 GiB 998.90 GB)
        Array Size : 5852944512 (5581.80 GiB 5993.42 GB)
      Raid Devices : 8
     Total Devices : 8
   Preferred Minor : 13

       Update Time : Tue Jun  9 02:02:37 2009
             State : clean
    Active Devices : 3
   Working Devices : 3
    Failed Devices : 4
     Spare Devices : 0
          Checksum : b579096c - correct
            Events : 2186236

        Chunk Size : 64K

         Number   Major   Minor   RaidDevice State
   this     5       8      113        5      active sync   /dev/sdh1

      0     0       0        0        0      removed
      1     1       0        0        1      faulty removed
      2     2       8       65        2      active sync   /dev/sde1
      3     3       0        0        3      faulty removed
      4     4       0        0        4      faulty removed
      5     5       8      113        5      active sync   /dev/sdh1
      6     6       8       33        6      active sync   /dev/sdc1
      7     7       0        0        7      faulty removed

============================================================

At this point the important parts seem to be:

  a) Two disks are way behind on events than the other six
     disks, these being the ones that failed during the past
	  week.

  b) Two disks are currently producing errors if I try to
     read from them, but these are not the same two disks
     as above (one of them is the same, the other is not).

  c) Of the six remaining disks, there are three disks
     which are 4 events behind the other three disks.
     I don't think there should have been any writing
     to the disks at all, as it wasn't even mounted.
     The extra 4 events seemed to have happened during
     the system shutdown process.

  d) One of the six disks which are nearly up-to-date with
     each other is producing I/O errors when being read
     from, which I must fix.  I think I can accomplish
     by shutting down the system, removing the two disks
     which failed days ago, and moving the one problem
     disk to a new SATA controller and power cable.

  e) I am very worried to even shut down to try this,
     as last time shutting down is what messed things up.
     I don't want to do anything that could increase the
     chances of losing the terabytes of data, much of it
     is not backed up elsewhere.

Any information on how to assess what state the disks
are in would be greatly appreciated.  Before today I had
never even looked at the Event numbers, or most of the
other diagnostics and options I have now learned about.

I have set /sys/module/md_mod/parameters/start_ro to 1,
as I read that will keep it from making changes after it
brings the array back up.  Any other tips?

Again, apologies for the severely long e-mail, and if
anyone actually looks through it -- thank you kindly for
your time.  I have tried to at least put things into clear
sections so it can be skipped over fairly easily.

I *really* don't want to lose this data.  I wish I knew
more about recovering from mdadm issues, I guess I am
getting practice at it now.

Sigh.

 - S.A.





