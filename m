From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: about raid5 recovery when created
Date: Tue, 8 Dec 2009 13:56:00 +0000
Message-ID: <20091208135600.GB21130@cthulhu.home.robinhill.me.uk>
References: <389deec70912080501u6c6bc90ei2d34ef245a1dae9e@mail.gmail.com>
 <20091208131446.GA21130@cthulhu.home.robinhill.me.uk>
 <389deec70912080549h1b22489es612235ad29354d6b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wq9mPyueHGvFACwf"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <389deec70912080549h1b22489es612235ad29354d6b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--wq9mPyueHGvFACwf
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Dec 08, 2009 at 09:49:48PM +0800, hank peng wrote:

> 2009/12/8 Robin Hill <robin@robinhill.me.uk>:
> > On Tue Dec 08, 2009 at 09:01:23PM +0800, hank peng wrote:
> >
> >> Hi, all:
> >> As we know, when a raid5 array is created, recovery will be going on
> >> which involves some read, one xor and one write. Since there is no
> >> real data in the disk at the time, besides, if I am willing to wait
> >> for recovery to complete and then use this raid5, how about adding
> >> support for a fast recovery method? Right now, what is in my mind is
> >> zero all disks which belong to this raid5. I think it will increase
> >> raid5 recovery speed when created and decrease CPU usage, since all
> >> zero is also XORed.
> >> What do raid developers think?
> >>
> > It'll decrease CPU usage but increase I/O - you're now needing to write
> > to all disks. =A0Most systems will be I/O limited rather than CPU limit=
ed,
> > so the current approach works better. =A0If you want to zero the disks
> > then do this before creating the array - you can then use --assume-clean
> > to skip the resync process.
> >
> I think --assume-clean is used mostly when doing performance test and
> can't be used when creating a raid5 array using new disk, because
> later read and write operation make assumption that all stripe is
> XORed. Correct me if I am wrong.
>=20
You're correct - that's why I said to zero all the disks first so the
XOR data is all correct.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--wq9mPyueHGvFACwf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkseWu8ACgkQShxCyD40xBJr4QCgxqK+OTbL97YSF5o5DAH+7nfm
FsoAn0lBArf53Ejl9NPRmwh7mvXopDiw
=8Psb
-----END PGP SIGNATURE-----

--wq9mPyueHGvFACwf--
