From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Is (non-failed) disk replace possible without loosing
 redundancy ?
Date: Fri, 12 Apr 2013 16:01:24 +0600
Message-ID: <20130412160124.3439ad7d@natsu>
References: <F5FBA8C0111F5C458B9E1BC24A3F4BDD01F43AAFA5@exchange2.ad.tlogica.com>
	<5166D3C5.5000407@websitemanagers.com.au>
	<runj3axnnb.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_q=pyd2oQuW=7zAyuOse_B0"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <runj3axnnb.ln2@goaway.wombat.san-francisco.ca.us>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/_q=pyd2oQuW=7zAyuOse_B0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Apr 2013 14:52:59 -0700
Keith Keller <kkeller@wombat.san-francisco.ca.us> wrote:

> Is there any way to accomplish the same sort of
> thing in a RAID5 or 6?

There is the "want_replacement" mechanism. It exists, it works perfectly, b=
ut
from this thread it looks like no one knows about it. Actually I am not sure
where it is documented, try searching the mail list archives.


--=20
With respect,
Roman

--Sig_/_q=pyd2oQuW=7zAyuOse_B0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFn23UACgkQTLKSvz+PZwjeIACfTEk/0a/m+IAcydQB1CFsMCjs
txUAoJcCpofniYDqcZ/tVnpFU/e+jcFy
=vtHY
-----END PGP SIGNATURE-----

--Sig_/_q=pyd2oQuW=7zAyuOse_B0--
