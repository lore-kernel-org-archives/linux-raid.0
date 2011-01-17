From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] fix: segfault if subarray is monitored but container is
 not
Date: Mon, 17 Jan 2011 12:09:13 +1100
Message-ID: <20110117120913.57c88d1b@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E8FDE84@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E8FDE84@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Thu, 13 Jan 2011 13:22:16 +0000 "Czarnowska, Anna"
<anna.czarnowska@intel.com> wrote:

> >From 7ea892adec6d2f383059b2a337db766735d7217f Mon Sep 17 00:00:00 2001
> From: Anna Czarnowska <anna.czarnowska@intel.com>
> Date: Thu, 13 Jan 2011 14:14:57 +0100
> Subject: [PATCH] fix: segfault if subarray is monitored but container is not
> 
> In this situation to->parent is null so "to" doesn't change to
> parent container and to->metadata is still null.
> This results in segmentation fault when checking
> to->metadata->ss->external.
> We should just skip this array as container is needed to move spares to.
> 
> Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
> ---
>  Monitor.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/Monitor.c b/Monitor.c
> index db4e8cc..ab1ae26 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -833,6 +833,11 @@ static void try_spare_migration(struct state *statelist, struct alert_info *info
>  			struct state *to = st;
>  			unsigned long long min_size;
>  
> +			if (to->parent_dev != NoMdDev && !to->parent)
> +				/* subarray monitored without parent container
> +				 * we can't move spares here */
> +				continue;
> +			
>  			if (to->parent)
>  				/* member of a container */
>  				to = to->parent;

Applied, thanks.

NeilBrown

