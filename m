From: Neil Brown <neilb@suse.de>
Subject: Re:
Date: Sun, 14 Nov 2010 06:36:00 +1100
Message-ID: <20101114063600.20c9bd33@notabene>
References: <BAY148-w34F1B0624B57B12374AC90EF340@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY148-w34F1B0624B57B12374AC90EF340@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Viau <viaum@sheridanc.on.ca>
Cc: linux-raid@vger.kernel.org, debian-user@lists.debian.org
List-Id: linux-raid.ids

On Sat, 13 Nov 2010 01:01:47 -0500
Mike Viau <viaum@sheridanc.on.ca> wrote:

>=20
> Hello,
>=20
> I am trying to re-setup my fake-raid (RAID1) volume with LVM2 like se=
tup previously. I had been using dmraid on a Lenny installation which g=
ave me (from memory) a block device like /dev/mapper/isw_xxxxxxxxxxx_ a=
nd also a /dev/One1TB, but have discovered that the mdadm has replaced =
the older and believed to be obsolete dmraid for multiple disk/raid sup=
port.
>=20
> Automatically the fake-raid LVM physical volume does not seem to be s=
et up. I believe my data is safe as I can insert a knoppix live-cd in t=
he system and mount the fake-raid volume (and browse the files). I am p=
lanning on perhaps purchasing another at least 1TB drive to backup the =
data before trying to much fancy stuff with mdadm in fear of loosing th=
e data.
>=20
> A few commands that might shed more light on the situation:
>=20
>=20
> pvdisplay (showing the /dev/md/[device] not recognized yet by LVM2, n=
ote sdc another single drive with LVM)
>=20
>   --- Physical volume ---
>   PV Name               /dev/sdc7
>   VG Name               XENSTORE-VG
>   PV Size               46.56 GiB / not usable 2.00 MiB
>   Allocatable           yes (but full)
>   PE Size               4.00 MiB
>   Total PE              11920
>   Free PE               0
>   Allocated PE          11920
>   PV UUID               wRa8xM-lcGZ-GwLX-F6bA-YiCj-c9e1-eMpPdL
>=20
>=20
> cat /proc/mdstat (showing what mdadm shows/discovers)
>=20
> Personalities :
> md127 : inactive sda[1](S) sdb[0](S)
>       4514 blocks super external:imsm
>=20
> unused devices:=20

As imsm can have several arrays described by one set of metadata, mdadm
creates an inactive arrive just like this which just holds the set of
devices, and then should create other arrays made of from different reg=
ions
of those devices.
It looks like mdadm hasn't done that you.  You can ask it to with:

  mdadm -I /dev/md/imsm0

That should created the real raid1 array in /dev/md/something.

NeilBrown


>=20
>=20
> ls -l /dev/md/imsm0 (showing contents of /dev/md/* [currently only on=
e file/link ])
>=20
> lrwxrwxrwx 1 root root 8 Nov  7 08:07 /dev/md/imsm0 -> ../md127
>=20
>=20
> ls -l /dev/md127 (showing the block device)
>=20
> brw-rw---- 1 root disk 9, 127 Nov  7 08:07 /dev/md127
>=20
>=20
>=20
>=20
> It looks like I can not even access the md device the system created =
on boot.=20
>=20
> Does anyone have a guide or tips to migrating from the older dmraid t=
o mdadm for fake-raid?
>=20
>=20
> fdisk -uc /dev/md127=C2=A0 (showing the block device is inaccessible)
>=20
> Unable to read /dev/md127
>=20
>=20
> dmesg (pieces of dmesg/booting)
>=20
> [=C2=A0=C2=A0=C2=A0 4.214092] device-mapper: uevent: version 1.0.3
> [=C2=A0=C2=A0=C2=A0 4.214495] device-mapper: ioctl: 4.15.0-ioctl (200=
9-04-01) initialised: dm-devel@redhat.com
> [=C2=A0=C2=A0=C2=A0 5.509386] udev[446]: starting version 163
> [=C2=A0=C2=A0=C2=A0 7.181418] md: md127 stopped.
> [=C2=A0=C2=A0=C2=A0 7.183088] md: bind<sdb>
> [=C2=A0=C2=A0=C2=A0 7.183179] md: bind<sda>
>=20
>=20
>=20
> update-initramfs -u (Perhaps the most interesting error of them all, =
I can confirm this occurs with a few different kernels)
>=20
> update-initramfs: Generating /boot/initrd.img-2.6.32-5-xen-amd64
> mdadm: cannot open /dev/md/OneTB-RAID1-PV: No such file or directory
>=20
>=20
> Revised my information, inital thread on Debian-users thread at:
> http://lists.debian.org/debian-user/2010/11/msg01015.html
>=20
> Thanks for any ones help :)
>=20
> -M
>  		 	   		  --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
