From: Jim Kukunas <james.t.kukunas@linux.intel.com>
Subject: Re: [PATCH] lib/raid6: Add AVX2 optimized recovery functions
Date: Fri, 9 Nov 2012 11:56:10 -0800
Message-ID: <20121109195610.GA2928@jtkukuna_gentoo_sb.jf.intel.com>
References: <1352411264-5156-1-git-send-email-james.t.kukunas@linux.intel.com>
 <1352460945.4387.7.camel@mattotaupa>
 <ead47490-afc3-48f1-871f-ba421eac3dd5@email.android.com>
 <20121109225025.13a846ca@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121109225025.13a846ca@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Paul Menzel <pm.debian@googlemail.com>, Linux Raid <linux-raid@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 09, 2012 at 10:50:25PM +1100, Neil Brown wrote:
> On Fri, 09 Nov 2012 12:39:05 +0100 "H. Peter Anvin" <hpa@zytor.com> wrote:
>=20
> > Sorry, we cannot share those at this time since the hardwarenis not yet=
 released.
>=20
> Can I take that to imply "Acked-by: "H. Peter Anvin" <hpa@zytor.com>" ??
>=20
> It would be nice to have at least a statement like:
>  These patches have been tested both with the user-space testing tool and=
 in=20
>  a RAID6 md array and the pass all test.  While we cannot release perform=
ance
>  numbers as the hardwere is not released, we can confirm that on that har=
dware
>  the performance with these patches is faster than without.
>=20
> I guess I should be able to assume that - surely the patches would not be
> posted if it were not true...  But I like to avoid assuming when I can.

Hi Neil,

That assumption is correct. The patch was tested and benchmarked before sub=
mission.

You'll notice that this code is very similar to the SSSE3-optimized
recovery routines I wrote earlier. This implementation extends that same
algorithm from 128-bit registers to 256-bit registers.

Thanks.

--=20
Jim Kukunas
Intel Open Source Technology Center

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQnV/aAAoJEJsd5ffp0QqM2XUP/jZyf7jP4PxivCI83+QYG1FT
1UCEfsmvv04I8Rs9cyoZREUKNH9vbnMSt6dlOQ58PjAS+AxEORRcaujt4tNiWd4T
vbY3ov78XvgIpf0DIFuLGJA3ih1H0Wx0tUXN72RsRmbaSpnc4ZDGvqTLy8QtFQv/
TiSjCruef7Y2XaLopJ4Z+NHbc1QNhsudzUJqOLdmlNzfgd6PMZejWZpaU1aQQKAs
oXSse1dR18S52Ci486dvpKgV2PJi4FAJttdsKvcvBIRvPXWpM1SIJgUhtAZTPyv5
g5EiEiwShhOD0Xlnhb6ZPuJzAi2N9+uXPWBaKLid2E9vB7sPZ/iMuECjRhkErbIj
WYnmTB42DW84kWqL5p5vtuLHTze8LTjgOpGOa9Wo9IFrAhBK70cyvb6348AlnJVY
SQ/dJVL2SlDtZCQ8I7ZaNnbvDct8UjBy4c1ELIL69uUsqxK+/G/eOtE9wdEGbyW0
DZXrWw0Wm+bRvYJZcTgW2izOSv///+VWWDF/V179LKODAoJR6jcUHIRblM8XahKQ
4t6+p5wNOGDQxZApcKegfb0q3aGpNWT1/uR80HKBlrHc4GazWsGsk6YDYVQeSRCj
OCZQX/DN3ZJ5628vpNqneyywyPOOvTl0AZlspmDXJFjBq8qr8mSs7ykSphw/EbVo
Su5PDKozV98OxA6u4Pb8
=e4b1
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
