From: Louis-David Mitterrand <vindex@apartia.org>
Subject: Re: recovering after a /dev/sda failure on raid1
Date: Mon, 5 Aug 2002 11:34:40 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020805093440.GB577@apartia.org>
References: <15690.63749.164322.929689@notabene.cse.unsw.edu.au> <Pine.LNX.4.30.0208030058480.26520-100000@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.30.0208030058480.26520-100000@duplo.agenda.si>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Aug 03, 2002 at 01:03:34AM +0200, Danilo Godec wrote:
> On Sat, 3 Aug 2002, Neil Brown wrote:
> 
> > > My concern is that if I power down and replace /dev/sda the machine
> > > won't be able to reboot without a rescue CD (lilo.conf has root=/dev/md0
> > > and boot=/dev/md0) or will it?
> 
> A recent enough lilo knows raid partition and will install it self on both
> disks. So, in theory both disk should be able to boot you system.

In theory, because I was unable to boot this debian sid system with
lilo-22.2 and these settings:

	boot=/dev/md0
	root=/dev/md0
	install=/boot/boot-menu.b
	delay=20
	map=/boot/map
	read-only

	image=/vmlinuz
		label=Linux

After altering the SCSI bios setting to boot from /dev/sdb the screen
filled with 01010101010.

However this is not specific to booting on degraded mode. I have the
same problem when both disks are fine. The machine will only boot after
I changed "boot=/dev/sda" and run lilo. I can then revert to
"boot=/dev/md0" and re-run lilo and from there booting will work fine.

> > > When the bios (Dell Poweredge 1500) will try /dev/sda's mbr and fail,
> > > will it then automatically try /dev/sdb?
> 
> It might not even try /dev/sdb if /dev/sda exists...
> But with some recent bioses you can choose which drive you want to boot,
> sou you could just choose your 2nd SCSI drive and it should work.

Yes, I found that out, sorry for the basic questions but I was a bit
stressed changing a disk on a production server and having it not
restart. But all went well in the end.

Thanks again to kernel-raid developers, on another server I replaced a
Mylex card with a kernel raid5 partition and the speed gain is
tremendous!

Cheers,

-- 
ldm@apartia.org 
