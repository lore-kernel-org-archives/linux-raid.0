From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md/bitmap: avoid read out of the disk
Date: Tue, 17 Oct 2017 08:15:33 +1100
Message-ID: <877evulrpm.fsf@notabene.neil.brown.name>
References: <a9a406f5f751d39620d5e4907992ccb1bdbfb5a7.1507670143.git.shli@fb.com> <87bmldnjtq.fsf@notabene.neil.brown.name> <20171012173019.c2bbfyz3hgudjbhz@kernel.org> <ED3BAA5A-9A7B-4FA1-BC4E-299F1A69D9E7@fb.com> <87wp3zlj9q.fsf@notabene.neil.brown.name> <20171013195122.mi7gr4xxm77odx7t@kernel.org> <608CE47A-1C46-4087-B7D3-6FA5936C1DAF@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <608CE47A-1C46-4087-B7D3-6FA5936C1DAF@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>, Shaohua Li <shli@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, "kumba@gentoo.org" <kumba@gentoo.org>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 16 2017, Song Liu wrote:

>> On Oct 13, 2017, at 12:51 PM, Shaohua Li <shli@kernel.org> wrote:
>>=20
>> On Fri, Oct 13, 2017 at 04:16:33PM +1100, Neil Brown wrote:
>>> On Thu, Oct 12 2017, Song Liu wrote:
>>>=20
>>>>> On Oct 12, 2017, at 10:30 AM, Shaohua Li <shli@kernel.org> wrote:
>>>>>=20
>>>>> On Thu, Oct 12, 2017 at 02:09:21PM +1100, Neil Brown wrote:
>>>>>> On Tue, Oct 10 2017, Shaohua Li wrote:
>>>>>>=20
>>>>>>> From: Shaohua Li <shli@fb.com>
>>>>>>>=20
>>>>>>> If PAGE_SIZE is bigger than 4k, we could read out of the disk bound=
ary. Limit
>>>>>>> the read size to the end of disk. Write path already has similar li=
mitation.
>>>>>>>=20
>>>>>>> Fix: 8031c3ddc70a(md/bitmap: copy correct data for bitmap super)
>>>>>>> Reported-by: Joshua Kinard <kumba@gentoo.org>
>>>>>>> Tested-by: Joshua Kinard <kumba@gentoo.org>
>>>>>>> Cc: Song Liu <songliubraving@fb.com>
>>>>>>> Signed-off-by: Shaohua Li <shli@fb.com>
>>>>>>=20
>>>>>> Given that this bug was introduced by
>>>>>> Commit: 8031c3ddc70a ("md/bitmap: copy correct data for bitmap super=
")
>>>>>>=20
>>>>>> and that patch is markted:
>>>>>>=20
>>>>>>   Cc: stable@vger.kernel.org (4.10+)
>>>>>>=20
>>>>>> I think this patch should be tagged "CC: stable" too.
>>>>>=20
>>>>> I thought the Fix tag is enough, but I'll add the stable=20
>>>>>> However ... that earlier patch looks strange to me.
>>>>>> Why is it that "raid5 cache could write bitmap superblock before bit=
map superblock is
>>>>>> initialized."  Can we just get raid5 cache *not* to write the bitmap
>>>>>> superblock too early?
>>>>>> I think that would better than breaking code that previously worked.
>>>>>=20
>>>>> That's the log reply code, which must update superblock and hence bit=
map
>>>>> superblock, because reply happens very earlier. I agree the reply mig=
ht still
>>>>> have problem with bitmap. We'd better defer reply after the raid is f=
ully
>>>>> initialized. Song, any idea?
>>>>>=20
>>>>=20
>>>> With write back cache, there are two different types of stripes in rec=
overy:
>>>> data-parity, and data-only. For data-parity stripes, we can simply rep=
lay data
>>>> from the journal. But for data-only stripes, we need to do rcw or rmw =
to update
>>>> parities. Currently, the writes are handled with raid5 state machine. =
Therefore,
>>>> we wake up mddev->thread in r5l_recovery_log(). It is necessary to fin=
ish these=20
>>>> stripes before we fully initialize the array, because these stripes ne=
ed to be=20
>>>> handled with write back state machine; while we we always start the ar=
ray with=20
>>>> write through journal_mode.=20
>>>>=20
>>>> Maybe we can fix this by change the order of initialization in md_run(=
),=20
>>>> specifically, moving bitmap_create() before pers->run().=20
>>>=20
>>> I've looked at some of the details here now.
>>>=20
>>> I think I would like raid5-cache to not perform any recovery until we
>>> reach
>>>=20
>>>=20
>>> 	md_wakeup_thread(mddev->thread);
>>> 	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
>>>=20
>>>=20
>>> in do_md_run().  Before that point it is possible to fail and abort -
>>> e.g. if bitmap_load() fails.
>>>=20
>>> Possibly we could insert another personality call here "->start()" ??
>>> That could then do whatever is needed before
>>>=20
>>> 	set_capacity(mddev->gendisk, mddev->array_sectors);
>>> 	revalidate_disk(mddev->gendisk);
>>>=20
>>> makes the array accessible.
>>>=20
>>> Might that be reasonable?
>>=20
>> Looks good. I think we should call the ->start before
>> md_wakeup_thread(mddev->thread); because we don't want to start recovery=
 before
>> log is recovered.
>
> I also like this idea. In the coming month, I won't have much bandwidth t=
o=20
> implement this. Please let me know if you want to make the change. Otherw=
ise,=20
> I will do it later (in December, I guess).=20

It isn't something we should rush so take your time.
However I think we need to clean up the patches that have gone to
=2Dstable.
I think
 Commit: 8031c3ddc70a ("md/bitmap: copy correct data for bitmap super")
should be reverted (in -stable too) and possibly be replaced by a patch
which refuses any attempt to combine a bitmap with a journal.
As Shaohua pointed that, that shouldn't really be needed anyway.
That would address the issue that 8031c3ddc70a was meant to fix.
I can write that patch if necessary.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnlIXcACgkQOeye3VZi
gbmZZA/9GzHC1DqEGJOeb7qGOuS7trn/4RSnav7OUdKfwTvjIFRy/ezvGTxFrnTa
yVAdQ5PKlXoyLYrUFUu9nGjg4+guk2mF070wO0MuRegirutn2v9GN3wcPNfrwzRE
CaAwM4a/i+Mx165Cv1jb5009OUkA9uIbUzq6k9xgjIjIIiG75Kl8kWRPYGUoyID+
GaHvWVN7I/nJ7QYIAeLZ3GAHXg0nejvN/UfMiu1z2tZhD97ExHW04PBqnYhWYr5T
k0d45/LvN/+6+V9DYYv+CIpsz1PEn5HQ0eN57w1829d1KjTApBzOehCIfrPYzAd0
EdRr09z/79cZZBiRvYvQYaWH3arXdXRzHtglpBc1V3yT6ODwipIT+d/mFgwXOJiw
iEpqu8drIqx30vN+jtbZhhOkdpNf+jBhh0At1BRW6p2JK+kb632iKEXR9K9rXs0g
vO9DAEb3WyxiCnHfzHJMbpcxNWXahFlnR9T5/RzRqlhkRIdIBk7CMZh+a57qRcSN
5mP+MWLP70u2idewSlJ1fDA4Zs9ftoS21eYaD1uHs0Ad8CHOAxUt177MXf4kkoD7
AqyxFiAYwCAVcvIzkTD8JvH0SD5OpTD1VIz+SDcOBnk2w567mVLkc4Z5rvRcKYLz
OEqIAW98PGw827w390koii8K+GGgMmg2WYK+oPOA+V4g4Xilcgk=
=ZcSv
-----END PGP SIGNATURE-----
--=-=-=--
