From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 5/9] FIX: Unfreeze array on success only during reshape
 continuation
Date: Thu, 10 Mar 2011 11:36:23 +1100
Message-ID: <20110310113623.56091fae@notabene.brown>
References: <20110309134019.8939.15438.stgit@gklab-128-013.igk.intel.com>
	<20110309134610.8939.79769.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110309134610.8939.79769.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Wed, 09 Mar 2011 14:46:10 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> When reshape continuation fails, reshaped array should remain frozen
> to allow user for repair action (mdmon will not change array state).
> Setting restart to 0 was moved down to allow failure detection.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  Grow.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index e37fc57..67bbb26 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -2255,11 +2255,12 @@ int reshape_container(char *container, char *devname,
>  				   content, force,
>  				   backup_file, quiet, 1, restart);
>  		close(fd);
> -		restart = 0;
>  		if (rv)
>  			break;
> +		restart = 0;
>  	}
> -	unfreeze(st);
> +	if (restart == 0)
> +		unfreeze(st);
>  	sysfs_free(cc);
>  	exit(0);
>  }
> 

Not applied... it is probably close to right, but I'm a little confused.
Surely we should never never unfreeze on an error - not only in the restart
case...
And the code doesn't make it obvious that the unfreeze is only in the
error case...
Maybe
  if (!rv)
     unfreeze(st);
??

NeilBrown
