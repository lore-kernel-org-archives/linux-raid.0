From: hansbkk@gmail.com
Subject: Inconsistent UUIDs between mkconf vs blkid
Date: Fri, 4 Feb 2011 11:45:41 +0700
Message-ID: <AANLkTimpqwEoyZTNB+as0UyK8uOAy7P1fihBUBpd1tCs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm a bit of a Linux noob, feel free to redirect me elsewhere if this
is an inappropriate post for this list - also, apologies for the many
questions.

I've got a set of arrays that I boot up using Ubuntu (latest MM) and a
couple of Live CD distros for doing maintanence, particularly System
Rescue (gentoo) and Grml (debian), as well as the regular production
server OS, which is rpath-based, pretty close to "stable" (read:
ancient) rhel.

When one of the RAID1 arrays kept dropping all but two of the members,
I re-created it with options "-e=0.90 --auto=md". This was the boot
array for Ubuntu, which failed at boot time due to its UUID changing.
I figured the best thing to do would be to simply set the array's UUID
back to what it was before, so I ran e2fstune to do so, but
unfortunately I got it wrong (UUIDs are so human-unfriendly!), so now
it seems I'm doubly hosed, but I'm taking it on as a learning
experience 8-)

When I ran update-initramfs I got an extended message, apparently from
mdadm, about making sure that my UUIDs were consistent between
mdadm.conf and fstab. Well my fstab is based on filesystem labels (so
much better!), so I thought no worries, but when I ran the suggested
script - /usr/share/mdadm/mkconf, that returned a UUID for the array
that is completely different from that shown by blkid!

So, first the simple questions:

Q1 between mkconf and blkid, which should I trust for the current UUID
of the array (both the filesystem and the underlying component
partitions are the same right?)

Q2 I've noticed that fail/removing a component doesn't always re-set
the UUID, even when --zero-superblock'ing I sometimes need to actually
re-format the partition or use e2fstune to reset the UUID manually,
but other times no problems. Is this a version-specific difference?

Q3 Can I take the UUIDs out of my mdadmconf and just use the
super-minor? I'd really like to use the filesystem label, but that
doesn't seem to be an option.


The more complex question (I realize it's OT for the list so feel free
to ignore)

Q4 Besides the following, are there other places need to be changed
when the UUID changes?

   bootloader kernel statements
   fstab
   mdadm.conf
   update-initramfs

grub2 is handling my booting from a dedicated partition where I
manually maintain the grub.conf, so I'm using filesystem labels there
as well, but I'm thinking I'll also have to re-run grub-install and
grub-mkconfig to rebuild the boot-sector images and get a new
intra-partition grub.conf for Ubuntu? I'm chaining from my manually
maintained "uber grub.cfg" into Ubuntu's automatically-maintained
grub.cfg via configfile.

Finally, a big-picture question:

Q5 I've noticed that my arrays aren't quite as as stable as I'd like,
and I'm wondering if that might be due to the different
flavors/versions of mdadm running? The kernels range from 24 to 35,
and while I'm using .0.90.3 metadata for the boot arrays, I've gone
with 1.2 for the big storage RAID6's.


Thanks in advance. . .
