From: Song Liu <liu.song.a23@gmail.com>
Subject: Re: [PATCH 1/1] md/raid10: avoid deadlock on recovery.
Date: Tue, 21 Jul 2020 23:18:19 -0700
Message-ID: <CAPhsuW5mSbNNspW2tPy-RZW0MmqZkEfsGzLPh1EvXkzW=eS1vg@mail.gmail.com>
References: <1583259280-124995-1-git-send-email-vmayatskikh@digitalocean.com>
 <1583259280-124995-2-git-send-email-vmayatskikh@digitalocean.com> <D5A36675-8344-4D67-9836-64F9BA78D78E@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D5A36675-8344-4D67-9836-64F9BA78D78E@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nigel Croxon <ncroxon@redhat.com>
Cc: Vitaly Mayatskikh <vmayatskikh@digitalocean.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jul 21, 2020 at 7:26 AM Nigel Croxon <ncroxon@redhat.com> wrote:
>
>
> > On Mar 3, 2020, at 1:14 PM, Vitaly Mayatskikh <vmayatskikh@digitalocean=
.com> wrote:
> >
> > When disk failure happens and the array has a spare drive, resync threa=
d
> > kicks in and starts to refill the spare. However it may get blocked by
> > a retry thread that resubmits failed IO to a mirror and itself can get
> > blocked on a barrier raised by the resync thread.
> >
> > Signed-off-by: Vitaly Mayatskikh <vmayatskikh@digitalocean.com>
> > ---
> > drivers/md/raid10.c | 14 +++++++++++---
> > 1 file changed, 11 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> > index ec136e4..f1a8e26 100644
> > --- a/drivers/md/raid10.c
> > +++ b/drivers/md/raid10.c
> > @@ -980,6 +980,7 @@ static void wait_barrier(struct r10conf *conf)
> > {
> >       spin_lock_irq(&conf->resync_lock);
> >       if (conf->barrier) {
> > +             struct bio_list *bio_list =3D current->bio_list;
> >               conf->nr_waiting++;
> >               /* Wait for the barrier to drop.
> >                * However if there are already pending
> > @@ -994,9 +995,16 @@ static void wait_barrier(struct r10conf *conf)
> >               wait_event_lock_irq(conf->wait_barrier,
> >                                   !conf->barrier ||
> >                                   (atomic_read(&conf->nr_pending) &&
> > -                                  current->bio_list &&
> > -                                  (!bio_list_empty(&current->bio_list[=
0]) ||
> > -                                   !bio_list_empty(&current->bio_list[=
1]))),
> > +                                  bio_list &&
> > +                                  (!bio_list_empty(&bio_list[0]) ||
> > +                                   !bio_list_empty(&bio_list[1]))) ||
> > +                                  /* move on if recovery thread is
> > +                                   * blocked by us
> > +                                   */
> > +                                  (conf->mddev->thread->tsk =3D=3D cur=
rent &&
> > +                                   test_bit(MD_RECOVERY_RUNNING,
> > +                                            &conf->mddev->recovery) &&
> > +                                   conf->nr_queued > 0),
> >                                   conf->resync_lock);
> >               conf->nr_waiting--;
> >               if (!conf->nr_waiting)
> > =E2=80=94
> > 1.8.3.1
> >
>
> Song, Have you had a chance to look at this patch?
> We would like to have it pulled in to the kernel.

I am sorry I missed this one. This looks good to me.

Nigel, would you like to add your Reviewed-by, or Acked-by, or Tested-by ta=
g?

Thanks,
Song
