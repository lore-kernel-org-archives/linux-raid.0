From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] imsm: Update metadata for second array
Date: Mon, 31 Jan 2011 20:19:16 +1100
Message-ID: <20110131201916.43ff49d5@notabene.brown>
References: <20110131085922.7551.47081.stgit@gklab-128-013.igk.intel.com>
	<20110131085930.7551.86542.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110131085930.7551.86542.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Mon, 31 Jan 2011 09:59:30 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> When second array reshape is about to start external metadata should be updated
> by mdmon in imsm_set_array_state().
> For this purposes imsm_progress_container_reshape() is reused.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  super-intel.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index 8484df6..0ab4355 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5249,13 +5249,17 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
>  		super->updates_pending++;
>  	}
>  
> -	/* finalize online capacity expansion/reshape */
> +	/* manage online capacity expansion/reshape */
>  	if ((a->curr_action != reshape) &&
>  	    (a->prev_action == reshape)) {
>  		struct mdinfo *mdi;
>  
> +		/* finalize online capacity expansion/reshape */
>  		for (mdi = a->info.devs; mdi; mdi = mdi->next)
>  			imsm_set_disk(a, mdi->disk.raid_disk, mdi->curr_state);
> +
> +		/* check next volume reshape */
> +		imsm_progress_container_reshape(super);
>  	}
>  
>  	return consistent;

You still haven't explained why you need this extra call to
imsm_progress_container_reshape.
Does the other call never get reached?  or does it do the wrong thing?  or is
it called too early? or too late or .....

NeilBrown
