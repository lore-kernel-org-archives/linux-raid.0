From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/2] md: add bad block support for external metadata
Date: Mon, 17 Oct 2016 17:23:14 -0700
Message-ID: <20161018002314.GA106864@kernel.org>
References: <1476714549-15057-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1476714549-15057-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org, aleksey.obitotskiy@intel.com, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com, maksymilian.kunt@intel.com, mariusz.dabrowski@intel.com
List-Id: linux-raid.ids

On Mon, Oct 17, 2016 at 04:29:09PM +0200, Tomasz Majchrzak wrote:
> Add new rdev flag which external metadata handler can use to switch
> on/off bad block support. If new bad block is encountered, notify it via
> rdev 'unacknowledged_bad_blocks' sysfs file. If bad block has been
> cleared, notify update to rdev 'bad_blocks' sysfs file.
> 
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  drivers/md/md.c | 22 ++++++++++++++++++++--
>  drivers/md/md.h |  3 +++
>  2 files changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index eac84d8..f375d1b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2568,6 +2568,10 @@ state_show(struct md_rdev *rdev, char *page)
>  		len += sprintf(page+len, "%sreplacement", sep);
>  		sep = ",";
>  	}
> +	if (test_bit(ExternalBbl, &flags)) {
> +		len += sprintf(page+len, "%sexternal_bbl", sep);
> +		sep = ",";
> +	}

that sep assignment isn't needed, please delete it and the previous occurences.
 
>  	return len+sprintf(page+len, "\n");
>  }
> @@ -2708,6 +2712,14 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
>  			}
>  		} else
>  			err = -EBUSY;
> +	} else if (cmd_match(buf, "external_bbl") && (rdev->mddev->external)) {
> +		set_bit(ExternalBbl, &rdev->flags);
> +		rdev->badblocks.shift = 0;
> +		err = 0;
> +	} else if (cmd_match(buf, "-external_bbl") && (rdev->mddev->external)) {
> +		clear_bit(ExternalBbl, &rdev->flags);
> +		rdev->badblocks.shift = -1;
> +		err = 0;

How is this safe? If md is clearing badblocks and in the meaningtime we set
badblocks.shift = -1 here, we have a trouble.

Thanks,
Shaohua
