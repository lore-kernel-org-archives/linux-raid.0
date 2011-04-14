From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] FIX: Use successfully loaded metadata only
Date: Thu, 14 Apr 2011 17:50:34 +1000
Message-ID: <20110414175034.5a7b16e8@notabene.brown>
References: <20110412125116.7062.36275.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110412125116.7062.36275.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Tue, 12 Apr 2011 14:51:16 +0200 Adam Kwolek <adam.kwolek@intel.com> wrote:

> Values greater than 0, means error. We exit from loop on error
> with empty super-block pointer when sd pointer is valid.
> This cannot be detected by check condition as error.
> For sure we shouldn't go forward with error condition.
> It leads to throwing exception with core file when metadata handler
> wants to access non existing super-block.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>

Applied, thanks.

NeilBrown


> ---
> 
>  Grow.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index a954cfd..768278f 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -2933,7 +2933,7 @@ int child_monitor(int afd, struct mdinfo *sra, struct reshape *reshape,
>  			continue;
>  		ok = st->ss->load_super(st, devfd, NULL);
>  		close(devfd);
> -		if (ok >= 0)
> +		if (ok == 0)
>  			break;
>  	}
>  	if (!sd) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

