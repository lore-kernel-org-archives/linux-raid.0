From: Alvin Oga <aoga@Maggie.Linux-Consulting.com>
Subject: Re: Re[2]: RH 7.3 raid1 setup
Date: Mon, 3 Jun 2002 05:39:56 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.3.96.1020603053217.19266A-100000@Maggie.Linux-Consulting.com>
References: <162623827266.20020603141854@vo.lu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <162623827266.20020603141854@vo.lu>
To: Christian Schmit <cschmit@vo.lu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


hi ya christian

looks okay too me... not that i played with grub too much but..

make a boot floppy so that we can recover if my experiment fails ...

	dd=/vmlinuz-2.4.18-3  of=/dev/fd0 bs-1204

	( or make a boot flop w/ syslinux
	http://www.Linux-Consulting.com/Boot/boot.flop.syslinux.txt

	( test that you can boot from floppy )
	( you'll see lots of "...." on the screen as it boot

	- should also work even if hda or hdc is disconnected

than comment out initrd in your grub.conf and "re-run/re-initialize" grub

	- that'd be my guess of why if you disconnect hda that the system
	wont boot
	- am guessing that the kernel that is in the initrd is NOT able
	to support raid1

- if its not the initrd.. ( guess i better go play with grub too one day )

- interesting problem... :-)

thanx
alvin


> grub.conf:
> -----------
> default=0
> timeout=10
> splashimage=(hd0,0)/grub/splash.xpm.gz
> title Red Hat Linux (2.4.18-3)
>         root (hd0,0)
>         kernel /vmlinuz-2.4.18-3 ro root=/dev/md2
>         initrd /initrd-2.4.18-3.img
> 
> 
> Partitions:
> ------------
> 
> Disk /dev/hda: 255 heads, 63 sectors, 5005 cylinders
> Units = cylinders of 16065 * 512 bytes
> 
>    Device Boot    Start       End    Blocks   Id  System
> /dev/hda1   *         1        45    361431   fd  Linux raid autodetect
> /dev/hda2            46       810   6144862+  fd  Linux raid autodetect
> /dev/hda3           811      1065   2048287+  fd  Linux raid autodetect
> 
> Disk /dev/hdc: 255 heads, 63 sectors, 5005 cylinders
> Units = cylinders of 16065 * 512 bytes
> 
>    Device Boot    Start       End    Blocks   Id  System
> /dev/hdc1   *         1        45    361431   fd  Linux raid autodetect
> /dev/hdc2            46       810   6144862+  fd  Linux raid autodetect
> /dev/hdc3           811      1065   2048287+  fd  Linux raid autodetect
> 

