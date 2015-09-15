From: Neil Brown <neilb@suse.de>
Subject: Re: raid1 resync stuck
Date: Tue, 15 Sep 2015 10:05:02 +0200
Message-ID: <8737yg6rbl.fsf@notabene.neil.brown.name>
References: <wrfjmvwvz9ke.fsf@redhat.com> <wrfjsi6k4zqy.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjsi6k4zqy.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: majianpeng@gmail.com, linux-raid <linux-raid@vger.kernel.org>, nate.dailey@stratus.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Jes Sorensen <Jes.Sorensen@redhat.com> writes:

> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>> Neil,
>>
>> We're chasing a case where the raid1 code gets stuck during resync. Nate
>> is able to reproduce it much more reliably than me - so attaching his
>> reproducing script. Basically run it on an existing raid1 with internal
>> bitmap on rotating disk.
>>
>> Nate was able to bisect it to 79ef3a8aa1cb1523cc231c9a90a278333c21f761,
>> the original iobarrier rewrite patch, and it can be reproduced in
>> current Linus' top of trunk a794b4f3292160bb3fd0f1f90ec8df454e3b17b3.
>>
>> In Nate's analysis it hangs in raise_barrier():
>>
>> static void raise_barrier(struct r1conf *conf, sector_t sector_nr)
>> {
>> 	spin_lock_irq(&conf->resync_lock);
>>
>> 	/* Wait until no block IO is waiting */
>> 	wait_event_lock_irq(conf->wait_barrier, !conf->nr_waiting,
>> 			    conf->resync_lock);
>>
>> 	/* block any new IO from starting */
>> 	conf->barrier++;
>> 	conf->next_resync =3D sector_nr;
>>
>> 	/* For these conditions we must wait:
>> 	 * A: while the array is in frozen state
>> 	 * B: while barrier >=3D RESYNC_DEPTH, meaning resync reach
>> 	 *    the max count which allowed.
>> 	 * C: next_resync + RESYNC_SECTORS > start_next_window, meaning
>> 	 *    next resync will reach to the window which normal bios are
>> 	 *    handling.
>> 	 * D: while there are any active requests in the current window.
>> 	 */
>> 	wait_event_lock_irq(conf->wait_barrier,
>> 			    !conf->array_frozen &&
>> 			    conf->barrier < RESYNC_DEPTH &&
>> 			    conf->current_window_requests =3D=3D 0 &&
>> 			    (conf->start_next_window >=3D
>> 			     conf->next_resync + RESYNC_SECTORS),
>> 			    conf->resync_lock);
>>
>> crash> r1conf 0xffff882028f3e600 | grep -e array_frozen -e barrier -e st=
art_next_window -e next_resync
>>   barrier =3D 0x1,                      (conf->barrier < RESYNC_DEPTH)
>>   array_frozen =3D 0x0,                 (!conf->array_frozen)
>>   next_resync =3D 0x3000,
>>   start_next_window =3D 0x3000,
>>
>> ie. next_resync =3D=3D start_next_window, which will never wake up since
>> start_next_window is smaller than next_resync + RESYNC_SECTORS.
>>
>> Have you seen anything like this?
>
> Looking further at this together with Nate. It looks like you had a
> patch resolving something similar:

I hope you realize that this a confirming-instance of my hypothesis that
if I just ignore questions, the asker will eventually solve it
themselves?  Maybe I should just wait a bit longer...

>
> commit 669cc7ba77864e7b1ac39c9f2b2afb8730f341f4
> Author: NeilBrown <neilb@suse.de>
> Date:   Thu Sep 4 16:30:38 2014 +1000
>
>     md/raid1: clean up request counts properly in close_sync()
>=20=20=20=20=20
>     If there are outstanding writes when close_sync is called,
>     the change to ->start_next_window might cause them to
>     decrement the wrong counter when they complete.  Fix this
>     by merging the two counters into the one that will be decremented.
>=20=20=20=20=20
>     Having an incorrect value in a counter can cause raise_barrier()
>     to hangs, so this is suitable for -stable.
>=20=20=20=20=20
>     Fixes: 79ef3a8aa1cb1523cc231c9a90a278333c21f761
>     cc: stable@vger.kernel.org (v3.13+)
>     Signed-off-by: NeilBrown <neilb@suse.de>
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index ad0468c..a31c92b 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1545,8 +1545,13 @@ static void close_sync(struct r1conf *conf)
>         mempool_destroy(conf->r1buf_pool);
>         conf->r1buf_pool =3D NULL;
>=20=20
> +       spin_lock_irq(&conf->resync_lock);
>         conf->next_resync =3D 0;
>         conf->start_next_window =3D MaxSector;
> +       conf->current_window_requests +=3D
> +               conf->next_window_requests;
> +       conf->next_window_requests =3D 0;
> +       spin_unlock_irq(&conf->resync_lock);
>  }
>=20=20
> It looks to us like close_sync()'s conf->start_next_window =3D MaxSector
> results in wait_barrier() triggering this when the outstanding IO
> completes:
>
> 	if (bio && bio_data_dir(bio) =3D=3D WRITE) {
> 		if (bio->bi_sector >=3D
> 		    conf->mddev->curr_resync_completed) {
> 			if (conf->start_next_window =3D=3D MaxSector)
> 				conf->start_next_window =3D
> 					conf->next_resync +
> 					NEXT_NORMALIO_DISTANCE;
>
> putting us into the situation where raise_barrier()'s condition never
> completes:
>
> 	wait_event_lock_irq(conf->wait_barrier,
> 			    !conf->array_frozen &&
> 			    conf->barrier < RESYNC_DEPTH &&
> 			    conf->current_window_requests =3D=3D 0 &&
> 			    (conf->start_next_window >=3D
> 			     conf->next_resync + RESYNC_SECTORS),
> 			    conf->resync_lock);
>
> So the question is, is it wrong for close_sync() to be setting
> conf->start_next_window =3D MaxSector in the first place, or should it
> only be doing this once all outstanding I/O has completed?

I think it is right to set start_next_window =3D MaxSector, but I think it
is wrong to set ->next_resync =3D 0;

I think:
 close_sync() should set next_sync to some impossibly big number,
   but not quite MaxSector as we sometimes add RESYNC_SECTORS or
   NEXT_NORMALIO_DISTANCE.
   May mddev->resync_max_sectors would be sensible.  Then raid1_resize
   would need to update it though.
   Or maybe we should make MaxSector a bit smaller so it is safe to
   add to it. ((~(sector_t)0)>>1) ??

 wait_barrier() should include ->next_resync in its decision about
   setting start_next_window.  May just replace
   "mddev->curr_resync_completed" with "next_resync".

Can you try that?  Does it make sense to you too?

=20

>
> Nate tested a case where removing the MaxSector assignment from
> close_sync() but are there any side effects to doing that?

Probably.  Not sure off hand what they are though.  It certainly feels
untidy leaving start_next_window pointing in the middle of the array
when resync/recovery has stopped.

Thanks,
NeilBrown

>
> Cheers,
> Jes

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJV99EuAAoJEDnsnt1WYoG5n5wP/RhI2YG+u9wB6UC+oLM5GPiU
c05ulnhU8jR6nnsHxWhPEaAy33yw0SUgT83Ztv2HZaT5QCDtlrgLXiYzUUmHKBFT
xTzNVUZQ7suuQm2cjpq46W5yBQwV6oMS45GNiwJ0wRyQAJbq7vWFQWUTKgfdW0D9
JnUm9hJNM8q9I5ziw/7ZodIeltB3L0SCmHjftvq6p7PCuHonvVdHiE4KdH/H70MS
naQxCdzIbe7R/HGnA3SAzGfSrcFgNqYxvVaWOvVMDYwlZunQxJZsQ0NET79d7P+p
3D5VEgNYMuQ2gmRcjGzXycBhSVQI/5FvSdr9LpdkpI8KZTex22GVlvm3BUgX8G36
MqVRHNYJIODl0UyhXEf502pgh+Z2AytpTk/YSyJxHPzpySnTHujD60GeGWk85ktv
vvouwUIQizCGxYJvC8mHVxVHMcBbyhsvqw5sjw6yM05fL6oUfircnFe0z+k+owbd
dxlzhcn9iRK5QLLOAvZYs1InKE+R9/U0YkHf+u42+iySdkIZKDf0khaV8JoAjP2n
Z8QJZAtxZRripx1WOFO5ygcizxwaBXtBeNQCtkZOS7XmsnMUE9mLKFvtxFROPXT6
brYidb2Hna0pQOyBzgN4aOHt9AmxLST2DMtE42sf2xtuoMA7iM0UyvJf2j6Rj42p
wM/UrXALm+rXImFcvrCJ
=PG+R
-----END PGP SIGNATURE-----
--=-=-=--
