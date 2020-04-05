From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH] raid5: use memalloc_noio_save()/restore in
 resize_chunks()
Date: Sun, 5 Apr 2020 17:43:33 +0000
Message-ID: <8A145C50-D9E8-4874-A365-576FC4578486@fb.com>
References: <20200402081312.32709-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200402081312.32709-1-colyli@suse.de>
Content-Language: en-US
Content-ID: <EF8B29F5D0E4A941A6A40FF3E1A4B5F3@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, "guoqing.jiang@cloud.ionos.com" <guoqing.jiang@cloud.ionos.com>, Kent Overstreet <kent.overstreet@gmail.com>, Michal Hocko <mhocko@suse.com>
List-Id: linux-raid.ids

Hi Coly,

Thanks for the patch!

> On Apr 2, 2020, at 1:13 AM, Coly Li <colyli@suse.de> wrote:
>=20
> Commit b330e6a49dc3 ("md: convert to kvmalloc") uses kvmalloc_array()
> to allocate memory with GFP_NOIO flag in resize_chunks() via function
> scribble_alloc(),
> 2269	err =3D scribble_alloc(percpu, new_disks,
> 2270			     new_sectors / STRIPE_SECTORS,
> 2271			     GFP_NOIO);
>=20
> The purpose of GFP_NOIO flag to kvmalloc_array() is to allocate
> non-physically continuous pages and avoid extra I/Os of page reclaim
> which triggered by memory allocation. When system memory is under
> heavy pressure, non-physically continuous pages allocation is more
> probably to success than allocating physically continuous pages.
>=20
> But as a non GFP_KERNEL compatible flag, GFP_NOIO is not acceptible
> by kvmalloc_node() and the memory allocation indeed is handled with
> kmalloc_node() to allocate physically continuous pages. This is not
> the expected behavior of the original purpose when mistakenly using
> GFP_NOIO flag.
>=20
> In this patch, the memalloc scope APIs memalloc_noio_save() and
> memalloc_noio_restore() are used when calling scribble_alloc(). Then
> when calling kvmalloc_array() with GFP_KERNEL mask, the scope APIs
> may indicatet the allocating context to avoid memory reclaim related
> I/Os, to avoid recursive I/O deadlock on the md raid array itself
> which is calling scribble_alloc() to allocate non-physically continuous
> pages.
>=20
> This patch also removes gfp_t flags from scribble_alloc() parameters
> list, because the invalid GFP_NOIO is replaced by memalloc scope APIs.
>=20
> Fixes: b330e6a49dc3 ("md: convert to kvmalloc")
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Kent Overstreet <kent.overstreet@gmail.com>
> Cc: Michal Hocko <mhocko@suse.com>
> ---
> drivers/md/raid5.c | 22 ++++++++++++++++------
> 1 file changed, 16 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index ba00e9877f02..6b23f8aba169 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2228,14 +2228,15 @@ static int grow_stripes(struct r5conf *conf, int =
num)
>  * of the P and Q blocks.
>  */

I noticed the comment before scribble_alloc() is outdated. Maybe
fix also that as we are on it?=20

> static int scribble_alloc(struct raid5_percpu *percpu,
> -			  int num, int cnt, gfp_t flags)
> +			  int num, int cnt)
> {
> 	size_t obj_size =3D
> 		sizeof(struct page *) * (num+2) +
> 		sizeof(addr_conv_t) * (num+2);
> 	void *scribble;
> +	unsigned int noio_flag;
I think we don't use noio_flag in scribble_alloc()?=20

Thanks,
Song
