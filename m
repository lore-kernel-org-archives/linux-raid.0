From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Bitmap did not survive reboot
Date: Wed, 11 Nov 2009 15:53:31 +0000
Message-ID: <20091111155331.GD9137@cthulhu.home.robinhill.me.uk>
References: <20091111091609.GB9137@cthulhu.home.robinhill.me.uk>
 <20091111150155475.WWUI3390@cdptpa-omta03.mail.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yudcn1FV7Hsu/q59"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091111150155475.WWUI3390@cdptpa-omta03.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--yudcn1FV7Hsu/q59
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Nov 11, 2009 at 09:01:46AM -0600, Leslie Rhorer wrote:

>=20
> > > If you have a temporary space for your data, I'd suggest you move it
> > > out and go for an internal bitmap solution. It certainly beats the
> > > patch work you're going to have to do on the startup scripts (and
> > > every time you update mdadm, or the distro).
> > >
> > There should be no need to move the data off - you can add an internal
> > bitmap using the --grow option.  An internal bitmap does have more of an
> > overhead than an external one though.
>=20
> 	I thought I remembered reading in the man page than an internal
> bitmap could only be added when the array was created?  Is that incorrect=
? =20
>=20
I've certainly done this with mdadm 2.6.8 - I guess older versions may
not be able to though.  It's only able to use a limited amount of space
though (whatever's left between the metadata and the data/end of disk),
so you don't get as much (if any) control of the chunk size.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--yudcn1FV7Hsu/q59
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkr63fkACgkQShxCyD40xBKL/QCdFeqeWMyPuoFkvqOwYf13zHGg
acIAnRNeg0qXv2uXEVWmsWj37LNWQ4FH
=kBB6
-----END PGP SIGNATURE-----

--yudcn1FV7Hsu/q59--
