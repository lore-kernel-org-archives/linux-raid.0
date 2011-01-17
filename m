From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 6/6] FIX: sync_completed == 0 causes reshape
 cancellation in metadata
Date: Mon, 17 Jan 2011 12:38:48 +1100
Message-ID: <20110117123848.42fd416b@notabene.brown>
References: <20110113144252.12728.82642.stgit@gklab-128-013.igk.intel.com>
	<20110113145050.12728.43280.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110113145050.12728.43280.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Thu, 13 Jan 2011 15:50:50 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> md signals reshape completion (whole area or parts) by setting sync_completed to 0.
> This causes in set_array_state() to rollback metadata changes (super-intel.c:4977.
> To avoid this do not allow for set last_checkpoint to 0 if reshape is finished.
> 
> This was also root cause of my previous fix for finalization reshape that I agreed earlier is not necessary,
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  monitor.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/monitor.c b/monitor.c
> index 1107d47..b7287d8 100644
> --- a/monitor.c
> +++ b/monitor.c
> @@ -363,8 +363,10 @@ static int read_and_act(struct active_array *a)
>  		/* Reshape has progressed or completed so we need to
>  		 * update the array state - and possibly the array size
>  		 */
> -		a->last_checkpoint = sync_completed;
> +		if (sync_completed != 0)
> +			a->last_checkpoint = sync_completed;
>  		a->container->ss->set_array_state(a, a->curr_state <= clean);
> +		a->last_checkpoint = sync_completed;
>  	}
>  
>  	if (sync_completed > a->last_checkpoint)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Applied, thanks.!!!

NeilBrown

