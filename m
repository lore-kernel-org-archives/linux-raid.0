From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md/bitmap: avoid read out of the disk
Date: Fri, 13 Oct 2017 08:44:17 +1100
Message-ID: <87tvz4m47i.fsf@notabene.neil.brown.name>
References: <a9a406f5f751d39620d5e4907992ccb1bdbfb5a7.1507670143.git.shli@fb.com> <87bmldnjtq.fsf@notabene.neil.brown.name> <20171012173019.c2bbfyz3hgudjbhz@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171012173019.c2bbfyz3hgudjbhz@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, kumba@gentoo.org, Shaohua Li <shli@fb.com>, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 12 2017, Shaohua Li wrote:

> On Thu, Oct 12, 2017 at 02:09:21PM +1100, Neil Brown wrote:
>> On Tue, Oct 10 2017, Shaohua Li wrote:
>>=20
>> > From: Shaohua Li <shli@fb.com>
>> >
>> > If PAGE_SIZE is bigger than 4k, we could read out of the disk boundary=
. Limit
>> > the read size to the end of disk. Write path already has similar limit=
ation.
>> >
>> > Fix: 8031c3ddc70a(md/bitmap: copy correct data for bitmap super)
>> > Reported-by: Joshua Kinard <kumba@gentoo.org>
>> > Tested-by: Joshua Kinard <kumba@gentoo.org>
>> > Cc: Song Liu <songliubraving@fb.com>
>> > Signed-off-by: Shaohua Li <shli@fb.com>
>>=20
>> Given that this bug was introduced by
>> Commit: 8031c3ddc70a ("md/bitmap: copy correct data for bitmap super")
>>=20
>> and that patch is markted:
>>=20
>>     Cc: stable@vger.kernel.org (4.10+)
>>=20
>> I think this patch should be tagged "CC: stable" too.
>
> I thought the Fix tag is enough, but I'll add the stable=20

My experience is that Fixes: sometimes causes patched to go to stable,
but not always.  Cc: stable *always* causes the stable team to look at
the patch.
I prefer to keep each having a well defined meaning.  Fixes is
documentation about a relationship between commits, Cc:stable is a
statement about the importance of a patch.

Thanks,
Neilbrown


>> However ... that earlier patch looks strange to me.
>> Why is it that "raid5 cache could write bitmap superblock before bitmap =
superblock is
>> initialized."  Can we just get raid5 cache *not* to write the bitmap
>> superblock too early?
>> I think that would better than breaking code that previously worked.
>
> That's the log reply code, which must update superblock and hence bitmap
> superblock, because reply happens very earlier. I agree the reply might s=
till
> have problem with bitmap. We'd better defer reply after the raid is fully
> initialized. Song, any idea?
>
> Thanks,
> Shaohua=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnf4jIACgkQOeye3VZi
gblU2g//Q+ixcWPGzWVxc+92tc42FP136u7p7oaDYQ1+GAxN7Zh4bYr5PWymQxk9
D8BDNXmETlZB2qfVLPebTvT+fB1Na2AWLF8CE3GRU5nBuwgEU6zbKxIK1rJBAwoe
5sjuJwQEDbUBl1QyFj2n805aPbaDYh5iI4bhIX9n1noqw+MsieE1lXQbgw4akqC6
elmcXwrGRsOZ9I0TYjxpvrH0VCpWllWcRr1Ls+vcxV/JHRYYmqWyzbk44pAA9GBd
XuKKDuLrlXL32hE0YVXgST/hjw06KfUOUzsWpDxP0Fy0+GP8JRdFyuyQppL6VSGG
jIRJ0KLfIV+R5tkGg7mGz8IyCFrvdBPAP0c72+P1jC1bHt82WMS6jnCkmoTWFlmb
ocaIALt1Z+9vDWCFf38vH5NDawbN4KDeOHPwBUrIPUcEdrs/Jsl8zC5lWORkdgzJ
ifN3+EPE8yVu49Xcn5inTx6M9/6x+3i8OQjtTAP8vjnfFby+cFKNaSrzTkhbCgz9
4tSuOac4TbxbvyEqF+oW0UUpmiM7FhSrGjjoME9JjEHIiVauegvZuNTprdBylmPl
U8zrfDMlg59porLZQSqUfMdq4fknTSQU9hRcIYsoFwde6DTzXhv9xEozQo8jw73m
akOzf0IN1Ha2cbjv67HGmz7omFJI6U8vrT1ShHvkmmXK8r8QTuM=
=fkg9
-----END PGP SIGNATURE-----
--=-=-=--
