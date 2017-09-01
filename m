From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] mdadm: handle super == NULL case in avail_size1
Date: Fri, 01 Sep 2017 10:21:59 +1000
Message-ID: <87r2vre09k.fsf@notabene.neil.brown.name>
References: <20170831173751.2910909-1-songliubraving@fb.com> <87ziafe2dk.fsf@notabene.neil.brown.name> <C170566B-A2B7-4220-9C61-D08DDE5E7E4A@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C170566B-A2B7-4220-9C61-D08DDE5E7E4A@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, Kernel Team <Kernel-team@fb.com>, Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@infradead.org>, "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 31 2017, Song Liu wrote:

>> On Aug 31, 2017, at 4:36 PM, NeilBrown <neilb@suse.com> wrote:
>>=20
>> On Thu, Aug 31 2017, Song Liu wrote:
>>=20
>>> Summary:
>>>=20
>>> Handling super =3D=3D NULL case in avail_size1() was removed a while
>>> back. However, it is still useful in the following stack:
>>>=20
>>> avail_size1() with st->sb =3D=3D NULL
>>> array_try_spare() with st =3D=3D NULL
>>> try_spare() with st =3D=3D NULL
>>> Incremental() with st =3D=3D NULL
>>=20
>> I assume you mean "st->sb =3D=3D NULL" in each case here?  What you have
>> written doesn't make sense.
>>=20
>
> I did mean st =3D=3D NULL. In array_try_spare(), if st is NULL, st2 is=20
> allocated with match_metadata_desc(), and avail_size() is called with
> st2.=20

Ahhh, OK.  But if st isn't NULL I think the problem still exists as when
an st is passed to try_spare() it doesn't have an st->sb.

>
>>>=20
>>> This patch adds the handling of super =3D=3D NULL back to avail_size1().
>>=20
>> I doubt this is the best thing to do.
>> If we don't have st->sb, calling avail_size doesn't make any sense.
>> Maybe we should be calling validate_geometry.
>>=20
>
> This was the same logic that got removed a few years ago. So far it=20
> works for my use cases. And I think it makes (some) sense.=20
> Is validate_geometry() really better than this approach?

validate_geometry is better because it doesn't expect 'sb' to be set.
The documentation for avail_size says:

	 * 'mdadm' only calls this for existing arrays where a possible
	 * spare is being added.

In the try_spare() case there is no existing array.  Rather, try_spare()
is checking if a particular geometry is valid.

It is rather sad that this auto-sparing functionality has been broken
for 4 years and no-one noticed until now.  I really should have created
some self-tests....

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmoqCgACgkQOeye3VZi
gbnBgg//YhZjMGToiTdTvVgOuFysAHzDl4kEVOVDwIIzX7D8sw4vpVJhG4AfZglp
GeugBWNnn0H9JEnDNAlH8RqVoA1dImeuatTfTdiSp+YYgNmRwgFxZnKli0DI6KGT
fkGvguxegUW6VfZDTctSchrN/GafaRZOBz1UpEF7BmbwTRCvlrcqChUXz0477Hr2
L2k3kwWPsQ85ZkYOpjNyh2X0QGS8CcW3QXC9Luh+SZGCdX+Pa3umk6Ddl42tAVkD
zlru7bukYeY5+HQjPBFCzy5vMwu9B/ptAg5npZQ7Gqe61NSdl9Usdm8dWfSoBZwS
q1TahQF9o3gVRZLO9ho4UOm7u9rfN/3LTeu48lw1T83Y65QtIdXWGeBpHlCN1B4T
1xfvkuU0Bc6fx+fgzOPAeQGsa6g1txytQ++LYgSiBAx3d251nl6ygYqyEmJIsTvm
IuxRKTN/22yic/tBmFmrG0gyUbVoOylXZAFwkiZZvgi9mWFAnPYGnbSun/YKmt3D
iO0e9+Piskl9bP092OcKLSV1Ka7B6OGBlhzqMfX4anbnA44WKs2uoQ9NXO+xcj1J
2pCWhgWyqSLqZdbeso+1GjMGJRf9vINoC77WJW8IoUtJH98d3l4bQLVJp5SNfTV+
SA29kfksXz+SzrHdjpASjhFS68jNI2B1zVaF9e66SzYlYSLNYhw=
=Qnp3
-----END PGP SIGNATURE-----
--=-=-=--
