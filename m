From: Coly Li <i@coly.li>
Subject: Re: [PATCH v2] Avoid nested function definition
Date: Mon, 28 Nov 2016 11:06:53 +0800
Message-ID: <4e5b3f6f-695b-5bfe-3f62-c50fe9e984c3@coly.li>
References: <20161128025004.18782-1-pefoley2@pefoley.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20161128025004.18782-1-pefoley2@pefoley.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Peter Foley <pefoley2@pefoley.com>, linux-kernel@vger.kernel.org, shli@kernel.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, kent.overstreet@gmail.com
List-Id: linux-raid.ids

On 2016/11/28 上午10:50, Peter Foley wrote:
> Fixes below error with clang:
> ../drivers/md/bcache/sysfs.c:759:3: error: function definition is not allowed here
>                 {       return *((uint16_t *) r) - *((uint16_t *) l); }
>                 ^
> ../drivers/md/bcache/sysfs.c:789:32: error: use of undeclared identifier 'cmp'
>                 sort(p, n, sizeof(uint16_t), cmp, NULL);
>                                              ^
> 2 errors generated.
> 
> v2:
> rename function to __bch_cache_cmp
> 
> Signed-off-by: Peter Foley <pefoley2@pefoley.com>
> ---
>  drivers/md/bcache/sysfs.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index b3ff57d61dde..8f12089a69e7 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -731,6 +731,11 @@ static struct attribute *bch_cache_set_internal_files[] = {
>  };
>  KTYPE(bch_cache_set_internal);
>  
> +static int __bch_cache_cmp(const void *l, const void *r)
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
> @@ -786,7 +788,7 @@ SHOW(__bch_cache)
>  			p[i] = ca->buckets[i].prio;
>  		mutex_unlock(&ca->set->bucket_lock);
>  
> -		sort(p, n, sizeof(uint16_t), cmp, NULL);
> +		sort(p, n, sizeof(uint16_t), __bch_cache_cmp, NULL);
>  
>  		while (n &&
>  		       !cached[n - 1])
> 

Acked-by: Coly Li <colyli@suse.de>

-- 
Coly Li
