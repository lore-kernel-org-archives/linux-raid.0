From: Karl Newman <siliconfiend@gmail.com>
Subject: Re: [BISECT] Kernel panic, RIP bitmap_create
Date: Thu, 3 May 2012 23:37:38 -0700
Message-ID: <CAOOwNtKko_db_wtqYOiGScq0ZOMbMK1L9DhDnm1geWhsQmLWNQ@mail.gmail.com>
References: <CAOOwNtJhFa67EFTs5AdgSHzFseBr9xJGTsaEOyYnaYYNCeUMAQ@mail.gmail.com>
	<CAOOwNt+wjMU9+Dzrr3+d3dwML2_Q_CgT4X5OgiKvPA_bBoTYcg@mail.gmail.com>
	<20120503155850.2900067d@notabene.brown>
	<CAOOwNtK0xKg9E=gS46GR8uDVvjPqqL7+FbufY2d7iuW7yZgVwQ@mail.gmail.com>
	<20120503165030.7e45c25b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120503165030.7e45c25b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 2, 2012 at 11:50 PM, NeilBrown <neilb@suse.de> wrote:
>
> I've managed to find a bug, but it is fairly minor and I cannot see h=
ow
> it would cause a crash.
>
> The calculation of bitmap->chunks is wrong and will usually be 1 too =
small.
>
> Does it make a difference for you? =A0I tend to doubt it.
>
> Thanks,
> NeilBrown
>
>
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 97e73e5..17e2b47 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -1727,8 +1727,7 @@ int bitmap_create(struct mddev *mddev)
> =A0 =A0 =A0 =A0bitmap->chunkshift =3D (ffz(~mddev->bitmap_info.chunks=
ize)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0- BITMAP_B=
LOCK_SHIFT);
>
> - =A0 =A0 =A0 /* now that chunksize and chunkshift are set, we can us=
e these macros */
> - =A0 =A0 =A0 chunks =3D (blocks + bitmap->chunkshift - 1) >>
> + =A0 =A0 =A0 chunks =3D (blocks + (1 << bitmap->chunkshift) - 1) >>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bitmap->chunkshift;
> =A0 =A0 =A0 =A0pages =3D (chunks + PAGE_COUNTER_RATIO - 1) / PAGE_COU=
NTER_RATIO;
>
> diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
> index 55ca5ae..b44b0aba 100644
> --- a/drivers/md/bitmap.h
> +++ b/drivers/md/bitmap.h
> @@ -101,9 +101,6 @@ typedef __u16 bitmap_counter_t;
>
> =A0#define BITMAP_BLOCK_SHIFT 9
>
> -/* how many blocks per chunk? (this is variable) */
> -#define CHUNK_BLOCK_RATIO(bitmap) ((bitmap)->mddev->bitmap_info.chun=
ksize >> BITMAP_BLOCK_SHIFT)
> -
> =A0#endif
>
> =A0/*

Somehow gmail marked this email as read, too, so I missed it. Anyway,
that did it! With this patch applied I can successfully boot! I tested
the offending commit by itself first with the all-zeros uuid patch
applied and confirmed the bug was still present, then applied this
patch and the bug was gone. I also applied this patch to 3.4-rc5 and
confirmed that it was still good.

Thank you for your help on this issue, and thank you for your work as
a kernel developer and supporting this crucial component.

Sincerely,

Karl Newman
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
