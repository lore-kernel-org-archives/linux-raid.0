From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 0/4] Assorted mdadm patches.
Date: Thu, 17 Aug 2017 08:20:06 +1000
Message-ID: <871sobnoix.fsf@notabene.neil.brown.name>
References: <150182450644.25561.9683614144764209335.stgit@noble> <8ff33ba2-35ce-805f-4c8c-5fb3b4615573@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8ff33ba2-35ce-805f-4c8c-5fb3b4615573@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 16 2017, Jes Sorensen wrote:

> On 08/04/2017 01:30 AM, NeilBrown wrote:
>> One real bugfix - that a customer might have hit.
>> Another real bugfix, which proves no-one is using that feature.
>> And a couple of minor consistency improvements.
>>=20
>> Can you guess which is which :-?
>
> Clearly patch 1 is the customer reported bug :)
>
> I applied all of them. I am not wildly in love with patch 4, I kinda=20
> would like to switch to using standard error codes, but mixing them is=20
> inconsistent, so lets at least be consistent for now.

If we were to switch to standard error codes, we should probably aim to
use the EX_* codes from sysexits.h.  No errno values.

>
> All applied!

Thanks,
NeilBrown

>
> Thanks,
> Jes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmUxRgACgkQOeye3VZi
gblulxAAlB/e6tkz5Wxmy7xR++8djJY4axEyPeRGZgFVMq3dar+QFuWHDn9CUqGF
e8nFnPJHRtsqZnjW4igR60yzaq8H1sDylnuIPKwi2YosFe0NrfcqlEhqgSL3a1D9
hyPU86j1GrGBE7mnMMWxc1rKok3wXIi+CNXwLxs6fX+CSSMqZosgIT9kC0fXXpjM
6A9RayLxXs4LTcdxzhSz0KTwPB0C891dZA+fpCyYVr3sv+w7Pqala4YVptpQDZAh
MZHSdtLOMkgRNx9L/7sIv+o1Dr4dPaxCcFo7yAGRmKS97Vy2M9vwFb6s21n2kk1A
msujcjy3G14d9zgC3sugiXKuOd63XYeuY2PR07rps6gBVij5ck8D8n+zSTyxWqAw
chmvd3xqd1nNfbWR/2v2xs8Kbfcy14rlVFAM/10auTCphIVbl5CXYvjX4UWO43NC
OP3TbvFLfbHWYwAkDuRvKTFOrA6r6w6gYiXbmVmO9vsQGrXTwAzOROSk0PXQ3PC1
H87G2GlEvXIPN0ZHMQMIqPTV3fsPE3tBf66DZ+SS2GGDZRXAD1E8lnskIENr9leZ
uxwZIb90l7WMVxLoApv3yWezlEVPuqZmUC1mv91+J9rDbxiJ5BVYxmI5huc9DIOA
3Kw5PB7KWjBEzVfYMk9F15z8kMyicYzgLaKWmCSsFYnS53TJcq4=
=GreE
-----END PGP SIGNATURE-----
--=-=-=--
