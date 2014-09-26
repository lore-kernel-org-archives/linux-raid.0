From: Chao Yu <chao2.yu@samsung.com>
Subject: RE: [PATCH] md: avoid potential long delay under pers_lock
Date: Fri, 26 Sep 2014 16:59:47 +0800
Message-ID: <004d01cfd968$513d6d00$f3b84700$@samsung.com>
References: <002801cfd892$696e39d0$3c4aad70$@samsung.com>
 <20140926103620.7c397832@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20140926103620.7c397832@notabene.brown>
Content-language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
To: 'NeilBrown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Friday, September 26, 2014 8:36 AM
> To: Chao Yu
> Cc: linux-raid@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] md: avoid potential long delay under pers_lock
> 
> On Thu, 25 Sep 2014 15:28:34 +0800 Chao Yu <chao2.yu@samsung.com> wrote:
> 
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
> I'm not sure I see the pressing need for this - have you noticed actual
> problems?

Haven't, I found this by code review.

Thanks,
Yu

> However it seems to make sense so I've applied it.
> 
> Thanks,
> NeilBrown
