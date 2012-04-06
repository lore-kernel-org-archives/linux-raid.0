From: NeilBrown <neilb@suse.de>
Subject: Re: Can't add drive to array 3.3 & 3.2.3
Date: Fri, 6 Apr 2012 20:27:13 +1000
Message-ID: <20120406202713.30ac90a3@notabene.brown>
References: <4F7E5309.7080302@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/o1k7EpW/g.3dki25lHFtrVx"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F7E5309.7080302@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/o1k7EpW/g.3dki25lHFtrVx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 06 Apr 2012 10:20:57 +0800 Brad Campbell <lists2009@fnarfbargle.com>
wrote:

> G'day Neil,
>=20
> I've got a vanilla 3.3 kernel, and mdadm v3.2.3.

Having now seen the real strace:


Yeah, that's a bad combination when bitmaps are involved.
mdadm v.3.2.3 has a bug with adding bitmaps.  It uses O_DIRECT writes from a
non-aligned buffer.

You could use the mdadm from my .git, and it would fix that problem, but th=
en
there is a kernel bug (fixed in 3.3.2 I think) which causes an oops.

Probably safest to go back to mdadm-3.2.2, but going forward  to
linux.3.3.2 and mdadm-.git would work too.

NeilBrown

>=20
> I have a 10 drive raid 6 :
> root@srv:~# mdadm --detail /dev/md0
> /dev/md0:
>          Version : 1.2
>    Creation Time : Tue Apr  5 18:14:42 2011
>       Raid Level : raid6
>       Array Size : 15628106752 (14904.12 GiB 16003.18 GB)
>    Used Dev Size : 1953513344 (1863.02 GiB 2000.40 GB)
>     Raid Devices : 10
>    Total Devices : 9
>      Persistence : Superblock is persistent
>=20
>    Intent Bitmap : Internal
>=20
>      Update Time : Fri Apr  6 10:11:46 2012
>            State : active, degraded
>   Active Devices : 9
> Working Devices : 9
>   Failed Devices : 0
>    Spare Devices : 0
>=20
>           Layout : left-symmetric
>       Chunk Size : 128K
>=20
>             Name : storage1:0_0
>             UUID : 0f24724f:8e39ff45:4ed83efe:cad4dd84
>           Events : 74069
>=20
>      Number   Major   Minor   RaidDevice State
>         0       8       48        0      active sync   /dev/sdd
>         1       0        0        1      removed
>         4       8      144        2      active sync   /dev/sdj
>        11       8       80        3      active sync   /dev/sdf
>        10       8       16        4      active sync   /dev/sdb
>         9       8        0        5      active sync   /dev/sda
>         8       8       32        6      active sync   /dev/sdc
>         7       8       64        7      active sync   /dev/sde
>         6       8       96        8      active sync   /dev/sdg
>         5       8      128        9      active sync   /dev/sdi
>=20
> When I go to add a disk to it :
> mdadm --add /dev/md0 /dev/sdh
>=20
> mdadm creates a superblock on the disk, but there is nothing in dmesg, no=
r /proc/mdstat.
>=20
> I've attached an strace of the mdadm --add /dev/md0 /dev/sdh for informat=
ion.
>=20
> Not an urgent query, but I thought it odd enough to bring up.
>=20
> Regards,
> Brad


--Sig_/o1k7EpW/g.3dki25lHFtrVx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT37FATnsnt1WYoG5AQIpFg/9FhISYx1pdo2+jrXJ7rLrXb4un3t+eoHN
QI/EhvMtbdI5HFJnEfrUvnj0mNAkzZiqLdwusI0rRRchEWdAV3sYmxMTVyeEIVyv
WqJbaQra/kSZ/+KGOFn/Ad5PG6qjKq+47BC3RklSv4sfiyqHGZTHQ1OXa6Kdh0lM
wnO7mefGBsseGflNl1c74mGv5nSE4azgI+gHzGU/Fc5oKzkYh2G9ddG9bdmV01y9
+3GvzducmnEqHvRvkfzhi604emMRwJUTDLD7kx+cxS5r+Vs/uhaskCGwmqcQa8YY
xMP5lgXRUcJHhXxDWna0KL7rBPYSKzv3WVjqJw5MxAWoFJpC1GsXgkBE50Q9kPxB
gv62eUwC+viCB1ryLBB816WXCtT72q1PVfa0bL7qtSJ3MLPIpCgm1/ehiUUcbPDc
SXVPMwhFOZ452WmOrgv2jmxkRXynFDJwLjowEYFLYStbyLkfrgJMdLRtpN+4PiV7
As+ZDDjYh9ppX8x+uMmDg3D5/tqgqczjxaiVeCiMFHV+ZBt287HPWOxacjvzpiO+
nGULoZQ320BQjAjEDFgrvBzpinGVDtqBLTk3bpnd3ashetBdy3RmwBEjwaUmV1dZ
fjAi3CRwi2XSlDkptIDaBE+mnjN+AsJUu9Ap3OG5ogVGVAtEFXZQAJqH7fvWzA//
k+MdFL8d0BM=
=AWHy
-----END PGP SIGNATURE-----

--Sig_/o1k7EpW/g.3dki25lHFtrVx--
