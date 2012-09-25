From: NeilBrown <neilb@suse.de>
Subject: Re: bug: 4-disk md raid10 far2 can be assembled clean with only two
 disks, causing silent data corruption
Date: Tue, 25 Sep 2012 22:32:27 +1000
Message-ID: <20120925223227.130ef8e3@notabene.brown>
References: <50606207.7040804@gooseman.cz>
	<20120925141959.0c22de7d@notabene.brown>
	<alpine.DEB.2.00.1209250658250.13902@uplift.swm.pp.se>
	<152edbf7bdad33717477f174f94116b7@192.168.93.35>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/EL2spjba_hMJa+Kziv8k2gZ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <152edbf7bdad33717477f174f94116b7@192.168.93.35>
Sender: linux-raid-owner@vger.kernel.org
To: jakub@gooseman.cz
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/EL2spjba_hMJa+Kziv8k2gZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Sep 2012 11:48:34 +0200 <jakub@gooseman.cz> wrote:

>=20
> On Tue, 25 Sep 2012 07:00:44 +0200 (CEST), Mikael Abrahamsson
> <swmike@swm.pp.se> wrote:
> > On Tue, 25 Sep 2012, NeilBrown wrote:
> >=20
> >> Why do you say that "the write IO errors are invisible for the=20
> >> filesystem"? They are certainly reported in the kernel logs that you=20
> >> should and I'm sure an application would see them if it checked return=
=20
> >> status properly.
> >>
> >> md is behaving as designed here.  It deliberately does not fail the=20
> >> whole array, it just fails those blocks which are no longer accessible.
> >=20
>=20
> Would you please refer to some documentation that this behaviour is
> correct? I now tried to fail several disks in raid5, raid0 and raid10-nea=
r,
> in case of r0 and r10n, mdadm didn't even allow me to remove more disks
> than is sufficient to access all the data. In case of r5 I was able to fa=
il
> 2 out of 3, but the array was correctly marked as FAILED and couldn't be
> accessed at all. I'd expect that behaviour even in my case of raid10-far.=
 I
> can't even assmenble and run it with less than required count of disks.
>=20

Could you please be explicit about exactly how the behaviour that you think
of as "correct" would differ from the current behaviour?  Because I cannot
really see what point you are making - I need a little help.

Thanks,
NeilBrown

--Sig_/EL2spjba_hMJa+Kziv8k2gZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGGkWznsnt1WYoG5AQIIbRAAlG+/mbs2QvvyBApoOcYESQ6IFjMpnUnK
7JDfKAwpw3vyiQEAORwAe6+7f0zu0ivzMa/ufCuktkw0L5W2zCzF3sfcK+d7CHDe
g6hGwXPjnSOgZQQyJM07auEC5sDp4QYpb0zwEzSx433TI4jRe7/zzKWGxjI4b6hv
k6RnUMwHI1NNFqa3pH1BlCmquuDlwLQ/zCd9gWOA4Tamg0qnK+wF5utci66+37Xl
B1AgoUg6yClQpOV8F3IHdREvx1CpZb4zP3TtJZV2s0QThX2KYcJNliV0+wKR1J5U
3p1CTJC33QyJiOamM7J6HNXTZpz7VeATNhcp2sSl720Y4B9hMLHu7BQhSA0LMAkM
IZIPq9/W+ugCA02itBLaoEPhBUsrUzrZFsI77nBUrkvFPsF1E5vUCm2QayDBZDE+
2S0YSyFHSHUSs0ZgFALWe8QybNY99mZdMKmsKUac1jdPTWHWnn/SjHVh0giinV4T
BsZh+VGxskL5HhmvrlndUx7OZjq0qclRoyPQu+ge8NZp6fLKbqC0z70OR4OlZv9D
zZ1TSRvxlwLTZYfgcVkU9noT5mcKrdObfhwNgb3tUlg48WLCfdDMVes5EvrVfpAD
XsS1FPdaLkvAkgu274wkkupTlVHMSCn4G0UOCarjwcHQRt0I2tJP9WV8ey5kHbNa
QdpDt8fqdlQ=
=hZ+T
-----END PGP SIGNATURE-----

--Sig_/EL2spjba_hMJa+Kziv8k2gZ--
