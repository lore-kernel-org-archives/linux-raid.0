From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH md 002 of 14] Allow raid1 to check consistency
Date: Thu, 1 Dec 2005 14:34:14 -0800
Message-ID: <20051201143414.50ae2750.akpm@osdl.org>
References: <20051201141508.29384.patches@notabene>
	<1051201032256.29567@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1051201032256.29567@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> wrote:
>
> +	if (test_bit(MD_RECOVERY_REQUESTED, &pi->mddev->recovery))
>  +		j = pi->raid_disks;
>  +	else
>  +		j = 1;
>  +	while(j--) {
>  +		bio = r1_bio->bios[j];
>  +		for (i = 0; i < RESYNC_PAGES; i++) {
>  +			page = alloc_page(gfp_flags);
>  +			if (unlikely(!page))
>  +				goto out_free_pages;
>  +
>  +			bio->bi_io_vec[i].bv_page = page;
>  +		}
>  +	}
>  +	/* If not user-requests, copy the page pointers to all bios */
>  +	if (!test_bit(MD_RECOVERY_REQUESTED, &pi->mddev->recovery)) {
>  +		for (i=0; i<RESYNC_PAGES ; i++)
>  +			for (j=1; j<pi->raid_disks; j++)
>  +				r1_bio->bios[j]->bi_io_vec[i].bv_page =
>  +					r1_bio->bios[0]->bi_io_vec[i].bv_page;
>   	}
>   
>   	r1_bio->master_bio = NULL;
>  @@ -122,8 +137,10 @@ static void * r1buf_pool_alloc(gfp_t gfp
>   	return r1_bio;
>   
>   out_free_pages:
>  -	for ( ; i > 0 ; i--)
>  -		__free_page(bio->bi_io_vec[i-1].bv_page);
>  +	for (i=0; i < RESYNC_PAGES ; i++)
>  +		for (j=0 ; j < pi->raid_disks; j++)
>  +			__free_page(r1_bio->bios[j]->bi_io_vec[i].bv_page);
>  +	j = -1;
>   out_free_bio:

Are you sure the error handling here is correct?

a) we loop up to RESYNC_PAGES, but the allocation loop may not have got
   that far

b) we loop in the ascending-index direction, but the allocating loop
   loops in the descending-index direction.

c) we loop up to pi->raid_disks, but the allocating loop may have
   done `j = 1;'.

d) there was a d), but I forgot what it was.
