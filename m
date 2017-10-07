From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: Remove nested function from sysfs
Date: Sat, 7 Oct 2017 10:33:22 +0800
Message-ID: <4b33315c-f0c8-cb72-a6e4-dc3a58d9aa23@coly.li>
References: <20171006213500.88230-1-mka@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20171006213500.88230-1-mka@chromium.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
To: Matthias Kaehlcke <mka@chromium.org>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, q^Center Roeck <groeck@chromium.org>, Behan Webster <behanw@converseincode.com>
List-Id: linux-raid.ids

On 2017/10/7 上午5:35, Matthias Kaehlcke wrote:
> From: Behan Webster <behanw@converseincode.com>
> 
> Replace the use of nested functions where a normal function will
> suffice.
> 
> Nested functions are not liked by upstream kernel developers in
> general. Their use breaks the use of clang as a compiler, and
> doesn't make the code any better.
> 
> This code now works for both gcc and clang.
> 
> From: Behan Webster <behanw@converseincode.com>
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Reviewed-by: Mark Charlebois <charlebm@gmail.com>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>

Hi Behan,

This patch was posted by Peter Foley in Nov 2016, I test it, and add it
to for-next directory. It should be in 4.15.

Thanks.

Coly

> ---
>  drivers/md/bcache/sysfs.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index 104c57cd666c..440c3906f852 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -745,6 +745,11 @@ static struct attribute *bch_cache_set_internal_files[] = {
>  };
>  KTYPE(bch_cache_set_internal);
>  
> +static int __bch_cache_cmp(const void *l, const void *r)
> +{
> +	return *((uint16_t *) r) - *((uint16_t *) l);
> +}
> +
>  SHOW(__bch_cache)
>  {
>  	struct cache *ca = container_of(kobj, struct cache, kobj);
> @@ -769,9 +774,6 @@ SHOW(__bch_cache)
>  					       CACHE_REPLACEMENT(&ca->sb));
>  
>  	if (attr == &sysfs_priority_stats) {
> -		int cmp(const void *l, const void *r)
> -		{	return *((uint16_t *) r) - *((uint16_t *) l); }
> -
>  		struct bucket *b;
>  		size_t n = ca->sb.nbuckets, i;
>  		size_t unused = 0, available = 0, dirty = 0, meta = 0;
> @@ -800,7 +802,7 @@ SHOW(__bch_cache)
>  			p[i] = ca->buckets[i].prio;
>  		mutex_unlock(&ca->set->bucket_lock);
>  
> -		sort(p, n, sizeof(uint16_t), cmp, NULL);
> +		sort(p, n, sizeof(uint16_t), __bch_cache_cmp, NULL);
>  
>  		while (n &&
>  		       !cached[n - 1])
> 
