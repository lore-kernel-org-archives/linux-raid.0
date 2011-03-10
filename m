From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/9] FIX: Block reshaped array monitoring
Date: Thu, 10 Mar 2011 11:28:06 +1100
Message-ID: <20110310112806.58dd84bb@notabene.brown>
References: <20110309134019.8939.15438.stgit@gklab-128-013.igk.intel.com>
	<20110309134545.8939.53720.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110309134545.8939.53720.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Wed, 09 Mar 2011 14:45:45 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> When array under reshape is is assembled it has be disabled from monitoring
> as soon as possible. It can accrue that this is i.e second array in container
> and mdmon is loaded already.
> Lack of blocking monitoring can cause change array state to active,
> and reshape continuation will be not possible.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  Assemble.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/Assemble.c b/Assemble.c
> index 20c27eb..fe917b2 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1519,6 +1519,9 @@ int assemble_container_content(struct supertype *st, int mdfd,
>  		if (sysfs_set_array(content, md_get_version(mdfd)) != 0)
>  			return 1;
>  
> +	if (content->reshape_active)
> +		block_subarray(content);
> +
>  	if (sra)
>  		sysfs_free(sra);
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Applied, thanks.


I think I need to review all the 'blocking' and see if it can be tidied up,
but this is OK for now.

NeilBrown

