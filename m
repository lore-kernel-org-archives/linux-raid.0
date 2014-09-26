From: Chao Yu <chao2.yu@samsung.com>
Subject: RE: [PATCH] md: avoid potential long delay under pers_lock
Date: Fri, 26 Sep 2014 16:56:44 +0800
Message-ID: <004c01cfd967$fa1012d0$ee303870$@samsung.com>
References: <002801cfd892$696e39d0$3c4aad70$@samsung.com>
 <20140925165114.GE10814@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20140925165114.GE10814@khazad-dum.debian.net>
Content-language: zh-cn
Sender: linux-raid-owner@vger.kernel.org
To: 'Henrique de Moraes Holschuh' <hmh@hmh.eng.br>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: Henrique de Moraes Holschuh [mailto:hmh@hmh.eng.br]
> Sent: Friday, September 26, 2014 12:51 AM
> To: Chao Yu
> Cc: neilb@suse.de; linux-raid@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] md: avoid potential long delay under pers_lock
> 
> On Thu, 25 Sep 2014, Chao Yu wrote:
> > printk may cause long time lapse if value of printk_delay in sysctl is
> > configured large by user. If register_md_personality takes long time to print in
> > spinlock pers_lock, we may encounter high CPU usage rate when there are other
> > pers_lock competitors who may be blocked to spin.
> > We can avoid this condition by moving printk out of coverage of pers_lock
> > spinlock.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  drivers/md/md.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index e02de05..5fcf215 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -7200,9 +7200,10 @@ static const struct file_operations md_seq_fops = {
> >
> >  int register_md_personality(struct md_personality *p)
> >  {
> > +	printk(KERN_INFO "md: %s personality registered for level %d\n",
> > +						p->name, p->level);
> >  	spin_lock(&pers_lock);
> >  	list_add_tail(&p->list, &pers_list);
> > -	printk(KERN_INFO "md: %s personality registered for level %d\n", p->name, p->level);
> >  	spin_unlock(&pers_lock);
> >  	return 0;
> >  }
> 
> Wouldn't it make more sense to move the printk after the spin_unlock ?

As original printk msg in {,un}register_md_personality shows '{,un}registered'
which means the main job is done before printk, it's better to move the printk
after spin_unlock in both {,un}register_md_personality. But IMHO, it's another
minor issue, should we fix in this patch?

Thanks,
Yu

> 
> --
>   "One disk to rule them all, One disk to find them. One disk to bring
>   them all and in the darkness grind them. In the Land of Redmond
>   where the shadows lie." -- The Silicon Valley Tarot
>   Henrique Holschuh

