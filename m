From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 7/9] FIX: Array cannot be opened for writing on restart
Date: Thu, 10 Mar 2011 11:38:10 +1100
Message-ID: <20110310113810.66b3f15e@notabene.brown>
References: <20110309134019.8939.15438.stgit@gklab-128-013.igk.intel.com>
	<20110309134626.8939.62466.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110309134626.8939.62466.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Wed, 09 Mar 2011 14:46:26 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> When reshape is restarted array (in readonly state) cannot be opened for writing.
> For reshape restart open array for reading only.
> Array is configured already and no writes are required.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  Grow.c |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index 67bbb26..e392290 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -2240,7 +2240,17 @@ int reshape_container(char *container, char *devname,
>  		if (!content)
>  			break;
>  
> -		fd = open_dev(mdstat->devnum);
> +		if (restart) {
> +			char buf[20];
> +			/* array is in readonly state,
> +			 * so cannot be opened for writting
> +			 */
> +			sprintf(buf, "%d:%d",
> +				dev2major(mdstat->devnum),
> +				dev2minor(mdstat->devnum));
> +			fd = dev_open(buf, O_RDONLY);
> +		} else
> +			fd = open_dev(mdstat->devnum);
>  		if (fd < 0)
>  			break;
>  		adev = map_dev(dev2major(mdstat->devnum),
> 

I changed open_dev to always open O_RDONLY instead.  That
seems to be quite sufficient.

Thanks,
NeilBrown

