From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH 2.5.68] eliminate deprecated MOD_INC_USE_COUNT/MOD_DEC_USE_COUNT
 in md.c
Date: Wed, 23 Apr 2003 10:00:58 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16037.55226.267006.507998@notabene.cse.unsw.edu.au>
References: <3EA595D9.E4CBB684@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Tuesday April 22
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday April 22, Paul.Clements@SteelEye.com wrote:
> Following is a simple patch to remove deprecated MOD_INC_USE_COUNT from
> md.c.
> 
> If it looks good, please apply.

I don't think it is that easy.
We take/drop a reference count there for a reason, and just removing
the calls isn't likely to do the right thing.

With md, we need to hold a refcount on the module not only when any
md device is open, but also when any md device is active.

I *think* changing them to "module_put(THIS_MODULE)" and
"try_module_get(THIS_MODULE)" would do the right thing, but I would
rather spend a bit little bit longer understanding the new block dev
stuff before I was sure.

NeilBrown

> 
> Thanks,
> Paul--- md.c.PRISTINE	2003-04-22 12:59:37.000000000 -0400
> +++ md.c	2003-04-22 12:59:50.000000000 -0400
> @@ -181,7 +181,6 @@ static void mddev_put(mddev_t *mddev)
>  		list_del(&mddev->all_mddevs);
>  		mddev_map[mdidx(mddev)] = NULL;
>  		kfree(mddev);
> -		MOD_DEC_USE_COUNT;
>  	}
>  	spin_unlock(&all_mddevs_lock);
>  }
> @@ -203,7 +202,6 @@ static mddev_t * mddev_find(int unit)
>  		mddev_map[unit] = new;
>  		list_add(&new->all_mddevs, &all_mddevs);
>  		spin_unlock(&all_mddevs_lock);
> -		MOD_INC_USE_COUNT;
>  		return new;
>  	}
>  	spin_unlock(&all_mddevs_lock);
