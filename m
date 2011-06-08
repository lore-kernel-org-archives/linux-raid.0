From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] md/bitmap: remove unused fields from struct bitmap
Date: Wed, 8 Jun 2011 12:38:45 +1000
Message-ID: <20110608123845.27c26efc@notabene.brown>
References: <1307458172-19373-1-git-send-email-namhyung@gmail.com>
	<1307458172-19373-2-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1307458172-19373-2-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue,  7 Jun 2011 23:49:32 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> Get rid of ->syncchunk and ->counter_bits since they're never used.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  drivers/md/bitmap.c |    3 ---
>  drivers/md/bitmap.h |    9 ---------
>  2 files changed, 0 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 8b40bd71bb4a..0e3b314917ab 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -1754,9 +1754,6 @@ int bitmap_create(mddev_t *mddev)
>  	bitmap->chunks = chunks;
>  	bitmap->pages = pages;
>  	bitmap->missing_pages = pages;
> -	bitmap->counter_bits = COUNTER_BITS;
> -
> -	bitmap->syncchunk = ~0UL;
>  
>  #ifdef INJECT_FATAL_FAULT_1
>  	bitmap->bp = NULL;
> diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
> index d0aeaf46d932..0a239f5d0ca1 100644
> --- a/drivers/md/bitmap.h
> +++ b/drivers/md/bitmap.h
> @@ -196,19 +196,10 @@ struct bitmap {
>  
>  	mddev_t *mddev; /* the md device that the bitmap is for */
>  
> -	int counter_bits; /* how many bits per block counter */
> -
>  	/* bitmap chunksize -- how much data does each bit represent? */
>  	unsigned long chunkshift; /* chunksize = 2^chunkshift (for bitops) */
>  	unsigned long chunks; /* total number of data chunks for the array */
>  
> -	/* We hold a count on the chunk currently being synced, and drop
> -	 * it when the last block is started.  If the resync is aborted
> -	 * midway, we need to be able to drop that count, so we remember
> -	 * the counted chunk..
> -	 */
> -	unsigned long syncchunk;
> -
>  	__u64	events_cleared;
>  	int need_sync;
>  


Always happy to see code disappear!  Thanks.

I took the opportunity to also remove COUNTER_BYTE_RATIO in the same patch.

Thanks,
NeilBrown
