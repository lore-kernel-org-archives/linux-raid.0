From: NeilBrown <neilb@suse.com>
Subject: Re: raid5-cache: avoid GFP_NOFAIL allocation
Date: Fri, 18 Dec 2015 10:31:46 +1100
Message-ID: <87d1u48xel.fsf@notabene.neil.brown.name>
References: <1450390197-19479-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1450390197-19479-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, shli@fb.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, Dec 18 2015, Christoph Hellwig wrote:

> bio_sets, mempools and high level retries are our friends:

Yes they are!

all applied, Thanks.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWc0XiAAoJEDnsnt1WYoG5JEAP/iowrEAAm48KPvYHdJJG8ypS
MEI64QiIQIyuNKvK1e9qubNe5NtYGHR0LVupmo5jIX50SvZfXZiByQ/5ysnm0vyG
+ALM0Np0IUmP3UjuT/9zdXXA0qKz/Pf1bGiWw00CSXiPaPv3Mjb/fvgkpyF+NJff
+o0RjaUTjhIsbgg/ADGckKyAmtDcFZuBD0uSJ0HhOwZq5sTcvXxseOswl3yI1f01
Lm8+VMMd4Xc2a7Huw8POpdV1Cet1h+eI6FK8bH6GRBJDJAjeULpFqEilnRfigBMw
99f1u8XsZh1hUTawT2msbOvaqlDWRzqvIAPZMaM5wnwELMZSkO3IYEAMfhXFEjaX
qTSRWT13XB+ucH/MCMLNETJP/q9JpiZO94amDXo0yw0Jmcw4gUen89td6Yi0JP4s
JqJM7kEWx882cMUODagEmvHc7+F2BYEQY1opnVIFokIkXPh4akdD8uw0RDpVeY+Y
16s1k6pzWmMfuBuhZYzzoKTP/CWkseOJxIw+fze5tJGDZ3NJnmF1SelCdtRTmW15
Sp79LhefM/axIzZjbCodHP8R2EFK9f5FJT+ArCBTM7mikeH/FWr4tlffpNSQw6nu
SM9adOibRIL1Upuyk/wmMEXWl8EVxJNNAqvuovkVwseQbthX3K4aFtRMtpxDoo9T
LTQz3nbCgFsifs5Y7Bp4
=pHkD
-----END PGP SIGNATURE-----
--=-=-=--
