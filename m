From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 02/12] raid5-cache: free I/O units earlier
Date: Tue, 15 Sep 2015 09:00:31 +0200
Message-ID: <87d1xk6ub4.fsf@notabene.neil.brown.name>
References: <1442038638-6947-1-git-send-email-hch@lst.de> <1442038638-6947-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1442038638-6947-3-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Christoph Hellwig <hch@lst.de> writes:

> There is no good reason to keep the I/O unit structures around after the
> stripe has been written back to the RAID array.  The only information
> we need is the log sequence number, and the checkpoint offset of the
> highest successfull writeback.  Store those in the log structure, and
> free the IO units from __r5l_stripe_write_finished.
>
> Besides simplifying the code this also avoid having to keep the allocation
> for the I/O unit around for a potentially long time as superblock updates
> that checkpoint the log do not happen very often.

This only saves the allocation for two I/O units doesn't it?  So not a
big saveding, but still a good clean-up.

>
> This also fixes the previously incorrect calculation of 'free' in
> r5l_do_reclaim as a side effect: previous if took the last unit which
> isn't checkpointed into account.

It took me a while to see that - so just to be sure I understand.

There is a list of I/O units which have been completely written to the
log and to the RAID.  The last one of these is used as a marker for the
start of the log, so it cannot be freed yet.  All the earlier ones can
be freed.
The previous code added up the sizes of all of the units in this list,
so it incorrectly included that last unit.
Your new code calculates the difference between the start of the first
unit and the start of the last unit, and so correctly excluded the last
unit from the free space calculation.

Did I get that right?

> @@ -690,60 +675,41 @@ static void r5l_do_reclaim(struct r5l_log *log)
>  	 * shouldn't reuse space of an unreclaimable io_unit
>  	 * */
>  	while (1) {
> -		struct list_head *target_list =3D NULL;
> -
> -		while (!list_empty(&log->stripe_end_ios)) {
> -			io =3D list_first_entry(&log->stripe_end_ios,
> -				struct r5l_io_unit, log_sibling);
> -			list_move_tail(&io->log_sibling, &list);
> -			free +=3D r5l_ring_distance(log, io->log_start,
> -						io->log_end);
> -		}
> -
> -		if (free >=3D reclaim_target ||
> +		reclaimable =3D r5l_reclaimable_space(log);
> +		if (reclaimable >=3D reclaim_target ||
>  		    (list_empty(&log->running_ios) &&
>  		     list_empty(&log->io_end_ios) &&
>  		     list_empty(&log->flushing_ios) &&
>  		     list_empty(&log->flushed_ios)))
>  			break;
>=20=20
> -		/* Below waiting mostly happens when we shutdown the raid */
> -		if (!list_empty(&log->flushed_ios))
> -			target_list =3D &log->flushed_ios;
> -		else if (!list_empty(&log->flushing_ios))
> -			target_list =3D &log->flushing_ios;
> -		else if (!list_empty(&log->io_end_ios))
> -			target_list =3D &log->io_end_ios;
> -		else if (!list_empty(&log->running_ios))
> -			target_list =3D &log->running_ios;
> -
> -		r5l_kick_io_unit(log);
> +		md_wakeup_thread(log->rdev->mddev->thread);
> +		wait_event_lock_irq(log->iounit_wait,
> +				    r5l_reclaimable_space(log) > reclaimable,
> +				    log->io_list_lock);
>  	}

This is ringing warning bells....  I'm not sure it's wrong, but I'm not
sure it is right.
I feel that if the thread gets woken and finds that
r5l_reclaimable_space is still too low, it should wake up the thread
again, just in case.
Also, it should test against reclaim_target, not reclaimable, shouldn't
it?

Instead of a wait_event_lock_irq inside a loop, could we just have a
wake_event_*??

wait_event_lock_irq_cmd(log->iounit_wait,
                        r5l_reclaimable_space(log) >=3D reclaim_target ||
                        (list_empty() && .... list_empty()),
                        log->io_list_lock,
                        md_wakeup_thread(log->rdev->mddev->thread));

??


Otherwise I like it.  Thanks.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJV98IPAAoJEDnsnt1WYoG5CykQAJc5kmBgjgqLMon1UmEVV0mb
+RJLqVxyJvNrrgc7NFz2fBXeWz7jKA3JIiryxqdxVaIHs2JVN0qhflbWjM8vbNYo
EB9PL7+qM/ycusMcTfn6U8dCs2AGgs0Q5PDyhirPnA1zM0odOw4pDw/cRmZV9odX
eluIMdVGCw42caRF0n0jl0z+fOTv8SxW9HHBlU5mIoS1NYGMAVKmRzrnKadxtmF5
qcU9kjetSWtCVW2LnqptUHl47jIPulqteljqkewCrv3La7Zl185doZz7i9XK9k7p
Pq+jmSuU9QQW3YO42G0YhtDwJWpYoVRrpD1a64Gf+RpuwoUSIN/PIfhz/BjYk7xx
ohQzlVyEjBiQExZ0K0lqjSb4dyxzKFtfgl0eCtywjRDrHt0xuNusGVdWdjRtH7Fg
sgUZdpAsRp+sl3m7hOchLDySFx/or8u7f3axQmeC7UR2SS6HxmgbTK4OdHpP17M0
dp8xQ6BoqokLyle5Lin3JzsvDodVsLOXDi8qH8GgMQeF2fvyXuaQzxOqgENPw2Eb
FKy55H2K2rvTKEslVnmg3R0ybtTJzzgYnPVvCplImTilyW0lk+69r72gkL6JvW/V
dbOp3PAe05tkAewaHEair4C1oTe3WgK2UmjNPZ9PTcMnDuK1fS8uhJjlj5zWJJiV
MoP5UvQ9OhP1gQTeToBE
=iUsL
-----END PGP SIGNATURE-----
--=-=-=--
