From: Mark Knecht <markknecht@gmail.com>
Subject: Guidance on how to best assemble new root drive?
Date: Sat, 1 Jan 2011 11:47:05 -0800
Message-ID: <AANLkTi=eU7Z8OaiAkEkatoN3-U67LEYcB5reB1f27QyU@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
   First off - everything is working. I'm just looking for guidance on
the best way to assemble a RAID that was created in a previous
installation. Note that this is a home server, not a commercial
machine, so my needs are likely very simple compared to others.

   My home server is named 'c2stable'. It currently uses a RAID1 that
is SuperBlock Ver. 0.9. I wanted to convert the machine to a 5-drive
SuperBlock Ver. 1.2 RAID6 which I have already created while running
c2stable. mdadm --detailssays the name is c2stable:3 . This drive
mounts as /dev/md3 and uses /dev/sd{a,b,c,d,e}3 .

   I installed Gentoo on /dev/md3 inside of a chroot, set that
machine's name to 'c2RAID6', created a kernel to boot and made an
initramfs file following the Gentoo docs. (Such as they were. Quite
sketchy for RAID and my also first initramfs.) I set the thing up to
boot and promptly got stuck because mdadm wouldn't assemble /dev/md3
for me.

   Using busybox and a bit of playing around I found I could assemble
md3 by hand using:

mdadm --assemble --name=c2stable:3 /dev/md3

I put that in my init file and the machine booted first time. Hooray!

   I'm now wondering if this is really the best way to do this
assembly. It would seem that my c2RAID6 file system will then always
carry the old c2stable name which is a bit strange. (To me...)

   Is there a way to rename the array in the SuperBlock? Should I
bother? I may go back and forth between these two Gentoo installations
for a while and want the RAID to be available in both, at least until
I delete the old RAID1 system to recapture the disk space.

   Any and all guidance welcomed.

Cheers,
Mark
