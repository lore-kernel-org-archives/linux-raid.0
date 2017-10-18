From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: use TASK_IDLE instead of blocking signals
Date: Thu, 19 Oct 2017 10:22:03 +1100
Message-ID: <87o9p4ghyc.fsf@notabene.neil.brown.name>
References: <alpine.LRH.2.02.1710181858530.32003@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1710181858530.32003@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>, Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 18 2017, Mikulas Patocka wrote:

> Hi - I submit this patch for the next merge window:
>
>
> Some times ago, I made a patch f9c79bc05a2a that blocks signals around the
> schedule() calls in MD. The MD subsystem needs to do an uninterruptible
> sleep that is not accounted in load average - so we block signals and use
> interruptible sleep.
>
> The kernel has a special TASK_IDLE state for this purpose, so we can use
> it instead of blocking signals. This patch doesn't fix any bug, it just
> makes the code simpler.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Thanks for doing this!  It has been on my mind to look at exactly this
possibility for a while but it never quite happened.  Now I don't need
to :-)

Acked-by: NeilBrown <neilb@suse.com>

Thanks,
NeilBrown


>
> ---
>  drivers/md/raid1.c |    7 +------
>  drivers/md/raid5.c |    7 +------
>  2 files changed, 2 insertions(+), 12 deletions(-)
>
> Index: linux-2.6/drivers/md/raid1.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/md/raid1.c
> +++ linux-2.6/drivers/md/raid1.c
> @@ -37,7 +37,6 @@
>  #include <linux/module.h>
>  #include <linux/seq_file.h>
>  #include <linux/ratelimit.h>
> -#include <linux/sched/signal.h>
>=20=20
>  #include <trace/events/block.h>
>=20=20
> @@ -1322,9 +1321,8 @@ static void raid1_write_request(struct m
>  		 */
>  		DEFINE_WAIT(w);
>  		for (;;) {
> -			sigset_t full, old;
>  			prepare_to_wait(&conf->wait_barrier,
> -					&w, TASK_INTERRUPTIBLE);
> +					&w, TASK_IDLE);
>  			if (bio_end_sector(bio) <=3D mddev->suspend_lo ||
>  			    bio->bi_iter.bi_sector >=3D mddev->suspend_hi ||
>  			    (mddev_is_clustered(mddev) &&
> @@ -1332,10 +1330,7 @@ static void raid1_write_request(struct m
>  				     bio->bi_iter.bi_sector,
>  				     bio_end_sector(bio))))
>  				break;
> -			sigfillset(&full);
> -			sigprocmask(SIG_BLOCK, &full, &old);
>  			schedule();
> -			sigprocmask(SIG_SETMASK, &old, NULL);
>  		}
>  		finish_wait(&conf->wait_barrier, &w);
>  	}
> Index: linux-2.6/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/md/raid5.c
> +++ linux-2.6/drivers/md/raid5.c
> @@ -55,7 +55,6 @@
>  #include <linux/ratelimit.h>
>  #include <linux/nodemask.h>
>  #include <linux/flex_array.h>
> -#include <linux/sched/signal.h>
>=20=20
>  #include <trace/events/block.h>
>  #include <linux/list_sort.h>
> @@ -5691,14 +5690,10 @@ static bool raid5_make_request(struct md
>  				 * wait.
>  				 */
>  				prepare_to_wait(&conf->wait_for_overlap,
> -						&w, TASK_INTERRUPTIBLE);
> +						&w, TASK_IDLE);
>  				if (logical_sector >=3D mddev->suspend_lo &&
>  				    logical_sector < mddev->suspend_hi) {
> -					sigset_t full, old;
> -					sigfillset(&full);
> -					sigprocmask(SIG_BLOCK, &full, &old);
>  					schedule();
> -					sigprocmask(SIG_SETMASK, &old, NULL);
>  					do_prepare =3D true;
>  				}
>  				goto retry;

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnn4hwACgkQOeye3VZi
gbmFJQ//UleUfdXIwRtC5IEwcpxBNHvXQIxfHC05PCaa66W5EI9kfSoupfG4vz9U
eXNl3SdrVHJf//z9hqNfxczgfNmoXSucYCpz2y5P0kugoe/HEs6XOheB3bznD8ss
4lcXb0I1J5ORltp16cvheN9f7Rn7fKFOP0RGu/pXdS/zKqtKxXobnZWZG2MoglMS
Dw5t7xYAiB3p9ePQFdBglfEamEECiuI0U8anxlEuBAFIHPTDP3GuFbyrPGSE7te0
eb1A2nG4o+UTg1rOP1nsXQOlZt3yF6f1NI+BVTm1svn3TPbXMtMC+BuJFlquwkGU
ZotuhU2dsoEnycRq3bcwJhUifY8WjtZsoMr2TamiSWs4zqwJmY46P7ep27yyhrez
tJvDGRqWq3Kpa5sB68Gg5BXcmXEAVuxE3ZOYQnvMFWW103x56gh7ZLQswQjPkypE
icY95rKxMlC1YJFzJcKllD5SqFNsDCt2M6IM7yiRPilx2/KDdgjjynkKhh1VxPGu
ifiS9k8tYq9wGdDukrg9rC3+VdWIokgsHrBf8IBysWVZ1xgNi8S/RHQhv1Gp1j9u
N4Cdcolf/XyE9hfTxm2WUoQsBzyCDklhmseFpVaIwqVXTI6uAL7njIPBW4uS3yJO
kYYAhFiyNwxnzyVsbwDDPXOY9A8Wz755OuFIr4NdzvR5puSB0QQ=
=Ojcu
-----END PGP SIGNATURE-----
--=-=-=--
