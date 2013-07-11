From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: [patch -next] bcache: check for allocation failures
Date: Wed, 10 Jul 2013 18:48:34 -0700
Message-ID: <20130711014834.GE13527@kmo-pixel>
References: <20130705060307.GB14443@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130705060307.GB14443-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

On Fri, Jul 05, 2013 at 09:05:46AM +0300, Dan Carpenter wrote:
> There is a missing NULL check after the kzalloc().
> 
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> 
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index 48f0353..4fe6ab2 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -232,6 +232,8 @@ STORE(__cached_dev)
>  			bch_uuid_write(dc->disk.c);
>  		}
>  		env = kzalloc(sizeof(struct kobj_uevent_env), GFP_KERNEL);
> +		if (!env)
> +			return -ENOMEM;
>  		add_uevent_var(env, "DRIVER=bcache");
>  		add_uevent_var(env, "CACHED_UUID=%pU", dc->sb.uuid),
>  		add_uevent_var(env, "CACHED_LABEL=%s", buf);

Thanks - applied
