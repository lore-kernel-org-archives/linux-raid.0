From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/3] md: fix raid10 takeover: use new_layout for
 setup_conf
Date: Thu, 17 Jun 2010 15:23:49 +1000
Message-ID: <20100617152349.053a49e1@notabene.brown>
References: <BE2BFE91933D1B4089447C64486040801E873EE6@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BE2BFE91933D1B4089447C64486040801E873EE6@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Trela, Maciej" <Maciej.Trela@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Wed, 16 Jun 2010 11:46:29 +0100
"Trela, Maciej" <Maciej.Trela@intel.com> wrote:

> From: Maciej Trela <maciej.trela@intel.com>
> 
> Use mddev->new_layout in setup_conf.

Thanks.
I added changed for ->chunk_sectors to ->new_chunk_sectors
and removed the setting of ->degraded in takeover().

Applied.

NeilBrown

> 
> Signed-off-by: Maciej Trela <maciej.trela@intel.com>
> ---
>  drivers/md/raid10.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c index 9f65dc5..7b47639 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2169,14 +2169,14 @@ static conf_t *setup_conf(mddev_t *mddev)
>  		goto out;
>  	}
>  
> -	nc = mddev->layout & 255;
> -	fc = (mddev->layout >> 8) & 255;
> -	fo = mddev->layout & (1<<16);
> +	nc = mddev->new_layout & 255;
> +	fc = (mddev->new_layout >> 8) & 255;
> +	fo = mddev->new_layout & (1<<16);
>  
>  	if ((nc*fc) <2 || (nc*fc) > mddev->raid_disks ||
> -	    (mddev->layout >> 17)) {
> +	    (mddev->new_layout >> 17)) {
>  		printk(KERN_ERR "md/raid10:%s: unsupported raid10 layout: 0x%8x\n",
> -		       mdname(mddev), mddev->layout);
> +		       mdname(mddev), mddev->new_layout);
>  		goto out;
>  	}

