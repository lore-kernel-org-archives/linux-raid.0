From: Martin Wilck <mwilck@arcor.de>
Subject: Re: mdadm -Db switches array to write-pending?!
Date: Wed, 17 Jul 2013 22:19:25 +0200
Message-ID: <51E6FC4D.6080309@arcor.de>
References: <51DD9FC1.2060200@arcor.de> <20130715151809.5fea8c78@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130715151809.5fea8c78@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/15/2013 07:18 AM, NeilBrown wrote:

> Probably the  best thing to do is:
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d059af5..b19a1c8 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5629,10 +5629,7 @@ static int get_bitmap_file(struct mddev * mddev, void __user * arg)
>  	char *ptr, *buf = NULL;
>  	int err = -ENOMEM;
>  
> -	if (md_allow_write(mddev))
> -		file = kmalloc(sizeof(*file), GFP_NOIO);
> -	else
> -		file = kmalloc(sizeof(*file), GFP_KERNEL);
> +	file = kmalloc(sizeof(*file), GFP_NOIO);
>  
>  	if (!file)
>  		goto out;
> 
> 
> A failure here is not likely and not catastrophic.
> 
> Does it fix the situation for you?

Yes it does.
Martin
