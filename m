From: danci@agenda.si
Subject: RE: Autodetection howto
Date: Tue, 29 Jun 2004 10:04:24 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0406290954440.8085@desktop.agenda.si>
References: <000001c453e8$7f3d2c10$7001a8c0@darwin>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000001c453e8$7f3d2c10$7001a8c0@darwin>
To: Tim Harvey <tharvey@alumni.calpoly.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > 2. If you have raid compiled as modules, you need a proper initrd
> >    which will load appropriate modules (raid5) and then re-autodetect
> >    the arrays (SuSE uses 'raidautorun' for that) - all that before
> >    your OS actually starts booting.

> I'm not exactly sure how to do this... could you give me an example?  
> My existing initrd is /boot/initrd-2.4.22-1.2140.nptl_30.rhfc1.at.img so
> I'm attempting:
> 
> # mkinitrd --preload raid5.o
> /boot/initrd-2.4.22-1.2140.nptl_30.rhfc1.at.img 2.4.22-1
> 
> I'm getting a usage error and I'm evidently not understanding mkinitrd's
> man page.

mkinitrd is pretty much distribution specific, so I cannot help you much
with that.

However, according to man page on Redhat 7.2 AXP that I have access to,
the 'mkinitrd' script is supposed to add raid modules automatically if the
system's root partition is on raid (I suppose it checks the /etc/fstab and 
/etc/raidtab files)...

Maybe you should check the content of your initrd by:

1. cp /boot/initrd-2.4.22-1.2140.nptl_30.rhfc1.at.img /tmp/myinitrd.gz
2. gunzip /tmp/myinitrd.gz
3. mkdir /tmp/loop
4. mount -o loop /tmp/myinitrd /tmp/loop
5. cd /tmp/loop

Here you will see a 'linuxrc' script, which lists all the commands that 
are executed.

This is my 'linuxrc':

#!/bin/nash

echo "Loading jbd module"
insmod /lib/jbd.o
echo "Loading ext3 module"
insmod /lib/ext3.o
mount -t proc /proc /proc
echo Mounting /proc filesystem
echo Creating root device
mkrootdev /dev/root
echo 0x0100 > /proc/sys/kernel/real-root-dev
umount /proc
echo Mounting root filesystem
mount --ro -t ext3 /dev/root /sysroot
pivot_root /sysroot /sysroot/initrd

As you can see, I don't use root on raid on this particular machine.

  D.


