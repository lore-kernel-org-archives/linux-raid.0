From: NeilBrown <neilb@suse.de>
Subject: Re: Reshape RAID10 -> RAID1
Date: Wed, 26 Feb 2014 18:03:17 +1100
Message-ID: <20140226180317.10790f0e@notabene.brown>
References: <20140226060532.GA18630@kevin.peecee3.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HTkWR0.Jb+n9/aiCI0S714e"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140226060532.GA18630@kevin.peecee3.com>
Sender: linux-raid-owner@vger.kernel.org
To: Charles Polisher <cpolish@surewest.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/HTkWR0.Jb+n9/aiCI0S714e
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Feb 2014 22:05:32 -0800 Charles Polisher <cpolish@surewest.net>
wrote:

> Hi all,
>=20
> I hope to reshape a RAID10 (near,2) with 2 failed and physically
> removed members [_U_U] into a RAID1 hopefully [UU], for the
> benefit of seeing a healthy status.
>=20
> Is following proposed invocation correct?
>=20
>    mdadm --grow /dev/md2 --level=3D1

I think so.  If not, mdadm will complain.

It is quite easy to experiment: create some largish file, use losetup to tu=
rn
them into block device.  Then experiment with /dev/loop*

NeilBrown


>=20
> Details:
>=20
> root@mencius $ mdadm --query --verbose --detail /dev/md2
> /dev/md2:
>         Version : 1.1
>   Creation Time : Fri Jul 15 22:56:53 2011
>      Raid Level : raid10
>      Array Size : 1944916992 (1854.82 GiB 1991.59 GB)
>   Used Dev Size : 972458496 (927.41 GiB 995.80 GB)
>    Raid Devices : 4
>   Total Devices : 2
>     Persistence : Superblock is persistent
>=20
>   Intent Bitmap : Internal
>=20
>     Update Time : Tue Feb 25 22:00:46 2014
>           State : active, degraded=20
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : near=3D2
>      Chunk Size : 512K
>=20
>            Name : localhost.localdomain:2
>            UUID : 971ee8b2:8d980355:0e5dfae9:c8bccd89
>          Events : 5326341
>=20
>     Number   Major   Minor   RaidDevice State
>        0       0        0        0      removed
>        1       8       19        1      active sync   /dev/sdb3
>        2       0        0        2      removed
>        3       8        3        3      active sync   /dev/sda3
> root@mencius $ uname -a
> Linux mencius 2.6.32-358.18.1.el6.centos.plus.x86_64 #1 SMP Wed Aug 28 16=
:14:04 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
> root@mencius $ mdadm --version
> mdadm - v3.2.6 - 25th October 2012
>=20
>=20
> Thanks,


--Sig_/HTkWR0.Jb+n9/aiCI0S714e
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUw2RtTnsnt1WYoG5AQKtvhAAsesbrB4peqSD6eiiqjX/ZuJXxT3x0TAB
q5Mow8GB3QZyyZ01Ts8x6/dA85a0RV91TaDS3kO/4v3MDB1/M4LLZ27iNL8SKdGM
WVv7n/CPGQmYfPGbV53VRJMrF8335QcpmgB7FZiE7t2is7zroRQNletxvXKVu1bD
mDu0LPCCJNwi3ELg2fw/z53r9TlaJprwWuxSGaHcjYchVD5zQd0BDv2iYPQRN1t8
SBObXa0kiQ7wwBoZzvu77l0y4SLL8JP4vGKEZzXw0euZQhRFLP+7TR7izabSymbf
OujDbXYwiseM6X5nxlKM0a7QMEu0rMZOXptWhmIKP+ugi9Ve17HATZ2BXjcUYPZn
BLVK9xK5a0zGM5ZnSqHn4i5Ies3qnKgIBqmKP7zrwtEluG/GRkbEN6xs48lyo1g+
t8D2aMlLy83eDDZfkseM+uqACsHTCnhlaxn4Y24E7nh+F1DPVjnZ8yzLa2q4EAod
9mUlPWAv2Rq9wm6g9Bm3Zj2ycuzdPR3rJZGouonC5sDS6JMY/e0zGPOQz8fy6BIb
QtNk+oPugdAaI5JsxwK59TD3UsAu6nESpnPempIU1BYbDMrQvFrI5OTMfH3S93iG
UC4GXzw//qSkuWVMqSnEmZIdte2TTfRKqn/aLWFTMH/cG1ovcYKwiUHJGuqiapUh
lnynmFALjHI=
=4lka
-----END PGP SIGNATURE-----

--Sig_/HTkWR0.Jb+n9/aiCI0S714e--
