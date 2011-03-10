From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/9] FIX: Make expansion counter usable
Date: Thu, 10 Mar 2011 11:28:30 +1100
Message-ID: <20110310112830.7d292125@notabene.brown>
References: <20110309134019.8939.15438.stgit@gklab-128-013.igk.intel.com>
	<20110309134554.8939.74177.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110309134554.8939.74177.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Wed, 09 Mar 2011 14:45:54 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> Currently whole array geometry is set in sysfs_set_array(),
> so none of disks (even for expansion) should fail during sysfs_add_disk()
> Due to this expansion counter should be used for reshaped array when
> disk slot is bigger than number of disks in array.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  Assemble.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/Assemble.c b/Assemble.c
> index fe917b2..0ffbbc9 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1526,13 +1526,14 @@ int assemble_container_content(struct supertype *st, int mdfd,
>  		sysfs_free(sra);
>  
>  	for (dev = content->devs; dev; dev = dev->next)
> -		if (sysfs_add_disk(content, dev, 1) == 0)
> -			working++;
> -		else if (errno == EEXIST)
> +		if (sysfs_add_disk(content, dev, 1) == 0) {
> +			if (dev->disk.raid_disk >= content->array.raid_disks &&
> +			    content->reshape_active)
> +				expansion++;
> +			else
> +				working++;
> +		} else if (errno == EEXIST)
>  			preexist++;
> -		else if (dev->disk.raid_disk >= content->array.raid_disks &&
> -			  content->reshape_active)
> -			expansion++;
>  	if (working == 0)
>  		return 1;/* Nothing new, don't try to start */
>  
> 

Applied, thanks.

NeilBrown
