From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: alignment of metadata 1.2 and mkfs.ext4
Date: Wed, 6 Jul 2011 16:02:49 +0600
Message-ID: <20110706160249.65303ced@natsu>
References: <1309936276.11661.8.camel@baal>
	<20110706152016.1982c6fd@natsu>
	<1309945954.2685.2.camel@baal>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/854hF6OWlRFeuuPt7u8fWiy"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1309945954.2685.2.camel@baal>
Sender: linux-raid-owner@vger.kernel.org
To: "Tyler J. Wagner" <tyler@tolaris.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/854hF6OWlRFeuuPt7u8fWiy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 06 Jul 2011 10:52:34 +0100
"Tyler J. Wagner" <tyler@tolaris.com> wrote:

> That is very interesting. The mdadm man page, and everything I've seen
> online, all say "The different sub-versions store the superblock at
> different locations on the device, either at the end (for 1.0), at the
> start (for 1.1) or 4K from the start (for 1.2)."

And? The quote is about location of the mdadm superblock (metadata), not al=
ignment or offset of user data.

--=20
With respect,
Roman

--Sig_/854hF6OWlRFeuuPt7u8fWiy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4UMskACgkQTLKSvz+PZwhxkgCgiWmmGPpZi8e+9jFYBlDZvoBr
E9oAn1yPvX7ePfEAZhXKtNatbV6Jh2wg
=0dgj
-----END PGP SIGNATURE-----

--Sig_/854hF6OWlRFeuuPt7u8fWiy--
