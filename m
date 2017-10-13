From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md/bitmap: avoid read out of the disk
Date: Fri, 13 Oct 2017 16:16:33 +1100
Message-ID: <87wp3zlj9q.fsf@notabene.neil.brown.name>
References: <a9a406f5f751d39620d5e4907992ccb1bdbfb5a7.1507670143.git.shli@fb.com> <87bmldnjtq.fsf@notabene.neil.brown.name> <20171012173019.c2bbfyz3hgudjbhz@kernel.org> <ED3BAA5A-9A7B-4FA1-BC4E-299F1A69D9E7@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ED3BAA5A-9A7B-4FA1-BC4E-299F1A69D9E7@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>, Shaohua Li <shli@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, "kumba@gentoo.org" <kumba@gentoo.org>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 12 2017, Song Liu wrote:

>> On Oct 12, 2017, at 10:30 AM, Shaohua Li <shli@kernel.org> wrote:
>>=20
>> On Thu, Oct 12, 2017 at 02:09:21PM +1100, Neil Brown wrote:
>>> On Tue, Oct 10 2017, Shaohua Li wrote:
>>>=20
>>>> From: Shaohua Li <shli@fb.com>
>>>>=20
>>>> If PAGE_SIZE is bigger than 4k, we could read out of the disk boundary=
. Limit
>>>> the read size to the end of disk. Write path already has similar limit=
ation.
>>>>=20
>>>> Fix: 8031c3ddc70a(md/bitmap: copy correct data for bitmap super)
>>>> Reported-by: Joshua Kinard <kumba@gentoo.org>
>>>> Tested-by: Joshua Kinard <kumba@gentoo.org>
>>>> Cc: Song Liu <songliubraving@fb.com>
>>>> Signed-off-by: Shaohua Li <shli@fb.com>
>>>=20
>>> Given that this bug was introduced by
>>> Commit: 8031c3ddc70a ("md/bitmap: copy correct data for bitmap super")
>>>=20
>>> and that patch is markted:
>>>=20
>>>    Cc: stable@vger.kernel.org (4.10+)
>>>=20
>>> I think this patch should be tagged "CC: stable" too.
>>=20
>> I thought the Fix tag is enough, but I'll add the stable=20
>>> However ... that earlier patch looks strange to me.
>>> Why is it that "raid5 cache could write bitmap superblock before bitmap=
 superblock is
>>> initialized."  Can we just get raid5 cache *not* to write the bitmap
>>> superblock too early?
>>> I think that would better than breaking code that previously worked.
>>=20
>> That's the log reply code, which must update superblock and hence bitmap
>> superblock, because reply happens very earlier. I agree the reply might =
still
>> have problem with bitmap. We'd better defer reply after the raid is fully
>> initialized. Song, any idea?
>>=20
>
> With write back cache, there are two different types of stripes in recove=
ry:
> data-parity, and data-only. For data-parity stripes, we can simply replay=
 data
> from the journal. But for data-only stripes, we need to do rcw or rmw to =
update
> parities. Currently, the writes are handled with raid5 state machine. The=
refore,
> we wake up mddev->thread in r5l_recovery_log(). It is necessary to finish=
 these=20
> stripes before we fully initialize the array, because these stripes need =
to be=20
> handled with write back state machine; while we we always start the array=
 with=20
> write through journal_mode.=20
>
> Maybe we can fix this by change the order of initialization in md_run(),=
=20
> specifically, moving bitmap_create() before pers->run().=20

I've looked at some of the details here now.

I think I would like raid5-cache to not perform any recovery until we
reach


	md_wakeup_thread(mddev->thread);
	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */


in do_md_run().  Before that point it is possible to fail and abort -
e.g. if bitmap_load() fails.

Possibly we could insert another personality call here "->start()" ??
That could then do whatever is needed before

	set_capacity(mddev->gendisk, mddev->array_sectors);
	revalidate_disk(mddev->gendisk);

makes the array accessible.

Might that be reasonable?

Thanks,
NeilBrown


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlngTDMACgkQOeye3VZi
gbmcGA/+M/ECmfNPut1RTLxI5LMtJvvj2q2YAcfLlsNi/3Bq4o85sIYNsFu3xYDB
WgnwkGh7ddf/wCfYNC7rKsE3noYTX5KkaivtBFZnWvsOD75hLR5o31suDa0EbP1/
G7+ngBk1gH0kuBK61o5CBzho2BdA8umr0snFKX+c8EFDUVqpbarjDJaijj7tdAXH
eCRrA40owUjLMDaM/eynx8wO6STQleIMl/M4DX+Kinoj2KUrRj03aV5BBVbjXfC4
jByp5WV8iYqXP1AcPyw1Ab7p7y7NCnIVFoKSG8EFyzj0VrhDtLPtLfaLESx9Rhg0
Gpz3pQrhU4QhKb+oqlY9AQvYeehG6CKhN4kYHOWtNxNho03Y0z24actJJZNR2fxH
0r3rtntUfgihUqaN4wI5WOBQbVdtVZAOyUnrTxlm4MqK/JRkHLUNbex9I1v1jKYc
s9PiqOjz74AjFnQnfx0x9vCKq0lZnJn9+sWbw1rU0HXmkEwaJGE5qK86FNRcRgvO
j3qL/tmy9qCCJuep0tFAXwOsnMf0PDTHlK1H29aHhnr0lNQuNNfVYFUk27tGC1EQ
s5CIjm4XggWYD4r5VbF8OaJnGq0MwHBsnWn1+FsEh3DjGyo0yD1fp3WDxzbeNTEM
KFlnTrM3EhjW8XaES5ZFfUk/WWGoCwGQkYibc9IE6SPM+/pRl1Y=
=BKgn
-----END PGP SIGNATURE-----
--=-=-=--
