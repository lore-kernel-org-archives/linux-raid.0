From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: FIX: mdmon crash during 2 raid0 arrays expansion
Date: Tue, 1 Feb 2011 10:27:46 +1100
Message-ID: <20110201102746.34e0730e@notabene.brown>
References: <20110131124815.26942.85427.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110131124815.26942.85427.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Mon, 31 Jan 2011 13:48:16 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> When expansion is run on 2 raid0 arrays in container no update
> is sent to mdmon because mdmon is off (mdadm performs update)
> Memory size for first reshaped array is allocated to satisfy memory
> requirements for expanded maps.
> Memory for second device is allocated using old disks number, as in metadata
> there is no information about this array reshape.
> When mdmon initiates second array reshape it overwrites internal structures
> and crashes). There is no place to keep expanded maps.
> To avoid this situation during loading metadata, allocated memory should be performed
> using the maximum used disks number in particular container.

Applied, thanks.

NeilBrown


> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  super-intel.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index 3e163ec..8c9e67f 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -2483,6 +2483,7 @@ static int parse_raid_devices(struct intel_super *super)
>  	int i;
>  	struct imsm_dev *dev_new;
>  	size_t len, len_migr;
> +	size_t len max_len = 0;
>  	size_t space_needed = 0;
>  	struct imsm_super *mpb = super->anchor;
>  
> @@ -2498,7 +2499,9 @@ static int parse_raid_devices(struct intel_super *super)
>  		dv = malloc(sizeof(*dv));
>  		if (!dv)
>  			return 1;
> -		dev_new = malloc(len_migr);
> +		if (max_len < len_migr)
> +			max_len = len_migr;
> +		dev_new = malloc(max_len);
>  		if (!dev_new) {
>  			free(dv);
>  			return 1;

