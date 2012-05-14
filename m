From: "C.J. Adams-Collier KF7BMP" <cjac@colliertech.org>
Subject: Re: Raid5 crashed, need comments on possible repair solution
Date: Mon, 14 May 2012 14:00:56 -0700
Message-ID: <1337029256.18273.37.camel@foxtrot.cjac.ntr.f5net.com>
References: <4F955F80.80903@evilazrael.de>
	 <20120424070044.707745b8@notabene.brown> <4F95CDE0.4070200@evilazrael.de>
	 <20120424090122.3d90b4a6@notabene.brown> <4FAE9BA3.4000407@pierre-beck.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-soLd2hgB+CzozjTqfWf0"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FAE9BA3.4000407@pierre-beck.de>
Sender: linux-raid-owner@vger.kernel.org
To: Pierre Beck <mail@pierre-beck.de>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-soLd2hgB+CzozjTqfWf0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you Pierre,

This may help me.  I've got an array of 6.  I moved disks from one
chassis to another and at that time, one of the disks dropped out of the
array.  I modified the partition table of sde, as the new system called
it, since its partition table was blank.

Once I made the partition table the same as all other drives in the
array and ran mdadm -a /dev/md0 /dev/sde2, /proc/mdstat indicated that
it was re-building the array.  It took a day and a half or so and it
looked like it was going to complete before I woke up in the morning, so
I went to sleep when it was at 98.8% with 300m left in the prepare at
current rate.

I was doing a 500G copy at the time, so the long duration to complete
1.2% seemed reasonable to me.

When I woke up in the morning, the array showed _UUUU_, with sde and sdg
now having fallen out of the array.  I have since shut the array down
and want some advice for how to move forward.  I've got 5 new 1T disks
in the mail, and they should probably arrive today.  I've got a sixth
here on my desk, but it has some of the data that was potentially lost,
so I don't really want to use it in the new array.  I'll set it up as a
spare once the recovery is complete.

So, considering that I've got enough storage to duplicate the current
state of the disks at a block level, can you advise me on next steps?
Mine look like this:

1) wait until new drives arrive
2) dd if=3D/dev/sd$old of=3D/dev/sd$new
3) ???
4) profit!

Cheers,

C.J.


On Sat, 2012-05-12 at 19:19 +0200, Pierre Beck wrote:
> Hi,
>=20
> got an all-spares auto-assembly on IRC with "Raid level: -unknown-". We=
=20
> recovered by re-creating the array. Since more data is always good, I=20
> add this to the thread and hope it helps confirm the bug is fixed by the=
=20
> patch.
>=20
> RAID-5, 3 members with 1 missing on creation and ever since.
>=20
> Members on partitions with partition type set for auto-assembly.
>=20
> Array was transported to a new machine.
>=20
> Drive order got mixed up on transport: AB_ BA_
> (figured that out on recovery)
>=20
> On target machine boot-up (array not yet configured in mdadm.conf)=20
> Archlinux auto-assembled array with both drives as spares:
>=20
> /dev/sda1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : c051172d:52ed3e47:e8dc6dc8:8798f4c9
>             Name : OncleGeorges:0
>    Creation Time : Fri Aug  5 18:00:19 2011
>       Raid Level : -unknown-
>     Raid Devices : 0
>=20
>   Avail Dev Size : 1953515969 (931.51 GiB 1000.20 GB)
>      Data Offset : 2048 sectors
>     Super Offset : 8 sectors
>            State : active
>      Device UUID : a8b44e10:ff04d973:c5f92933:3c9e124f
>=20
>      Update Time : Sat Apr 21 19:14:34 2012
>         Checksum : 8b57fb27 - correct
>           Events : 1
>=20
>=20
>     Device Role : spare
>     Array State :  ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> /dev/sdb1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : c051172d:52ed3e47:e8dc6dc8:8798f4c9
>             Name : OncleGeorges:0
>    Creation Time : Fri Aug  5 18:00:19 2011
>       Raid Level : -unknown-
>     Raid Devices : 0
>=20
>   Avail Dev Size : 2046769231 (975.98 GiB 1047.95 GB)
>    Used Dev Size : 1953515969 (931.51 GiB 1000.20 GB)
>      Data Offset : 2048 sectors
>     Super Offset : 8 sectors
>            State : active
>      Device UUID : d2594375:c8adc5a0:53938a24:9bd5c6be
>=20
>      Update Time : Sat Apr 21 19:14:34 2012
>         Checksum : 83dd0895 - correct
>           Events : 1
>=20
>=20
>     Device Role : spare
>     Array State :  ('A' =3D=3D active, '.' =3D=3D missing)
>=20
>=20
> Versions:
>=20
> Linux HostName 3.3.4-2-ARCH #1 SMP PREEMPT Wed May 2 15:39:58 UTC 2012=
=20
> i686 AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ AuthenticAMD GNU/Linu=
x
>=20
> mdadm - v3.2.3 - 23rd December 2011
>=20
> Greetings,
>=20
> Pierre Beck
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=-soLd2hgB+CzozjTqfWf0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABCAAGBQJPsXKIAAoJEEyimPmPQm232a4H/1F2R+fhYGlhK6tON8iAsu5a
Yq3qKBpSt6Dq0nRSt+HIVm/KZ2SOTQq9AzYWFnl2zKUxdyteL4yDIXDeSxTWxSNF
bx8kq9vlDtwlDcV5L7TwywEaCF6IkcB2E7i6UVJRiuCf6z+6jCMbYpDYFjnwAbJJ
eA08HNKKJ024uEz2+hXPCGi5n1wR2NInPEYyoc6Gp+lYWPtg7nG83o77QJLpapv0
syKFl70FxNeKnc/ECm5bt53GwyHlYmfJC3VrTO/p7Eu7DJQCaCFed+oER7/Udc7a
pOuA7Ossqa20ZyfsNExD59pfCLdNyNp4CthxfkJad0FpsCrEiYQebArInKXBdRk=
=uxJW
-----END PGP SIGNATURE-----

--=-soLd2hgB+CzozjTqfWf0--

