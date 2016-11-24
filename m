From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/2] raid5-cache: suspend reclaim thread instead of shutdown
Date: Thu, 24 Nov 2016 11:00:15 +1100
Message-ID: <87oa15bvcg.fsf@notabene.neil.brown.name>
References: <598ff2610261ffa745b682c311d5300fefeb2fcc.1479751751.git.shli@fb.com> <87twayc3yu.fsf@notabene.neil.brown.name> <20161123063017.GA41488@shli-mbp.local>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161123063017.GA41488@shli-mbp.local>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 23 2016, Shaohua Li wrote:

> On Wed, Nov 23, 2016 at 01:41:45PM +1100, NeilBrown wrote:
>> On Tue, Nov 22 2016, Shaohua Li wrote:
>>=20
>> > There is mechanism to suspend a kernel thread. Use it instead of playi=
ng
>> > create/destroy game.
>>=20
>> Good idea!
>>=20
>> >
>> > Signed-off-by: Shaohua Li <shli@fb.com>
>> > ---
>> >  drivers/md/md.c          |  4 +++-
>> >  drivers/md/raid5-cache.c | 18 +++++-------------
>> >  2 files changed, 8 insertions(+), 14 deletions(-)
>> >
>> > diff --git a/drivers/md/md.c b/drivers/md/md.c
>> > index d3cef77..f548469 100644
>> > --- a/drivers/md/md.c
>> > +++ b/drivers/md/md.c
>> > @@ -7136,10 +7136,12 @@ static int md_thread(void *arg)
>> >  		wait_event_interruptible_timeout
>> >  			(thread->wqueue,
>> >  			 test_bit(THREAD_WAKEUP, &thread->flags)
>> > -			 || kthread_should_stop(),
>> > +			 || kthread_should_stop() || kthread_should_park(),
>> >  			 thread->timeout);
>> >=20=20
>> >  		clear_bit(THREAD_WAKEUP, &thread->flags);
>> > +		if (kthread_should_park())
>> > +			kthread_parkme();
>> >  		if (!kthread_should_stop())
>> >  			thread->run(thread);
>> >  	}
>> > diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
>> > index 8cb79fc..5f817bd 100644
>> > --- a/drivers/md/raid5-cache.c
>> > +++ b/drivers/md/raid5-cache.c
>> > @@ -19,6 +19,7 @@
>> >  #include <linux/raid/md_p.h>
>> >  #include <linux/crc32c.h>
>> >  #include <linux/random.h>
>> > +#include <linux/kthread.h>
>> >  #include "md.h"
>> >  #include "raid5.h"
>> >  #include "bitmap.h"
>> > @@ -1437,23 +1438,14 @@ void r5l_quiesce(struct r5l_log *log, int stat=
e)
>> >  	struct mddev *mddev;
>> >  	if (!log || state =3D=3D 2)
>> >  		return;
>> > -	if (state =3D=3D 0) {
>> > -		/*
>> > -		 * This is a special case for hotadd. In suspend, the array has
>> > -		 * no journal. In resume, journal is initialized as well as the
>> > -		 * reclaim thread.
>> > -		 */
>> > -		if (log->reclaim_thread)
>> > -			return;
>> > -		log->reclaim_thread =3D md_register_thread(r5l_reclaim_thread,
>> > -					log->rdev->mddev, "reclaim");
>> > -		log->reclaim_thread->timeout =3D R5C_RECLAIM_WAKEUP_INTERVAL;
>> > -	} else if (state =3D=3D 1) {
>> > +	if (state =3D=3D 0)
>> > +		kthread_unpark(log->reclaim_thread->tsk);
>>=20
>> The old code tested for log->reclaim_thread being NULL.  This new
>> version will just crash.
>
> But the reclaim_thread couldn't be NULL if log !=3D NULL. Am I missing an=
ything?

Yes, you are right.  The old code had a test that the new code didn't,
which rang warning bells for me.
Both now that we don't de-register the thread in r5l_quiesce(),
log->reclaim_thread will never be NULL, so the test isn't needed.


>=20=20
>> > +	else if (state =3D=3D 1) {
>> >  		/* make sure r5l_write_super_and_discard_space exits */
>> >  		mddev =3D log->rdev->mddev;
>> >  		wake_up(&mddev->sb_wait);
>> > +		kthread_park(log->reclaim_thread->tsk);
>>=20
>> r5l_do_reclaim has a wait loop internally.  I think you need that to
>> abort when kthread_should_park(), else this will block indefinitely.
>
> Sounds not harmful to me. The loop in r5l_do_reclaim will eventually end =
if all
> data is reclaimed. Then the thread will be in the md_thread() loop. In th=
at
> loop, the thread will not sleep because the wait checks kthread_should_pa=
rk().
> Then the thread will get parked.

Maybe ... it just looks odd.
what is that while(1) {} loop really waiting for?  It waits for there to
be more than reclaim_target work to do, or for all the _ios lists to be
empty. By the time r5l_quiesce() is called, all active stripes should
have drained, so I guess that will abort quickly.
Why is it waiting there, rather than in md_thread()?  Why do we need
that loop?

Thanks,
NeilBrown

>
> Thanks,
> Shaohua

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYNi2PAAoJEDnsnt1WYoG5xKYP/0ni80VOUI2Osd8nHDiEfyKp
9aAvcOZDFZza0jgunG0vxUzEpjJcLqxCDF8ccnIq4xJKQyTcP2HM5UxVZzn1IEXm
XRnZKCvJkuqJaldjo0UG1C0QhvXVAQEesv5Aapb4gG46Kclo96pf4pJ3pbNvR5h1
2yOTrVU6J/HczbLWHelUsh8fc5goizJOYKs/WBtszyODpwXvZK/r3aU2Eo5wzKbc
vxB8kahLuGbjO4XQWKgXxUGxw886MbZxrAjb0FXMM4nHuoquWXP15Ft37u7Pomda
n6Tgacg1OGs7oo6jinzr8qlbzb+n9N5CqHZRhfzw78cq+9bsKMii1nrHHPu6z5Np
PGNEvB41/DB2XCMAQe1k0YunOnO4pYvxVfIWKux7P++DJNJntnnR/MFlwvQucVTA
yCDI8mQ+pGJ30+2GC/XuqX2oO3iS+rfeUM8+U5g88XHgpzdZOZqUDtjnoASGct2E
W5bLOs2iCbvpkvGgBShvGg4GsFxorzZCzXnGf48is6wIG4EnucwBoUJ+V7MsFHVJ
2piLfY8FJdwea76LJIWXcrKT5YBUxTIZ9rq3OcShhEWm24GJyD9tAABtEtTRUTsB
BsSg4Ivic7GnOoyDzVeAMIkVUwNZAigH+QA8f70NYm/COeDDwIVnBIlaW+F1db6P
E4qRFTgXGEWBsm6CRymt
=/Wzw
-----END PGP SIGNATURE-----
--=-=-=--
