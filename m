From: NeilBrown <neilb@suse.de>
Subject: Re: Commit "db91ff55bdf06736b" using curr_resync_completed instead
 of curr_resync when interrupted the resync operation
Date: Mon, 29 Oct 2012 09:47:44 +1100
Message-ID: <20121029094744.1ddfb4e5@notabene.brown>
References: <201210251415581641823@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/X6myk8PtjUCzKECVZmnd.=y"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201210251415581641823@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/X6myk8PtjUCzKECVZmnd.=y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 25 Oct 2012 14:16:02 +0800 majianpeng <majianpeng@gmail.com> wrote:

> Hi Neil,
> >commit db91ff55bdf06736b849afc1b1fce5763bbb8d5d
> >    1/ If a resync is aborted we should record how far we got
> >     (recovery_cp) the last request that we know has completed
> >     (->curr_resync_completed) rather than the last request that was
> >     submitted (->curr_resync).
> If resync operation interrupted,it will call:
> >	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
> So the curr_resync must be complete. Using curr_resync is safe.
> --------------
> majianpeng

I must have had a reason for that patch.  Unfortunately the change log isn't
the best...

If the resync aborted cleanly with no errors (e.g. while stopping the array=
),
then I agree.
However if some read error was involved I'm not so sure.  I would have to
examine the code closely, which I don't feel up to at the moment (plenty of
other things to do).


NeilBrown

--Sig_/X6myk8PtjUCzKECVZmnd.=y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUI22EDnsnt1WYoG5AQJvdg/9HBwxb8YCRgd1y5ccoEHvgH6eWoeu3d19
QY3JPBgRo3UfDh92p8NXFKRTaQESW4AoX1gAsRqKYC+fsM8RpaW3mT59gDJ/CTbD
3pKjUWogWyI0+kq7TkIZflpMlLmcmkNMH0MvS+ZRoKZ6bZnpkUe754JzmvGGv3Ay
RVIsmoCg3DtL++crOnZkPnaInTg8orS4K6jwYTyDOlkuZEHo7OWUfJTJxnEhxBmY
5Lnfyps7h/75Nh00ezX6jm6lonVLNARdqr2gNNNHSdY3lrP4LZkCKJ65zvlBUqCB
Y4z9bWulqi444jh/aBKVJ8jgx9/johhyNiekIMI8R8kkdtcfg4KfeXdGhSHjcgNc
GM8Vo4bK9CZ6NRcvWacZSL0j/iUjOAMeSGdpAjAK7NkSlf0R02yJaVDbtOL4QZge
aiQGi55ULPiw5otlqmVSiyqigdq0wu6TSMhIJia7nKtyD7t/EaXlznUiORSB74kI
OUu0orz6aTTX0EOkJokLE64PFjyXysG1epjGBdBu74ibiIlkCIpz09gk4h7f6KK/
G4oUiu8Pv8FgyAo5LRHmDoJ3ZONOkspLE/jhOsAtq4QnMs4t3eRJSFkSHvitRWpT
mrHHWwyLeN3NcYOMVEkozNe7SQ/49cxfF0PLIkueiEXhoC4hkVUSN/1SqMiI9Jhc
F8/bJ7shbks=
=smzN
-----END PGP SIGNATURE-----

--Sig_/X6myk8PtjUCzKECVZmnd.=y--
