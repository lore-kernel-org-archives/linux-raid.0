From: NeilBrown <neilb@suse.de>
Subject: Re: raid5 reshape is stuck
Date: Thu, 21 May 2015 09:48:37 +1000
Message-ID: <20150521094837.6a2d29c4@notabene.brown>
References: <1612858661.15347659.1431671671467.JavaMail.zimbra@redhat.com>
	<2043891461.15360424.1431673224036.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/gEGs9llLKBU.DNy3rw_r7DV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2043891461.15360424.1431673224036.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/gEGs9llLKBU.DNy3rw_r7DV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 15 May 2015 03:00:24 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:

> Hi Neil
>=20
>    I encounter the problem when I reshape a 4-disks raid5 to raid5. It ju=
st can
> appear with loop devices.
>=20
>    The steps are:
>=20
> [root@dhcp-12-158 mdadm-3.3.2]# mdadm -CR /dev/md0 -l5 -n5 /dev/loop[0-4]=
 --assume-clean
> mdadm: /dev/loop0 appears to be part of a raid array:
>        level=3Draid5 devices=3D6 ctime=3DFri May 15 13:47:17 2015
> mdadm: /dev/loop1 appears to be part of a raid array:
>        level=3Draid5 devices=3D6 ctime=3DFri May 15 13:47:17 2015
> mdadm: /dev/loop2 appears to be part of a raid array:
>        level=3Draid5 devices=3D6 ctime=3DFri May 15 13:47:17 2015
> mdadm: /dev/loop3 appears to be part of a raid array:
>        level=3Draid5 devices=3D6 ctime=3DFri May 15 13:47:17 2015
> mdadm: /dev/loop4 appears to be part of a raid array:
>        level=3Draid5 devices=3D6 ctime=3DFri May 15 13:47:17 2015
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md0 started.
> [root@dhcp-12-158 mdadm-3.3.2]# mdadm /dev/md0 -a /dev/loop5
> mdadm: added /dev/loop5
> [root@dhcp-12-158 mdadm-3.3.2]# mdadm --grow /dev/md0 --raid-devices 6
> mdadm: Need to backup 10240K of critical section..
> [root@dhcp-12-158 mdadm-3.3.2]# cat /proc/mdstat=20
> Personalities : [raid6] [raid5] [raid4]=20
> md0 : active raid5 loop5[5] loop4[4] loop3[3] loop2[2] loop1[1] loop0[0]
>       8187904 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/6] [UU=
UUUU]
>       [>....................]  reshape =3D  0.0% (0/2046976) finish=3D639=
6.8min speed=3D0K/sec
>      =20
> unused devices: <none>
>=20
>    It because the sync_max is set to 0 when run the command --grow
>=20
> [root@dhcp-12-158 mdadm-3.3.2]# cd /sys/block/md0/md/
> [root@dhcp-12-158 md]# cat sync_max=20
> 0
>=20
>    I tried reproduce with normal sata devices. The progress of reshape is=
 no problem. Then
> I checked the Grow.c. If I use sata devices, in function reshape_array, t=
he return value
> of set_new_data_offset is 0. But if I used loop devices, it return 1. The=
n it call the function
> start_reshape.=20

set_new_data_offset returns '0' if there is room on the devices to reduce t=
he
data offset so that the reshape starts writing to unused space on the array.
This removes the need for a backup file, or the use of a spare device to
store a temporary backup.
It returns '1' if there was no room for relocating the data_offset.

So on your sata devices (which are presumably larger than your loop devices)
there was room.  On your loop devices there was not.


>=20
>    In the function start_reshape it set the sync_max to reshape_progress.=
 But in sysfs_read it
> doesn't read reshape_progress. So it's 0 and the sync_max is set to 0. Wh=
y it need to set the
> sync_max at this? I'm not sure about this.=20

sync_max is set to 0 so that the reshape does not start until the backup has
been taken.
Once the backup is taken, child_monitor() should set sync_max to "max".

Can you  check if that is happening?

Thanks,
NeilBrown


>=20
>    I tried to fix this but I'm not sure whether it's the right way. I'll =
send the patches in=20
> other mails.
>=20
> Best Regards
> Xiao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/gEGs9llLKBU.DNy3rw_r7DV
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVV0dVTnsnt1WYoG5AQJf2hAArS/MBFASZ23r5R7fk9Dv2X7GxZ91zbBb
DH+qRLknEZw7IyzhhHa1RxLUGt5jJslEsVOVw/fxM4nnm3CU8RDeU5uxLpcr1WH4
OZlYZmzw4GYVqIOPXY80QJviVZszy8pqIN5Ua5BzvFS6JxcCObxFCAW7Py/cR2ro
RBak6cZZ3dcjZe8yfvaaG8ASeDkHwaq4P2mNkO/DEu0AFK0LI5McHTisqDe0DWlp
fHeJX/3dKtl2owT6IXvJRuqyUBL9wmXBPk2qisHfAgE6tMD8MVRY6mx/RUlTQgR3
ClZFDkWSd5q1WY8ckc/lzKZYzY8kq+fdvwRFr0HBHbSApql2FY3o/uX6aCJd2gKb
G5oMR1DmlzqT025UXGrKfWvN1Jvi5HCHVPmPrrG4DXt2KquyRPX+UTLCtGLyvlTE
mXHzEiKLWeRDfWbxvJUgRLKBLH2i+QrnU+42sjjwLp/Om0/umstyJqNE5plK/vxQ
nrblDQiNpZ6qXjXLr+Ppx0yj6rUqtF1NPbaZhIXs2pcK61dD4zoHo2CevO+WQ8a3
fZY0DgwzzYrNj5E6Y6T+kGd2NxD2koBqjyLkXWaVbyAqH8DYML9xNfkLqso67YmN
uwc5nSX6FGgGgJ9eOjPkcWPxnZJ+Gr43JUjLGv+sP7tgOFPNQGOFPBUo5B8PjeQ/
kIN/nLq1J+M=
=Jn7H
-----END PGP SIGNATURE-----

--Sig_/gEGs9llLKBU.DNy3rw_r7DV--
