From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 8/9] FIX: Set 'active' array state before array
 configuration
Date: Thu, 10 Mar 2011 11:39:10 +1100
Message-ID: <20110310113910.3c761071@notabene.brown>
References: <20110309134019.8939.15438.stgit@gklab-128-013.igk.intel.com>
	<20110309134634.8939.13062.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110309134634.8939.13062.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Wed, 09 Mar 2011 14:46:34 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> For not reshaped array in container during assembly array is in auto-read-only state.
> It is not possible to set disk slot for such array and later reshape cannot be started also.
> To move array from 'auto-read-only' to 'active' state storing 'active' state
> to sysfs is added. This allows for disks configuration and reshape.
> 
> During reshaped array restart it is disabled by condition on restart variable.
> 
> When reshape is starting, storing 'active' state
> to already active array should not matter.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  Grow.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index e392290..9a831f4 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1654,6 +1654,15 @@ static int reshape_array(char *container, int fd, char *devname,
>  		info->new_level = UnSet;
>  		msg = analyse_change(info, &reshape);
>  		info->new_level = new_level;
> +		if (!restart) {
> +			sra = sysfs_read(fd, 0, GET_VERSION);
> +			if (sra) {
> +				sysfs_set_str(sra, NULL,
> +					      "array_state", "active");
> +				sysfs_free(sra);
> +				sra = NULL;
> +			}
> +		}
>  	} else
>  		msg = analyse_change(info, &reshape);
>  	if (msg) {
> 

I changed this to just use the RESTART_ARRAY_RW ioctl instead.

Thanks,
NeilBrown

