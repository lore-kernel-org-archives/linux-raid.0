From: Karl Voit <news@Karl-Voit.at>
Subject: Re: only 4 spares and no access to my data
Date: Thu, 13 Jul 2006 12:59:14 +0000 (UTC)
Message-ID: <loom.20060713T144528-293@post.gmane.org>
References: <loom.20060709T205013-455@post.gmane.org>  <loom.20060710T095111-275@post.gmane.org>  <44B213CD.5010907@idgmail.se>  <loom.20060710T112944-980@post.gmane.org>  <62b0912f0607100416v51309355v693b5c83ee51fdbc@mail.gmail.com>  <loom.20060710T132722-427@post.gmane.org>  <62b0912f0607100507s21544d12xec9a8bf117b6edc2@mail.gmail.com>  <loom.20060710T142912-798@post.gmane.org>  <62b0912f0607101006k6f9e66cfp86d4f0d0c1de4a3a@mail.gmail.com>  <loom.20060710T211030-179@post.gmane.org> <62b0912f0607121235v5146eafbx84a877899e965c94@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Molle Bestefich <molle.bestefich <at> gmail.com> writes:

> Karl Voit wrote:
> > if (super == NULL) {
> >   fprintf(stderr, Name ": No suitable drives found for %s\n", mddev);
> > [...]
> >
> > Well I guess, the message will be shown, if the superblock is not found.
> 
> Yes.  No clue why, my buest guess is that you've already zeroed the superblock.

I did, yes. This was because the disks were marked as spare disks and a friend
of mine guessed that zeroing the superblocks might probably erase those
spare-marks and probably the disks can be assembled again. This was after a lot
of testing other methods.

> What does madm --query / --examine say about /dev/sd[abcd], are there
> superblocks ?

root@ned ~ #  mdadm --query /dev/md0 /dev/sd[abcd]
/dev/md0: is an md device which is not active
/dev/sda: is not an md array
/dev/sdb: is not an md array
/dev/sdc: is not an md array
/dev/sdd: is not an md array
root@ned ~ # mdadm --query /dev/md0 /dev/sd[abcd]1                             
                                                                        
/dev/md0: is an md device which is not active
/dev/sda1: is not an md array
/dev/sda1: device 4 in 4 device undetected raid5 /dev/md0.  Use \
mdadm --examine for more detail.
/dev/sdb1: is not an md array
/dev/sdb1: device 6 in 4 device undetected raid5 /dev/md0.  Use \
mdadm --examine for more detail.
/dev/sdc1: is not an md array
/dev/sdc1: device 5 in 4 device undetected raid5 /dev/md0.  Use \
mdadm --examine for more detail.
/dev/sdd1: is not an md array
/dev/sdd1: device 7 in 4 device undetected raid5 /dev/md0.  Use \
mdadm --examine for more detail.
root@ned ~ #  mdadm --examine /dev/md0 /dev/sd[abcd]
mdadm: No md superblock detected on /dev/md0.
mdadm: No md superblock detected on /dev/sda.
mdadm: No md superblock detected on /dev/sdb.
mdadm: No md superblock detected on /dev/sdc.
mdadm: No md superblock detected on /dev/sdd.
root@ned ~ # mdadm --examine /dev/md0
mdadm: No md superblock detected on /dev/md0.
root@ned ~ # mdadm --examine /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 15f07005:037e4abf:70f51389:83dde0ed
  Creation Time : Sun Jan 29 21:35:05 2006
     Raid Level : raid5
    Device Size : 244147712 (232.84 GiB 250.01 GB)
     Array Size : 732443136 (698.51 GiB 750.02 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sun Jul  2 17:23:03 2006
          State : clean
 Active Devices : 0
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 4
       Checksum : 4eb2dfe6 - correct
         Events : 0.1652541

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8        1        4      spare   /dev/sda1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
   4     4       8        1        4      spare   /dev/sda1
   5     5       8       33        5      spare   /dev/sdc1
   6     6       8       17        6      spare   /dev/sdb1
   7     7       8       49        7      spare   /dev/sdd1
root@ned ~ # mdadm --examine /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 15f07005:037e4abf:70f51389:83dde0ed
  Creation Time : Sun Jan 29 21:35:05 2006
     Raid Level : raid5
    Device Size : 244147712 (232.84 GiB 250.01 GB)
     Array Size : 732443136 (698.51 GiB 750.02 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sun Jul  2 17:23:03 2006
          State : clean
 Active Devices : 0
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 4
       Checksum : 4eb2dffa - correct
         Events : 0.1652541

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     6       8       17        6      spare   /dev/sdb1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
   4     4       8        1        4      spare   /dev/sda1
   5     5       8       33        5      spare   /dev/sdc1
   6     6       8       17        6      spare   /dev/sdb1
   7     7       8       49        7      spare   /dev/sdd1
root@ned ~ # mdadm --examine /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 15f07005:037e4abf:70f51389:83dde0ed
  Creation Time : Sun Jan 29 21:35:05 2006
     Raid Level : raid5
    Device Size : 244147712 (232.84 GiB 250.01 GB)
     Array Size : 732443136 (698.51 GiB 750.02 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sun Jul  2 17:23:03 2006
          State : clean
 Active Devices : 0
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 4
       Checksum : 4eb2e008 - correct
         Events : 0.1652541

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8       33        5      spare   /dev/sdc1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
   4     4       8        1        4      spare   /dev/sda1
   5     5       8       33        5      spare   /dev/sdc1
   6     6       8       17        6      spare   /dev/sdb1
   7     7       8       49        7      spare   /dev/sdd1
root@ned ~ # mdadm --examine /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 15f07005:037e4abf:70f51389:83dde0ed
  Creation Time : Sun Jan 29 21:35:05 2006
     Raid Level : raid5
    Device Size : 244147712 (232.84 GiB 250.01 GB)
     Array Size : 732443136 (698.51 GiB 750.02 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sun Jul  2 17:23:03 2006
          State : clean
 Active Devices : 0
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 4
       Checksum : 4eb2e01c - correct
         Events : 0.1652541

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     7       8       49        7      spare   /dev/sdd1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
   4     4       8        1        4      spare   /dev/sda1
   5     5       8       33        5      spare   /dev/sdc1
   6     6       8       17        6      spare   /dev/sdb1
   7     7       8       49        7      spare   /dev/sdd1
root@ned ~ #

[Unrecognised md component device]
> > Again: this seems to be the case, when the superblock is empty.
> 
> Yes, looks like it can't find any usable superblocks.
> Maybe you've accidentally zeroed the superblocks on sd[abcd]1 also?

Yes. But it was on purpose (again after trying a lot of things 
without success).
 
> If you fdisk -l /dev/sd[abcd], does the partition tables look like
> they should / like they used to?

Yes:

root@ned ~ # fdisk -l /dev/sda

Disk /dev/sda: 250.0 GB, 250059350016 bytes
255 heads, 63 sectors/track, 30401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1       30395   244147806   fd  Linux raid autodetect
root@ned ~ # 

... all four of them are exactly the same.
 
> What does mdadm --query / --examine /dev/sd[abcd]1 tell you, any
> superblocks ?

See above.
 
> > The problem is also, that without deeper background knowledge, I can not
> > predict, if this or that permanently affects the real data on the disks.
> 
> My best guess is that it's OK and you won't loose data if you run
> --zero-superblock on /dev/sd[abcd] and then create an array on
> /dev/sd[abcd]1, but I do find it odd that it suddenly can't find
> superblocks on /dev/sd[abcd]1.

My friend said, that I should try this line

mdadm --create -n 4 -l 5 /dev/md0 missing /dev/sdb1 /dev/sdc1 /dev/sdd1

instead of this line

mdadm --create -n 4 -l 5 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1

first, because when the second one works, it might be the case, that the
raid is starting to synchronize and this might cause problems.

> > Maybe such a person like me starts to think that sw-raid-tools like
> > mdadm should warn users before permanent changes are executed. If
> > mdadm should be used by users (additional to raid-geeks like you),
> > it might be a good idea to prevent data loss. (Ment as a suggestion.)
> 
> Perhaps.  Or perhaps mdadm should just tell you that you're doing
> something stupid if you try to manipulate arrays on a block device
> which seems to contain a partition table.

Additionally, yes.
 
> It's not like it's even remotely useful to create an MD array spanning
> the whole disk rather than spanning a partition which spans the whole
> disk, anyway.

I agree. But including best practices into mdadm is not quite an easy 
task, I guess.

TNX (again)

