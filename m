From: "Vince W." <listacct1@lvwnet.com>
Subject: grub-install to mdp-style RAID1 array?
Date: Sun, 26 Mar 2006 09:00:18 -0500
Message-ID: <44269E72.209@lvwnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have a server which is currently still running on 1 of 2 drives.  The 
server originally had /boot, /, and swap partitions set up as RAID1 md 
devices, ie, matching partitions set up on each drive, then RAID1 md 
arrays created.  The other drive has failed, so I would like to create a 
new mdp-style array with 2 other drives and "migrate" the server to the 
new array.

I've gotten the mdp-style array created with no problem and am also able 
(by adding the array's info to /etc/mdadm.conf) to get FC5 to start the 
array before trying to init.  (my initrd.img already has the RAID1 
module in it).  So I think I'm pretty close to being able to get this 
working.  The one thing that seems to remain is getting the GRUB 
bootloader installed onto the mdp RAID device, goal being to be able to 
boot from the mdp RAID device.

The command I used to create the array was:

# mdadm --create /dev/mdpraid --auto=mdp --level=1 --raid-devices=2 
/dev/hdi /dev/hdk

which works fine, the raid device gets created without any problem. 
I've also tried this creating mdp arrays with more standard names for 
the device like /dev/md_d0 and /dev/md/d0.

I've mke2fs'd the mdpraid1 partition (first partition of the RAID 
device) for the /boot filesystem, and copied /boot/* from the drive the 
system is currently actually running on, then tried various ways of 
running grub-install.  The /boot filesystem on the new array is mounted 
at /raidtest/boot, where /raidtest would be the new root filesystem on 
/dev/mdpraid3, mounted here while running the current root filesystem.

I've tried these things:

editing /raidtest/boot/grub/device.map to define (hd0) as /dev/mdpraid
editing /raidtest/boot/grub/device.map to define (hd0) as /dev/md_d0
editing /raidtest/boot/grub/device.map to define (hd0) as /dev/md/d0

(the last two when that's what the test device was created as)
---
running grub-install:

# grub-install --root-directory=/raidtest /dev/mdpraid
response:
/dev/hdi does not have any corresponding BIOS drive.
---
running interactive grub shell:

     GNU GRUB  version 0.95  (640K lower / 3072K upper memory)

  [ Minimal BASH-like line editing is supported.  For the first word, TAB
    lists possible command completions.  Anywhere else TAB lists the 
possible
    completions of a device/filename.]

grub> device (hd0) /dev/mdpraid

grub> root (hd0,  <- tab completion attempt to see what it will say:
  Possible partitions are:
    Partition num: 0,  Filesystem type is ext2fs, partition type 0x83
    Partition num: 1,  Filesystem type unknown, partition type 0x82
    Partition num: 2,  Filesystem type is ext2fs, partition type 0x83

grub> root (hd0,0)
  Filesystem type is ext2fs, partition type 0x83

grub> setup

Error 11: Unrecognized device string

---

I was less expectant of the first method (grub-install) to work, but I 
can't seem to coax the interactive shell to 'setup', regardless of what 
I name the md device.  Just for the heck of it, I even tried 'mknod -m 
600 /dev/hdz b 254 0' to create another device node with a 
/dev/hd*-style name but pointing to the current block major/minor of the 
  /dev/mdpraid device, to try to fool GRUB into accepting the device 
name, but it gives the same error message (Error 11).

Any suggestions?  Am I going to have to manually install the bootloader 
to each member drive as is typically necessary with md-style RAID1 
devices so that either drive is bootable?

Neil helped me on a scenario like this a few years back when I was still 
using LILO and running a patched 2.4 kernel, but things seem rather 
different nowadays with 2.6.16 etc. and GRUB.  Any advice anyone can 
offer would be very much appreciated.

Thanks,
Vince

