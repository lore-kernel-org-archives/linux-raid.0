From: bernd@rhm.de
Subject: No boot after disk failure
Date: Fri, 27 May 2005 18:55:16 +0200 (MESZ)
Message-ID: <200505271655.SAA10388@node130.rhm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

we have a serious problem with raid1 after a disk fails and the spare was
taken in. The system isn't bootable from the remaining disks! 

Our configuration is (everything is SuSE 9.3 prof, nothing added/modified):

raid1 with 2 partitions (swap=md0, /=md1), 3 disks, 2 working, 1 spare.
We are using lilo as bootloader (raid-axtra-boot=mbr-ony, boot=/dev/md1)
lilo-Version is 22.3.2. When all is in place running lilo tells us for 
all three disks (x=a,b,c): 

   "boot area of /dev/sdx1 has been updated" 

We can boot off of the two working disks, we tested this by moving each of
them in the 'first place', fine!

Then we set the 2 partitions of one of the working disks faulty (mdadm -f)
It starts rebuilding the spare, takes one hour and finishes as expected.
We remove the 2 faulty partitions from the array (mdadm -r), everything
looks still fine (2 working disks, no spare anymore).

But when we reboot lilo fills up the screen with 01 (illegal disk command).
It's not possible to boot from any disk!

With the rescue-system we checked /dev/md1 (reiserfs), no corruptions found.
Then we mount /dev/md1 into /mnt, chroot to /mnt and give lilo -v. Lilo
tells the boot area of the disks have been updates. And now we can boot 
as usual, the system comes up without any problems.

What goes wrong? Why is the disk from which the spare is synced not bootable,
too. It _was_ bootable just before the mdadm -f/-r game. Nobody should have
touched anything related to the boot process on this disk. Ok, if the synced
spare would have problems booting from it, may be.

This is serious because we have the only chance to come up after a disk 
failure by using the rescue-system.

Thanks in advance
Greetings Bernd Rieke (if OT please advise where to post)
