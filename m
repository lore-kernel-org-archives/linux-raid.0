From: NeilBrown <neilb@suse.de>
Subject: Re: raid10: 6 out of 8 disks marked as stale on every restart
Date: Thu, 18 Dec 2014 16:36:32 +1100
Message-ID: <20141218163632.6cb57524@notabene.brown>
References: <548B2033.5030803@kieser.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/cn+Hrp+.RJhMWgtI4nYAz25"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <548B2033.5030803@kieser.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Kieser <peter@kieser.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/cn+Hrp+.RJhMWgtI4nYAz25
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 12 Dec 2014 09:04:51 -0800 Peter Kieser <peter@kieser.ca> wrote:

> Hello,
>=20
> I have a 8 disk RAID10 array, 6 of the disks are on an LSISAS2008=20
> controller and 2 are on a  82801JI (ICH10 Family) SATA AHCI controller. =
=20
> I upgraded the kernel from 3.17.1 to 3.17.6 when the issue I am having=20
> started to occur, but reverting to an older kernel does not resolve the=20
> issue.
>=20
> Restarting the machine causes the array not to start (or be visible in=20
> /proc/mdstat or any mention in kernel messages.) If I try to assemble=20
> the drives, mdraid complains that 6 out of the 8 disks (coincidentally=20
> all on the LSISAS2008 controller) are non-fresh:
>=20
> root@kvm:~# mdadm --assemble /dev/md3 /dev/sde /dev/sdf /dev/sdg=20
> /dev/sdh /dev/sdi /dev/sdj /dev/sda /dev/sdb
>=20
> Dec 11 21:08:25 kvm kernel: [  528.503736] md: kicking non-fresh sdi=20
> from array!
> Dec 11 21:08:25 kvm kernel: [  528.503747] md: unbind<sdi>
> Dec 11 21:08:25 kvm kernel: [  528.523775] md: export_rdev(sdi)
> Dec 11 21:08:25 kvm kernel: [  528.523802] md: kicking non-fresh sdg=20
> from array!
> Dec 11 21:08:25 kvm kernel: [  528.523809] md: unbind<sdg>
> Dec 11 21:08:25 kvm kernel: [  528.531753] md: export_rdev(sdg)
> Dec 11 21:08:25 kvm kernel: [  528.531780] md: kicking non-fresh sdf=20
> from array!
> Dec 11 21:08:25 kvm kernel: [  528.531788] md: unbind<sdf>
> Dec 11 21:08:25 kvm kernel: [  528.539749] md: export_rdev(sdf)
> Dec 11 21:08:25 kvm kernel: [  528.539776] md: kicking non-fresh sdh=20
> from array!
> Dec 11 21:08:25 kvm kernel: [  528.539785] md: unbind<sdh>
> Dec 11 21:08:25 kvm kernel: [  528.547744] md: export_rdev(sdh)
> Dec 11 21:08:25 kvm kernel: [  528.547771] md: kicking non-fresh sdj=20
> from array!
> Dec 11 21:08:25 kvm kernel: [  528.547779] md: unbind<sdj>
> Dec 11 21:08:25 kvm kernel: [  528.555755] md: export_rdev(sdj)
> Dec 11 21:08:25 kvm kernel: [  528.555782] md: kicking non-fresh sde=20
> from array!
> Dec 11 21:08:25 kvm kernel: [  528.555790] md: unbind<sde>
> Dec 11 21:08:25 kvm kernel: [  528.563758] md: export_rdev(sde)
> Dec 11 21:08:25 kvm kernel: [  528.565831] md/raid10:md3: not enough=20
> operational mirrors.
> Dec 11 21:08:25 kvm kernel: [  528.567230] md: pers->run() failed ...
>=20
> /dev/sda and /dev/sdb are the only drives not on the LSI controller. If=20
> I force the assembly with 6 out of the 8 drives the RAID array comes up:
>=20
> root@kvm:~# mdadm --assemble /dev/md3 /dev/sde /dev/sdf /dev/sdg=20
> /dev/sdh /dev/sdi /dev/sdj --run
>=20
> Then I add the extra drives:
>=20
> root@kvm:~# mdadm --manage /dev/md3 --add /dev/sda
> root@kvm:~# mdadm --manage /dev/md3 --add /dev/sdb
>=20
> root@kvm:~# mdadm --detail /dev/md3
> /dev/md3:
>          Version : 1.0
>    Creation Time : Thu Sep 12 18:43:56 2013
>       Raid Level : raid10
>       Array Size : 7814055936 (7452.06 GiB 8001.59 GB)
>    Used Dev Size : 1953513984 (1863.02 GiB 2000.40 GB)
>     Raid Devices : 8
>    Total Devices : 8
>      Persistence : Superblock is persistent
>=20
>      Update Time : Fri Dec 12 08:58:19 2014
>            State : active, degraded, recovering
>   Active Devices : 6
> Working Devices : 8
>   Failed Devices : 0
>    Spare Devices : 2
>=20
>           Layout : near=3D2
>       Chunk Size : 512K
>=20
>   Rebuild Status : 76% complete
>=20
>             Name : kvm.taylor.kieser.ca:3
>             UUID : f0bc8469:9879a709:e4cc94a7:521bd273
>           Events : 82901
>=20
>      Number   Major   Minor   RaidDevice State
>         0       8      128        0      active sync /dev/sdi
>         8       8       96        1      active sync /dev/sdg
>        11       8        0        2      spare rebuilding /dev/sda
>         3       8      112        3      active sync /dev/sdh
>         4       0        0        4      removed
>        10       8       80        5      active sync /dev/sdf
>         6       8       64        6      active sync /dev/sde
>         9       8      144        7      active sync /dev/sdj
>=20
>        12       8       16        -      spare   /dev/sdb
>=20
> This occurs every time I restart the machine. Thoughts? I tried=20
> rebuilding the initramfs but this didn't resolve the issue. I'm also=20
> running bcache on this machine, but on top of the mdraid.
>=20
> /etc/mdadm.conf:
>=20
> # definitions of existing MD arrays
> ARRAY /dev/md/0 metadata=3D1.0 UUID=3D3b174514:49f3e22e:550cf9a7:8ed93920=
=20
> name=3Dlinux:0
> ARRAY /dev/md/1 metadata=3D1.0 UUID=3D8e23f81d:73f9b393:addd1f7f:5ee1833a=
=20
> name=3Dlinux:1
> ARRAY /dev/md/2 metadata=3D1.0 UUID=3Dcc5a0495:b5262855:fb3cd40a:8b237162=
=20
> name=3Dkvm.taylor.kieser.ca:2
> ARRAY /dev/md/3 metadata=3D1.0 UUID=3Df0bc8469:9879a709:e4cc94a7:521bd273=
=20
> name=3Dkvm.taylor.kieser.ca:3
>=20
>=20
> root@kvm:~# uname -a
> Linux kvm 3.17.6 #3 SMP Sun Dec 7 12:16:45 PST 2014 x86_64 x86_64 x86_64=
=20
> GNU/Linux
>=20
> root@kvm:~# mdadm -V
> mdadm - v3.2.5 - 18th May 2012
>=20
> root@kvm:~# cat /proc/mdstat
> Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]=20
> [raid4] [raid10]
> md127 : inactive sdk[2](S)
>        1465138448 blocks super 1.0
>=20
> md3 : active raid10 sdb[12](S) sda[11] sdi[0] sdj[9] sde[6] sdf[10]=20
> sdh[3] sdg[8]
>        7814055936 blocks super 1.0 512K chunks 2 near-copies [8/6]=20
> [UU_U_UUU]
>        [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>.....]  recovery =
=3D 76.6% (1498279040/1953513984)=20
> finish=3D4710.1min speed=3D1610K/sec
>=20
> md1 : active raid1 sdd5[3] sdc5[2]
>        25164672 blocks super 1.0 [2/2] [UU]
>=20
> md0 : active raid1 sdd1[3] sdc1[2]
>        16779136 blocks super 1.0 [2/2] [UU]
>=20
> md2 : active raid1 sdd6[3] sdc6[2]
>        192472960 blocks super 1.0 [2/2] [UU]
>=20
> unused devices: <none>
>=20
> -Peter
>=20
>=20

