From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 4/9] imsm: FIX: After checkpoint mark array have to be
 clean
Date: Tue, 8 Mar 2011 16:07:43 +1100
Message-ID: <20110308160743.35b85f6a@notabene.brown>
References: <20110302132426.24771.99191.stgit@gklab-128-013.igk.intel.com>
	<20110302132927.24771.39913.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110302132927.24771.39913.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Wed, 02 Mar 2011 14:29:27 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> When checkpoint is marked set volume as clean.
> Reshape on dirty volume cannot be restarted from checkpoint.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  super-intel.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index 11972f3..04e32ae 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5218,6 +5218,7 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
>  				    __le32_to_cpu(dev->vol.curr_migr_unit)) {
>  					dev->vol.curr_migr_unit =
>  						__cpu_to_le32(unit);
> +					dev->vol.dirty = 0;
>  					super->updates_pending++;
>  				}
>  			}
> 

hi Adam,
 You'll need to explain this one a bit more.

 If the array isn't clean, then it is wrong to mark it as clean.
 If it is clean, then 'consistent' should be 'true' and it will
 be marked clean anyway.

 Why cannot a reshape of a dirty volume be restarted from a checkpoint?
 I would think it would continue with the reshape and then when that
 finished, go back and do the resync.

NeilBrown

