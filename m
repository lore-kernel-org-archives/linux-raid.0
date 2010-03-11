From: Carlos Mennens <carloswill@gmail.com>
Subject: Creating RAID5 w/ Hotspare?
Date: Thu, 11 Mar 2010 09:55:57 -0500
Message-ID: <d80f793f1003110655m4b49f1c3x36c8aef817c62d72@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a machine that supports 4 S-ATA drives. I have all identical
drives in each slot. I am asking for someone to please tell me how I
can create a RAID5 array on Linux and then also have the 4th drive
(/dev/sdd) as a hot spare for any of the three drives in the array /
volume?

I did the following:

/device = type @ parition size

/dev/sda1 = fd @ 100 MB (bootable for /boot)
/dev/sda2 = fd @ 1 GB (Going to be used for Swap)
/dev/sda3 = fd @ 300 GB (Going to be used for /)

Now I make the same thing for /dev/sdb & /dev/sdc. I DON'T PARTITION
OR FORMAT /dev/sdd.

Now I am creating my RAID and this is where I am confused. How do I
correctly issue the 'mdadm' command to create the volumes for my
filesystem and also utilize /dev/sdd as a hot spare?

(/boot)
mdadm --create /dev/md0 --level=1 --raid-devices=3 /dev/sda1 /dev/sdb1
/dev/sdc1 --spare-devices=1 /dev/sdd

(Swap)
mdadm --create /dev/md1 --level=1 --raid-devices=3 /dev/sda2 /dev/sdb2
/dev/sdc2 --spare-devices=1 /dev/sdd

(/)
mdadm --create /dev/md2 --level=5 --raid-devices=3 /dev/sda3 /dev/sdb3
/dev/sdc3 --spare-devices=1 /dev/sdd

Is that correct above or would I 1st have to partition the /dev/sdd drive?
