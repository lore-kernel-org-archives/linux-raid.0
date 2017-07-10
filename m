From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v3 05/14] md: raid1: don't use bio's vec table to manage resync pages
Date: Mon, 10 Jul 2017 14:38:19 +1000
Message-ID: <87h8yk6h50.fsf@notabene.neil.brown.name>
References: <20170316161235.27110-1-tom.leiming@gmail.com> <20170316161235.27110-6-tom.leiming@gmail.com> <87mv8d5ht7.fsf@notabene.neil.brown.name> <CACVXFVP69kLQyr0NOY7zXMZ_bdJYCV7fBbDrKdFF9fBPBTsU-g@mail.gmail.com> <20170710041304.GB15321@ming.t460p>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170710041304.GB15321@ming.t460p>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Ming Lei <tom.leiming@gmail.com>
Cc: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 10 2017, Ming Lei wrote:

> On Mon, Jul 10, 2017 at 11:35:12AM +0800, Ming Lei wrote:
>> On Mon, Jul 10, 2017 at 7:09 AM, NeilBrown <neilb@suse.com> wrote:
...
>> >> +
>> >> +             rp->idx =3D 0;
>> >
>> > This is the only place the ->idx is initialized, in r1buf_pool_alloc().
>> > The mempool alloc function is suppose to allocate memory, not initiali=
ze
>> > it.
>> >
>> > If the mempool_alloc() call cannot allocate memory it will use memory
>> > from the pool.  If this memory has already been used, then it will no
>> > longer have the initialized value.
>> >
>> > In short: you need to initialise memory *after* calling
>> > mempool_alloc(), unless you ensure it is reset to the init values befo=
re
>> > calling mempool_free().
>> >
>> > https://bugzilla.kernel.org/show_bug.cgi?id=3D196307
>>=20
>> OK, thanks for posting it out.
>>=20
>> Another fix might be to reinitialize the variable(rp->idx =3D 0) in
>> r1buf_pool_free().
>> Or just set it as zero every time when it is used.
>>=20
>> But I don't understand why mempool_free() calls pool->free() at the end =
of
>> this function, which may cause to run pool->free() on a new allocated bu=
f,
>> seems a bug in mempool?
>
> Looks I missed the 'return' in mempool_free(), so it is fine.
>
> How about the following fix?

It looks like it would probably work, but it is rather unusual to
initialise something just before freeing it.

Couldn't you just move the initialization to shortly after the
mempool_alloc() call.  There looks like a good place that already loops
over all the bios....

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlljBLwACgkQOeye3VZi
gbnEzA//UM5mXEpH2HPSm1HUA9slvhE3TSQauU8woWR9pwzyMe5nsFFyAEuPzPEy
pYc2Lg5xnWzAotY1HQk5MUFOl7WqyUnU4XOWIZOTSRuFSwzBhkD4+N4G3loDmOA8
pUaSPIScGuHr+F2+ZyJkyOLJ2VKqV9AiioGBeNcUpqohiRGg2d3yLmm8wxWC5CKk
udcfPwVP1VEzJ4m65IYRf8B8nH+oAoloF5J2OYubM7m1LIYBhbyBUT2/xvKtTo6s
LvWhWtjwV8kMpVtEk8JJHANnKmzZW0/SEBnRPVmL9o9AEptzBEdTZZpeu4BfA949
7necsyk3wfC5MCk2Rsh0iEApSjdibSVIEF0cBV9Egt79SMcz1pYXD3grWNhRpltY
/ZyroXB6Qu/TQ/C2nCk8aaCNorrivrWa63C5VluXAuNuM9TJxyoPTQ2hNwLeIe5D
WAHFNVue5YqIcyr0SkFZKF6Domv9ndwjx+9DwJnw0jQ1eCALCiotj4Adp1ei+Ru2
kcDgWwPFst27WihyFRJDo92MPsAlkjEBmSWyALCkCmcuYbnu+oBo57SKRDPcIyFp
o1yJzRZ7prX8QDXFB60ivSVa+/lJuwbgDcZ/XxUg4sVdpatMtD/5uZ0voimXXhnC
SKPShFORTcTaqwoowG36PQ2l4a/f6rGNOkAWwPBAhajrUCqz7zU=
=VPGb
-----END PGP SIGNATURE-----
--=-=-=--
