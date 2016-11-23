From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/2] raid5-cache: suspend reclaim thread instead of shutdown
Date: Wed, 23 Nov 2016 13:41:45 +1100
Message-ID: <87twayc3yu.fsf@notabene.neil.brown.name>
References: <598ff2610261ffa745b682c311d5300fefeb2fcc.1479751751.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <598ff2610261ffa745b682c311d5300fefeb2fcc.1479751751.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 22 2016, Shaohua Li wrote:

> There is mechanism to suspend a kernel thread. Use it instead of playing
> create/destroy game.

Good idea!

>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/md.c          |  4 +++-
>  drivers/md/raid5-cache.c | 18 +++++-------------
>  2 files changed, 8 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d3cef77..f548469 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7136,10 +7136,12 @@ static int md_thread(void *arg)
>  		wait_event_interruptible_timeout
>  			(thread->wqueue,
>  			 test_bit(THREAD_WAKEUP, &thread->flags)
> -			 || kthread_should_stop(),
> +			 || kthread_should_stop() || kthread_should_park(),
>  			 thread->timeout);
>=20=20
>  		clear_bit(THREAD_WAKEUP, &thread->flags);
> +		if (kthread_should_park())
> +			kthread_parkme();
>  		if (!kthread_should_stop())
>  			thread->run(thread);
>  	}
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 8cb79fc..5f817bd 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -19,6 +19,7 @@
>  #include <linux/raid/md_p.h>
>  #include <linux/crc32c.h>
>  #include <linux/random.h>
> +#include <linux/kthread.h>
>  #include "md.h"
>  #include "raid5.h"
>  #include "bitmap.h"
> @@ -1437,23 +1438,14 @@ void r5l_quiesce(struct r5l_log *log, int state)
>  	struct mddev *mddev;
>  	if (!log || state =3D=3D 2)
>  		return;
> -	if (state =3D=3D 0) {
> -		/*
> -		 * This is a special case for hotadd. In suspend, the array has
> -		 * no journal. In resume, journal is initialized as well as the
> -		 * reclaim thread.
> -		 */
> -		if (log->reclaim_thread)
> -			return;
> -		log->reclaim_thread =3D md_register_thread(r5l_reclaim_thread,
> -					log->rdev->mddev, "reclaim");
> -		log->reclaim_thread->timeout =3D R5C_RECLAIM_WAKEUP_INTERVAL;
> -	} else if (state =3D=3D 1) {
> +	if (state =3D=3D 0)
> +		kthread_unpark(log->reclaim_thread->tsk);

The old code tested for log->reclaim_thread being NULL.  This new
version will just crash.


> +	else if (state =3D=3D 1) {
>  		/* make sure r5l_write_super_and_discard_space exits */
>  		mddev =3D log->rdev->mddev;
>  		wake_up(&mddev->sb_wait);
> +		kthread_park(log->reclaim_thread->tsk);

r5l_do_reclaim has a wait loop internally.  I think you need that to
abort when kthread_should_park(), else this will block indefinitely.

Thanks,
NeilBrown


>  		r5l_wake_reclaim(log, MaxSector);
> -		md_unregister_thread(&log->reclaim_thread);
>  		r5l_do_reclaim(log);
>  	}
>  }
> --=20
> 2.9.3

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYNQHpAAoJEDnsnt1WYoG5l3sP/RCwcSdTuDCresAGAB7mIeQ6
inFcFWkcxMmZW5dGNJlbT8exwJvFOVTWcx695PcCtaOiTSaIwbcWxontnNODUBXQ
BzlYALbIDexQdHUp/Wy4B74V6MW5BE0jxG7RoL46Lxhktrsp3DoKOQKVSgXDBsyM
0/PtO5u9xj0BRBBwgEMJb9ZkzzoHhMBfevxqHytzZ1BzO3Z/sOb6gNCzu8CUfDni
jd1jkFRtf/krKahW8A+O3NYy3UTHWnggqkZPypLFxEGoyYjZWpk3QsT+GtnmDR33
Ij7RBlZ4hxhBrlpqfiEjKn4W5jtTsYiseMo3mbOXSn33BmYkQx0w5C8OVbG3aWiZ
4NWcMOAZiHnS/zYSmAzPocTHsOGTb6ecvuhMBRIRz3HModvrm+RpTHrmGBnjc5t/
wHOb6IrYV34SZcRR3xSZs53XgJAwQJeAxluwpgIT9VHjyDjekOTJd0BnJFKHDuVh
BhoQMsRVEvQJwqsbAPKZmEDAIVeXYM6u0a6w0OD37uz7kAY6qV42TBW6HnLNjiHP
Ohxhsfm3x9NjsgsePtuVhrDh0tFnWoRSnM8V8EWkqJ9Cz4qom6AfHIbij9WQkLYy
IK1o1W1h7kdFULEVyUl7TjfPCbxtgs9gaiZCur5Fe9klF0MVWKPrdGOVdzv3PLvx
Fv69OAhgE3BmcrUf0KwS
=Iad6
-----END PGP SIGNATURE-----
--=-=-=--
