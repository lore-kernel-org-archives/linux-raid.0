From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] FIX: Seg Fault in incremental if BBM log detected
Date: Thu, 17 Feb 2011 17:07:06 +1100
Message-ID: <20110217170706.76f33d25@notabene.brown>
References: <20110216124204.9233.9404.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110216124204.9233.9404.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Wed, 16 Feb 2011 13:42:04 +0100 Krzysztof Wojcik
<krzysztof.wojcik@intel.com> wrote:

> Bug  detected for imsm metadata.
> Assembling of array using Incremental switch generate segmentation
> fault if BBM log is detected.
> Reason: missing return from Incremental_container if BBM is detected
> and unnecessary list=NULL assignment.
> This patch fix the problem and memory leak in this area.
> 
> Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> ---
>  Incremental.c |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/Incremental.c b/Incremental.c
> index 889184f..26739fe 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -1471,7 +1471,19 @@ static int Incremental_container(struct supertype *st, char *devname,
>  	if (list->array.state & (1<<MD_SB_BBM_ERRORS)) {
>  		fprintf(stderr, Name ": BBM log found in metadata. "
>  					"Cannot activate array(s).\n");
> -		list = NULL;
> +		/* free container data and exit */
> +		while (list) {
> +			struct mdinfo *d1 = list->next;
> +			struct mdinfo *disk = list->devs;
> +			while (disk) {
> +				struct mdinfo *d2 = disk->next;
> +				free(disk);
> +				disk = d2;
> +			}
> +			free(list);
> +			list = d1;
> +		}

That can all be replaced with
   sysfs_free(list);

> +		return 2;

With that change, I have applied this patch, thanks.

NeilBrown



>  	}
>  
>  	for (ra = list ; ra ; ra = ra->next) {

