From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/9] FIX: Load container content for container reshape
 continuation
Date: Thu, 10 Mar 2011 11:27:28 +1100
Message-ID: <20110310112728.16890045@notabene.brown>
References: <20110309134019.8939.15438.stgit@gklab-128-013.igk.intel.com>
	<20110309134537.8939.29039.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110309134537.8939.29039.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Wed, 09 Mar 2011 14:45:37 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> st->sb is null. This is exception cause.
> reshape_container() function expects that super block will be loaded.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  Grow.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index 40cb929..e37fc57 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -3370,10 +3370,18 @@ int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
>  		fmt_devname(buf, st->container_dev);
>  		container = buf;
>  		freeze(st);
> -		if (info->reshape_active == 2)
> -			return reshape_container(container, NULL,
> +
> +		if (info->reshape_active == 2) {
> +			int cfd = open_dev(st->container_dev);
> +			if (cfd >= 0) {
> +				st->ss->load_container(st, cfd, container);
> +				close(cfd);
> +				return reshape_container(container, NULL,
>  						 st, info, 0, backup_file,
>  						 0, 1);
> +			}
> +			return 1;
> +		}
>  	}
>  	return reshape_array(container, mdfd, "array", st, info, 1,
>  			     backup_file, 0, 0, 1);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Applied, thanks.

NeilBrown

