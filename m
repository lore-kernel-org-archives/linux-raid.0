From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: Pending sectors in valid array - how to proceed?
Date: Thu, 29 Jul 2010 03:11:00 +0600
Message-ID: <20100729031100.69f583d7@natsu>
References: <4C506CF5.2080307@xunil.at>
	<4C5079C4.2050308@seoss.co.uk>
	<4C5092C4.6050708@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3xuTBvJckA.nglvCUrTg2F9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C5092C4.6050708@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: st0ff@npl.de
Cc: st0ff@gmx.net, Tim Small <tim@seoss.co.uk>, lists@xunil.at, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/3xuTBvJckA.nglvCUrTg2F9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Jul 2010 22:27:48 +0200
Stefan *St0fF* Huebner <st0ff@gmx.net> wrote:

> >>   5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Alwa=
ys
> >>       -       0
> >> 195 Hardware_ECC_Recovered  0x001a   058   039   000    Old_age   Alwa=
ys
> >>       -       146754005
> >> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Alwa=
ys
> >>       -       13
> >> 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
> >> Offline      -       13
> >>
> >> (relevant lines as far as I understand ...)
> >>  =20
> > Do you have any high-fly writes?  Are there lots of
> > Hardware_ECC_Recovered on all the drives?  Is vibration likely to be an
> > issue?  What's the drive/chassis?
> Hardware ECC recovered means how many times the internal error
> correction of the drive succeeded.  Indeed this may indicate vibration
> or other external sources of errors.

That drive is most likely a Seagate, and if so, there's nothing to worry
about. Literally every Seagate drive will have a high value in
Hardware_ECC_Recovered, it's just a peculiarity of their SMART. Other vendo=
rs'
drives recover read errors using ECC too, but don't report that into the SM=
ART
metric.

--=20
With respect,
Roman

--Sig_/3xuTBvJckA.nglvCUrTg2F9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxQnOQACgkQTLKSvz+PZwiQxQCcDKGJSf3FShufSemWtEPzFQbq
l4UAoIPSW+aSKkLPsWU7N+APpI04fvQK
=r3oa
-----END PGP SIGNATURE-----

--Sig_/3xuTBvJckA.nglvCUrTg2F9--
