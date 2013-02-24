From: NeilBrown <neilb@suse.de>
Subject: Re: BUG  - raid 1 deadlock on handle_read_error / wait_barrier
Date: Mon, 25 Feb 2013 09:43:50 +1100
Message-ID: <20130225094350.4b8ef084@notabene.brown>
References: <1361487504.4863.54.camel@linux-lxtg.site>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cwCFq2STVKVMANPT9oTjNDd"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1361487504.4863.54.camel@linux-lxtg.site>
Sender: linux-raid-owner@vger.kernel.org
To: tbayly@bluehost.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/cwCFq2STVKVMANPT9oTjNDd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 21 Feb 2013 15:58:24 -0700 Tregaron Bayly <tbayly@bluehost.com> wro=
te:

> Symptom:
> A RAID 1 array ends up with two threads (flush and raid1) stuck in D
> state forever.  The array is inaccessible and the host must be restarted
> to restore access to the array.
>=20
> I have some scripted workloads that reproduce this within a maximum of a
> couple hours on kernels from 3.6.11 - 3.8-rc7.  I cannot reproduce on
> 3.4.32.  3.5.7 ends up with three threads stuck in D state, but the
> stacks are different from this bug (as it's EOL maybe of interest in
> bisecting the problem?).

Can you post the 3 stacks from the 3.5.7 case?  It might help get a more
complete understanding.

...
> Both processes end up in wait_event_lock_irq() waiting for favorable
> conditions in the struct r1conf to proceed.  These conditions obviously
> seem to never arrive.  I placed printk statements in freeze_array() and
> wait_barrier() directly before calling their respective
> wait_event_lock_irq() and this is an example output:
>=20
> Feb 20 17:47:35 sanclient kernel: [4946b55d-bb0a-7fce-54c8-ac90615dabc1] =
Attempting to freeze array: barrier (1), nr_waiting (1), nr_pending (5), nr=
_queued (3)
> Feb 20 17:47:35 sanclient kernel: [4946b55d-bb0a-7fce-54c8-ac90615dabc1] =
Awaiting barrier: barrier (1), nr_waiting (2), nr_pending (5), nr_queued (3)
> Feb 20 17:47:38 sanclient kernel: [4946b55d-bb0a-7fce-54c8-ac90615dabc1] =
Awaiting barrier: barrier (1), nr_waiting (3), nr_pending (5), nr_queued (3)

This is very useful, thanks.  Clearly there is one 'pending' request that
isn't being counted, but also isn't being allowed to complete.
Maybe it is in pending_bio_list, and so counted in conf->pending_count.

Could you print out that value as well and try to trigger the bug again?  If
conf->pending_count is non-zero, then it seems very likely the we have found
the problem.
Fixing it isn't quite so easy.  'nr_pending' counts request from the
filesystem that are still pending.  'pending_count' sounds request down to
the underlying device that are still pending.  There isn't a 1-to-1
correspondence, so we cannot just subtract one from the other.  It will
require more thought than that.

Thanks for the thorough report,

NeilBrown

--Sig_/cwCFq2STVKVMANPT9oTjNDd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUSqXrTnsnt1WYoG5AQJ+/Q/+IjOkSIycEbeut/W0UTO1d3KBWL/v6wMB
4mgBxh9Rk087kOjJ3YmeMecKGptmWUFBOo/h5nz9B2ijeMPuoOzMRo43jg6W8jna
MhgwRJUNZVTb+69GgrZy295dm8NVPsST99RYeGr3HTDhg+u/J826uOga0ckL3XBa
8DAzNp52CLMezLWph+rQ6pLAcvn0k70BO6G+AHZYePKqjx+w1NEGh2zjt0/l23a9
dm3wY+Ri8EG08a58Y0OZ6j96i3L8qJvzDwCwvn2vCvasX7jJ/CzAyo/e7UbHKicZ
iZp7s+9SxRHlK2c/obZv7C9CMki8W/xTr6A3vmmfzitvMSlqe4oo8AftH8cbRZ3w
p27X1EAt1ie0bhfbLLYcDpwmA0giCo2jTz4d6TrtC+raQ+7A+oavgwAjXDGLIsVU
HUBKmpkPTNzhWbwnab+f2tSprYrSaTW6BEdpm87w1LK83O/qOcPvsSfxmUG16Njo
ko/ZI/F+u9OAFvo0RqzJKTJnFZcht/NneNzIB+FppO0Xxh15BxHnkDKvwltcIevm
gNwLdd4ojMgOewleKIJ6RJsLeA5yWBnYzW2cSvtWcYL9PTt6tYOxLwdFovZ2Cm/n
BWNyp+4g7I9OegeO872jt994WGLg5xRIDe9ngiVy+sVxqPalVP0OkQrcTKIXgEKh
jsUpvl3xYnw=
=mffx
-----END PGP SIGNATURE-----

--Sig_/cwCFq2STVKVMANPT9oTjNDd--
