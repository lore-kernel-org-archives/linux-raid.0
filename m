From: NeilBrown <neilb@suse.de>
Subject: Re: read error recovery threshold
Date: Mon, 22 Sep 2014 13:35:37 +1000
Message-ID: <20140922133537.20222f9c@notabene.brown>
References: <CAK=nhWO75WOJNCOXG+_ynug3ta6939b-8fyz0R1D-ENXF7jEGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/lOoi4Vv99zC2X2xawmaOHYJ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK=nhWO75WOJNCOXG+_ynug3ta6939b-8fyz0R1D-ENXF7jEGg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Mei <meijia@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/lOoi4Vv99zC2X2xawmaOHYJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 15 Sep 2014 10:56:11 -0600 Eric Mei <meijia@gmail.com> wrote:

> Hi,
>=20
> After a read error detected, RAID6 will initiate a recovery procedure
> try to correct it, until the number of read error exceeds a threshold,
> which is "conf->max_nr_stripes" (see raid5_end_read_request()), I'm
> wondering the reasoning behind this. To me the threshold seems a drive
> property, but max_nr_stripes is a array-wide cache setting and can be
> changed at runtime. In our specific case, we observed a drive emitting
> lots of read errors without being marked as faulty because the larger
> max_nr_stripes
> setting.
>=20
> Look at other part of MD code, there is "mddev::max_corr_read_errors"
> which is set to 20, but only RAID10 makes use of it. Also the comment
> above MD_DEFAULT_MAX_CORRECTED_READ_ERRORS says "...We divide the read
> error count by 2 for every hour elapsed between read errors", but I
> don't see any code matching this description.
>=20
> Any thoughts? Thanks

Yes, it is inconsistent.
It wasn't designed to be inconsistent, it just happened.
Patch with good justification will be looked on kindly.

Thanks,
NeilBrown

--Sig_/lOoi4Vv99zC2X2xawmaOHYJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVB+ZCjnsnt1WYoG5AQJjgA//anC3XYkXxggTXnzqeICloyXMOzTGtUVs
C16YAuVxXNpWKGh2z3nbmjef1KAX90lTyUfhVwY4PIFfkqWzrp5TfYdBYvtAXCN3
MV7gE6MCxVjyTbq72o1AxSJCKsHnXwVqZVXLq5TqBK8F17aWOzgE6h4LhpbkjuGZ
1D5kVjz7NntPLE3oqYwL4RqFA6/feVUKuPFydKwBUBmUPE7g/v4z3OtvrNDtfOrX
HkurapGaqMr+bRzmMIsxFw3r8jarV1YgVQ8j6p2yT0yQjfYpHZmYhVbh0X4y+xqb
n3FmYRBvsRb6j8Mcxz24GgFwTB16BaGctFvptj/D/McuCojT+A1qelZie1Af3o0m
Q3zGsdCX4wK3YubMk3YvZqB8YNNBrnfrH3V+8MOAzrgqvzhQuft2lbG/eztms+gf
Xr5LSsiZTxhquNjyB0byn/LlpTEUTexS6H3FpVUUnFhBfKcqeyAqlcK/9Uv+qjA9
DiTudIQKVccdECB+7IxVdJebNP9uzMc/1vkj6VHq5BSSmk8ehaCsEalmQ3abEgCF
vgE9MXk6mLVTxPEX7nvLlKQ6t+m9p1yaBoVgTSEJAP6EYSKvdTXTsmUFV6XnI8BP
GDJBj/Ot+Yn2SmOvxptXq5YOr6hNY+osFbitwPuFLGjD4guZlo+skjmNFhYvuGEf
gxoC5pup64M=
=FskW
-----END PGP SIGNATURE-----

--Sig_/lOoi4Vv99zC2X2xawmaOHYJ--
