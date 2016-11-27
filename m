From: Coly Li <i@coly.li>
Subject: Re: [PATCH] Avoid nested function definition
Date: Sun, 27 Nov 2016 12:06:04 +0800
Message-ID: <9a8a84ed-ecf7-b1dd-59e8-1a36dbcef088@coly.li>
References: <20161126222415.13404-1-pefoley2@pefoley.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20161126222415.13404-1-pefoley2@pefoley.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Peter Foley <pefoley2@pefoley.com>, shli@kernel.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kent.overstreet@gmail.com
List-Id: linux-raid.ids

On 2016/11/27 上午6:24, Peter Foley wrote:
> Fixes below error with clang:
> ../drivers/md/bcache/sysfs.c:759:3: error: function definition is not allowed here
>                 {       return *((uint16_t *) r) - *((uint16_t *) l); }
>                 ^
> ../drivers/md/bcache/sysfs.c:789:32: error: use of undeclared identifier 'cmp'
>                 sort(p, n, sizeof(uint16_t), cmp, NULL);
>                                              ^
> 2 errors generated.
> 
> Signed-off-by: Peter Foley <pefoley2@pefoley.com>
> ---
>  drivers/md/bcache/sysfs.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index b3ff57d61dde..22ac9e6676a0 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -731,6 +731,11 @@ static struct attribute *bch_cache_set_internal_files[] = {
>  };
>  KTYPE(bch_cache_set_internal);
>  
> +static int cmp(const void *l, const void *r)
> +{
> +	return *((uint16_t *)r) - *((uint16_t *)l);
> +}
> +
>  SHOW(__bch_cache)
>  {
>  	struct cache *ca = container_of(kobj, struct cache, kobj);
> @@ -755,9 +760,6 @@ SHOW(__bch_cache)
>  					       CACHE_REPLACEMENT(&ca->sb));
>  
>  	if (attr == &sysfs_priority_stats) {
> -		int cmp(const void *l, const void *r)
> -		{	return *((uint16_t *) r) - *((uint16_t *) l); }
> -
>  		struct bucket *b;
>  		size_t n = ca->sb.nbuckets, i;
>  		size_t unused = 0, available = 0, dirty = 0, meta = 0;
> 

 I agree with this fix. Anyway, Can we use a more unique name like
__bch_cache_cmp() ?

Thanks.

-- 
Coly Li
