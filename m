From: Doug Ledford <dledford@redhat.com>
Subject: Re: Problem with mdadm 2.6.7
Date: Sun, 27 Jul 2008 11:06:38 -0400
Message-ID: <1217171198.9041.62.camel@firewall.xsintricity.com>
References: <488C531B.5060005@mandriva.org>  <488C8599.4090503@mandriva.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-En3LW7j7FtcqVJJoEIFS"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <488C8599.4090503@mandriva.org>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Backlund <tmb@mandriva.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-En3LW7j7FtcqVJJoEIFS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-07-27 at 17:26 +0300, Thomas Backlund wrote:
> Hi,
> (please cc me as I'm not subscribed)
>=20
> I have hit a bug with mdadm 2.6.7
>=20
> It rebuilds my raid5 array on every boot
> (raid0 and raid1 arrays are not affected)
>=20
> This didn't happend with 2.6.4
>=20
> kernels tested are 2.6.24.7 and 2.6.25.12
>=20
> Arch is x86_64
> Distro Mandriva 2008.1, but I've tested wich kernel.org kernels and=20
> upstream mdadm 2.6.7 and have the same problem
>=20
> Now I could try to bisect it, but every raid5 rebuild takes 6-7 hours,=20
> so I thought about asking for pointers before...
>=20
> Any ideas where to start looking ?

Are you using mkinitrd (or something similar) to start the arrays, or
are you using udev rules that call mdadm --incremental --run?  If it's
the later, then this is what you get when A) the array is started as
soon as there are enough devices to run in degraded mode and B)
something writes to the array before the last device gets added and C)
you don't have a bitmap to allow the array to keep track of what blocks
need resynced and therefore it resynces the entire drive.

> here is the info on the array that gets rebuilt...
>=20
>=20
> [root@tmb ~]# mdadm --detail /dev/md8
> /dev/md8:
>          Version : 00.90
>    Creation Time : Fri Feb  1 17:44:23 2008
>       Raid Level : raid5
>       Array Size : 1465143808 (1397.27 GiB 1500.31 GB)
>    Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
>     Raid Devices : 3
>    Total Devices : 3
> Preferred Minor : 8
>      Persistence : Superblock is persistent
>=20
>      Update Time : Sun Jul 27 13:32:30 2008
>            State : clean, degraded, recovering
>   Active Devices : 2
> Working Devices : 3
>   Failed Devices : 0
>    Spare Devices : 1
>=20
>           Layout : left-symmetric
>       Chunk Size : 128K
>=20
>   Rebuild Status : 1% complete
>=20
>             UUID : dc482f3f:ad67b9ef:bb6636b8:e9392071
>           Events : 0.16162
>=20
>      Number   Major   Minor   RaidDevice State
>         0       8       33        0      active sync   /dev/sdc1
>         1       8       49        1      active sync   /dev/sdd1
>         3       8       65        2      spare rebuilding   /dev/sde1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband


--=-En3LW7j7FtcqVJJoEIFS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkiMjv4ACgkQTzP9PM7pjw+pBgCeKowdR2XUHdTzd5R8bgtjih/8
vp4An3ahDfvtlVZ4yudK9/Frqi93E2eN
=Z5Ej
-----END PGP SIGNATURE-----

--=-En3LW7j7FtcqVJJoEIFS--

