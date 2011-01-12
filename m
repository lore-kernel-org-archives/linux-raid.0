From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 13/13] FIX: Fill sys_name for disk add
Date: Wed, 12 Jan 2011 16:02:00 +1100
Message-ID: <20110112160200.30b94087@notabene.brown>
References: <20110110110950.10776.75218.stgit@gklab-128-013.igk.intel.com>
	<20110110112912.10776.73847.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110110112912.10776.73847.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Mon, 10 Jan 2011 12:29:12 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> Add disks fails due to empty sys name field.
> sysfs_init fills out required fields for add disk operation.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>

Applied, thanks.

NeilBrown


> ---
> 
>  Grow.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index 9d31087..2ca9835 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1692,7 +1692,8 @@ static int reshape_array(char *container, int fd, char *devname,
>  			st->ss->container_content(st, subarray);
>  		struct mdinfo *d;
>  
> -		if (info2)
> +		if (info2) {
> +			sysfs_init(info2, fd, st->devnum);
>  			for (d = info2->devs; d; d = d->next) {
>  				if (d->disk.state == 0 &&
>  				    d->disk.raid_disk >= 0) {
> @@ -1703,7 +1704,8 @@ static int reshape_array(char *container, int fd, char *devname,
>  					add_disk(fd, st, info2, d);
>  				}
>  			}
> -		sysfs_free(info2);
> +			sysfs_free(info2);
> +		}
>  	}
>  
>  	if (reshape.blocks == 0) {

