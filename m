From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: misunderstanding of spare and raid devices? - and one question
 more
Date: Fri, 1 Jul 2011 09:50:44 +0100
Message-ID: <20110701085044.GA22611@cthulhu.home.robinhill.me.uk>
References: <4E0C5539.4030000@gmx.de>
 <4E0C5E47.5090604@anonymous.org.uk>
 <4E0C6CC4.3030506@turmel.org>
 <4E0C7196.1070307@gmx.de>
 <4E0C7B4B.7090404@turmel.org>
 <4E0C8685.3020806@gmx.de>
 <20110701072855.69ee763b@notabene.brown>
 <iujspj$jgg$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <iujspj$jgg$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Jul 01, 2011 at 09:23:43 +0200, David Brown wrote:

> On 30/06/2011 23:28, NeilBrown wrote:
> > On Thu, 30 Jun 2011 16:21:57 +0200 Karsten R=F6mke<k.roemke@gmx.de>  wr=
ote:
> >
> >> Hi Phil
> >>>
> >>> If your CPU has free cycles, I suggest you run raid6 instead of raid5=
+spare.
> >>>
> >>> Phil
> >>>
> >> I started the raid 6 array and get:
> >>
> >> Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> >> md0 : active raid6 sde5[4] sdd5[3] sdc5[2] sdb2[1] sda3[0]
> >>         13759296 blocks level 6, 64k chunk, algorithm 2 [5/5] [UUUUU]
> >>         [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>...]  res=
ync =3D 87.4% (4013184/4586432) finish=3D0.4min speed=3D20180K/sec
> >                                    ^^^^^^
> > Note: resync
> >
> >>
> >> when I started the raid 5 array I get
> >>
> >> md0 : active raid5 sdd5[4] sde5[5](S) sdc5[2] sdb2[1] sda3[0]
> >>         13759296 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
> >>         [=3D>...................]  recovery =3D  6.2% (286656/4586432)=
 finish=3D0.9min speed=3D71664K/sec
> >                                    ^^^^^^^^
> > Note: recovery.
> >
> >>
> >> so I have to expect a three times less write speed - or is this calcul=
ation
> >> to simple ?
> >>
> >
> > You are comparing two different things, neither of which is write speed.
> > If you want to measure write speed, you should try writing and measure =
that.
> >
> > When you create a RAID5 mdadm deliberately triggers recovery rather than
> > resync as it is likely to be faster.  This is why you see a missed devi=
ce and
> > an extra spare.  I don't remember why it doesn't with RAID6.
> >
>=20
> What's the difference between a "resync" and a "recovery"?  Is it that a=
=20
> "resync" will read the whole stripe, check if it is valid, and if it is=
=20
> not it then generates the parity, while a "recovery" will always=20
> generate the parity?
>=20
=46rom the names, recovery would mean that it's reading from N-1 disks,
and recreating data/parity to rebuild the final disk (as when it
recovers from a drive failure), whereas resync will be reading from all
N disks and checking/recreating the parity (as when you're running a
repair on the array).

The main reason I can see for doing a resync on RAID6 rather than a
recovery is if the data reconstruction from the Q parity is far slower
that the construction of the Q parity itself (I've no idea how the
mathematics works out for this).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk4NimMACgkQShxCyD40xBIRwwCfZRo4lwJjqEgJSDTHrJwH8Ddh
xoQAn1CB68sGP0iKZUExChWgqO/dzorV
=IRJR
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
