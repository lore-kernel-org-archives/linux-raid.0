From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH] md/bitmap: use mddev_suspend/resume instead of ->quiesce()
Date: Mon, 8 Oct 2018 10:23:41 +0200
Message-ID: <CAMGffEk=XmRpRpTK1MKMykfJc8F7ZbUP5=ULPx2aM80V+i2-tQ@mail.gmail.com>
References: <1538035677-20770-1-git-send-email-jinpuwang@gmail.com> <20180928183044.GA12491@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180928183044.GA12491@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Wang Jinpu <xjtuwjp@gmail.com>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Sep 28, 2018 at 8:30 PM Shaohua Li <shli@kernel.org> wrote:
>
> On Thu, Sep 27, 2018 at 10:07:57AM +0200, Jack Wang wrote:
> > From: Jack Wang <jinpu.wang@profitbricks.com>
> >
> > After 9e1cc0a54556 ("md: use mddev_suspend/resume instead of ->quiesce(=
)")
> > We still have similar left in bitmap functions.
> >
> > Replace quiesce() with mddev_suspend/resume.
> >
> > Also move md_bitmap_create out of mddev_suspend. and move mddev_resume
> > after md_bitmap_destroy. as we did in set_bitmap_file.
> >
> > Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
> > Reviewed-by: Gioh Kim <gi-oh.kim@profitbricks.com>
> >
> > ---
> > v2->v1: add reviewed-by.
> > ---
> >  drivers/md/md-bitmap.c | 13 +++++++------
> >  1 file changed, 7 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> > index 2fc8c113977f..c369f1753ea6 100644
> > --- a/drivers/md/md-bitmap.c
> > +++ b/drivers/md/md-bitmap.c
> > @@ -2123,7 +2123,7 @@ int md_bitmap_resize(struct bitmap *bitmap, secto=
r_t blocks,
> >       }
> >
> >       if (!init)
> > -             bitmap->mddev->pers->quiesce(bitmap->mddev, 1);
> > +             mddev_suspend(bitmap->mddev);
>
>
> mddev_suspend is supposed to be called with reconfig_mutex hold. At least=
 one
> place this isn't true with this change, for example, raid_preresume doesn=
't
> call md_bitmap_resize with the lock hold. Could you please double check t=
he
> lock usage?
You're right, I missed this one, will double check.

Thanks for review!



--=20
Jack Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang@profitbricks.com
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss, Matthias Steinberg, Christoph Steff=
ens
