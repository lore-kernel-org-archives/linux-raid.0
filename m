From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Failed during rebuild (raid5)
Date: Fri, 3 May 2013 13:40:23 +0100
Message-ID: <20130503124023.GB27548@cthulhu.home.robinhill.me.uk>
References: <51839E4F.7050102@midgaard.us>
 <5183A1C7.5000905@mpstor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SkvwRMAIpAhPCcCJ"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5183A1C7.5000905@mpstor.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Boman <aboman@midgaard.us>
Cc: linux-raid@vger.kernel.org, Benjamin ESTRABAUD <be@mpstor.com>
List-Id: linux-raid.ids


--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri May 03, 2013 at 12:38:47PM +0100, Benjamin ESTRABAUD wrote:

> On 03/05/13 12:23, Andreas Boman wrote:
> > I have (had?) a raid 5 array, with 5 disks (1.5TB/EA), smartd warned=20
> > one was getting bad, so I replaced it with an identical disk.
> > I issued mdadm --manage --add /dev/md127 /dev/sdX
> >
> > The array seemed to be rebuilding, was at around 15% when I went to bed.
> >
> > This morning I came up to see the array degraded with two missing=20
> > drives, another failed during the rebuild.
> >
> > I powered the system down, and since I have the disk smartd flagged as=
=20
> > bad and tried to just plug that in and power up hoping to see the=20
> > array come back up -no such luck (not enough disks).
> >
> Unfortunately this happens way too often: Your RAID members silently=20
> fail over time. They will get some bad blocks, and you won't know about=
=20
> it until you try to read or write one of the bad blocks. When that=20
> happen a disk will get kicked out. At this stage you'll replace the=20
> disk, not knowing that other areas of the other RAID members have also=20
> failed. The only sensible option is to run a RAID 6 which dramatically=20
> reduces the potential for double failure, or to run a RAID 5 but run a=20
> weekly (at least) check of the entire array for badblocks, carefully=20
> monitoring the smart reported changes after running the test (trying to=
=20
> read the entire array will cause badblocks to be detected and=20
> reallocated if any).
>
I'd recommend running a regular check anyway, whatever RAID level you're
running. I wouldn't choose to run RAID5 with more than 5 disks, or
larger than 1TB members either, but that really comes down to an
individual's cost/benefit view on the situation.

> > I powered the system down again, and now I'm trying to evaluate my=20
> > best options to recover. Hoping to have some good advice in my inbox=20
> > when I get back from the office. I'll be able to boot the thing up and=
=20
> > get log info this afternoon.
> >
> I had to recover an array like that twice. The most important is=20
> probably to mitigate the data loss on the second drive that is failing=20
> right now by "ddrescueing" all of its data on another drive before it=20
> gets more damaged (the longer the failing drive is online the less=20
> chance you have). Use GNU ddrescue for that purpose.
>=20
> Once you have rescued the failing drive onto a new one, you could then=20
> try to add that new recovered drive in place of the failing one and=20
> start the resync as you did before.
>=20
Not "add", but "force assemble using". Whenever you end up in a
situation with too many failed disks to start your array, ddrescue and
force assemble (mdadm -Af) is your safest option. If that fails you can
look at more extreme measures, but that should always be the first
approach.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--SkvwRMAIpAhPCcCJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlGDsDcACgkQShxCyD40xBKLEwCgwGoB61TdPE90IwrxKn4YDKmn
O3EAn37X1C61YmWr3B7UwGQkXmBAwqSb
=WXIg
-----END PGP SIGNATURE-----

--SkvwRMAIpAhPCcCJ--
