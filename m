From: "Ian! D. Allen" <idallen@idallen.ca>
Subject: Re: Mdadm -- how to add another device in a linear mode?
Date: Thu, 27 Apr 2006 20:11:34 -0400
Message-ID: <20060428001134.GH11345@elm.home.idallen.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>1- I would like to create a linear raid level with one device.
>2- I would like to add another device to the first one.

An example.

Since a linear array is dependent on *all* the component devices, failure 
could be a problem as you add more components.  (A failure of any single
device will bring down the whole linear.  Bad.)  So I always add raid1
devices to a linear, never raw disk partitions.  A disk failure only
degrades the raid1, it doesn't destroy the linear.

Create a raid1 pair from two partitions: 

  mdadm --create --auto=yes --level=raid1 --raid-devices=2 \
     /dev/md10 /dev/sdc1 /dev/sdd1

Put the raid1 device into a linear (only one device!) and make a file system:

  mdadm --create --auto=yes --level=linear --force --raid-devices=1 \
     /dev/md12 /dev/md10
  mkfs -j /dev/md12              # creates an ext3 journalling file system
  mkdir -p /mnt/test
  mount /dev/md12 /mnt/test
  df -h

Do whatever you need with /dev/md12 (the linear).  Time passes.  You want
to add another device to the linear and grow the ext3 file system to 
use the rest of the space.  You can do all this without copying your data.

First, make another raid1 device to add to the linear:

  mdadm --create --auto=yes --level=raid1 --raid-devices=2 \
     /dev/md11 /dev/sde1 /dev/sdf1

To grow the linear by adding to the end, unmount the fs, stop the linear,
remake it with both raid1 pairs (get the order right!), and resize the
file system to fill the new big linear partition:

  umount /mnt/test
  mdadm --stop /dev/md12
  mdadm --create --auto=yes --level=linear --raid-devices=2 \
     /dev/md12 /dev/md10 /dev/md11
  fsck -f -C /dev/md12            # resize2fs wants a fsck first
  resize2fs -p /dev/md12          # grows to fill entire linear partition
  fsck -f -C /dev/md12            # should be clean
  mount /dev/md12 /mnt/test
  df -h                           # shows full new size

Note that an ext[23] file system will allocate files *all over* the 
new large linear partition, using both /dev/md10 and /dev/md11, so just
because you added a new disk at the *end* of the linear array doesn't
mean it won't get used the instant it's mounted as part of an ext[23]
file system.

-- 
- Ian! D. Allen  -  idallen@idallen.ca  -  Ottawa, Ontario, Canada
| Home Page: http://www.idallen.com/ - Contact Improv: http://contactimprov.ca/
| College professor (Open Source / Linux) via: http://teaching.idallen.com/
| Support the public commons and public digital rights:  http://eff.org/
