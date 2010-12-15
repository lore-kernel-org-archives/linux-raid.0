From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] imsm: FIX: imsm_add_spare() wrongly tests spares list
Date: Thu, 16 Dec 2010 09:08:17 +1100
Message-ID: <20101216090817.79d6ad30@notabene.brown>
References: <20101215093814.9746.43002.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101215093814.9746.43002.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Wed, 15 Dec 2010 10:38:15 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> For more than one disk tested additional_test_list was searched from last
> point, not from begin.
> 
> This bug causes that more than 2 disks cannot be added to imsm array,
> when imsm_add_spare() is used for this.

Thanks.  Patch applied.

NeilBrown


> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  super-intel.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index e32228e..4758951 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5454,6 +5454,7 @@ static struct dl *imsm_add_spare(struct intel_super *super, int slot,
>  	__u32 array_start = 0;
>  	__u32 array_end = 0;
>  	struct dl *dl;
> +	struct mdinfo *test_list;
>  
>  	for (dl = super->disks; dl; dl = dl->next) {
>  		/* If in this array, skip */
> @@ -5467,16 +5468,17 @@ static struct dl *imsm_add_spare(struct intel_super *super, int slot,
>  			}
>  		if (d)
>  			continue;
> -		while (additional_test_list) {
> -			if (additional_test_list->disk.major == dl->major &&
> -			    additional_test_list->disk.minor == dl->minor) {
> +		test_list = additional_test_list;
> +		while (test_list) {
> +			if (test_list->disk.major == dl->major &&
> +			    test_list->disk.minor == dl->minor) {
>  				dprintf("%x:%x already in additional test list\n",
>  					dl->major, dl->minor);
>  				break;
>  			}
> -			additional_test_list = additional_test_list->next;
> +			test_list = test_list->next;
>  		}
> -		if (additional_test_list)
> +		if (test_list)
>  			continue;
>  
>  		/* skip in use or failed drives */

