From: NeilBrown <neilb@suse.de>
Subject: Re: "bitmap file is out of date, doing full recovery"
Date: Wed, 29 Oct 2014 10:19:50 +1100
Message-ID: <20141029101950.5528b347@notabene.brown>
References: <CAGRgLy5zhV49xF=ZwULaF46Xx=8rnWcypTWxxgf0HmEPpCP+yQ@mail.gmail.com>
	<20141013092426.5ea1288d@notabene.brown>
	<CAGRgLy69gC2n0oAP8CRNBzTb+tBnwmwoJOCdKb+aRMO=Oeqf3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/TZox/I1whH/npOlcQU8jI5v"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy69gC2n0oAP8CRNBzTb+tBnwmwoJOCdKb+aRMO=Oeqf3Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/TZox/I1whH/npOlcQU8jI5v
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Oct 2014 19:04:48 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> I found at least one way of this happening. The problem is that in
> md_update_sb() we allow to decrease the event count:
>=20
>     /* If this is just a dirty<->clean transition, and the array is clean
>      * and 'events' is odd, we can roll back to the previous clean state =
*/
>     if (nospares
>         && (mddev->in_sync && mddev->recovery_cp =3D=3D MaxSector)
>         && mddev->can_decrease_events
>         && mddev->events !=3D 1) {
>         mddev->events--;
>         mddev->can_decrease_events =3D 0;
>=20
> Then we call bitmap_update_sb(). If we crash after we update (the
> first or all of) bitmap superblocks, then after reboot, we will see
> that bitmap event count is less than MD superblock event count. Then
> we decide to do full resync.
>=20
> This can be easily reproduced by hacking bitmap_update_sb() to call
> BUG(), after it calls write_page() in case event count was decreased.
>=20
> Why we are decreasing the event count??? Can we always increase it?
> u64 is a lot to increase...

The reason for decreasing the event count is so that we don't need to update
the event count on spares - they can be left spun down.
We for simple clean/dirty transitions with increment for clean->dirty and
decrement for dirty->clean.  But we should only use this optimisation when
everything is simple.
We really shouldn't do this when the array is degraded.
Do this fix your problem?

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2c73fcb82593..98fd97b10e13 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2244,6 +2244,7 @@ repeat:
 	 * and 'events' is odd, we can roll back to the previous clean state */
 	if (nospares
 	    && (mddev->in_sync && mddev->recovery_cp =3D=3D MaxSector)
+	    && mddev->degraded =3D=3D 0
 	    && mddev->can_decrease_events
 	    && mddev->events !=3D 1) {
 		mddev->events--;


>=20
> Some other doubt that I have is that bitmap_unplug() and
> bitmap_daemon_work() call write_page() on page index=3D0. This page
> contains both the superblock and also some dirty bits (could not we
> waste 4KB on bitmap superblock???). I am not sure, but I wonder
> whether this call can race with md_update_sb (which explicitly calls
> bitmap_update_sb), and somehow write the outdated superblock, after
> bitmap_update_sb has completed writing it.
>=20

storage.sb_page is exactly the same as storage.filemap[0]
So once an update has happened, the "outdated superblock" doesn't exist
anywhere to be written out from.

> Yet another suspect is when loading the bitmap we basically load it
> from the first up-to-date drive. Maybe we should have scanned all the
> bitmap superblocks, and selected one that has the higher event count
> (although as we saw "higher" does not necessarily mean "more
> up-to-date").
>=20
> Anyways, back to decrementing the event count. Do you see any issue
> with not doing this and always incrementing?
>=20
> Thanks,
> Alex.
>=20

Thanks,
NeilBrown

--Sig_/TZox/I1whH/npOlcQU8jI5v
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVFAkljnsnt1WYoG5AQLF0Q/+NSCJXCXt42bP/a4ifYsF3fxDdQv4yFjy
QtOZ1hGrR6saszF7Wn8ioNGIF9ufqjpXonEa0GSLNK/Gf9NTLSuwvOVlJTISIFqr
ynL92+Cnt6iH+JeDvVc0KwGJLMLMELWvwHCt84j3V1Bm4OzXJ1FIWVktvq0HdWHy
ZQQoQ0+HxUWziJEP1alOUFXvnBPh2c3L7ZLRO/eb+NFcwT7KJFB0Mu2q6ZS05USh
93X6qquTG3g9riIHQb6v4S99j/2Surb7cYeMjMDv6JgLTd9KvY0YWUvoiGxUyXzh
12j8nCMOy8O551itT7MzEQt0j6MzW+7x7yPpDpIaH+JC9hJ+FxMGOKNGdYV2Ipf1
JXPSAXSCjcF/1D61Tu5kZ6UF/o5SBRff6uSb88QPFD6CURtW7vwejqNWRxZEwJod
+h4O/2nOgclFN7ORnZcFQRqmOrYDfsJ0vK93h7tMvMvY2bb1bHKuDsOKSJfmowvP
UedwgrS1DIrQwxdQRnbIVHBAnikWr4OD6t6MvOx+yNUMkY0aYugkjXsKgymMaN8t
mUNHlbLUGYxigXHQ7XYpfQHvMQPNUXbDnBcnhCjx9CAHUAXdkYhfRy0KSSAq8Ass
M3OUbmN8kl69p5afMHuB21ox0uzgg9G/tvNCrqncXpNGCIQ1gdKbXQ3oV4C7055O
ZfM+TmKomjk=
=vSO6
-----END PGP SIGNATURE-----

--Sig_/TZox/I1whH/npOlcQU8jI5v--
