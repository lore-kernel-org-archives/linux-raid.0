From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: What does the '-1' value of size mean now?
Date: Fri, 10 Aug 2012 14:20:34 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB18FD92A8@IRSMSX102.ger.corp.intel.com>
References: <D9FFE20C522965449E182ACE73889AEB18FD8F13@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D9FFE20C522965449E182ACE73889AEB18FD8F13@IRSMSX102.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday, August 09, 2012 6:12 PM Dorau, Lukasz wrote:
> 
> Hi Neil
> 
> What does the '-1' value of size (Grow.c:1990 and Grow.c:2678) mean now
> regarding your recent patch:?
> 
> From d04f65f48c93e7e57cc3c1d70dd07d094dece717 Mon Sep 17 00:00:00
> 2001
> From: NeilBrown <neilb@suse.de>
> Date: Mon, 9 Jul 2012 17:20:32 +1000
> Subject: [PATCH] Change the values for "max size" from -1 to 1.
> 
> There are two places (Grow.c:1990 and Grow.c:2678) where reshape_super()
> is called with size==-1. Is it still right?
> 

The patch "Grow.c: change size to be unsigned and use '0' in case of 'no change'"
that I've just sent to linux-raid fixes it.

Regards,
Lukasz

> I am asking you because you have changed also the 'size' parameter of
> imsm_reshape_super() from signed to unsigned (super-intel.c:9884).
> When reshape_super() is called with size==-1 at Grow.c:2678,
> imsm_reshape_super() is called with size==-1 too, so the size is converted to
> unsigned value 0xFFFFFFFFFFFFFFFF and the logic is broken down, because
> the condition "geo->size != -1" at super-intel.c:9310 had been false previously
> and now the condition "geo->size > 0" is true, because
> size==0xFFFFFFFFFFFFFFFF now:
> 
> @@ -9307,7 +9307,7 @@ static int
> imsm_reshape_is_allowed_on_container(struct supertype *st,
>  		"st->devnum = (%i)\n",
>  		st->devnum);
> 
> -	if (geo->size != -1 ||
> +	if (geo->size > 0 ||
> 
> I am going to correct it, but I don't know if the '-1' value of size parameter at
> Grow.c:1990 and Grow.c:2678 is still right?
> 
> Regards,
> Lukasz
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
