From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] fix: imsm: size must be in K for rounding to chunk
Date: Mon, 14 Feb 2011 09:50:16 +1100
Message-ID: <20110214095016.17e8258d@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F011149855B@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F011149855B@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Thu, 10 Feb 2011 08:33:33 +0000 "Czarnowska, Anna"
<anna.czarnowska@intel.com> wrote:

> >From 77d66de281e818f93e97b3150dc0e610634463de Mon Sep 17 00:00:00 2001
> From: Anna Czarnowska <anna.czarnowska@intel.com>
> Date: Tue, 8 Feb 2011 11:13:14 +0100
> Subject: [PATCH 1/2] fix: imsm: size must be in K for rounding to chunk
> Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>
> 
> chunk is in K so size must be converted to K before it is rounded.
> Otherwise we may get wrong freesize returned
> resulting in creation failure.
> 
> Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>

Thanks.  I've applied both patches in this series.

NeilBrown


> ---
>  super-intel.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index 6a21b26..5c16137 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -4379,7 +4379,8 @@ static int reserve_space(struct supertype *st, int raiddisks,
>  	maxsize = merge_extents(super, extent_cnt);
>  	minsize = size;
>  	if (size == 0)
> -		minsize = chunk;
> +		/* chunk is in K */
> +		minsize = chunk * 2;
>  
>  	if (cnt < raiddisks ||
>  	    (super->orom && used && used != raiddisks) ||
> @@ -4392,8 +4393,8 @@ static int reserve_space(struct supertype *st, int raiddisks,
>  	if (size == 0) {
>  		size = maxsize;
>  		if (chunk) {
> -			size /= chunk;
> -			size *= chunk;
> +			size /= 2 * chunk;
> +			size *= 2 * chunk;
>  		}
>  	}
>  

