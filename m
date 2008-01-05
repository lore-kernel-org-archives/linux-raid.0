From: Nagilum <nagilum@nagilum.org>
Subject: Re: Raid 1, can't get the second disk added back in.
Date: Sat, 05 Jan 2008 21:00:02 +0100
Message-ID: <20080105210002.t5syxhjahwocks4g@cakebox.homeunix.net>
References: <477FAAAC.2090107@fayettedigital.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_6yldozc76qcc";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <477FAAAC.2090107@fayettedigital.com>
Sender: linux-raid-owner@vger.kernel.org
To: jim@fayettedigital.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_6yldozc76qcc
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

----- Message from jim@fayettedigital.com ---------
     Date: Sat, 05 Jan 2008 11:05:00 -0500
     From: Jim <jim@fayettedigital.com>
Reply-To: jim@fayettedigital.com
  Subject: Raid 1, can't get the second disk added back in.
       To: linux-raid@vger.kernel.org


> Sometime in the distant past, I lost a member of my raid 1 group.
> Here's some output:
>
> root@chinaberry:~# mdadm /dev/md0 --add /dev/hdb5
> mdadm: Cannot open /dev/hdb5: Device or resource busy
> root@chinaberry:~# cat /proc/mdstat
> Personalities : [raid1]
> md0 : active raid1 hda5[1]
>      93771264 blocks [2/1] [_U]
>
> unused devices: <none>
> root@chinaberry:~# cat /etc/mdadm.conf
> DEVICE /dev/hdb5 /dev/hda5
> ARRAY /dev/md0 level=3Draid1 num-devices=3D2
>
> root@chinaberry:~# fdisk -l /dev/hdb
>
> Disk /dev/hdb: 120.0 GB, 120034123776 bytes
> 255 heads, 63 sectors/track, 14593 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
>
>   Device Boot      Start         End      Blocks   Id  System
> /dev/hdb1               1         973     7815591   83  Linux
> /dev/hdb2             974        1946     7815622+  83  Linux
> /dev/hdb3            1947        2919     7815622+  83  Linux
> /dev/hdb4            2920       14593    93771405    5  Extended
> /dev/hdb5            2920       14593    93771373+  83  Linux
> root@chinaberry:~# fdisk -l /dev/hda
>
> Disk /dev/hda: 120.0 GB, 120034123776 bytes
> 255 heads, 63 sectors/track, 14593 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
>
>   Device Boot      Start         End      Blocks   Id  System
> /dev/hda1   *           1         973     7815591   83  Linux
> /dev/hda2             974        1946     7815622+  83  Linux
> /dev/hda3            1947        2919     7815622+  83  Linux
> /dev/hda4            2920       14593    93771405    5  Extended
> /dev/hda5            2920       14593    93771373+  83  Linux
>
> I attempted to boot single user mode and fsck /dev/hdb5 but single user
> doesn't seem to do what it used to, for some reason /dev/md0 was
> mounted.  However I did boot Knoppix CD and do a fsck -f /dev/hdb5.  It
> had no errors and when I rebooted back it still wouldn't install.
>
> I've searched the documentation and pretty much anything I try ends up
> with a "Cannot open /dev/hdb5: Device or resource busy" message.
>
> Here's what mount says:
> /dev/sda3 on / type ext3 (rw,errors=3Dremount-ro)
> proc on /proc type proc (rw,noexec,nosuid,nodev)
> /sys on /sys type sysfs (rw,noexec,nosuid,nodev)
> varrun on /var/run type tmpfs (rw,noexec,nosuid,nodev,mode=3D0755)
> varlock on /var/lock type tmpfs (rw,noexec,nosuid,nodev,mode=3D1777)
> procbususb on /proc/bus/usb type usbfs (rw)
> udev on /dev type tmpfs (rw,mode=3D0755)
> devshm on /dev/shm type tmpfs (rw)
> devpts on /dev/pts type devpts (rw,gid=3D5,mode=3D620)
> /dev/sda5 on /home type ext3 (rw)
> /dev/md0 on /backupmirror type ext3 (rw)
> /dev/hda1 on /vz type ext3 (rw)
> binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)
>
> from dmesg:
> md: md0 stopped.
> md: bind<hdb5>
> md: bind<hda5>
> md: kicking non-fresh hdb5 from array!
> md: unbind<hdb5>
> md: export_rdev(hdb5)
> raid1: raid set md0 active with 1 out of 2 mirrors
>
> And :
> mdadm --detail /dev/md0
> /dev/md0:
>        Version : 00.90.03
>  Creation Time : Fri Feb 23 15:03:40 2007
>     Raid Level : raid1
>     Array Size : 93771264 (89.43 GiB 96.02 GB)
>    Device Size : 93771264 (89.43 GiB 96.02 GB)
>   Raid Devices : 2
>  Total Devices : 1
> Preferred Minor : 0
>    Persistence : Superblock is persistent
>
>    Update Time : Sat Jan  5 10:45:47 2008
>          State : clean, degraded
> Active Devices : 1
> Working Devices : 1
> Failed Devices : 0
>  Spare Devices : 0
>
>           UUID : d01d66b4:16efa6c2:d7493088:59f3fe68
>         Events : 0.28752
>
>    Number   Major   Minor   RaidDevice State
>       0       0        0        0      removed
>       1       3        5        1      active sync   /dev/hda5
>
----- End message from jim@fayettedigital.com -----

Since /dev/hdb5 has been part of this array before you should use =20
--re-add instead of --add.
Kind regards,
Alex.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 #
#   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 #
#  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   #
# /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux #
#           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..


--=_6yldozc76qcc
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBHf+HAAKWN2UY+sLwRAt81AKCq6IIaE5VNpnnj8OYVinvsDWU8rQCfTxJI
zAu5WdSB1dko8Sszj6OGLHs=
=N1RY
-----END PGP SIGNATURE-----

--=_6yldozc76qcc--
