From: "Max Booker" <max.booker@ntlworld.com>
Subject: Raid1 and mdadm
Date: Sat, 29 Mar 2003 20:28:34 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <005e01c2f631$c5de3620$6b7ba8c0@max>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello

I am a Linux newbie, using Redhat Linux 7.3 Kernel 2.4.18-17.7.x on an Asus
7V333 with Promise Raid Controller (disabled).

I would like to understand more about Raid in a Linux environment, except
that all the documentation I have read seems not to apply to my case.

I understand that mdadm is better than raidtools, but I still cannot get my
head around the concept of how Linux Raid works.

Neil Brown gave a reply to splee in April, which seems to be relatively
straightforward - however, when I try this method, I get a kernel panic.

My setup is as follows:

GRUB boot loader

    hda1    /boot
    hda2    /
    hda3    swap

    hdd1    (intended) mirror partition of  /

I can create the (degraded) array on hdd1, mkfs on /dev/md0, mount /dev/md0
as /mnt, copy / to /mnt, and edit /mnt/etc/fstab.

Everything works well up to the point where I reboot, with kernel parameters
(md=0,/dev/hdd1 root=/dev/md0). This is where the kernel panics.

I think that I have not edited fstab properly, or GRUB is getting in the
way, or maybe it is not possible to add hda2 to the array because it already
has a filesystem on it.... How do I get hda2 to be part of the Raid array?
Nothing attempted so far has made any impression on the fact that mdadm
insists that /dev/hda2 is not an md component.

I hope that this is enough info.

Best regards

Max Booker

