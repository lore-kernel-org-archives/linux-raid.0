From: Song Liu <liu.song.a23@gmail.com>
Subject: Re: [PATCH] md: Fix failed allocation of md_register_thread
Date: Tue, 12 Mar 2019 10:22:04 -0700
Message-ID: <CAPhsuW5JDsRZSJY+AggEMkk59kt025NLeTV6zC2fpfv9_qTw-g@mail.gmail.com>
References: <20190304224854.12494-1-pakki001@umn.edu> <854b0e4a-35e4-4666-5d05-c1f9ffaceae8@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <854b0e4a-35e4-4666-5d05-c1f9ffaceae8@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: Aditya Pakki <pakki001@umn.edu>, kjlu@umn.edu, Shaohua Li <shli@kernel.org>, linux-raid <linux-raid@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Mar 7, 2019 at 7:13 PM Guoqing Jiang <gqjiang@suse.com> wrote:
>
>
>
> On 3/5/19 6:48 AM, Aditya Pakki wrote:
> > mddev->sync_thread can be set to NULL on kzalloc failure downstream.
> > The patch checks for such a scenario and frees allocated resources.
> >
> > Signed-off-by: Aditya Pakki <pakki001@umn.edu>

Applied to https://github.com/liu-song-6/linux/tree/for-5.1/md-post

@Guoqing, I added your Acked-by to the commit and also the raid5 fix.

Thanks,
Song

> > ---
> >   drivers/md/raid10.c | 2 ++
> >   1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> > index abb5d382f64d..f52b4d9bcd24 100644
> > --- a/drivers/md/raid10.c
> > +++ b/drivers/md/raid10.c
> > @@ -3939,6 +3939,8 @@ static int raid10_run(struct mddev *mddev)
> >               set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
> >               mddev->sync_thread = md_register_thread(md_do_sync, mddev,
> >                                                       "reshape");
> > +             if (!mddev->sync_thread)
> > +                     goto out_free_conf;
> >       }
> >
> >       return 0;
>
> Could you make the change for raid5 as well? It also doesn't check the
> failure
> in raid5_run.
>
> Thanks,
> Guoqing
