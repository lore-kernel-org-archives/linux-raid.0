From: NeilBrown <neilb@suse.de>
Subject: Re: [patch] md/raid10: double lock typo in handle_read_error()
Date: Wed, 27 Jul 2011 20:59:54 +1000
Message-ID: <20110727205954.4dc688b1@notabene.brown>
References: <20110727095202.GJ3824@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110727095202.GJ3824@shale.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 27 Jul 2011 12:52:02 +0300 Dan Carpenter <error27@gmail.com> wrote:

> This should be a spin_unlock_irq() instead of spin_lock_irq()
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 9214e08..8b29cd4 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2117,7 +2117,7 @@ read_more:
>  			mbio->bi_phys_segments = 2;
>  		else
>  			mbio->bi_phys_segments++;
> -		spin_lock_irq(&conf->device_lock);
> +		spin_unlock_irq(&conf->device_lock);
>  		generic_make_request(bio);
>  		bio = NULL;
>  

Thanks!
I haven't yet submitted the patch which introduced that bug, so I just fixed
the patch directly and credited you.

Thanks,
NeilBrown
