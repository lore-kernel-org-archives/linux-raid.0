From: Coly Li <i@coly.li>
Subject: Re: [RESEND PATCH 1/3] bcache: Remove redundant parameter for
 cache_alloc()
Date: Wed, 29 Jun 2016 18:20:27 +0800
Message-ID: <bb659bb1-b2ff-6b47-c47e-1b89fe9395b5@coly.li>
References: <1466561446-30443-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1466561446-30443-1-git-send-email-wangyijing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yijing Wang <wangyijing@huawei.com>, axboe@fb.com, Kent Overstreet <kent.overstreet@gmail.com>
Cc: Eric Wheeler <git@linux.ewheeler.net>, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

=D4=DA 16/6/22 =C9=CF=CE=E710:10, Yijing Wang =D0=B4=B5=C0:
> Cache_sb is not used in cache_alloc, and we have copied
> sb info to cache->sb already, remove it.
>=20
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  drivers/md/bcache/super.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index f5dbb4e..aecaace 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1803,7 +1803,7 @@ void bch_cache_release(struct kobject *kobj)
>  	module_put(THIS_MODULE);
>  }
> =20
> -static int cache_alloc(struct cache_sb *sb, struct cache *ca)
> +static int cache_alloc(struct cache *ca)
>  {
>  	size_t free;
>  	struct bucket *b;
> @@ -1858,7 +1858,7 @@ static int register_cache(struct cache_sb *sb, =
struct page *sb_page,
>  	if (blk_queue_discard(bdev_get_queue(ca->bdev)))
>  		ca->discard =3D CACHE_DISCARD(&ca->sb);
> =20
> -	ret =3D cache_alloc(sb, ca);
> +	ret =3D cache_alloc(ca);

I am not sure whether struct cache_b *sb will be used in future, I
suggest to let it be for now.



>  	if (ret !=3D 0)
>  		goto err;
> =20
>=20


--=20
Coly Li
