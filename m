From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/4] imsm: FIX: add raid5 to raid0 case to
 analyse_change()
Date: Mon, 14 Feb 2011 09:26:42 +1100
Message-ID: <20110214092642.555377e7@notabene.brown>
References: <20110209134737.4559.34527.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110209134737.4559.34527.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Wed, 09 Feb 2011 14:47:37 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> Transition raid0 to raid5 is not possible
> due to wrong condition in imsm_analyze_change().
> Current condition blocks migration possibility instead allow for it.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>

Thanks.  All 4 in this series applied.

NeilBrown


> ---
> 
>  super-intel.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index 6a21b26..2875ade 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -6934,7 +6934,7 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
>  			}
>  			break;
>  		case 5:
> -			if (geo->level != 0)
> +			if (geo->level == 0)
>  				change = CH_LEVEL_MIGRATION;
>  			break;
>  		case 10:

