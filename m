From: m d <mikeintel8@gmail.com>
Subject: MD RAID5 / XFS filesystem creation error
Date: Wed, 16 Oct 2013 17:39:57 -0700
Message-ID: <CAB7tbKUppfi49m+8wFRq78gvdidOfKD_UyB=uUYHTkhnzH1hSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, michael.j.degon@intel.com
List-Id: linux-raid.ids

Hey Guys,

In my testing I have encountered a problem  while  trying to create a
xfs  filesystem on a 4 disk Intel SSD Raid5 volume. I am currently
testing with a Fedora 3.11.4-201 kernel  and the latest  version of
the mdadm binary(3.2.6-21). I realize that userspace mdadm binary may
not factor into the equation and the error may be all mdraid5 kernel
module driven.

The basic kernel error is encountered when  creating a 4 drive RAID5
volume  and writing an XFS filesystem to it after  it has resync=92d.
The quick commands used are as follows:


1.       Check  to make sure the Raid 5 volume is resync=92d:

              #cat /proc/mdstat

2.       Change from init5 to init3, eliminating the X-windowing
system, allowing for more explicit kernel error output:

              #init 3

3.       Build  xfs filesystem  on the sync=92d raid5 volume:

              # mkfs.xfs   /dev/md5



After  executing the mkfs.xfs command,  the standard out  will
instantly start to spew blk  & mdraid5 errors. Ending after 2 rounds
of errors with a cpu soft lockup message:

Kernel: [ 1016.781678] BUG: soft lockup ? CPU#1 stuck for 22s! [md5_rai=
d:463]


The kernel panic error log is posted at:

http://pastebin.com/EbGYti24



Detailed Configuration Setup:

This  configuration requires  4 SATA2 ports to be present on the same
controller.

Test Environment:

Storage Media:                 Intel SSD 710 Series 200GB  x 4 Disks
OS:                                 Fedora 19 x86_64



Steps to recreate:
1.            HW Setup:
         a.            Install 2 x 2GB DDR3 UDIMMs  on the last 2
slots farthest from the CPU (one memory channel).
         b.            Connect  all 4  Intel 710  200GB SSDs to SATA2
ports located on  the one ahci  sata  controller. I have tried  Intel
320 SSDs with the same result.
         c.             Insert a  8GB USBkey in to one of the USB
slots and  Install Fedora OS.  Use a standard partitioning system and
limit  swap to 3GB.  In my experience  this is assigned  to the
/dev/sde  device.

2.            After the  OS has been installed on the  platform ,
reboot  system.

3.            When  system  is back up,  login  as root and use fdisk
to create a 50 GB  partition  on each disk. Assign the partition  type
to be =93fd=94 which is the =93linux RAID auto-detect=94 partition type=
 for
every partition created.

4.            Use mdadm  binary  to create a RAID 5  partition using
the 4  50GB  linux RAID auto-detect that were just created. Use a
command like this:

#mdadm  --create /dev/md5 --level=3D5 --raid-devices =3D 4 /dev/sda1
/dev/sdb1 /dev/sdc1 /dev/sdd1

5.            Once the RAID5 volume has been created, attempt to make
a XFS file system on the new volume. This can be accomplished  using
this command;

# mkfs.xfs  /dev/md5

6.            After about 5 seconds there the system will start
indicating  kernel errors and 5 seconds after that  the system will
freeze. If one is  running this experiment in the init 3  multi-user
mode , the system will spew  kernel errors until  it eventually
freezes. The  error should look like this:

Kernel: [ 1016.781678] BUG: soft lockup ? CPU#1 stuck for 22s! [md5_rai=
d:463]



Basic experiments  executed to narrow the scope of issue:

#Is the  problem persistent on all local media  types?

                I tried this same setup on 4 enterprise 3G HDD disks
with no problems or issues. I was able to create a 4 disk RAID5 array
and write an XFS  filesystem to the RAID array. Then I was able to
write, append and read a file to the XFS filesystem on the RAID array
=2E

#Does it fail if you create a different file system type. (ext3)?

 Yes, I have tried  this and the failure still  occurs.

#Does it fail if you create a XFS file system on a non RAID AVN SATA
disk? Create XFS on a single disk.

 No  failure. I was able to create a partition, write a xfs
filesystem, create a file, write the file, read the file, and delete
the file.

#Is the RAID5 volume fully initialized when you create the XFS file
system. you can check it with cat /proc/mdstat. it will show a
percentage of how far its done.

  Yes , After  creating the RAID5 volume, I  run the =91#watch cat
/proc/mdstat=92command to watch the  volume go through its sync process=
=2E


#Can you try to do that same without using AVN SATA drives. Use 4 RAM
disks instead of real drives and do that same test. That way we can
rule out AVN SATA. Use /dev/ram0 etc... you have to specify the ram
disk size in grub.

I checked  this out:

o             loading the brd module
o             resized each /dev/ram[?]  device to  8192  (8M)
o             Created /dev/md100 using mdadm RAID5  and /dev/ram[0-3]
o             Executed  #mkfs.xfs  /dev/md100 with  no errors.



I think this issue is MD5 RAID kernel module and SSD timing related
and this test proves that  there is nothing wrong with the mdadm
binary in relation to Atom processor originally being tested.


Experiments tried to verify that this a kernel issue:

Below are all of the experiments trying to create a xfs filesystem on
RAID5 resulted  in the same kernel panic error:

- Moved OS USB key and SSDs to an older generation atom storage
platform, failed.
- Connected the SSDs to a LSI card, failed.
- Updated the kernel to the latest kernel (3.11.4-201), failed.
- Updated  the mdadm binary(3.2.6-21) to the latest version, failed.



When  moving  the OS and SSDs to the order Atom generation which did
not have these problems before, the  problem followed,  indicating
that the issue was kernel or  MDRAID related.



Regards,

Michael
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
