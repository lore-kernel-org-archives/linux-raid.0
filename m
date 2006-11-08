From: Neil Brown <neilb@suse.de>
Subject: Re: FYI: [2.6.16 patch] drivers/md/md.c: update START_ARRAY printk
Date: Thu, 9 Nov 2006 09:55:07 +1100
Message-ID: <17746.24651.204927.943159@cse.unsw.edu.au>
References: <20061108072428.GQ4729@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Adrian Bunk on Wednesday November 8
Sender: linux-raid-owner@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: mingo@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday November 8, bunk@stusta.de wrote:
> FYI: I've just committed the patch below in the 2.6.16 tree.
>

Very appropriate, thanks.

NeilBrown

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d05e312..78cca0c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3662,7 +3662,7 @@ static int md_ioctl(struct inode *inode,
>  		if (cnt > 0 ) {
>  			printk(KERN_WARNING
>  			       "md: %s(pid %d) used deprecated START_ARRAY ioctl. "
> -			       "This will not be supported beyond July 2006\n",
> +			       "START_ARRAY is removed in kernel 2.6.19 and above.\n",
>  			       current->comm, current->pid);
>  			cnt--;
>  		}
