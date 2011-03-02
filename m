From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/7] FIX: reshape in md should wait for monitoring
 process (external metadata)
Date: Wed, 2 Mar 2011 12:06:03 +1100
Message-ID: <20110302120603.591725ca@notabene.brown>
References: <20110301144932.10678.20916.stgit@gklab-128-013.igk.intel.com>
	<20110301145658.10678.6778.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110301145658.10678.6778.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Tue, 01 Mar 2011 15:56:58 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> When container content is assembled it is possible that reshape
> is in progress. To avoid md to run reshape without monitoring.
> Before setting array parameters sync_max is set to 0, to not allow md
> for any move forward. After array parameters are set, sync_max is set to current
> reshape_progress. This is current reshape start point.
> Note that md is still blocked, and reshape is not continued.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  Assemble.c |   17 ++++++++++++++++-
>  1 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/Assemble.c b/Assemble.c
> index 4d41081..6aff049 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1510,11 +1510,26 @@ int assemble_container_content(struct supertype *st, int mdfd,
>  	sysfs_init(content, mdfd, 0);
>  
>  	sra = sysfs_read(mdfd, 0, GET_VERSION);
> -	if (sra == NULL || strcmp(sra->text_version, content->text_version) != 0)
> +	if (sra == NULL || strcmp(sra->text_version,
> +				  content->text_version) != 0) {
> +		if (content->reshape_active) {
> +			/* block reshape until reshape monitoring
> +			 * allows for run
> +			 */
> +			sysfs_set_num(content, NULL, "sync_max", 0);
> +		}
>  		if (sysfs_set_array(content, md_get_version(mdfd)) != 0) {
>  			close(mdfd);
>  			return 1;
>  		}
> +		if (content->reshape_active) {
> +			/* set the current checkpoint to allow monitoring to
> +			 * restart reshape
> +			 */
> +			sysfs_set_num(content, NULL, "sync_max",
> +				      content->reshape_progress);
> +		}
> +	}
>  	if (sra)
>  		sysfs_free(sra);
>  


I fairly sure this is completely ineffective.

At this point the array has not been started, so 'sync_max' does not exist.
It doesn't appear until the array is activated.

We avoid restart starting early by assembling the array 'readonly' as reshape
cannot progress on a read-only array.

NeilBrown
