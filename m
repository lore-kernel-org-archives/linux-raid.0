From: Sergey Vidishev <sergeyv@yandex-team.ru>
Subject: Re: [PATCH v2] mdadm: monitor: fix nullptr dereference when get_md_name() returns NULL
Date: Tue, 19 May 2015 21:39 +0300
Message-ID: <1916694.4Z1o92rJfN@sergeyv_box>
References: <1531453.K804EMet0W@sergeyv_box> <1591364.ylu2LGHCpE@sergeyv> <CAGRSmLuzqwn=7LQZx_CA1VE4SsGTHMEWU-TJkuHUeeaa8XUQ1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRSmLuzqwn=7LQZx_CA1VE4SsGTHMEWU-TJkuHUeeaa8XUQ1Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David F." <df7729@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

On 18.05.15 at 18:42:22, David F. <df7729@gmail.com> wrote:
> not sure if that causes a memory leak since st not freed ?

You're right, thanks! 

Also I did reviewed the code and replaced return with continue since it's more 
correct to skip an mse's (if get_md_name() returned NULL for it) instead of 
return.

I'll resend the patch.

> On Mon, May 18, 2015 at 4:33 PM, Sergey Vidishev <sergeyv@yandex-team.ru> 
wrote:
> > From c1e59424bfabee349aa7b8b903833475a56cf145 Mon Sep 17 00:00:00 2001
> > From: Sergey Vidishev <sergeyv@yandex-team.ru>
> > Date: Wed, 8 Oct 2014 21:51:03 +0400
> > Subject: [PATCH] mdadm: monitor: fix nullptr dereference when
> > get_md_name()
> > 
> >  returns NULL
> > 
> > Function add_new_arrays() expects that function get_md_name() should
> > return pointer to devname, but also get_md_name() may return NULL. So
> > check the pointer before use it in add_new_arrays().
> > 
> > Signed-off-by: Sergey Vidishev <sergeyv@yandex-team.ru>
> > ---
> > 
> > v1 -> v2: more verbose commit message
> > 
> > This patch against fresh git://neil.brown.name/mdadm.
> > I'm not subscribed to the list, please CC me in replies.
> > 
> >  Monitor.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Monitor.c b/Monitor.c
> > index 1cd378b..1bbaf89 100644
> > --- a/Monitor.c
> > +++ b/Monitor.c
> > @@ -687,6 +687,7 @@ static int add_new_arrays(struct mdstat_ent *mdstat,
> > struct state **statelist,> 
> >  {
> >  
> >         struct mdstat_ent *mse;
> >         int new_found = 0;
> > 
> > +       char *name;
> > 
> >         for (mse=mdstat; mse; mse=mse->next)
> >         
> >                 if (mse->devnm[0] &&
> > 
> > @@ -697,7 +698,12 @@ static int add_new_arrays(struct mdstat_ent *mdstat,
> > struct state **statelist,> 
> >                         struct state *st = xcalloc(1, sizeof *st);
> >                         mdu_array_info_t array;
> >                         int fd;
> > 
> > -                       st->devname = xstrdup(get_md_name(mse->devnm));
> > +
> > +                       name = get_md_name(mse->devnm);
> > +                       if (!name)
> > +                               return 0;
> > +
> > +                       st->devname = xstrdup(name);
> > 
> >                         if ((fd = open(st->devname, O_RDONLY)) < 0 ||
> >                         
> >                             ioctl(fd, GET_ARRAY_INFO, &array)< 0) {
> >                             
> >                                 /* no such array */
> > 
> > --
> > 1.9.1
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

