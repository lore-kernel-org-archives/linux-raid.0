From: jes.sorensen@gmail.com
Subject: Re: [PATCH 2/2] mdadm.c: fix compile error "switch condition has boolean value"
Date: Wed, 29 Mar 2017 11:47:28 -0400
Message-ID: <wrfjpoh0dqzz.fsf@gmail.com>
References: <1490780434-8720-1-git-send-email-gi-oh.kim@profitbricks.com>
        <1490780434-8720-2-git-send-email-gi-oh.kim@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1490780434-8720-2-git-send-email-gi-oh.kim@profitbricks.com>
        (Gioh Kim's message of "Wed, 29 Mar 2017 11:40:34 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Gioh Kim <gi-oh.kim@profitbricks.com>
Cc: neilb@suse.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Gioh Kim <gi-oh.kim@profitbricks.com> writes:
> Remove a boolean expression in switch condition
> to prevent compile error of some compilers.

Please be specific, which compile is unable to handle this?

> Signed-off-by: Gioh Kim <gi-oh.kim@profitbricks.com>
> ---
>  mdadm.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/mdadm.c b/mdadm.c
> index 08ddcab..a98a051 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -1905,11 +1905,11 @@ static int misc_list(struct mddev_dev *devlist,
>  			rv |= SetAction(dv->devname, c->action);
>  			continue;
>  		}
> -		switch(dv->devname[0] == '/') {
> -			case 0:
> +		switch(dv->devname[0]) {
> +			default:
>  				mdfd = open_dev(dv->devname);
>  				if (mdfd >= 0) break;
> -			case 1:
> +			case '/':
>  				mdfd = open_mddev(dv->devname, 1);  
>  		}
>  		if (mdfd>=0) {

While I agree the original code is ugly, I am not convinced your
replacement is a lot prettier.

Thanks,
Jes
