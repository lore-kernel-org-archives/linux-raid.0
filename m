From: Thomas -Balu- Walter <tw@itreff.de>
Subject: Woody, initrd, raid1, boot
Date: Mon, 17 Jun 2002 17:15:11 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020617171511.B12084@itreff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

First two smaller questions/notes:
The FAQ at http://www.tldp.org/FAQ/Linux-RAID-FAQ/index.html lists
three mailinglist-archives, while only
http://marc.theaimsgroup.com/?l=linux-raid&r=1&w=2 seems to have actual
mails (I was kinda shocked that the last mails were coming from 2000 :)

What are the actual raidtools? raidtools-20010914?

Now to a something more complex problem (which I am going to despair on):

I've read different HOWTOs, Hints, Tipps and tricks, but none helped.

I am trying to set up a debian (woody) system running the
debian-packaged 2.4.18-686-kernel that boots from "root=/dev/md1" (and
uses the debian-initrd to load the md-modules)

To do so, I've installed a minimal woody using a netinstall-CD and
upgraded it to kernel-image-2.4.18-686 (including the initrd-changes to
lilo). The system got installed on hda:

Disk /dev/hda: 4865 cylinders, 255 heads, 63 sectors/track
Units = cylinders of 8225280 bytes, blocks of 1024 bytes, counting from 0

   Device Boot Start     End   #cyls   #blocks   Id  System
/dev/hda1   *      0+      5       6-    48163+  83  Linux
/dev/hda2          6      67      62    498015   82  Linux swap
/dev/hda3         68     675     608   4883760   83  Linux
/dev/hda4          0       -       0         0    0  Empty

while /dev/hhda1 is mounted as /boot and /dev/hda3 is mounted as / and
/dev/hdc got exact the same partition table. 

I rebooted to get 2.4.18 up and running, then I've changed the
/dev/hdc-partitions to be Raid-Autodetect and set up the following
/etc/raidtab:

        # /boot
        raiddev /dev/md0
                raid-level      1
                nr-raid-disks   2
                nr-spare-disks  0
                chunk-size      4
                persistent-superblock   1
                device          /dev/hdc1
                raid-disk       0
                device          /dev/hda1
                failed-disk     1

        # /
        raiddev /dev/md1
                raid-level      1
                nr-raid-disks   2
                nr-spare-disks  0
                chunk-size      4
                persistent-superblock   1
                device          /dev/hdc3
                raid-disk       0
                device          /dev/hda3
                failed-disk     1

I've prepared the md-devices using mkraid and mke2fs, mounted them
        /dev/md1 -> /mnt
        /dev/md0 -> /mnt/boot

Next was to "cp -a" the installed system on the md-devices (all but
/mnt, /proc and /lost+found) and change /mnt/etc/fstab to mount the
md-devices instead of the original /dev/hda partitions.

So far, everything is okay. Next I tried to reboot and at boot I told
lilo to run "Linux root=/dev/md1", but I get

        md: md driver 0.90.0 MAX_MD...
        cramfs: wrong magic
        EXT3-FS: unable to read superblock
        EXT2-FS: unable to read superblock
        Kernel panic: VFS: Unable to mount root fs on 09:01

Missing the raid-module, I've added "raid1" to /etc/mkinitrd/modules and
created a new initrd:
      # mkinitrd -o /boot/initrd-2.4.18-686-raid1 /lib/modules/2.4.18-686
      # ln -sf /boot/initrd-2.4.18-686-raid1 /initrd.img
      # lilo

Now the raid1-module gets loaded right after the md-module, but I keep
getting the same error.

I've also tried the way James Bromberger suggests in
http://www.james.rcpt.to/programs/debian/raid1/ - especially using
(manually entered by now though) the append parameters
"md=0,/dev/hdc1,/dev/hda1", and "root=/dev/md0" (and
"md=1,/dev/hdc3,/dev/hda3") and and and.

Also tested was root=/dev/md1 in mkinitrd.conf.

Another approach was adding the values to lilo.conf - 
        boot=/dev/md0
        root=/dev/md1
(which should not make a difference than adding it to the lilo-prompt?)

One of my biggest problems is, that I don't know where the problem is
located - is it lilo (which boots the kernel and initrd and should be
fine?), initrd (missing a module?) or the root-filesystem on the
md-devices, or even the md-devices themself (it should be possible to
boot from a degraded device?)

I am really clueless... :-/ any hints?

     Balu
-- 
In the begining was the word, and the word was:
Content-Type: text/plain; charset=us-ascii
