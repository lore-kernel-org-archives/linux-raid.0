From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC PATCH V1] raid1: rewrite the iobarrier
Date: Mon, 4 Mar 2013 14:18:07 +1100
Message-ID: <20130304141807.083e33a2@notabene.brown>
References: <2013012414023278904611@gmail.com>
	<20130206131653.27d025a6@notabene.brown>
	<2013022016540861404722@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Kiy9R4E7K9HXyOZo3wO/xo2"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2013022016540861404722@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/Kiy9R4E7K9HXyOZo3wO/xo2
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Feb 2013 16:54:12 +0800 majianpeng <majianpeng@gmail.com> wrote:

> >On Thu, 24 Jan 2013 14:02:52 +0800 majianpeng <majianpeng@gmail.com> wro=
te:
> >
> >> There is iobarrier in raid1 because two reason resync/recovery  or rec=
onfigure the array.
> >> At present,it suspend all nornal IO when reysync/recovey.
> >> But if nornal IO is outrange the resync/recovery windwos,it  don't nee=
d to iobarrier.
> >> So I rewrite the iobarrier.
> >> Because the reasons of barrier are two,so i use two different methods.
> >> First for resync/recovery, there is a reysnc window.The end position i=
s 'next_resync'.Because the resync depth is  RESYNC_DEPTH(32),
> >> so the start is 'next_resync - RESYNC_SECTOR * RESYNC_DEPTH'
> >> The nornal IO Will be divided into three categories by the location.
> >> a: before the start of resync window
> >> b: between the resync window
> >> c: after the end of resync window
> >> For a, it don't barrier.
> >> For b, it need barrier and used the original method
> >> For c, it don't barrier but it need record the minimum position.If nex=
t resync is larger this, resync action will suspend.Otherwise versa.
> >> I used rbtree to order those io.
> >>=20
> >> For the reason of reconfigure of the arrary,I proposed a concept "forc=
e_barrier".When there is force_barrier, all Nornam IO must be suspended.
> >>=20
> >> NOTE:
> >> Because this problem is also for raid10, but i only do it for raid1. I=
t is post out mainly to make sure it is=20
> >> going in the correct direction and hope to get some helpful comments f=
rom other guys.
> >> If the methods is accepted,i will send the patch for raid10.
> >>=20
> >> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> >
> >Hi,
> > thanks for this and sorry for the delay in replying.
> >
> Hi, sorroy for delay in replying.Thanks very much for your suggestion.
> >The patch is reasonably good, but there is room for improvement.
> >I would break it up into several patches which are easier to review.
> >
> >- Firstly, don't worry about the barrier for 'read' requests - it really
> >  isn't relevant for them (your patch didn't do this).
> >
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index bd6a188..2e5bf75 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -235,6 +235,7 @@ static void call_bio_endio(struct r1bio *r1_bio)
>         struct bio *bio =3D r1_bio->master_bio;
>         int done;
>         struct r1conf *conf =3D r1_bio->mddev->private;
> +       int rw =3D bio_data_dir(bio);
> =20
>         if (bio->bi_phys_segments) {
>                 unsigned long flags;
> @@ -253,7 +254,8 @@ static void call_bio_endio(struct r1bio *r1_bio)
>                  * Wake up any possible resync thread that waits for the =
device
>                  * to go idle.
>                  */
> -               allow_barrier(conf);
> +               if (rw =3D=3D WRITE)
> +                       allow_barrier(conf);
>         }
>  }
> =20
> @@ -1035,7 +1037,8 @@ static void make_request(struct mddev *mddev, struc=
t bio * bio)
>                 finish_wait(&conf->wait_barrier, &w);
>         }
> =20
> -       wait_barrier(conf);
> +       if (rw =3D=3D WRITE)
> +               wait_barrier(conf);
> =20
>         bitmap =3D mddev->bitmap;=02
>=20
> Above code is what's you said.But it met read-error,raid1d will blocked f=
or ever.
> The reason is freeze_array:
> >       wait_event_lock_irq_cmd(conf->wait_barrier,
> >                                conf->nr_pending =3D=3D conf->nr_queued+=
1,
> For read operation, it can't add nr_pending.
> Are you have good method to do this?

Only update nr_queued for Write requests, not for read requests?


>=20
> >- Secondly, find those places where raise_barrier() is used to reconfigu=
re
> >  the array and replace those with "freeze_array()".  I think that is sa=
fe,
> >  and it means that we don't need to pass a 'force' argument to
> >  'raise_barrier()' and 'lower_barrier()'.
> But it will be blocked for ever.
> The comment of freeze_array,
> > * This is called in the context of one normal IO request
> >	 * that has failed.
> In freeze_array,the judgement is
> >wait_event_lock_irq_cmd(conf->wait_barrier,
> >				conf->nr_pending =3D=3D conf->nr_queued+1,
> Because the place where call this func in io context,so there must be nr_=
pending.
> But for the flace where called reconfigure array don't  in io context.So =
the condition
> "conf->nr_pending =3D=3D conf->nr_queued+1" is never true.
> If we add a parameter 'int iocontext' to freeze_array, that is
> >static void freeze_array(struct r1conf *conf, int iocontext)
> >if (iocontext)
> >wait_event_lock_irq_cmd(conf->wait_barrier,
> >				conf->nr_pending =3D=3D conf->nr_queued+1,
> >  else
> > wait_event_lock_irq_cmd(conf->wait_barrier,
> >				conf->nr_pending =3D=3D conf->nr_queued,
>=20
> How about this method?

Probably makes sense - hard to tell without the full context of a complete
patch.


> >
> >- The rest might have to be all one patch, though if it could be done in=
 a
> >  couple of distinct stages that would be good.
> >  For the different positions (before, during, after), which you current=
ly
> >  call 0, 1, and 2 you should use an enum so they all have names.
> >=20
> Ok,thanks!

If you could blank lines around the text which is your reply, it would make
it a lot easier to find and to read.

> >  I don't really like the rbtree.  It adds an extra place where you take=
 the
> >  spinlock and causes more work to be done inside a spinlock.  And it is=
n't
> >  really needed.  Instead, you can have two R1BIO flags for "AFTER_RESYN=
C".
> >  One for requests that are more than 2 windows after, one for request t=
hat
> >  are less then 2 windows after (or maybe 3 windows or maybe 8..).  Each=
 of
> >  these has a corresponding count (as you already have: nr_after).
> >  Then when resync gets to the end of a window you wait until the count =
of=20
> For resync operation,there is no resync window.How to do this?

You aren't explaining yourself very well (again!).

> >  "less than 2 windows after" reaches zero, then atomically swap the mea=
ning
> >  of the two bits (toggle a bit somewhere).
> We don't know the nearset position from request which more than 2 windows=
 after.
> For example, there are three request after 2 windows.
> A is after three windows;B is after six windows; C is after 11 windows.
> When the count of "less than 2 windows after" reached zero, how to do?
> >  This should give you nearly the same effect with constant (not log-n)
> >  effort.
> >
>=20
> >Finally, have you done any testing, either to ensure there is no slow-do=
wn,
> >or to demonstrate some improvement?
> >
> I only used dd to test.There was no apparent performance degradation=20

There is no point reporting any results of a performance test without
actually giving numbers.


NeilBrown

>=20
> Thanks!
> Jianpeng Ma

--Sig_/Kiy9R4E7K9HXyOZo3wO/xo2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUTQSbznsnt1WYoG5AQJ8DxAAoi1Ywv3L+Jb/DMpVQcdzN5WDDLQYsbCf
29Ow4/aaBZFGPB0dlXqtFXeAzbrECbVBdoN3a2RYzNU9nWlx0z0I/go7QkuF6Y9p
qxFKwVXiHvfk7MwtpDCMMpS+zMFCaN8pv9PCZQNESLcFAHGVV5B36hNM3NnplfA0
hoahkL8kyLDjjwHx9wHt/jCYJdtfn3c58omCcw35OuR6c7yU6XNhGVvUvCUv25s4
6lH6cbjiDQofXMk7jiWEoBvaEkdaql9qRmrAQP2bmbskO37gqLeWBRSazNRdGDO9
KnjI6P8NLxSEPZB/BG8S8ugD6Txd65F5X67sOO0aRObBO7KLor/v9oui8kkYFfFe
kjrcvkW9sn2IEIOG6sSEvLFavjZSMJy4ZHaF0MmtnOWHVmiQioTGh7nzYEx9glvb
e+y217ee6fkQbMsQYKL7FDYON0EoVT9RWjuvBQZ1fj68HB4uBd0zohuVWihN6Sdb
Ty+qBbA2VR0MtPRh4BVRweZewhvEUt6sqSpmEnzxjIjJ1V+8FiE1EEyotNt3JHVV
u7jdkCCC4EPufG5BsS+tZQI+l1VwCr+H4QjIwGrfCeOwiWECpU1iWgrxNs/q1kqK
Lf2TAG4AgRo5TtFOauFE4xc9yGIDLTe1ouPChSrMhqKMCw7kFT2HDHlA9QQg/3TK
25ZGI5qlQaI=
=ogA4
-----END PGP SIGNATURE-----

--Sig_/Kiy9R4E7K9HXyOZo3wO/xo2--
