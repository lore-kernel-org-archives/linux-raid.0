From: Brennahn Chesteine <ven_ficken@yahoo.com>
Subject: initrd showing root at 1,9 when it's at 0,0 new kernel wont boot
Date: Wed, 19 Mar 2003 09:09:01 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030319170901.75221.qmail@web14408.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

this is odd. I ususally use "make install" when
building a kernwel to take care of initrd but I noted
it said this 

tools/build -b bbootsect bsetup
compressed/bvmlinux.out CURRENT > bzImage
Root device is (9, 1)
Boot sector 512 bytes.
Setup is 2533 bytes.
System is 1098 kB
warning: kernel is too big for standalone boot from
floppy

should I be using the "#boot=/dev/hde" in my
grub.conf?

My grub.con looks like this 
default=2
timeout=10
splashimage=(hd0,0)/grub/splash.xpm.gz
title Red Hat Linux (2.4.20)
         root (hd0,0)
         kernel /vmlinuz-2.4.20 ro root=/dev/md1
 hdb=ide-scsi
        initrd /initrd-2.4.20.img
 
 title linux
         root (hd0,0)
         kernel /vmlinuz-2.4.18-26.8.0 ro
 root=/dev/md1
 hdb=ide-scsi
         initrd /initrd-2.4.18-26.8.0.img


The stock kernel boots just fine but 2.4.20 says it
cannot start modprobe then dies saying cannot locate
root dev @ 9,1.

Ahh, help

__________________________________________________
Do you Yahoo!?
Yahoo! Platinum - Watch CBS' NCAA March Madness, live on your desktop!
http://platinum.yahoo.com
