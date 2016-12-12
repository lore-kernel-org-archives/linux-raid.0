From: NeilBrown <neilb@suse.com>
Subject: Re: [BUG] MD/RAID1 hung forever on freeze_array
Date: Tue, 13 Dec 2016 08:53:24 +1100
Message-ID: <87oa0gzuej.fsf@notabene.neil.brown.name>
References: <CAMGffE=1kp7gMhG+dFxTvhD6VkRuSfbuXbf9vYSWwGG+=vvhDA@mail.gmail.com> <87a8c20xpg.fsf@notabene.neil.brown.name> <CAMGffEkQ5puQEE0FVfLMV1of1OYOhLMhHdUTAy-YLYPkzBzjDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMGffEkQ5puQEE0FVfLMV1of1OYOhLMhHdUTAy-YLYPkzBzjDg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jinpu Wang <jinpu.wang@profitbricks.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 13 2016, Jinpu Wang wrote:

> On Mon, Dec 12, 2016 at 1:59 AM, NeilBrown <neilb@suse.com> wrote:
>> On Sat, Nov 26 2016, Jinpu Wang wrote:
>>> [  810.270860]  [<ffffffff813fc851>] blk_prologue_bio+0x91/0xc0
>>
>> What is this?  I cannot find that function in the upstream kernel.
>>
>> NeilBrown
>
> Hi Neil,
>
> blk_prologue_bio is our internal extension to gather some stats, sorry
> not informed before.

Ahhh.

....
> +       return q->custom_make_request_fn(q, clone);

I haven't heard of custom_make_request_fn before either.

> +}
>
> =EF=BC=A9=EF=BC=AD=EF=BC=A8=EF=BC=AF=EF=BC=8C it seems unrelated, but I w=
ill rerun my test without this change.

Yes, please re-test with an unmodified upstream kernel (and always
report *exactly* what kernel you are running.  I cannot analyse code
that I cannot see).

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhPHFUACgkQOeye3VZi
gbnrRxAAm5T4PHhSnWVvnz7f94arby1pvYl9slVqPEEY24w/XAou+mLSvgs/2EL+
7D7GIC8GeyTViez8ejEuk/uU8pItUwC2uJ7n2/teYNv1BArvtOrCPDaYUvD27cco
GQ1e897G4wZO1n0u5GL/ZcHQ8xsgDOto40dt7vaU89DUQFW4gNRj4eZ/yeo1TdxB
ork2Ye0GJziTVKBXbYN7R54V7YloAi7Bz970FknFP5mRYwydQbHG/lMJppqeyvSP
MeYs2YETsMjuGUW7o1QzCRDQOlOsLxdar6zSv+44kzGM9ToPVz/jsaV68/eSHeh3
DM7uK/6HULIkg6vtQf1tiPOsz4eXazx+Ovm4Wqu+z+cj6Btrv6Ds1u3MjN/TklvM
9PS2Skfhux7ojObgqjCTBxrp7FQrtGMXY+d1a3i+1mOqqZ3SQ22Xp9Qi8xuRkoA4
rsDOqDGqdZmMMB+pMNgdp2VnCXlJPeIAm1d8s3kyhLY207u5O0AsMHaRZ2U6tkCG
5y95hdP+oRQqLOIcSC8p7P4jrwN7/FFLqnqwe+N9aIdrrQ2FSGH/kofJgKZx4NhG
8C1UxTx0RpceO9uompRNXNNdH1YDaBZCTv6vsC5Cwew8BqejAPliHphMVUFRq4K+
M20hvbryHXC7ZXsn7A/LSibPcl9CtBlme7IIgYRqabJJWQJAOsk=
=3in0
-----END PGP SIGNATURE-----
--=-=-=--
