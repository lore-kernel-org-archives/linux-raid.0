From: NeilBrown <neilb@suse.de>
Subject: Re: Bugreport: mdmon will not start with latest git version when
 using ddf container
Date: Thu, 1 Aug 2013 10:44:33 +1000
Message-ID: <20130801104433.1e7b41a5@notabene.brown>
References: <51F953FA.5000400@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Q4Yc3I666w8M5Yr4GCAarJD"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51F953FA.5000400@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Albert Pauw <albert.pauw@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Q4Yc3I666w8M5Yr4GCAarJD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 31 Jul 2013 20:14:18 +0200 Albert Pauw <albert.pauw@gmail.com> wrot=
e:

> Seems mdmon will not start when I create a ddf container with raid=20
> devices therein:
>=20
> I am using this version from git:
>=20
> mdadm - v3.3-rc2-20-gd81cc6a - 31st July 2013
>=20
> on Centos 6.4, 2.6.32-358.14.1.el6.x86_64
>=20
> I am using 5 loop devices of 512 MB each for disks.
> I created a container with 5 disks:
>=20
> mdadm -CR /dev/md127 -e ddf -l container -n 5 /dev/loop[1-5]
>=20
> [root@moonlight ~]# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [raid1]
> md127 : inactive loop5[4](S) loop4[3](S) loop3[2](S) loop2[1](S) loop1[0]=
(S)
>        163840 blocks super external:ddf
>=20
> unused devices: <none>
>=20
> And created two raid sets in it, one with three disks in raid 5, the=20
> other a raid 1
>=20
> [root@moonlight ~]# mdadm -CR /dev/md1 -l raid5 -n 3 /dev/md127
> mdadm: array /dev/md1 started.
> mdadm: failed to launch mdmon. Array remains readonly
> [root@moonlight ~]# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [raid1]
> md1 : active (read-only) raid5 loop1[2] loop2[1] loop3[0]
>        958464 blocks super external:/md127/1 level 5, 512k chunk,=20
> algorithm 2 [3/3] [UUU]
>            resync=3DPENDING
>=20
> md0 : active (read-only) raid1 loop4[1] loop5[0]
>        479232 blocks super external:/md127/0 [2/2] [UU]
>            resync=3DPENDING
>=20
> md127 : inactive loop5[4](S) loop4[3](S) loop3[2](S) loop2[1](S) loop1[0]=
(S)
>        163840 blocks super external:ddf
>=20
> unused devices: <none>
>=20
> And adding another one, raid5 in my case, gives the same result for the=20
> next /dev/md device.
>=20
> Unfortunately, they stay readonly, as mdmon won't start, so mdadm=20
> --readwrite /dev/md0, etc, won't work.
>=20
> However, when I create these raid devices directly on top of the=20
> /dev/loop[1-5] devices, without using a ddf container, it works as=20
> advertised and the devices get (re)build/resynced.
>=20

Thanks for the report.
This works when I try it so we must be doing something slightly differently.

When mdadm tries to run mdmon it looks in:
  - the same directory that 'mdadm' was found in
  - /sbin
  - the current directory.

Where are mdadm and mdmon installed?  What directory are you running from.
If we can't discover the problem from that information, please run
   strace -f -o /tmp/md-trace mdadm -CR /dev/md1 -l raid5 -n 3 /dev/md127

and post the resulting /tmp/md-trace file.

Thanks,
NeilBrown

--Sig_/Q4Yc3I666w8M5Yr4GCAarJD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUfmvcTnsnt1WYoG5AQJNiw//WzJ9yXsHQXvk6kDuHthcq/BjKEDtwwkd
kXdVDKGqa+lZDK1RBcpfa9blpS/DvDm+2/ZLkL/HOcbu4TErx6mMOMfBQdHCzBzl
1rxHOFxyfLlS9TxBUEhOPIEhhYJ3rEzbnsk88ibjKRlq623zKu5rjnCWVDdDpsc8
jMHIkeGanqN/avFBRuCld5zat8B+dxFQ26BvnXfF6PlHL6dJxXes5NYI5GinsdQ4
YAQLUJqJdl1Evz/pVx+64yskkDi+HmJz10OfY+pSfpZxF9BlfKO4vs6DrYnl4oo3
HpL0ResOVJwG3sPWZVdh8c00tGsdJtGHgQ2rl9oQqvKjenhcsTqqMI9C3xvC3NkI
Tc2Vueo0Z5wxIUPXsRyYZmbgS+1M/m1q3WMw8DtYAAsjsCNwOoZ31KAyeOFPU+C6
eqdm95lYcTZ+LYpcPbHd+esHOQSlcdDNZ6HNyrMbWL/Y0J4oDdBMkXeSFQyostuv
1fi3hYEc4C9bDNivUdErrGCh1KTF57dkItmYgvMGV/5zMe2WK055NoUFEcsQcQcm
pO9Olf/8JW0pojF9t/5HKainsLC95HQdHm9x6eyMvPAA2VA7492qNeT5fLW4a0Y2
OjM01nWplb3JIMEGc+9oHFbilrPt2gpnI1YfUD/I97cmwffM4x4xwqsEtYMiVQAQ
GP8gCEw7ywk=
=Bju2
-----END PGP SIGNATURE-----

--Sig_/Q4Yc3I666w8M5Yr4GCAarJD--
