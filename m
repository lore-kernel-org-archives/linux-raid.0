From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/6] Unfreeze for non re-striping transitions
Date: Mon, 17 Jan 2011 13:04:08 +1100
Message-ID: <20110117130408.4bb4f6c3@notabene.brown>
References: <20110113152722.20266.24174.stgit@gklab-128-111.igk.intel.com>
	<20110113153244.20266.59989.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110113153244.20266.59989.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Thu, 13 Jan 2011 16:32:44 +0100 Krzysztof Wojcik
<krzysztof.wojcik@intel.com> wrote:

> For non re-striping transitions array must be unfrozen
> before end of processing.
> 
> Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> ---
>  Grow.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index 47a8fb8..c0f9419 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1751,7 +1751,7 @@ static int reshape_array(char *container, int cfd, int fd, char *devname,
>  				printf("chunk size for %s set to %d\n",
>  				       devname, info->array.chunk_size);
>  		}
> -
> +		unfreeze(st);
>  		return rv;
>  	}
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


I already had an unfreeze in there, condition on 'forked', how I think yours
is more correct - I don't want the condition there.

Applied thanks,

NeilBrown
