From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 03/13] imsm: FIX: when monitor is active post update
Date: Wed, 12 Jan 2011 14:56:24 +1100
Message-ID: <20110112145624.3991f041@notabene.brown>
References: <20110110110950.10776.75218.stgit@gklab-128-013.igk.intel.com>
	<20110110112750.10776.44373.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110110112750.10776.44373.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Mon, 10 Jan 2011 12:27:50 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> Updates has to be posted when monitor is active for this array/container.
> Only when monitor is not active mdadm has update metadata itself.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  super-intel.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index 58a776e..8644c39 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -6570,9 +6570,15 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
>  				goto exit_imsm_reshape_super;
>  			}
>  
> -			/* As well as creating update, we apply update.
> -			 */
> +			if (mdmon_running(st->container_dev)) {
> +				ret_val = 0;
> +				append_metadata_update(st, u, len);
> +				goto exit_imsm_reshape_super;
> +			}
> +			
>  
> +			/* no mdmon - apply update
> +			 */
>  			dprintf("imsm:prepare space list for update_reshape\n");
>  			for (dl = super->devlist; dl;
>  			     dl = dl->next) {


I really don't like have code in super-* calling "mdmon_running".  It feels
like a layering violation.


imsm_reshape_super should:
 -  *always* change the metadata as required
 -  if st->update_tail is non-null, then a metadata update should also
    be added with append_metadata_update

The common code will then call sync_metadata() to either flush the updates
through mdmon or write them directly.

NeilBrown

