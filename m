From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 4/8] md: analyze_sbs(): Fix potential NULL-pointer dereference.
Date: Wed, 9 Jul 2008 09:09:01 +1000
Message-ID: <18547.62349.86619.101004@notabene.brown>
References: <20080708155541.GS23944@skl-net.de>
	<S1754836AbYGHQde/20080708163334Z+60@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Tuesday March 25
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday March 25, maan@systemlinux.org wrote:
> If no device in the array contains a valid super block, "freshest"
> will be NULL, but we happily dereference that pointer in the subsequent
> call to validate_super().
> 
> Fix it by returning early in this case.
> 
> Signed-off-by: Andre Noll <maan@systemlinux.org>
> ---
>  drivers/md/md.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 7943df1..bf1499c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2249,6 +2249,10 @@ static void analyze_sbs(mddev_t * mddev)
>  			kick_rdev_from_array(rdev);
>  		}
>  
> +	if (!freshest) {
> +		printk(KERN_ERR "md: no valid devices found\n");
> +		return;
> +	}
>  
>  	super_types[mddev->major_version].
>  		validate_super(mddev, freshest);

This shouldn't actually be possible.  But I've got to rush off just
now.  I'll have a deeper look later.

Thanks,
NeilBrown
