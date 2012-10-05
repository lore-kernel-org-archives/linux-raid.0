From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Promise SATA TX4 300 + 3TB disks?
Date: Fri, 5 Oct 2012 12:36:53 +0600
Message-ID: <20121005123653.0a5398e0@natsu>
References: <818058745.20121005012826@oudeis.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/42AtdA4=HkhCS_JK516Ob.k"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <818058745.20121005012826@oudeis.org>
Sender: linux-raid-owner@vger.kernel.org
To: Rainer =?UTF-8?B?RsO8Z2Vuc3RlaW4=?= <rfu@oudeis.org>
Cc: Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/42AtdA4=HkhCS_JK516Ob.k
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 5 Oct 2012 01:28:26 +0200
Rainer F=C3=BCgenstein <rfu@oudeis.org> wrote:

> If not, which (inexpensive) PCI SATA controllers would you recommend?

http://blog.zorinaq.com/?e=3D10

I would not recommend a PMP, with it your 5 disks will be limited to one SA=
TA
port's bandwidth, which will not give you good performance. But by all mean=
s,
use up all of your mobo's onboard SATA ports first (for individual disks),
before using an addon controller's ports.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/42AtdA4=HkhCS_JK516Ob.k
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlBugAUACgkQTLKSvz+PZwjcTgCfRgL08AEC0bc/q888WFw9RdxL
jZ0An2486baV3DY3K3p93BR6BrSHgK23
=3CBI
-----END PGP SIGNATURE-----

--Sig_/42AtdA4=HkhCS_JK516Ob.k--
