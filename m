From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: migrate single disk to RAID 1?
Date: Tue, 14 Jul 2009 17:00:48 +0100
Message-ID: <20090714160048.GA22826@cthulhu.home.robinhill.me.uk>
References: <479b70ed0907140016u5ec6b3d7x6320147dbdcbd17f@mail.gmail.com> <4A5C588D.4000400@anonymous.org.uk> <479b70ed0907140844p16b0081fh28bb1386a28afb1a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <479b70ed0907140844p16b0081fh28bb1386a28afb1a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Jul 14, 2009 at 10:44:15AM -0500, Ben Beuchler wrote:

> >> umount /dev/sdb4
> >> mdadm --build /dev/md0 --level=3D1 -n2 /dev/sdb4 missing
> >> mount /dev/md0 /mail
> >> mdadm --add /dev/md0 /dev/sda4
> >>
> >> Will that work? =A0Or am I misunderstanding something fundamental?
> >
> > It'll work but you'll be using a legacy array without superblocks, so y=
ou
> > can't have various features that come with superblocks
>=20
> Right; for this particular application I'm willing to give up
> superblocks.  Just to be 100% sure, thought:  the way I've described
> the process would be non-destructive of the data on sdb4?
>=20
Yes - there'll be no need to write to sdb4 at all.  Be aware that,
without a superblock, the array will need to do a full resync every
single time you start it (unless you use the --assume-clean switch, in
which case you could be risking corruption).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkpcq68ACgkQShxCyD40xBLRAgCgsygBmqZJMBz3rtWMYHIU4hKX
+BUAmQE2hpfaEw0bKgCRInT2W+WRzLBM
=cEzB
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
