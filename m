From: Harold Pritchett <harold@uga.edu>
Subject: Draft Mirrored Linux Mini How-to
Date: Thu, 06 Aug 2009 20:08:47 -0400
Message-ID: <4A7B708F.4050406@uga.edu>
References: <4A78292A.5000607@in.ibm.com>	 <1249421223.18245.36.camel@pasglop> <4A794E26.8080207@in.ibm.com>	 <1249465934.18245.54.camel@pasglop>  <4A7ADBB1.3050906@in.ibm.com> <1249595469.24311.5.camel@pasglop>
Reply-To: harold@uga.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1249595469.24311.5.camel@pasglop>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Following this note is a draft of a "Mirrored Linux Mini How-to" document.
It's primarily for my own use, but I will make it available to anyone who
would like a copy.

Before I do this, I would like input from this group as to whether it:
1. is a good idea?
2. has no obvious errors or problems?
3. will reliably work?
4. Should I provide more details?  Or at least pointers to using fdisk, etc.

Thanks for the assistance

Harold

==============================================================================

Mirrored Linux Mini How-to

Install linux on two identical disk drives in such a way that the failure
of either of the drives will allow the system to be recovered without any
loss of data

Both of the drives are partitioned exactly the same:
      1.  3 primary partitions
      2.  Partition 1 - size - 1GB format as Linux Raid (fd)
      3.  Partition 2 - size = real memory size, format as linux swap (82)
      4.  Partition 3 = size = remainder of disk, format as linux raid (fd)

To ensure that the partitions are correct, and in the correct order, boot from
the install CD/DVD and run the rescue system.  Use fdisk from this system
to partition the two drives.  (The GUI disk partitioner which runs in the
anaconda installer has a tendency to move partitions around without asking.
We don't want this to happen!)  After saving the partition information on
both drives, you can Run the Linux installer.  Select "custom" installation.

Define a raid 1 mirror named fd0 using the first partition on both drives
Define a raid 1 mirror named fd1 using the third partition of both drives

Define a linux ext3 filesystem on fd0.  Mount on /boot
Define a linux Logical Volume Group named vg0 on fd1.
Within vg0, define the following Logical Volumes:
      lv00 - /
      lv01 - /tmp
      lv02 - /var
      lv03 - /usr
      lv04 - /usr/local
      lv05 - /home
      lv06 - /opt
I'm from the old school.  I believe in lots of partitions.  Create any
additional partitions you may need.  If you really want to, you can
just create a single partition and put "/" in it.  You still will
need the "/boot" partition since you can't boot from an LVM partition.

You can now continue to install linux normally.  I usually do it twice.
the first time is to get an idea of how big each partition should be
and the second time is to get it right.  Remember to leave some extra
unallocated space in the volume group to be allocated later if one of your
file systems fills up.  Read the linux logical volume manager docs.


In the event of a disk failure, follow the below procedure.

1.  Shutdown the system and remove the failed drive.

2.  If the second (non boot) drive is the failing drive, skip to step 9 below.

3.  Move the second (non boot) drive to the boot drive position.

4.  Boot from the linux rescue CD/DVD and start the system, no network.

5.  Use the "chroot /mnt/sysimage" command to mount the system.

6.  Run the command "/sbin/grub-install /dev/sda" or whatever your drive is
     to write a boot image into the MBR of the new boot drive.

7.  Remove the CD/DVD and re-boot.  The system should boot on a single drive
     and both raid array's will show no spare available.

8.  Shutdown the system

9.  Install a new drive, identical to the existing drive if possible.

10. Bring up the system and use fdisk to partition the new drive EXACTLY
     the same as the existing drive.

11. Format the swap partition with "mkswap /dev/sdb2"

12. Add the mirror for the /boot partition with "mdadm --add /dev/md0 /dev/sdb1"
     or whatever is appropriate for your system...

13. Add the mirror for the LVM partition with "mdadm --add /dev/md1 /dev/sdb3"
     or whatever is appropriate for your system...

14. Wait for the mirror to sync.  It may take several hours

------------------------------------------------------------------------------

Example:

Disk /dev/sda: 200.0 GB, 200049647616 bytes
255 heads, 63 sectors/track, 24321 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

    Device Boot  Start     End      Blocks   Id  System
/dev/sda1   *       1     131     1052226   fd  Linux raid autodetect
/dev/sda2         132     392     2096482+  82  Linux swap / Solaris
/dev/sda3         393   24321   192209692+  fd  Linux raid autodetect

/dev/sdb is exactly the same

md0 : active raid1 sdb1[1] sda1[0]
       1052160 blocks [2/2] [UU]

md1 : active raid1 sdb3[1] sda3[0]
       192209600 blocks [2/2] [UU]

Filesystem            Size  Used Avail Use% Mounted on
/dev/md0              996M   52M  893M   6% /boot
/dev/mapper/vg0-lv00  992M  373M  568M  40% /
/dev/mapper/vg0-lv01  2.0G  101M  1.8G   6% /tmp
/dev/mapper/vg0-lv02  2.0G  266M  1.6G  15% /var
/dev/mapper/vg0-lv03  4.9G  2.8G  1.9G  60% /usr
/dev/mapper/vg0-lv04  992M  104M  837M  12% /usr/local
/dev/mapper/vg0-lv05  2.0G  132M  1.8G   7% /var/www
/dev/mapper/vg0-lv06   20G  6.6G   12G  36% /home
/dev/mapper/vg0-lv07   44G   39G  3.2G  93% /opt
tmpfs                1010M     0 1010M   0% /dev/shm



