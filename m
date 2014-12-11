From: NeilBrown <neilb@suse.de>
Subject: Re: Growing RAID-10 (near-2) array - which kernel needed?
Date: Fri, 12 Dec 2014 07:28:14 +1100
Message-ID: <20141212072814.65b1e134@notabene.brown>
References: <b906dbe55e09c7cf24abcacfbf97efed@kruemel.org>
	<20141211192139.GA4233@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/T/G.5=OsZbCEBOE6QGxoJui"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141211192139.GA4233@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: cvb@kruemel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/T/G.5=OsZbCEBOE6QGxoJui
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Dec 2014 19:21:39 +0000 Robin Hill <robin@robinhill.me.uk> wrote:

> On Thu Dec 11, 2014 at 07:31:31PM +0100, cvb@kruemel.org wrote:
>=20
> > Apologies for raising this topic again, but I can't seem to find=20
> > anything googling, and man mdadm doesn't also give me a clue. Which=20
> > kernel version is needed to grow a near-2 RAID 10 array?
> >=20
> Full reshape support (changing number of devices, layout or chunk size)
> was introduced in 3.5 (http://kernelnewbies.org/Linux_3.5).
>=20
> > I'm currently running kernel 3.13.0 with mdadm 3.2.5. But I could also=
=20
> > use a live CD with a newer kernel, if needed.
> >=20
> It also requires mdadm 3.3 or above.
>=20
> > I have replaced the 4 disks here with larger ones (2TB drives -> 4 TB=20
> > drives), and this is what the array currently looks like:
> >=20
> > # mdadm --detail /dev/md0
> > /dev/md0:
> >          Version : 1.2
> >    Creation Time : Sat Aug 20 08:15:07 2011
> >       Raid Level : raid10
> >       Array Size : 3906764800 (3725.78 GiB 4000.53 GB)
> >    Used Dev Size : 1953382400 (1862.89 GiB 2000.26 GB)
> >     Raid Devices : 4
> >    Total Devices : 4
> >      Persistence : Superblock is persistent
> >=20
> >      Update Time : Thu Dec 11 08:31:15 2014
> >            State : clean
> >   Active Devices : 4
> > Working Devices : 4
> >   Failed Devices : 0
> >    Spare Devices : 0
> >=20
> >           Layout : near=3D2
> >       Chunk Size : 512K
> >=20
> >             Name : alpha:0  (local to host alpha)
> >             UUID : 8199e640:58fc3a04:99b52fe6:80a1574d
> >           Events : 918971
> >=20
> >      Number   Major   Minor   RaidDevice State
> >         6       8        1        0      active sync   /dev/sda1
> >         5       8       33        1      active sync   /dev/sdc1
> >         7       8       17        2      active sync   /dev/sdb1
> >         4       8       49        3      active sync   /dev/sdd1
> >=20
> I can't find anything explicitly covering growing a RAID 10 by just
> increasing the device sizes.=20

commit 006a09a0ae0a494473a8cd82c8d1d653e37e6663
Author: NeilBrown <neilb@suse.de>
Date:   Mon Mar 19 12:46:40 2012 +1100

    md/raid10 - support resizing some RAID10 arrays.


$ git describe --contains 006a09a0ae0a494473a8cd82c8d1d653e37e6663
v3.4-rc1~147^2~8

So Linux-3.4 is needed.
I don't think you need a particularly new mdadm.

NeilBrown

>                              I would have thought that would be an
> easier task than doing so by adding disks, so should be supported in an
> earlier version. mdadm 3.2.1 mentions supporting converting between
> RAID-10 and RAID-1, which can definitely be grown.
>=20
> Have you tried doing a grow with the versions you have?
>=20
> Cheers,
>     Robin
>=20


--Sig_/T/G.5=OsZbCEBOE6QGxoJui
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVIn+Xjnsnt1WYoG5AQJArBAAnPgfs45hXa8cO9vs2hj7W1TM8oJ0KDRx
JUYNI9NMeLpwWo1FmQ4d0rvAAc2kAWca5SDXu8kZ30O9BeaAfFIyB5GxxHgV3EAf
AFm8fqJFC1CfwBfvc+XcjD81+QKboxEo1jSUd8uT+SWLAPAA+12R49hTNvZ317jn
meISaUUxWCUNwRwuvFuSy21zoGZWwM/sGADFttTt9+pbBnRG8RqV/vF95XoNwPAS
TsxEA1c8vR5gdtm51Fkb444H1Z6nMBqpu9+gJXM7ZjtZEuUA5V3QFLojx7aXB9Se
uhYqZtDycXLttT+LJpns29jzErrZWuj0M9OIgsiuGWmtJbU4z3dooyJwqrB+Jjns
VzBgldH2a0sD4dhd8NAGgvsoTU7XXW9SRUnVahRwO/dnnQLcnpUv0YAGhaRfkY22
NaZlVSo/qgLGk1P+05M7ItbFJbmjk/2nkBcUUUYIIyBMTKmoLTe0swKO9pUY4TbA
YbLFctK2dP7XLFlAAT7S3aFDvWQoE0dnD4wAdX6n04UUt+U1Tf/wXF5oCvJG6nzV
GcAi+7MFHud0qntx8pmUEp8Qz/L5elS0u5KQEfDLoJWEcE55yPkQGCSBTgqpzBaG
l+TFOIrkld5Hjm5LGEwFTGue6j1f7iPg7wnfOnjDG1wasrLzxoUHTf3i1xtPxVB5
U08FgWy54RE=
=Elbo
-----END PGP SIGNATURE-----

--Sig_/T/G.5=OsZbCEBOE6QGxoJui--
