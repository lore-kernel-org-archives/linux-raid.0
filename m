From: NeilBrown <neilb@suse.de>
Subject: Re: Reason for md raid1 max_sectors_kb limited to 127?
Date: Mon, 7 May 2012 21:18:46 +1000
Message-ID: <20120507211846.789d5808@notabene.brown>
References: <4FA798D7.4070506@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7KQua5T0ns/0NSurc0A9tqs"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FA798D7.4070506@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/7KQua5T0ns/0NSurc0A9tqs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 07 May 2012 11:41:43 +0200 Sebastian Riemer
<sebastian.riemer@profitbricks.com> wrote:

> Hi list,
>=20
> I'm wondering why max_sectors_kb is set to 127 with md raid1.
> This value is at 512 on normal HDDs.
>=20
> If I do a file copy on ext4 on a normal HDD then I can see with
> blktrace/blkparse that 128 KiB chunks are read and 512 KiB chunks are
> written.
>=20
> With md raid it looks like this: 124 KiB, 4 KiB, 124 KiB, 4 KiB, ... .
> This looks very inefficient.
>=20
> So, is there a particular reason that max_sectors_kb is set to 127?
>=20
> Cheers,
> Sebastian
>=20

You didn't say which kernel you are running.

However md/raid1 bases all those settings on the minimum or maximum (as
appropriate) of the setting of the underlying devices, using blk_stack_limi=
ts
(in block/blk-settings.c).

So the likely answer is that one of your HDDs has a smaller max_sectors_kb?

NeilBrown

--Sig_/7KQua5T0ns/0NSurc0A9tqs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6evljnsnt1WYoG5AQIK6w/9H/B2I3+XHMsLHGs/sga4A+bxyPzviN4P
BjgNFlhMO1eLmJswnsh8eq/HuAfzoyVVtD3QaNnxjy6uxCliyGX6kYZFhkEDsqhr
IbdU/ISl14I5NsamBiozwi47CmnaTelZ+P9C2DAC4kunCcEbGsLUBPVf9kxk4DfV
M7xA3sOGcMwY/nyvmG51VZsHfggeyma2KZSx4YOwnCHni9+wUUFBmwqT/D8vEhjD
4XPX9mf4GiBQizYMTLvkytjhxoDDbmyHJRA6mweSdTaN7J3R02Cw+faPwzlorDr+
dVxgJEdaaS8vRFIL53/SZyY+GeqDCwIzBHEAOwftQts0E3faFXPCaT+gezMwhaqq
Ep/EDfeLD6XX0TPRSQh9Pecli0asFz9dDJjeyW5j4qt10Omb0VffwASCHjdlQdfE
N0QTB3FNM6PM9svD63vXXcpZImk/xYf6JcnPjnUe1+KFkAEAj15z4UK1uAidh5Cp
IgJ7bkEE4niQcOfJ1te2Fvl1WmuVeWWHu9FBTnFRML3LL7jRpsXE5gWmKlF8iZ67
vYSrctxOtIH0lYI4UMveRzSfVdXfNenDDgRC0UHIb28HuWx9mC6hWFYg2x9YBuEC
WXL/1Ll2Bwr4muSAMMYmkHqI1jOW5tenzqQs0AJUf8INqW3kzZforp6u7K8YP2jr
sRTX9bb/+kU=
=xodh
-----END PGP SIGNATURE-----

--Sig_/7KQua5T0ns/0NSurc0A9tqs--
