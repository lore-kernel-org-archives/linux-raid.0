From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md/bitmap: avoid read out of the disk
Date: Fri, 13 Oct 2017 08:46:35 +1100
Message-ID: <87r2u8m43o.fsf@notabene.neil.brown.name>
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

I was thinking exactly this as I was looking at the code.  ->run can
start recovery happening, and having that happen before the bitmap is
ready is wrong.
Maybe there is enough locking that things won't happen in the wrong
order, but it does look a bit odd.
Thanks for the explanation about the interaction between the journal and
the bitmaps.  I'll dig into the code and see what I find.  Then maybe we
can compare notes.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnf4rsACgkQOeye3VZi
gblB8RAAo6dB50fDqAzhQImC8uMUqW78FuP3lbUxQGm+l6PlhNwAbnF3zW2wM69x
wK22kXW6uRfViYodrArA/F4xK5SLviClsiASJs4WDunIBgb6xSA0r8MihJdI1TGr
vyu6loZVfvqmsLi9BCa0aN3mspdlM/99AXJ+PfzU47Z04xbdn+yZgAmQQ6fOkBnQ
wO5Zf9q7PvXwVAPtSydEJrEHE6IN0m7/r5x73mfihHrCeVc2isiByJlszkr5ZEWN
Qfbre9FwV3GT+Tv1X9m7Jd4pIA1jnspbIKgvE6R1YUWzULBdQdDjuOLvQbrwyXeb
ic2EEaeYwHwZV+Iaf2KIdRsHG2poORDYPOloiI/IKcyxlOvi22GQrS4qvqTtyd+3
OMvf895UdcKMcVXaw2cHtOFmaGlJiI7fZw8AwbL82GrWd4bJSQr1tqOyoUHnQK0w
q8aDded3a/pKoWOGEuclYsVaFi/D+pwfqaxUesHEdy+S5B9uA9riEa/HqE4GRzqg
INyDlQ67Gj679mAgYX9Vvhh7Tn1z1PV+TeoR/O/sSTTWEWt/WqAkrBLg+B7LrI0E
+wPOc20MUnc1jjJqg9aZRTVG9zkRbMcyvmlX0Rt87V41SbtEw+xy/6+o5ZiRLnTs
fPUGDIO9CcyS3fiznumAOQaOXmagSiJMyeh5W/CKc/+UJpmBPAQ=
=IZ5s
-----END PGP SIGNATURE-----
--=-=-=--
