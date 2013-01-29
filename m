From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH v3] md: protect against crash upon fsync on ro array
Date: Tue, 29 Jan 2013 05:45:26 +0000
Message-ID: <1359438326.3367.41.camel@deadeye.wl.decadent.org.uk>
References: <1358707492.24121.210.camel@deadeye.wl.decadent.org.uk>
	 <5102A01B.7000407@profitbricks.com>
	 <1359229480.2894.21.camel@deadeye.wl.decadent.org.uk>
	 <20130127163942.GA28572@infradead.org> <510653A3.9090403@profitbricks.com>
	 <51067164.4050301@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-EEagJUfz0xpF84pz8gUq"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51067164.4050301@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Cc: Christoph Hellwig <hch@infradead.org>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, 696650@bugs.debian.org
List-Id: linux-raid.ids


--=-EEagJUfz0xpF84pz8gUq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-01-28 at 13:39 +0100, Sebastian Riemer wrote:
>=20
> On 28.01.2013 11:32, Sebastian Riemer wrote:
> > O.K., then I hope Neil applies the attached patch. I've changed the
> > return value to success.
> >=20
> > This is also something for linux-stable and should apply to many kernel
> > versions without an issue.
> >=20
>=20
> I've tried to race with continuous fsyncs against continuous "mdadm -o
> /dev/md0; mdadm -w /dev/md0;" in parallel but couldn't break it.
> Therefore, no additional locking is required and this part can be put
> directly before the RCU locking stuff and the suspended handling.
>=20
> I've attached version 3 of the patch.

> From fe0357344877c9b9cc623fd582a4e0670e448317 Mon Sep 17 00:00:00 2001
> From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
> Date: Fri, 25 Jan 2013 12:46:59 +0100
> Subject: [PATCH v3] md: protect against crash upon fsync on ro array
>=20
> If an fsync occurrs on a read-only array, we need to send a
> completion for the IO and may not increment the active IO count.
> Otherwise, we hit a bug trace and can't stop the MD array anymore.
>=20
> By advice of Christoph Hellwig we silently return success.
>=20
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Ben Hutchings <ben@decadent.org.uk>
> Cc: NeilBrown <neilb@suse.de>
> Signed-off-by: Sebastian Riemer <sebastian.riemer@profitbricks.com>
> Reported-by: Ben Hutchings <ben@decadent.org.uk>
>=20
> ---
>  drivers/md/md.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 3db3d1b..6ba20f7 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -307,6 +307,10 @@ static void md_make_request(struct request_queue
> *q, struct bio *bio)
>                 bio_io_error(bio);
>                 return;
>         }
> +       if (mddev->ro =3D=3D 1 && unlikely(rw =3D=3D WRITE)) {
> +               bio_endio(bio, 0);
> +               return;
> +       }
>         smp_rmb(); /* Ensure implications of  'active' are visible */
>         rcu_read_lock();
>         if (mddev->suspended) {

I'm slightly uneasy about returning 0 for all writes to a read-only
deivce, because if someone ever fails to check the read-only flag
elsewhere this could turn into silent data loss.  Does this work:

		BUG_ON(bio_segments(bio));

Or should it be:

		bio_endio(bio, bio_segments(bio) =3D=3D 0 ? 0 : -EROFS);

to make the error survivable?

Ben.

--=20
Ben Hutchings
If more than one person is responsible for a bug, no one is at fault.

--=-EEagJUfz0xpF84pz8gUq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUQdh9ue/yOyVhhEJAQqwWg/9G+n+LQC7P6PhNfHA62D4jbSUocY5ptzm
xhuH3eIvUsQu2L6KHMq+OUG+xchKnBvagsknonrr+C2Xbr2ALmje/hrMQcBjNR9k
ZzM+QKyPuW/aqV3Fj6Bcze73UHKOB5Q0yG7uYVXuU7hcL6SVyw8fqvSC7Tg82dli
msIY5D2lP+jWIEm1jFuuT4bB0+r/jW2HUE2SbVA3aGiyL+1gM0UiR2J6JL2T1xFe
blyo40sbBHT7ViIJ0VFcnsmXiUzhwmvHhGE+RpvPUEXxlrE2Sv1QjghqUCt5p7mm
eKUYe20R2wQHZkahWTJkhLcM3pY+Bsmb1bshALQLXaZFVLF+Jsi2wz2GbjlNEKyM
1OF6uQ82O0g0xRvOtsxvy36BXAl86xP2dbm5lTVN0GYgcDysceVem6w/Frhgv2vo
lk7gF/gCmZNMNQrIf194hwNA22P5J9EmzpvZphgI6W/+lXpv77xwhP57WE+6A4jV
Mk9X1cGdys1TT/SYRrqXMpangeZIpIjlc2jqXa0yNu6kBOiKcXs2vGx3MYPzBJGg
cmGpn3zhHX6GhLgJW1JXK9mgskWJEW7ieYECSyHpcnIIzPXoz8otDMEZ2zrzFoiM
BTsgPyOKAqi1BaR5McKWGnpRwVi5IOrypTQT5x6QG4GCFmSbWLHVvIfQLaxB2tLU
IU6/00X7eVk=
=b/JS
-----END PGP SIGNATURE-----

--=-EEagJUfz0xpF84pz8gUq--
