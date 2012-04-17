From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC 1/2] MD: raid5 trim support
Date: Wed, 18 Apr 2012 06:26:41 +1000
Message-ID: <20120418062641.000e881c@notabene.brown>
References: <20120417083552.483324288@kernel.org>
	<20120417084632.306032602@kernel.org>
	<CABE8wwswKWQ=LDbx0ysTaZf2Hz0jD_q45FNF0jw96ZwZdJiHPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/db0vnk5igLLl9JHSrWYlq21"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABE8wwswKWQ=LDbx0ysTaZf2Hz0jD_q45FNF0jw96ZwZdJiHPw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, axboe@kernel.dk, Shaohua Li <shli@fusionio.com>
List-Id: linux-raid.ids

--Sig_/db0vnk5igLLl9JHSrWYlq21
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Apr 2012 07:46:03 -0700 Dan Williams <dan.j.williams@intel.com>
wrote:

> On Tue, Apr 17, 2012 at 1:35 AM, Shaohua Li <shli@kernel.org> wrote:
> > Discard for raid4/5/6 has limitation. If discard request size is small,=
 we do
> > discard for one disk, but we need calculate parity and write parity dis=
k. =A0To
> > correctly calculate parity, zero_after_discard must be guaranteed.
>=20
> I'm wondering if we could use the new bad blocks facility to mark
> discarded ranges so we don't necessarily need determinate data after
> discard.
>=20
> ...but I have not looked into it beyond that.
>=20
> --
> Dan

No.

The bad blocks framework can only store a limited number of bad ranges - 512
in the current implementation.
That would not be an acceptable restriction for discarded ranges.

You would need a bitmap of some sort if you wanted to record discarded
regions.

http://neil.brown.name/blog/20110216044002#5

NeilBrown

--Sig_/db0vnk5igLLl9JHSrWYlq21
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT43SATnsnt1WYoG5AQIjPQ//bb3eZM8iz1a8pXJs3v5TJ4BHnJP7vlKo
B38XKmfJ9FebKhSnM4cjU0utovOXsF4M6G8oMyYTTLUiK/FZreSkZc6S/MaL9vwA
SF+RIVcO+l0snUDrxbnE3wUcWPLnWZ5ED16YmGNKx6YmEhDXkOM9nx5GvLK/v5uG
CcxdPa2Hrxc8n+mKz2LmI2+7u7Vvl5vRP+i4gdhAV9/lSGjRySodgclcnWEDSu+a
CSuG2BjtaqF1ptPf51Jg1k1gholbdHWAO0JQR2VRQB1biuXCbdaP3fHOwjcJPMDj
ocfFSIFsvhflkqFqgG+tvxHSfKVxM8gYCun3ZcGbU45MSJB6YJTWnpszGv/ML6lC
WrFBcXeiJHxdDUAJR6WG8ckClyajefk+sAEUK8/vkaUzJPYEhV3XtyH15WLXc+6T
AM2LbD14XSQYt4h8tTvGpu/UR7hCgo8bknZrqy1Js+e+BdhENylfHEBGnWRk1uxX
lWUWbRrGOOcJNGlhyO8SFgXDXkhrmGAnN9o5la+s3uRGW5NmsjL8xPm6DA4T/vit
squk453xLsHIKxBTfZa6pJOEncBxzO5z46lOfRAdx7jN4ak8nPa5iL7CMZfVhjl+
OXRmAQRtJimQAXehdjL9FpTTsstaUm54QhDVxAhAx2s0YCSUtcuAEJfXDNnck6wi
vcHAZgtMInw=
=Oxt2
-----END PGP SIGNATURE-----

--Sig_/db0vnk5igLLl9JHSrWYlq21--
