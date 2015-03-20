From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/1] Make bm_blocks to match previous semantic
Date: Sat, 21 Mar 2015 09:37:50 +1100
Message-ID: <20150321093750.1f8c4075@notabene.brown>
References: <1426560030-16152-1-git-send-email-jgq516@gmail.com>
	<20150318095712.1954b958@notabene.brown>
	<550A476D.4060707@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/s1UFl7_GnLJBrdTx3h9vx6V"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <550A476D.4060707@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <GQJiang@suse.com>
Cc: jgq516@gmail.com, rgoldwyn@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/s1UFl7_GnLJBrdTx3h9vx6V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 19 Mar 2015 11:50:05 +0800 Guoqing Jiang <GQJiang@suse.com> wrote:

> Hi Neil,
>=20
> NeilBrown wrote:
> > On Tue, 17 Mar 2015 10:40:30 +0800 jgq516@gmail.com wrote:
> >
> >  =20
> >> From: Guoqing Jiang <gqjiang@suse.com>
> >>
> >> The bm_blocks is modified by commit fe60ce (md/bitmap: use
> >> sector_div for sector_t divisions), but it makes bm_blocks
> >> has different value which is changed from like "a/b" to "a%b",
> >> need to correct this to make sure cluster-md still works.
> >>    =20
> >
> > One of us is confused here.
> >
> > This code is trying to find the start of the bitmap relevant to this ho=
st in
> > a table of multiple bitmaps.  So it first needs to find out the size of=
 each
> > bitmap.  It then multiples the size by the index number of this host to=
 get
> > an offset.
> >
> >  =20
> Thanks for detailed description, it really helps. I quoted related lines
> from bitmap.c.
>=20
>  574                 sector_t bm_blocks;
>  575                 sector_t resync_sectors =3D
> bitmap->mddev->resync_max_sectors;=20
>  576
>  577                 bm_blocks =3D sector_div(resync_sectors,
>  578                                      =20
> bitmap->mddev->bitmap_info.chunksize >> 9);  =20
>  579                 bm_blocks =3D bm_blocks << 3;
>  580                 bm_blocks =3D DIV_ROUND_UP_SECTOR_T(bm_blocks, 4096);
>  581                 bitmap->mddev->bitmap_info.offset +=3D
> bitmap->cluster_slot * (bm_blocks << 3);
>=20
> > So it take the total number of sectors (resync_max_sectors), divides by=
 the
> > chunksize (in sectors) to get a number of chunks.  This is the number o=
f bits.
> >
> >  =20
> L577 is supposed to do above job.
> > Then it should div-round-up by 8 to get a number of bytes.
> >  =20
> I guess what you mean is about L579, while it used "<<3" rather than
> ">>3" now.
> > Then div-round-up by 4096 to get number of 4-K blocks, because the bitm=
aps
> > are always 4K aligned.
> >  =20
> L580 did the job.
> > Then this number is multiplied by 8 (or shifted by 3) to get a number of
> > sectors to add to the start of the table.
> >  =20
> L581 is for this, right? Is the shifted by 3 is to match the bitmap
> format for each
> nodes? Seems the relationship between slot and the bitmap region of the n=
ode
> is like n <-----> [8*nK, 8*(n+1)K]. How about the following changes?
>=20
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 501f83f..b2a241b 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -571,12 +571,10 @@ static int bitmap_read_sb(struct bitmap *bitmap)
>  re_read:
>         /* If cluster_slot is set, the cluster is setup */
>         if (bitmap->cluster_slot >=3D 0) {
> -               sector_t bm_blocks;
> -               sector_t resync_sectors =3D bitmap->mddev->resync_max_sec=
tors;
> +               sector_t bm_blocks =3D bitmap->mddev->resync_max_sectors;
> =20
> -               bm_blocks =3D sector_div(resync_sectors,
> -                                    =20
> bitmap->mddev->bitmap_info.chunksize >> 9);
> -               bm_blocks =3D bm_blocks << 3;
> +               sector_div(bm_blocks,
> bitmap->mddev->bitmap_info.chunksize >> 9);

Yes, of course.  sector_div returns the remainder doesn't it!
I was thinking that it returned the quotient and set the first arg to the
remainder - and wonder why you wanted the remainder :-(

I've updated the patch to do the right thing and credited you.
Thanks.

> +               bm_blocks =3D bm_blocks >> 3;
>                 bm_blocks =3D DIV_ROUND_UP_SECTOR_T(bm_blocks, 4096);
> > So the original code in commit b97e92574c0bf335db1cd2ec491d8ff5cd5d0b49
> > is wrong because it uses sector_div in a way which destroys
> > resync_max_sectors.
> > And is wrong because it multiplies by 8 (<<3) instead of divides by 8 to
> > convert from bits to bytes.
> >
> > commit f9209a323547f054c7439a3bf67c45e64a054bd
> > removes the abuse of sector_div, which is good, but uses a simple "a/b"
> > division, which isn't allowed in the kernel.
> >
> > commit fe60ce80488a2a481ac175c4ff98f90df22e1e46
> > then does the right thing with sector_div, but the "<< 3" is still the =
wrong
> > way around.
> >
> > If you still think your code is correct, please explain in detail why.
> >
> > Goldwyn: if you agree that "<< 3" should be ">> 3" or even
> > DIV_ROUND_UP_SECTOR_T( , 8);
> > please send a patch.  If you don't think so, please explain why.
> >
> >  =20
> But anyway, it is better wait for Goldwyn's back from vacation, :)

I'll leave the other change (<<3 or >>8) until then.

thanks,
NeilBrown


>=20
> Thanks,
> Guoqing


--Sig_/s1UFl7_GnLJBrdTx3h9vx6V
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVQyhPjnsnt1WYoG5AQL8Tw//TqP30ncykp4vsd/PVSbtzOBCk8t5YrCq
Vzj1mXYD5tGJvMOdxWWSc/1IkZmWMlz+ZVGmD4ooRwTkjsKdkoUKk+icJu/RtBPx
kJPm8VQ+InL59vi1N6RIag4whGDFiuHY5tbXZtVP3tDBVs3pmZYfe2hvqC21ZbGC
FafiI0gUHrT4FGx5I9HEXWsCthHKlxQ7YkQ9F7XQXt3I5dxW6ihylNLlcoxw6Yw3
7zHYXP0GEN4bRwTdA9S4zufChS2u8ioLVseiUuQnAJcKgCCF8A1uYErdH2yoBLFx
jx88So7x8wqQhg0PYjRK2yMcLDoclI5qfeBK2QqcFcHu9zC3okfLmHGNLaNj3X+F
SdmLsvjjDjCKkN1aQH+E7KbZfqs+F3O7rGJDaJHGDYTA2ZbYUtYzdl7FuFCzh8wv
Zx9qr9rWswADZpnNgsv6HyonwM7nASsi8sA0VL1E1WfCxKohZAdTJ8vtkfYCJlsV
V4epikhktG6lDuAjsq7RQDw/Y7W8rYkJ5ACBGu1DzVBvLUwExYVT5fjeI/mulEb6
GK8CAShCFhtVXiDsWst4uL9DR7DzHNqCjskXm4+u6F9TjlW8wV5ekhacE4eEd2TY
jnPgP7N4JXFh4N1new0p/EG00oZEb2rspbL2nLW3ZQJNmiXSEVLImL+RaZsOyQeb
Dj9A1WhHzZo=
=oH4p
-----END PGP SIGNATURE-----

--Sig_/s1UFl7_GnLJBrdTx3h9vx6V--
