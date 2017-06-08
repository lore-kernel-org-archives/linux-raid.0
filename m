From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: don't use flush_signals in userspace processes
Date: Thu, 08 Jun 2017 16:59:03 +1000
Message-ID: <87h8zrart4.fsf@notabene.neil.brown.name>
References: <alpine.LRH.2.02.1706071834250.22850@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1706071834250.22850@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Jun 07 2017, Mikulas Patocka wrote:

> The function flush_signals clears all pending signals for the process. It
> may be used by kernel threads when we need to prepare a kernel thread for
> responding to signals. However using this function for an userspaces
> processes is incorrect - clearing signals without the program expecting it
> can cause misbehavior.
>
> The raid1 and raid5 code uses flush_signals in its request routine because
> it wants to prepare for an interruptible wait. This patch drops
> flush_signals and uses sigprocmask instead to block all signals (including
> SIGKILL) around the schedule() call. The signals are not lost, but the
> schedule() call won't respond to them.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org

Thanks for catching that!

Acked-by: NeilBrown <neilb@suse.com>

NeilBrown


>
> ---
>  drivers/md/raid1.c |    5 ++++-
>  drivers/md/raid5.c |    5 ++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
> Index: linux-4.12-rc4/drivers/md/raid1.c
> ===================================================================
> --- linux-4.12-rc4.orig/drivers/md/raid1.c
> +++ linux-4.12-rc4/drivers/md/raid1.c
> @@ -1335,7 +1335,7 @@ static void raid1_write_request(struct m
>  		 */
>  		DEFINE_WAIT(w);
>  		for (;;) {
> -			flush_signals(current);
> +			sigset_t full, old;
>  			prepare_to_wait(&conf->wait_barrier,
>  					&w, TASK_INTERRUPTIBLE);
>  			if (bio_end_sector(bio) <= mddev->suspend_lo ||
> @@ -1345,7 +1345,10 @@ static void raid1_write_request(struct m
>  				     bio->bi_iter.bi_sector,
>  				     bio_end_sector(bio))))
>  				break;
> +			sigfillset(&full);
> +			sigprocmask(SIG_BLOCK, &full, &old);
>  			schedule();
> +			sigprocmask(SIG_SETMASK, &old, NULL);
>  		}
>  		finish_wait(&conf->wait_barrier, &w);
>  	}
> Index: linux-4.12-rc4/drivers/md/raid5.c
> ===================================================================
> --- linux-4.12-rc4.orig/drivers/md/raid5.c
> +++ linux-4.12-rc4/drivers/md/raid5.c
> @@ -5693,12 +5693,15 @@ static void raid5_make_request(struct md
>  				 * userspace, we want an interruptible
>  				 * wait.
>  				 */
> -				flush_signals(current);
>  				prepare_to_wait(&conf->wait_for_overlap,
>  						&w, TASK_INTERRUPTIBLE);
>  				if (logical_sector >= mddev->suspend_lo &&
>  				    logical_sector < mddev->suspend_hi) {
> +					sigset_t full, old;
> +					sigfillset(&full);
> +					sigprocmask(SIG_BLOCK, &full, &old);
>  					schedule();
> +					sigprocmask(SIG_SETMASK, &old, NULL);
>  					do_prepare = true;
>  				}
>  				goto retry;

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlk49bkACgkQOeye3VZi
gbkErw//b1YtHYBkV9LsbkZjqWVxwLWyVtHqDDJ3mxK/0sYDknke4+coV7YBVFJM
wAgI+DXK4RKe4tEZ0prQQA1OxDJ9Iz1Hdh86SF6ryki8bPTkacoIjnMN3okBQDYm
qL9WR1G2RCECrpommTW/n8iAomdCkAK5UoW8lkZu1brI2hftxPnwq4d/Cq5KVWnq
smtVAhH0m4wVLdXRqgdDRp3sk5jW/vTuy0yxueYA02YaPDiArn9Yj68qWFhBtl08
L4dqAn8kKpoHYID4fCMjpy42sinooG+V0hGIvkktrRs8vpAvr72JPv+NCeY3Tsht
C+d8COBDeG/651D8WbL+0Y2ehPqcZw5yc+tqVR8k824yaYP/gtJ/ueZpYtsVmC3M
t77pRru0afKE4lujvzcMF+52NytMHDoAmsl7cSCSyTqCE8cRp0CTzPFul4jF6G4I
cgFGjrkgtdLfSgvU+HQgUlMlllaq/c0ksvq0ZlXOf+90vfSx/3RYoARbgMO1HUOa
kUJ4rJ/hT+bqR18Ew7+L2HCJbfOm8yyp26LF2g3pB+6PZM3Bc6DNTtjF3u/28aLR
jKEurjG9V8k6WsYa3CYqx1wABUQcxYUfhXSNgxRRBVt8IFKoP7FTnfV1Ib71PMRZ
z3m4uPNbezePrjsW9fZIeQD64lQpDyJo15FM3pZ9j/DtGM7JTts=
=Aq/m
-----END PGP SIGNATURE-----
--=-=-=--
