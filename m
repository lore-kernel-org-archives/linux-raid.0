From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Can't boot from /dev/md0 (RAID-1) (more info)
Date: Mon, 1 Jul 2002 12:17:46 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200207011217.46988.roy@karlsbakk.net>
References: <Pine.LNX.3.96.1020630164412.31859A-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.3.96.1020630164412.31859A-100000@Maggie.Linux-Consulting.com>
To: Alvin Oga <aoga@Maggie.Linux-Consulting.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Please listen

I've tried all this

see the dmesg output

On Monday 01 July 2002 01:50, Alvin Oga wrote:
> hi ya
>
> how was the floppy made ??
> 	- does it have a initrd file ??
> 	- initrd is notlisted in your lilo.conf.hda
> 	- is the kernel on the bootable floppy the same as that
> 	referenced in lilo.conf ?
>
> i'd take out all those explicit defines and see if it helps
>
> simplified(?) lilo.conf
> 	boot=/dev/md0
> 		- not sure about boot= for /dev/hda vs /dev/md0
> 	map=/boot/map
> 	install=/boot/boot.b
> 	prompt
> 	timeout=50
> 	lbad32
>
> 	image=/boot/vmlinuz
> 	   root=/dev/md0
> 	   label=raid
> 	   read-only
>
> -- you'd also want to use /dev/hda  and /dev/hdc ...
>
> c ya
> alvin
>
> On Sun, 30 Jun 2002, Roy Sigurd Karlsbakk wrote:
> > see below for my original post
> >
> > I've uploaded some files to http://karlsbakk.net/bugs/ that may help to
> > explain the problem. Still - I can't boot from nothing but floppy.

-- 
Roy Sigurd Karlsbakk, Datavaktmester

Computers are like air conditioners.
They stop working when you open Windows.

