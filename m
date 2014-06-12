From: Roman Mamedov <rm@romanrm.net>
Subject: Re: md-raid paranoia mode?
Date: Thu, 12 Jun 2014 12:28:14 +0600
Message-ID: <20140612122814.2db74377@natsu>
References: <5397FBCE.3060009@bartk.us>
	<53990D44.300@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/iYakQu7lSPo9doa_TJO7d6K"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53990D44.300@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: Bart Kus <me@bartk.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/iYakQu7lSPo9doa_TJO7d6K
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Jun 2014 10:15:32 +0800
Brad Campbell <lists2009@fnarfbargle.com> wrote:

> On 11/06/14 14:48, Bart Kus wrote:
> > Hello,
> >
> > As far as I understand, md-raid relies on the underlying devices to
> > inform it of IO errors before it'll seek redundant/parity data to
> > fulfill the read request.  I have, however, seen certain hard drives
> > report successful reads while returning garbage data.
>=20
> If you have drives that return garbage as valid data then you have far=20
> greater problems than what you are suggesting will fix. So much so I=20
> suggest you document these instances and start banging a drum announcing=
=20
> them in a name and shame campaign. That sort of behavior from storage=20
> devices is never ok, and the manufacturer needs to know that.

If your RAM can return garbage, that's not a justification for having ECC R=
AM.
ECC RAM is a gimmick invented by weak conformist people. Instead, you shoul=
d go
and loudly scream at the manufacturer who sold you that RAM! Errors from RAM
are never OK! RAM should always work perfectly! And if it doesn't, you have
greater problems. We shall not tolerate this behavior! So go get a drum and
start banging it as loudly as you can! Name and shame the manufacturer who
sold you that RAM. Fight the power, brother!!!

You can probably tell just how sick I am of reasoning like yours. That's why
we can't have nice things (md-side resiliency for the cases when you need/w=
ant
it), and sadly Neil is of the same opinion as you.

--=20
With respect,
Roman

--Sig_/iYakQu7lSPo9doa_TJO7d6K
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlOZSH4ACgkQTLKSvz+PZwhDcQCgjU56bipX4GMstg08YF+rCAva
sB4AnjMmEW+aoNCfmBCbOmoS9JewC7OT
=XTMM
-----END PGP SIGNATURE-----

--Sig_/iYakQu7lSPo9doa_TJO7d6K--
