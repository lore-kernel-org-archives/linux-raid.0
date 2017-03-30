From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [PATCHv2] mdadm.c: fix compile error "switch condition has
 boolean value"
Date: Thu, 30 Mar 2017 18:50:44 +0100
Message-ID: <58DD4574.3020803@youngman.org.uk>
References: <1490893093-4666-1-git-send-email-gi-oh.kim@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1490893093-4666-1-git-send-email-gi-oh.kim@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gioh Kim <gi-oh.kim@profitbricks.com>, jes.sorensen@gmail.com, neilb@suse.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

You can add my acked-by (never done it before, not sure how :-)

Cheers,
Wol

On 30/03/17 17:58, Gioh Kim wrote:
> Remove a boolean expression in switch condition
> to prevent compile error of some compilers,
> for example, gcc version 5.2.1 20151010 (Ubuntu 5.2.1-22ubuntu2).
> 
> Signed-off-by: Gioh Kim <gi-oh.kim@profitbricks.com>
> ---
>  mdadm.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/mdadm.c b/mdadm.c
> index 0f32773..d6b5437 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -1965,14 +1965,12 @@ static int misc_list(struct mddev_dev *devlist,
>  			rv |= SetAction(dv->devname, c->action);
>  			continue;
>  		}
> -		switch(dv->devname[0] == '/') {
> -			case 0:
> -				mdfd = open_dev(dv->devname);
> -				if (mdfd >= 0)
> -					break;
> -			case 1:
> -				mdfd = open_mddev(dv->devname, 1);  
> -		}
> +
> +		if (dv->devname[0] != '/')
> +			mdfd = open_dev(dv->devname);
> +		if (dv->devname[0] == '/' || mdfd < 0)
> +			mdfd = open_mddev(dv->devname, 1);
> +
>  		if (mdfd >= 0) {
>  			switch(dv->disposition) {
>  			case 'R':
> 
