From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: don't impose the MD_SB_DISKS limit on arrays without
 metadata.
Date: Tue, 28 Feb 2017 13:15:24 -0800
Message-ID: <20170228211524.x7dbmhgq2th7gmiu@kernel.org>
References: <87k28aoy5b.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87k28aoy5b.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, ian_bruce@mail.ru
List-Id: linux-raid.ids

On Wed, Mar 01, 2017 at 07:31:28AM +1100, Neil Brown wrote:
> 
> These arrays, created with "mdadm --build" don't benefit from a limit.
> The default will be used, which is '0' and is interpreted as "don't
> impose a limit".
> 
> Reported-by: ian_bruce@mail.ru
> Signed-off-by: NeilBrown <neilb@suse.com>

applied, thanks!

> ---
>  drivers/md/md.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ba485dcf1064..e0ac7f5a8e68 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6464,9 +6464,8 @@ static int set_array_info(struct mddev *mddev, mdu_array_info_t *info)
>  	mddev->layout        = info->layout;
>  	mddev->chunk_sectors = info->chunk_size >> 9;
>  
> -	mddev->max_disks     = MD_SB_DISKS;
> -
>  	if (mddev->persistent) {
> +		mddev->max_disks     = MD_SB_DISKS;
>  		mddev->flags         = 0;
>  		mddev->sb_flags         = 0;
>  	}
> -- 
> 2.11.0
> 


