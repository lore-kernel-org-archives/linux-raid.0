From: Doug Ledford <dledford@redhat.com>
Subject: Re: converting to raid - Error 2
Date: Fri, 30 Apr 2010 16:53:44 -0400
Message-ID: <4BDB4358.80009@redhat.com>
References: <4BDB4076.7010909@vorgon.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA430FB77D6EED6953BDFE369"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BDB4076.7010909@vorgon.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Timothy D. Lenz" <tlenz@vorgon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA430FB77D6EED6953BDFE369
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/30/2010 04:41 PM, Timothy D. Lenz wrote:
> This is something I've been trying to do for some time and there are 2
> older threads, but the last post got no responce, so starting a new
> thread. The old ones are:
>=20
> Converting system to raid
> Removing drives
>=20
> The computer with 2 sata drives switched over fine a long time ago, but=

> I have yet to get the one with 3 sata drives to boot with raid. Raid
> support is built into the kernel, partitions are type fd.
>=20
> fdisk -l shows:
> -----------------------------------------------------------------------=

> Disk /dev/hda: 40.0 GB, 40020664320 bytes
> 255 heads, 63 sectors/track, 4865 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Disk identifier: 0x6b381dfe
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/hda1   *           1        4660    37431418+  83  Linux
> /dev/hda2            4661        4865     1646662+   5  Extended
> /dev/hda5            4661        4865     1646631   82  Linux swap /
> Solaris
>=20
> Disk /dev/sda: 500.1 GB, 500107862016 bytes
> 255 heads, 63 sectors/track, 60801 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Disk identifier: 0x94140963
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sda1   *           1        3040    24418768+  fd  Linux raid
> autodetect
> /dev/sda2            3041        3649     4891792+  fd  Linux raid
> autodetect
> /dev/sda3            3650       60801   459073440   fd  Linux raid
> autodetect
>=20
> Disk /dev/sdb: 500.1 GB, 500107862016 bytes
> 255 heads, 63 sectors/track, 60801 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Disk identifier: 0xf1814421
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1   *           1        3040    24418768+  fd  Linux raid
> autodetect
> /dev/sdb2            3041        3649     4891792+  fd  Linux raid
> autodetect
> /dev/sdb3            3650       60801   459073440   fd  Linux raid
> autodetect
>=20
> Disk /dev/sdc: 500.1 GB, 500107862016 bytes
> 255 heads, 63 sectors/track, 60801 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Disk identifier: 0x371b6063
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdc3            3650       60801   459073440   fd  Linux raid
> autodetect
>=20
> Disk /dev/md0: 25.0 GB, 25004736512 bytes
> 2 heads, 4 sectors/track, 6104672 cylinders
> Units =3D cylinders of 8 * 512 =3D 4096 bytes
> Disk identifier: 0x00000000
>=20
> Disk /dev/md0 doesn't contain a valid partition table
>=20
> Disk /dev/md2: 940.1 GB, 940182208512 bytes
> 2 heads, 4 sectors/track, 229536672 cylinders
> Units =3D cylinders of 8 * 512 =3D 4096 bytes
> Disk identifier: 0x00000000
>=20
> Disk /dev/md2 doesn't contain a valid partition table
>=20
> Disk /dev/md1: 5009 MB, 5009113088 bytes
> 2 heads, 4 sectors/track, 1222928 cylinders
> Units =3D cylinders of 8 * 512 =3D 4096 bytes
> Disk identifier: 0x00000000
>=20
> Disk /dev/md1 doesn't contain a valid partition table
> -----------------------------------------------------------------------=

>=20
> Orginaly I had made both md0 and md1 2-way mirrors with a spare. But
> when it wouldn't boot, I was told it might be because of the spare and
> to grow them in. That also didn't work. I change md0 and md1 to 2-way
> mirrors, and removed the boot flag for sdc1 and zeroed superblock And I=

> corrected the mdadm.conf file to reflect the changes to md0/1. Still
> would not boot from raid. I removed the two partitions sdc1 and sdc2
> leaving just sdc3 which is part of md2 raid5. Also re-ran grub on md0
> using:
>=20
>  sudo grub
>  grub>device (hd0) /dev/sda
>  grub>root (hd0,0)
>  grub>setup (hd0)

You can't use the setup macro (can't remember why, I just know it
generally doesn't work) when putting grub on your raid1 array.  You need:=


install --stage2=3D/grub/stage2 /grub/stage1 (hd0) /grub/e2fs_stage1_5
/grub/stage2 /grub/grub.conf

and if that doesn't work in your particular configuration, you can add
the d option after stage1 and before (hd0), but if you use it, then your
boot disk must always be BIOS device 0x80, which means setting your BIOS
to boot off of some disk other than the first disk found usually won't
work and instead you just have to make whatever disk you want to boot
off of the first disk found by the BIOS.  You can switch (hd0) to
(hd0,0) if you want and if you have a normal DOS master boot record.

>  grub>device (hd0) /dev/sdb
>  grub>root (hd0,0)
>  grub>setup (hd0)
>=20
> To copy the current boot drive hda1 over to md0, I use a GRML boot disk=
,
> mount /dev/md0 to /mnt/md0 and /dev/sdd1 (/dev/hda1) to /mnt/sdd1, then=
 do:
>=20
> rsync -caHh --progress --delete /mnt/sdd1/ /mnt/md0.
>=20
> Then I reboot normally. I have 2 copies of /boot/grub/device.map,
> /boot/grub/menu.lst and /etc/fstab. one for normal boot and one for
> raid. On /mnt/md0 I swap the normal boot files for the raid files by
> adding .old to the names of normal boot and removing .raid from the rai=
d
> versions. Then reboot again and in cmos move the pata drive to the
> bottom of the list so cmos tries the sata drives first. That worked for=

> the 32bit linux 2 drive system. But on this 64bit 3 drive I get:
>=20
> Grub loading stage 1.5
> Grub loading, please wait
> Error 2
>=20
> I can't remove the 3rd drive because it has part of md2 and I shouldn't=

> need to anyway. Copies of the above mentioned files I put at:
> http://24.255.17.209:2400/vdr/local/raid/
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigA430FB77D6EED6953BDFE369
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvbQ1gACgkQg6WylM+/8ZT2cwCfd4q0iG+i7qBElEqFxqjBUgFf
9AkAnR4JWwqXTc33bZC9J+QVfeAPNUMK
=a/PU
-----END PGP SIGNATURE-----

--------------enigA430FB77D6EED6953BDFE369--
