From: Bernd Rieke <bernd@rhm.de>
Subject: opensuse 11.1: after growing a raid1 by one disk, no md1 on boot
Date: Sun, 11 Jan 2009 19:55:01 +0100
Message-ID: <496A4085.8040904@rhm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

we made the following steps:

install an opensuse 11.1 as RAID1 on two scsi-disks:

/dev/md0 .... swap (/dev/sda1 /dev/sdb1)
/dev/md1 .... root (/dev/sda2 /dev/sdb2)

Just the install with no modifications, nothing else!

Everything works fine. We rebooted the system several times, it came up
as expected. Then we noticed that we forgot the third disk within the
arrays as we meant to have for more redundancy. So we made a

mdadm --grow -n 3 /dev/md0
mdadm --grow -n 3 /dev/md1
mdadm -a /dev/md0 /dev/sdc1
mdadm -a /dev/md1 /dev/sdc2

The third disk was synced, everything fine again. But on the next reboot
the system stopped with 'waiting for /dev/md1 to appear'.

When the system is installed initially with 3 disks there are no
problems. To produce the problem it needs only the --grow -n 3. After
this the root-partition /dev/md1 seems to be corrupted or not known to 
the kernel for any reasons.

When we try to assemble with the rescue system it tells us that there is
no superblock on /dev/sdx2. And when we try to mount one of the disks
directly it tells us that the filesystem linux-raid-xxx (forgot the xxx,
it was something like 'type', i think) is not a valid filesystem-type.

What goes wrong?

Kernel: 2.6.27.7-9-pae #1 SMP 2008-12-04 18:10:04 +0100

Greetings Bernd Rieke


