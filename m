From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/raid1: add error handling of read error from FailFast
 device
Date: Mon, 14 May 2018 12:30:11 -0700
Message-ID: <20180514193011.krnxl2mkgkrwg47r@kernel.org>
References: <20180502110811.10886-1-gi-oh.kim@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180502110811.10886-1-gi-oh.kim@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gioh Kim <gi-oh.kim@profitbricks.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 02, 2018 at 01:08:11PM +0200, Gioh Kim wrote:
> Current handle_read_error() function calls fix_read_error()
> only if md device is RW and rdev does not include FailFast flag.
> It does not handle a read error from a RW device including
> FailFast flag.
> 
> I am not sure it is intended. But I found that write IO error
> sets rdev faulty. The md module should handle the read IO error and
> write IO error equally. So I think read IO error should set rdev faulty.
> 
> Signed-off-by: Gioh Kim <gi-oh.kim@profitbricks.com>
> ---
>  drivers/md/raid1.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index e9e3308cb0a7..4445179aa4c8 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2474,6 +2474,8 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>  		fix_read_error(conf, r1_bio->read_disk,
>  			       r1_bio->sector, r1_bio->sectors);
>  		unfreeze_array(conf);
> +	} else if (mddev->ro == 0 && test_bit(FailFast, &rdev->flags)) {
> +		md_error(mddev, rdev);
>  	} else {
>  		r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
>  	}
> -- 
> 2.14.1

Looks reasonable, applied! 
