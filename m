From: <lrhorer@satx.rr.com>
Subject: Upgrading to GRUB2 from GRUB Legacy on RAID1
Date: Thu, 10 Jun 2010 19:40:27 -0500
Message-ID: <4D.41.26996.506811C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	I thought I had sent this previously, but I don't see a reflection
copy in my in-box.  Pardon me if this is a duplicate, but OTOH, if it is,
doesn't anyone have any comments or advice?  I'm especially a little fuzzy
around step 4 below.  I think I need to run `grub-setup` or something, but
I'm not clear on the details.

	Dilemma: GRUB legacy will not upgrade to GRUB2 on my machines.  The
systems were originally built to "fake out" GRUB legacy by using a 1.0
superblock on a pair of RAID1 members and pointing GRUB to one or the other
of the disks so it can chain load from what it thinks is an ordinary primary
partition.  Once initrd loads and md is active, it assembles the arrays and
then the kernel mounts / and then /boot, and booting continues normally.

	The cause: When dpkg instructs grub-pc to configure itself, it fails
because it is unable to reconcile the information in /boot/grub/menu.lst
with the hardware mounted by /etc/fstab.

	The cure? : I was thinking I should be able to comment out the
entries for /dev/md1 in /etc/fstab  and /etc/mdadm/mdadm.conf, and reboot
the system.  Then I think I can

1.  Mount /dev/hda1 to /boot.

2.  Upgrade GRUB, which should now understand both /etc/fstab and
/boot/grub/menu/lst.

3.  Reboot to make sure it works.

4.  Edit /boot/grub/grub.cfg and /boot/grub/device.map to let GRUB2 know it
should be booting from an array and to make sure it is loading the RAID1
module.

5.  Umount /boot and create a new 1.0 superblock RAID1 array using only
/dev/hda1 and a missing member.  Mount the new array as /boot.

6.  Add the new array info into /etc/mdadm/mdadm.conf and change /etc/fstab
back to mount /dev/md1.

7.  Run update-initramfs to copy the new configuration into initrd.

8.  Reboot and make sure GRUB2 can now boot into the new array.

9.  Add /dev/hdb1 into the new array, and re-sync the array.

10. Update /etc/mdadm/mdadm.conf with the full array info, getting rid of
the missing member, and remove the reference to the old array altogether.

11. Run the GRUB update routine to remove the chain-load from GRUB legacy.

12. Run update-initramfs to copy the final configuration into the initrd (if
GRUB update doesn't already do it.)

	Is my thinking correct, here?  Have I missed a step?  Up until step
9, I should be able to easily revert back to my original configuration by
simply removing the comment for the old array, forcing an assembly of the
old array using only /dev/hdb1, add back /dev/hda1, resync the array, remove
the comment from /etc/fstab and run update-initramfs.



