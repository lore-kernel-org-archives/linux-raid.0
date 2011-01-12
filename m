From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 09/13] Finalize reshape after adding disks to array
Date: Wed, 12 Jan 2011 15:52:27 +1100
Message-ID: <20110112155227.23c40d96@notabene.brown>
References: <20110110110950.10776.75218.stgit@gklab-128-013.igk.intel.com>
	<20110110112840.10776.12936.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110110112840.10776.12936.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Mon, 10 Jan 2011 12:28:40 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> When reshape is finished monitor, has to finalize reshape in metadata.
> To do this set_array_state() should be called.
> This finishes migration and stores metadata on disks.
> 
> This finishes reshape flow in mdmon.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>

I think I had rejected this patch before asking for more explanation, and you
haven't given any....

There is already code to handle the case:

(a->curr_action == idle && a->prev_action == reshape)

Why do you think you need more code to handle this case?

NeilBrown


> ---
> 
>  monitor.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/monitor.c b/monitor.c
> index 1107d47..a0068d3 100644
> --- a/monitor.c
> +++ b/monitor.c
> @@ -322,6 +322,17 @@ static int read_and_act(struct active_array *a)
>  		 */
>  		check_reshape = 1;
>  
> +	/* finalize reshape detection
> +	 */
> +	if ((a->curr_action != reshape) &&
> +	    (a->prev_action == reshape)) {
> +		/* A reshape has finished.
> +		 * Some disks may be in sync now.
> +		 */
> +		a->container->ss->set_array_state(a, a->curr_state <= clean);
> +		check_degraded = 1;
> +	}
> +
>  	/* Check for failures and if found:
>  	 * 1/ Record the failure in the metadata and unblock the device.
>  	 *    FIXME update the kernel to stop notifying on failed drives when