Curious.

What does "mdadm --examine" report for each device immediately after boot,
before you try assembling anything?

Maybe also get the output just before you shut down to compare.

NeilBrown

--Sig_/cn+Hrp+.RJhMWgtI4nYAz25
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVJJn4Dnsnt1WYoG5AQJPSRAAjMT6LKOmdxfdCwZONH4f1eimE+SDMUFW
8Aa8zGRQdjffSgnK8Dap36YDSF9DKPAgFCf9yEjqwb3GrNSdXTwl68Gcfi2Cgovo
uXlMrUXbx8ng1DqsriXnSTD5u1mX7Z6z9dilfli3DNekwnO6BwxN/afzCffaXGMJ
YLoMvKOfjy73EhHXJn0k7EetFmH1AAjQ6uw5B3M6Dc8BslstZmGcbsKrvjFT42Uz
SA3KaiRl6rJ8a+TCv6xP2KHrGqDbTHgMvfltqMdFdxRArfqYs0Upgn37iqOGdHG9
8CQg5Yvz07qk1veHakPVQyXPjwUfDQWR0TnE++CpzjHRUd4vGXYDl/FOObgKPplf
dnVtKYf6R+sm54VsDnjQxrf9SAF9+uLVKdG/8Z+CQUaNhIzKwZYboe4Ks4iACjgL
1Pork54/NS5oBeGlWBX+ijr2/b41Eo4f++rxajjFzY/TddVTuuclMm5mEWsMHf5F
eRU/HzHJSK2utoYoxkpq/+k4o9K1h3sh0v9qQq7HQ9r/2zLZh5qUWX16id6Rstux
hQ4pCBk6qxKPPEy+rOzuJ8IwG/7TAL68XL5eIE6X6vzbrVa+hzG+JeBb8I2ZmPpk
sK0mu76mz/nj2kU+IwAINCxTTOiyi/LiP+aJ1NY+pLvpNv5xay2kaUb6iZ2TTmAA
If0F0xbktUE=
=37nD
-----END PGP SIGNATURE-----

--Sig_/cn+Hrp+.RJhMWgtI4nYAz25--
