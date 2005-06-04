From: =?ISO-8859-1?Q?paul_k=F6lle?= <paul@subsignal.org>
Subject: Re: Cannot boot from initrd into RAID1[solved]
Date: Sat, 04 Jun 2005 19:57:09 +0200
Message-ID: <d7spor$i1i$1@sea.gmane.org>
References: <d7l3mj$o1j$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d7l3mj$o1j$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

paul k=F6lle wrote:
> Hi list,
>=20
> well, I won't bother you with the whole story, so just the important
> facts. I have to use initrd because I need to preload the module for =
the
>  SATA Controller (4port Marvell). I have 4 disks with /<root> and a f=
ew
> other partitions on RAID1 and others on RAID5. I made a raidtab confi=
g
> and build the arrays with no problems, created fstab an can mount all
> partitions from my boot/rescue system just fine. The problem is booti=
ng
> the system. After loading the SATA module, linuxrc tries to mount
> /dev/md0 (which is supposed to be /<root>) and fails with input/outpu=
t
> error. ^D -> rescue shell let me do cat /proc/mdstat wich shows
> something like:
> <identities>  [raid1 raid5]
>=20
> but no arrays. I wonder if I need a statically built binary of mdadm =
or
> thelike in initrd to initialize the arrays or should a proper configu=
red
> kernel just do fine?
replying to myself:

As it turned out the problem is that if RAID support is compiled into
the kernel but the driver for the disk controller is a module the kerne=
l
tries to init the RAID but the disks aren't there yet because the modul=
e
is loaded later from the initrd system.

There are two possible solutions:

1. Build all RAID support as modules and make sure the modules are
loaded in the correct order from initrd. Than with partitions set to FD=
,
the kernel should be able to access the /dev/md* devices (haven't tried
this actually).

2. Include a statically build version of mdadm or raidstart into the
initrd and run it (through linuxrc) *after* the disk controller has bee=
n
initialized and *after* the device nodes have been populated by udev.


cheers
 Paul

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
