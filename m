From: NeilBrown <neilb@suse.de>
Subject: Re: RFC: handling of missing disks in DDF
Date: Thu, 8 Aug 2013 09:04:23 +1000
Message-ID: <20130808090423.4b806828@notabene.brown>
References: <5202B633.3080807@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YIgHFdq_JE=GeNFWhm7.R9p"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5202B633.3080807@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/YIgHFdq_JE=GeNFWhm7.R9p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 07 Aug 2013 23:03:47 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> Hi Neil, everyone,
>=20
> I'd like to get comments on the following concept for handling missing
> disks. Currently we handle "Missing" and "Failed" almost equally, that's
> not optimal.
>=20
> 1. Try to detect missing disks and mark them so in the meta data.
> ddf_open_new() could do this. At the latest, it must be done before
> writing the meta data (write_super or sync_metadata).
>=20
> 2. Detection of a missing disk should not force an immediate meta data
> write, because the disk may be added soon. It's sufficient to mark a
> disk as missing when we write the meta data for other reasons.
>=20
> 3. Try to be smart when loading headers. A disk that was missing in a
> previous run must have a lower seq number and time stamp in the meta
> data than the other disks, and must be marked "Missing" there (but not
> "Failed"). The meta data on the preciously missing disk should mark it
> as "active/Online". In this case, use the newer meta data, and try to
> re-integrate the previously missing disk (i.e. treat it as preferred
> global spare).
>=20
> 4. It's possible that an array wasn't written to while a disk had been
> missing. In that case the disk could be re-added to the array without
> recovery. The question is if we can detect this situation. I thought
> first  the "Not Consistent" bit might be usable for that, but I doubt it
> now. The spec isn't clear about whether "consistent" state means
> consistency over all configured disks or only over present ones.
>=20

Hi Martin.
Thanks for looking into this.

Can you say why exactly that treating 'Missing' like 'Failed' is not
optimal?  I find them to be very similar concepts.

Your idea for marking a missing device that reappears as a preferred spare =
is
probably a good one - is that incompatible with treating it as failed while
it isn't present?

As soon as we mark an array as active (aka Not Consistent) we need to mark
any missing devices as 'failed' in some way to ensure that the data is never
seen as valid in the array.  Before that we can certainly be lazy about
translating 'missing' to 'failed'...

Maybe if you could give some more detail on the problem scenario??

Thanks,
NeilBrown

--Sig_/YIgHFdq_JE=GeNFWhm7.R9p
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUgLSdznsnt1WYoG5AQKOgw//TZ/KQHQSZCrL202D1GNE9WVZ240XuTJa
Bk+VAiDBXUIzMDFbuJGjEx8nB9wFCTGD/8GoWOxD+3zji9+DZpc/bWdOpbSiqjYB
bdPTRcO4wzQKZLJ31T8IyKHSj4GsOCZAD41vURycIxZ3hV5D5YCVTAvPuAl6Cwpx
rh+h07wXqbxW8+KkJN6OsW52X9CiHU07z+a4aXu7Z1iEVwwlSrvXKeDZ9NwUKWVJ
o6VTf3Xz0+RhtptZkvdnjBYWkX3QJYvkFo6TAyqBTO0ZCquvZJ06NNmWKTrnaJHu
XfXGKLwIgOv3QBFKoXRkBGl4PifO8+DnyU7soEYmXhv3YVejsYwvWfT8dxmiXpo3
TtXF7H5zJTcPl11Y0WB9RQeMgkD9+lLxWPrW7nAC7Q8lhRB13lzbtZv1j2S5hvOM
qYJdEBPtct8d9+Jeay0mF+drZZA4TkBvdXwb3weO8yLZ83ZsUY/vbWYjjMUXJFVw
3mmBXoTq+ts7emKu5tHBtZ7DMELkgX0Kvg8swxSsQczNWg7/dFk2J4Bah/nJ8nIu
2DB4T85X44EirjdfAcCbNOThe0B0stIkntvRGfGileJGNKq70CPmroeihbcGsr/l
sSJnJ69MlQoKZ/yczbI1Hn7Tx+fdn82O73PsV2/ZduNsP8qygmkk/+qm6u2Rfhgt
3u4u05RGxnQ=
=SS2w
-----END PGP SIGNATURE-----

--Sig_/YIgHFdq_JE=GeNFWhm7.R9p--
