From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/8] imsm: FIX: Size is already set in metadata
Date: Thu, 3 Feb 2011 17:45:19 +1100
Message-ID: <20110203174519.105469f5@notabene.brown>
References: <20110201134226.13398.4071.stgit@gklab-128-013.igk.intel.com>
	<20110201134920.13398.77330.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110201134920.13398.77330.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Tue, 01 Feb 2011 14:49:20 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> In metadata size is set already during migration initialization.
> There is no reason for second /the same/ calculation.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  super-intel.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index 42f7065..62b13b0 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5185,15 +5185,12 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
>  				/* round array size down to closest MB */
>  				array_blocks = (array_blocks >> SECT_PER_MB_SHIFT)
>  					<< SECT_PER_MB_SHIFT;
> -				dev->size_low = __cpu_to_le32((__u32) array_blocks);
> -				dev->size_high = __cpu_to_le32((__u32) (array_blocks >> 32));
>  				a->info.custom_array_size = array_blocks/2;
>  				a->check_reshape = 1; /* encourage manager to update
>  						       * array size
>  						       */
> -				super->updates_pending++;
>  				imsm_progress_container_reshape(super);
> -			}				
> +			}
>  		}
>  	}
>  
> 

Doing the same calculation in two placed does seem wrong, but are you
sure this is the right one to remove?

The available space in the array does not change until the reshape
completes.  So changing dev->size_{low,high} during initialisation
seems wrong.

Are you able to confirm what the windows driver does?

If we do set the size early, then we have to be careful to reduce to the
original size when assembling an array that is in the middle of reshape.

So I won't apply this patch now, and will wait for you to confirm when the
windows driver updates dev->size_{low,high}

Thanks,
NeilBrown

