From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH] mdadm: handle super == NULL case in avail_size1
Date: Thu, 31 Aug 2017 23:46:19 +0000
Message-ID: <C170566B-A2B7-4220-9C61-D08DDE5E7E4A@fb.com>
References: <20170831173751.2910909-1-songliubraving@fb.com>
 <87ziafe2dk.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ziafe2dk.fsf@notabene.neil.brown.name>
Content-Language: en-US
Content-ID: <26D520AFBACBD645824CEDDBC6EE0C41@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, Kernel Team <Kernel-team@fb.com>, Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@infradead.org>, "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>
List-Id: linux-raid.ids


> On Aug 31, 2017, at 4:36 PM, NeilBrown <neilb@suse.com> wrote:
>=20
> On Thu, Aug 31 2017, Song Liu wrote:
>=20
>> Summary:
>>=20
>> Handling super =3D=3D NULL case in avail_size1() was removed a while
>> back. However, it is still useful in the following stack:
>>=20
>> avail_size1() with st->sb =3D=3D NULL
>> array_try_spare() with st =3D=3D NULL
>> try_spare() with st =3D=3D NULL
>> Incremental() with st =3D=3D NULL
>=20
> I assume you mean "st->sb =3D=3D NULL" in each case here?  What you have
> written doesn't make sense.
>=20

I did mean st =3D=3D NULL. In array_try_spare(), if st is NULL, st2 is=20
allocated with match_metadata_desc(), and avail_size() is called with
st2.=20

>>=20
>> This patch adds the handling of super =3D=3D NULL back to avail_size1().
>=20
> I doubt this is the best thing to do.
> If we don't have st->sb, calling avail_size doesn't make any sense.
> Maybe we should be calling validate_geometry.
>=20

This was the same logic that got removed a few years ago. So far it=20
works for my use cases. And I think it makes (some) sense.=20
Is validate_geometry() really better than this approach?

Thanks,
Song
