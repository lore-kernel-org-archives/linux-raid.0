From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID down, dont know why!
Date: Sun, 8 Nov 2009 15:01:57 +0000
Message-ID: <20091108150157.GB11786@cthulhu.home.robinhill.me.uk>
References: <4AF6CEFD.60309@gmail.com>
 <20091108142238.GA11786@cthulhu.home.robinhill.me.uk>
 <4AF6D494.2050207@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vGgW1X5XWziG23Ko"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4AF6D494.2050207@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun Nov 08, 2009 at 09:24:20AM -0500, Andrew Dunn wrote:
> Robin Hill wrote:
> > On Sun Nov 08, 2009 at 09:00:29AM -0500, Andrew Dunn wrote:
> >
> >  =20
> >> I just copied 4+ TiB of information to this array, restarted 5 times
> >> and tried to access it.... What is going on?
> >>
> >> What kind of logs do you need, I really need help!
> >>
> >>    =20
> > From the message you've posted, it looks like something has triggered
> > the (simultaneous) removal of four drives from the array.  I'd check the
> > dmesg output - it should provide some information.  I'd guess these four
> > drives are all attached to the same controller (are they external or
> > internal?), so possibly the controller reset (or for external drives, it
> > could be a cable issue).
> >
> What would I be looking for on this? Its a lot to sift through.
>=20
> Currently just line-by-lining it.
>=20
Look for where the drives are being kicked out of the array (should be
towards the bottom).  Just above that should be some error messages
(often including bus resets).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--vGgW1X5XWziG23Ko
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkr23WUACgkQShxCyD40xBKMugCfQofgCZn15QvMDJOO3o5tjn4k
Ej4Anii6r4iwau0LxLZmYEM4qv4m9Fef
=fBnY
-----END PGP SIGNATURE-----

--vGgW1X5XWziG23Ko--
