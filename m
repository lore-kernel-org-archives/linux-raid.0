From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Expand RAID5 array or switch to RAID10
Date: Mon, 22 Dec 2014 09:15:33 +0000
Message-ID: <20141222091533.GA10786@cthulhu.home.robinhill.me.uk>
References: <CAG__1a7YqAWMccgDeYksY_t10Zyy8Rc-veZM_P7aaXs-DtFdfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG__1a7YqAWMccgDeYksY_t10Zyy8Rc-veZM_P7aaXs-DtFdfQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Duffield <forumscollective@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Dec 17, 2014 at 12:11:27pm +0200, George Duffield wrote:

> Hi
>=20
> I have a RAID5 array comprising four 3TB drives and I've basically got
> 100GB remaining free so it's time to expand the array.  With this in
> mind, and considering my requirement is predominantly to increase
> capacity, I'm wondering whether it'd be best to add another 3TB drive
> and expand the array whilst retaining RAID5 or to switch out to a
> RAID10 array.  My thinking is 1) adding a 5th 3TB drive to the
> existing array may result in drive failure during the rebuild; and 2)
> RAID10 is very expensive to implement.  Hence, I'm tempted to consider
> other options (recognising that whilst it'd be convenient I don't
> actually need everything stored on a single array).   One such option
> would be running two raid5 arrays comprised of 3x 3TB each yielding
> 12TB of storage across the two arrays.
>=20
>=20
> Questions:
> + Is my assumption re RAID5 drive failure correct/ likely?
> + Is there a non-destructive way to migrate from RAID5 to RAID10?
> + 2 x RAID5 arrays seems pretty appealing - from a reliability and
> cost effectiveness standpoint - yes/no?

RAID5 with 3TB drives is definitely a dodgy area. The rebuild times are
sufficiently long, and the amount of data that needs to be read
sufficiently high, that an unreadable block or complete drive failure
during rebuild are too probable to be worth the risk (in my opinion
anyway).

You can non-destructively convert from a RAID5 to a RAID0, then from the
RAID0 to a RAID10 (near-2). This does mean going via RAID0 though, so
there's a data-loss risk there.

I wouldn't run RAID5 on these size disks at all - anything over 2T is
too risky for my liking, no matter how many disks there are in the
array.

If you just want to reduce the risk of a secondary failure during
rebuild, RAID6 would be the safer option. RAID10 is definitely more
performant but there's a far higher capacity overhead, so it very much
depends on your use case as to which would be better.

My advice would be to add two additional drives, converting to RAID6 and
expanding the array.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlSX4TUACgkQShxCyD40xBIn7ACg1OTiKLBqpxg6yHlpoWw50pIw
jY0AoKWig1DW3uL3m42/KxRGQA+7+89q
=iVj2
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
