From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: Bisected: Kernel 4.14 + has 3 times higher write IO latency than
 Kernel 4.4 with raid1
Date: Wed, 7 Aug 2019 14:35:20 +0200
Message-ID: <CAMGffEm41+-DvUu_MhfbVURL_LOY8KP1QkTWDcFf7nyGLK7Y3A@mail.gmail.com>
References: <CAMGffEkotpvVz8FA78vNFh0qZv3kEMNrXXfVPEUC=MhH0pMCZA@mail.gmail.com>
 <0a83fde3-1a74-684c-0d70-fb44b9021f96@molgen.mpg.de> <CAMGffE=_kPoBmSwbxvrqdqbhpR5Cu2Vbe4ArGqm9ns9+iVEH_g@mail.gmail.com>
 <CAMGffEkcXcQC+kjwdH0iVSrFDk-o+dp+b3Q1qz4z=R=6D+QqLQ@mail.gmail.com>
 <87h86vjhv0.fsf@notabene.neil.brown.name> <CAMGffEnKXQJBbDS8Yi0S5ZKEMHVJ2_SKVPHeb9Rcd6oT_8eTuw@mail.gmail.com>
 <CAMGffEkfs0KsuWX8vGY==1dym78d6wsao_otSjzBAPzwGtoQcw@mail.gmail.com>
 <87blx1kglx.fsf@notabene.neil.brown.name> <CAMGffE=cpxumr0QqJsiGGKpmZr+4a0BiCx3n0_twa5KPs=yX1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMGffE=cpxumr0QqJsiGGKpmZr+4a0BiCx3n0_twa5KPs=yX1g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Neil F Brown <nfbrown@suse.com>, Alexandr Iarygin <alexandr.iarygin@cloud.ionos.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Paul Menzel <pmenzel@molgen.mpg.de>, linux-kernel@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Aug 7, 2019 at 8:36 AM Jinpu Wang <jinpu.wang@cloud.ionos.com> wrote:
>
> On Wed, Aug 7, 2019 at 1:40 AM NeilBrown <neilb@suse.com> wrote:
> >
> > On Tue, Aug 06 2019, Jinpu Wang wrote:
> >
> > > On Tue, Aug 6, 2019 at 9:54 AM Jinpu Wang <jinpu.wang@cloud.ionos.com> wrote:
> > >>
> > >> On Tue, Aug 6, 2019 at 1:46 AM NeilBrown <neilb@suse.com> wrote:
> > >> >
> > >> > On Mon, Aug 05 2019, Jinpu Wang wrote:
> > >> >
> > >> > > Hi Neil,
> > >> > >
> > >> > > For the md higher write IO latency problem, I bisected it to these commits:
> > >> > >
> > >> > > 4ad23a97 MD: use per-cpu counter for writes_pending
> > >> > > 210f7cd percpu-refcount: support synchronous switch to atomic mode.
> > >> > >
> > >> > > Do you maybe have an idea? How can we fix it?
> > >> >
> > >> > Hmmm.... not sure.
> > >> Hi Neil,
> > >>
> > >> Thanks for reply, detailed result in line.
> >
> > Thanks for the extra testing.
> > ...
> > > [  105.133299] md md0 in_sync is 0, sb_flags 2, recovery 3, external
> > > 0, safemode 0, recovery_cp 524288
> > ...
> >
> > ahh - the resync was still happening.  That explains why set_in_sync()
> > is being called so often.  If you wait for sync to complete (or create
> > the array with --assume-clean) you should see more normal behaviour.
> I've updated my tests accordingly, thanks for the hint.
> >
> > This patch should fix it.  I think we can do better but it would be more
> > complex so no suitable for backports to -stable.
> >
> > Once you confirm it works, I'll send it upstream with a
> > Reported-and-Tested-by from you.
> >
> > Thanks,
> > NeilBrown
>
> Thanks a lot, Neil, my quick test show, yes, it fixed the problem for me.
>
> I will run more tests to be sure, will report back the test result.
Hi Neil,

I've run our regression tests with your patch, everything works fine
as expected.

So Reported-and-Tested-by: Jack Wang <jinpu.wang@cloud.ionos.com>

Thank you for your quick fix.

The patch should go to stable 4.12+

Regards,
Jack Wang

>
> Regards,
> Jack Wang
>
> >
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 24638ccedce4..624cf1ac43dc 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -8900,6 +8900,7 @@ void md_check_recovery(struct mddev *mddev)
> >
> >         if (mddev_trylock(mddev)) {
> >                 int spares = 0;
> > +               bool try_set_sync = mddev->safemode != 0;
> >
> >                 if (!mddev->external && mddev->safemode == 1)
> >                         mddev->safemode = 0;
> > @@ -8945,7 +8946,7 @@ void md_check_recovery(struct mddev *mddev)
> >                         }
> >                 }
> >
> > -               if (!mddev->external && !mddev->in_sync) {
> > +               if (try_set_sync && !mddev->external && !mddev->in_sync) {
> >                         spin_lock(&mddev->lock);
> >                         set_in_sync(mddev);
> >                         spin_unlock(&mddev->lock);
