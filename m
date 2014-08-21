From: NeilBrown <neilb@suse.de>
Subject: Re: The parallel make patch for mdadm
Date: Thu, 21 Aug 2014 15:05:39 +1000
Message-ID: <20140821150539.4a54ece7@notabene.brown>
References: <53F4DE42.4030308@gentoo.org>
	<20140821104357.511f7d7e@notabene.brown>
	<53F56E00.4090307@gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/TIyLJqRRkaQEHjBioR1Plz+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53F56E00.4090307@gentoo.org>
Sender: linux-raid-owner@vger.kernel.org
To: Samuli Suominen <ssuominen@gentoo.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/TIyLJqRRkaQEHjBioR1Plz+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 21 Aug 2014 06:56:48 +0300 Samuli Suominen <ssuominen@gentoo.org>
wrote:

>=20
> On 21/08/14 03:43, NeilBrown wrote:
> > On Wed, 20 Aug 2014 20:43:30 +0300 Samuli Suominen <ssuominen@gentoo.or=
g>
> > wrote:
> >
> >> I think you forgot to apply the patch?
> >>
> >> Link to it,
> >>
> >> http://www.spinics.net/lists/raid/msg46782.html
> > No, I sent you a reply which you didn't respond to.
> >
> > I've attached it.
> >
> > NeilBrown
> >
>=20
> Sorry! I blame my mail client, and can't immediately find the
> responsible kludge
> from Thunderbird.
>=20
> So, here is it as attachment, properly git formatted patch.
>=20
>=20

Thanks.  It was close enough so I applied it.
However you forgot the signed-off-by line, and you put the entire long
description on a single line:

Subject: [PATCH] Fix parallel make problem, as in, when make is called with,
 for example, "make -j9 install install-system", both install and install-s=
ystemd
 targets at the same line and with high -j value.
 Same install.tmp file was used, and udev rules ended up in systemd
 service files, or otherway around.
 For more information, see:
 http://www.spinics.net/lists/raid/msg46782.html
 http://bugs.gentoo.org/show_bug.cgi?id=3D517218


Best to have a short on-line description (this goes in the subject).  Then a
blank line.  Then the details.

Like this:

http://git.neil.brown.name/?p=3Dmdadm.git;a=3Dcommitdiff_plain;h=3D47c4331d=
1fe9c68e9d8dd0a7d94ee8e70b285a0b


Thanks,
NeilBrown

--Sig_/TIyLJqRRkaQEHjBioR1Plz+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU/V+JDnsnt1WYoG5AQJaJBAAtoFq+FuWBMBy81GkST/NZF3lOi7g5S6V
KWZv0Xf+XmLShazHZdf6jOP6s+ibg1ataSz/rGr4qqpSax5tymyLJ0dSAFrLlJOb
hV6Rpuu8BKtwasdXuKCcm/Em3cBOpV6VZgTBh4Ra//XpMEQ1wngg+N9FVC2JBjSb
VLzb6ebQh6vQ7moI1KDHEPWcrhS0+Q/0dtfvpnUVDBXKRyhq1mH76RHT42q7rLOm
AE3KjpCSo83l63odVOXckGWlwqHUesC/+/LNmub58ky847dPrui3wozN46D4RqEa
XbOrPjvTrGg8bkX09aDE3F8BMzMpumZdGGcCcJs0dgGPxBLDPdvc6pgYVX59k5d4
B0Iilpplx1H1qRpAr23fV9UeCb+j5No/8H8+EkkYQm0fHn/SxIDG+d/GypZM193B
aAV6jDiOCtZdgudnctF1gmPrjfd2ZxAdXv/jQy07f/fgahw1Lsg7k2s5BUf8XnAH
5yIISOGGgSMS+8+m8JZb0M9jXLL7f/i4lRm6RYiS7QHy8SAj7ITqysIGecEWf/13
XVue5oLyinpX74Z3d6IFat0uOX4Yz84y3PFKqoIoKLlaaWE7+PcTsejgyC9e3oX+
OKfG6GxV59ni5Y7m1UXcH9pvJ5p1RkwfezDktmnzVlBSzDnV4dfMe8WJGDy9HElp
2lZ2CDMFsi0=
=fZM5
-----END PGP SIGNATURE-----

--Sig_/TIyLJqRRkaQEHjBioR1Plz+--
