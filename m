From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] Monitor: Check destination array domain early.
Date: Tue, 21 Dec 2010 09:07:33 +1100
Message-ID: <20101221090733.74899aaa@notabene.brown>
References: <905EDD02F158D948B186911EB64DB3D176B9CF39@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D176B9CF39@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Fri, 17 Dec 2010 13:26:42 +0000 "Labun, Marcin" <Marcin.Labun@intel.com>
wrote:

> >From 868faba9b94b8278c93f9f8026b05fb698212207 Mon Sep 17 00:00:00 2001
> From: Marcin Labun <marcin.labun@intel.com>
> Date: Thu, 16 Dec 2010 15:16:12 +0100
> Subject: [PATCH] Monitor: Check destination array domain early.
> 
> Destination arrays that do not have any domains are excluded
> from spare sharing. We can check it early, without searching
> for donor arrays.

Applied.  Thanks.

NeilBrown


> 
> Signed-off-by: Marcin Labun <marcin.labun@intel.com>
> ---
>  Monitor.c |   14 ++++++++------
>  1 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/Monitor.c b/Monitor.c
> index ce160f3..e79f658 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -767,8 +767,7 @@ static int move_spare(struct state *from, struct state *to,
>  	return 0;
>  }
>  
> -static int check_donor(struct state *from, struct state *to,
> -		       struct domainlist *domlist)
> +static int check_donor(struct state *from, struct state *to)
>  {
>  	struct state *sub;
>  
> @@ -790,8 +789,6 @@ static int check_donor(struct state *from, struct state *to,
>  			return 0;
>  	if (from->spare <= 0)
>  		return 0;
> -	if (domlist == NULL)
> -		return 0;
>  	return 1;
>  }
>  
> @@ -923,10 +920,15 @@ static void try_spare_migration(struct state *statelist, struct alert_info *info
>  							   to->metadata->ss->name);
>  			if (to->spare_group)
>  				domain_add(&domlist, to->spare_group);
> -
> +			/*
> +			 * No spare migration if the destination
> +			 * has no domain. Skip this array.
> +			 */
> +			if (!domlist)
> +				continue;
>  			for (from=statelist ; from ; from=from->next) {
>  				dev_t devid;
> -				if (!check_donor(from, to, domlist))
> +				if (!check_donor(from, to))
>  					continue;
>  				if (from->metadata->ss->external)
>  					devid = container_choose_spare(

