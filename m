From: "A. Krijgsman" <a.krijgsman@draftsman.nl>
Subject: Debian kernel stanza after aptitude kernel upgrade
Date: Tue, 21 Sep 2010 12:39:24 +0200
Message-ID: <30D96C04B1444C569D53B7790707D718@DesktopManie>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear fellow software-raid-users,

Hopefully someone can help my out with their experience.
Since I am not a die-hard linux user, and are not very familiar with the 
kernel modules loaded during initrd.

Normally I install software raid1 on all servers I get my hands on (if it 
does not have a raid controller.)
I always use Debian, and their installer makes creating a raid 1 setup easy.
Now recently I switched two servers from a single disk setup to a raid1 
setup on a running setup, without the installer.

Yesterday I did a apt-get update / apt-get upgrade, and got myself a shiny 
new kernel package.
After rebooting that system was in a lockdown.

Stupid me! I didn't check the menu.lst of my grub, and apperantly aptitude 
rebuilded the initrd for the new kernel.
The sysadmin I got the server managed to het the md device back online and I 
can now access my server again trough ssh.

I wish to avoid this kind of problems in the future (and I prefere never to 
upgrade the kernel on a running machine again ;-))
However since it is smart to sometimes make those changes, I was wondering 
if there is a way to test if my machine will boot without actually booting 
it?
I checked up again with the raid1 turotials I used, and re-created the 
initramdisk. (I noticed that I lost the /etc/default/modules lines for md 
and raid1.)
What steps should I take in account to make sure my raid1 array is always 
bootable?

#My menu.list for grub:
default         0
fallback        1

#And the stanza's:

title           Debian GNU/Linux, kernel 2.6.26-2-686 RAID (hd1)
root            (hd1,0)
kernel          /boot/vmlinuz-2.6.26-2-686 root=/dev/md0 ro quiet
initrd          /boot/initrd.img-2.6.26-2-686

## ## End Default Options ##

title           Debian GNU/Linux, kernel 2.6.26-2-686
root            (hd0,0)
kernel          /boot/vmlinuz-2.6.26-2-686 root=/dev/sda1 ro quiet
initrd          /boot/initrd.img-2.6.26-2-686

#And my /etc/initramfs-tools/modules:
raid1
md

#And my /etc/modules
loop
raid1
md

An other questions I would like to ask is the following.
Since Grub loads the initrd-image from one of the two disks, if one fails, 
it won't boot the md root device anyway right?
Is it that whel /dev/sda fails, /dev/sdb becomes /dev/sda? (or must I state 
that hd1 becomes hd0 when hd0 has failed?)
This because I would prefere a stanza that always boots up in degraded mode, 
rather then in a panic kernel mode ;-)
I have seen stanza's containing both disksk within one stanza, don't know if 
this is old or still supported?

Thanks for your time to read and hopefully reply!

Regards,
Armand 

