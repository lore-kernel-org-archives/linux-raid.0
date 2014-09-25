From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] md: avoid potential long delay under pers_lock
Date: Thu, 25 Sep 2014 13:51:15 -0300
Message-ID: <20140925165114.GE10814@khazad-dum.debian.net>
References: <002801cfd892$696e39d0$3c4aad70$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <002801cfd892$696e39d0$3c4aad70$@samsung.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chao Yu <chao2.yu@samsung.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 25 Sep 2014, Chao Yu wrote:
> printk may cause long time lapse if value of printk_delay in sysctl is
> configured large by user. If register_md_personality takes long time to print in
> spinlock pers_lock, we may encounter high CPU usage rate when there are other
> pers_lock competitors who may be blocked to spin.
> We can avoid this condition by moving printk out of coverage of pers_lock
> spinlock.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  drivers/md/md.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index e02de05..5fcf215 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7200,9 +7200,10 @@ static const struct file_operations md_seq_fops = {
>  
>  int register_md_personality(struct md_personality *p)
>  {
> +	printk(KERN_INFO "md: %s personality registered for level %d\n",
> +						p->name, p->level);
>  	spin_lock(&pers_lock);
>  	list_add_tail(&p->list, &pers_list);
> -	printk(KERN_INFO "md: %s personality registered for level %d\n", p->name, p->level);
>  	spin_unlock(&pers_lock);
>  	return 0;
>  }

Wouldn't it make more sense to move the printk after the spin_unlock ?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
