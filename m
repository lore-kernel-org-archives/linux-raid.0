From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH 02/14] md/raid5: simplfy delaying of writes while
 metadata is updated.
Date: Thu, 16 Feb 2017 09:37:57 -0800
Message-ID: <20170216173757.chtxbvpbzxcqjk62@kernel.org>
References: <148721992248.7521.17160361058957519076.stgit@noble>
 <148721994135.7521.12977218167692514945.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <148721994135.7521.12977218167692514945.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

On Thu, Feb 16, 2017 at 03:39:01PM +1100, Neil Brown wrote:
> If a device fails during a write, we must ensure the failure is
> recorded in the metadata before the completion of the write is
> acknowleged.
> 
> Commit c3cce6cda162 ("md/raid5: ensure device failure recorded before
> write request returns.")  added code for this, but it was
> unnecessarily complicated.  We already had similar functionality for
> handling updates to the bad-block-list, thanks to Commit de393cdea66c
> ("md: make it easier to wait for bad blocks to be acknowledged.")
> 
> So revert most of the former commit, and instead avoid collecting
> completed writes if MD_CHANGE_PENDING is set.  raid5d() will then flush
> the metadata and retry the stripe_head.
> 
> We check MD_CHANGE_PENDING *after* analyse_stripe() as it could be set
> asynchronously.  After analyse_stripe(), we have collected stable data
> about the state of devices, which will be used to make decisions.
> 
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  drivers/md/raid5.c |   27 ++++-----------------------
>  drivers/md/raid5.h |    3 ---
>  2 files changed, 4 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 760b726943c9..154593e0afbe 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4492,7 +4492,8 @@ static void handle_stripe(struct stripe_head *sh)
>  	if (test_bit(STRIPE_LOG_TRAPPED, &sh->state))
>  		goto finish;
>  
> -	if (s.handle_bad_blocks) {
> +	if (s.handle_bad_blocks ||
> +	    test_bit(MD_SB_CHANGE_PENDING, &conf->mddev->sb_flags)) {
>  		set_bit(STRIPE_HANDLE, &sh->state);
>  		goto finish;
>  	}

This part is fragile. We don't delay it and post it to handle list again. So
the raid5d/worker could run this stripe infinitely.

Thanks,
Shaohua
