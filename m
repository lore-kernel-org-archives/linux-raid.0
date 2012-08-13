From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 6/7 v2] MD: raid5 trim support
Date: Mon, 13 Aug 2012 11:50:51 +1000
Message-ID: <20120813115051.64d5d44e@notabene.brown>
References: <20120810025113.050392766@kernel.org>
	<20120810025255.292192477@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/REpd/v9rFGVi=aUl5kWkLn9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120810025255.292192477@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fusionio.com>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, shli@kernel.org
List-Id: linux-raid.ids

--Sig_/REpd/v9rFGVi=aUl5kWkLn9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Aug 2012 10:51:19 +0800 Shaohua Li <shli@fusionio.com> wrote:

> @@ -4094,6 +4159,19 @@ static void make_request(struct mddev *m
>  	bi->bi_next =3D NULL;
>  	bi->bi_phys_segments =3D 1;	/* over-loaded to count active stripes */
> =20
> +	/* block layer doesn't correctly do alignment even we set correct align=
ment */
> +	if (unlikely(bi->bi_rw & REQ_DISCARD)) {
> +		int stripe_sectors =3D conf->chunk_sectors *
> +			(conf->raid_disks - conf->max_degraded);

This isn't right when an array is being reshaped.
I suspect that during a reshape we should only attempt DISCARD on the part =
of
the array which has already been reshaped.  On the other section we can
either fail the discard (is that a good idea?) or write zeros.

> +
> +		logical_sector =3D (logical_sector + stripe_sectors - 1);
> +		sector_div(logical_sector, stripe_sectors);

This would look better with DIV_ROUND_UP_SECTOR_T().


> +		sector_div(last_sector, stripe_sectors);
> +
> +		logical_sector *=3D stripe_sectors;
> +		last_sector *=3D stripe_sectors;
> +	}
> +
>  	for (;logical_sector < last_sector; logical_sector +=3D STRIPE_SECTORS)=
 {
>  		DEFINE_WAIT(w);
>  		int previous;
> @@ -4114,6 +4192,11 @@ static void make_request(struct mddev *m
>  			if (mddev->reshape_backwards
>  			    ? logical_sector < conf->reshape_progress
>  			    : logical_sector >=3D conf->reshape_progress) {
> +				/* The stripe will be reshaped soon, ignore it */
> +				if (bi->bi_rw & REQ_DISCARD) {
> +					spin_unlock_irq(&conf->device_lock);
> +					goto next_stripe;
> +				}
>  				previous =3D 1;
>  			} else {
>  				if (mddev->reshape_backwards
> @@ -4202,6 +4285,12 @@ static void make_request(struct mddev *m
>  			finish_wait(&conf->wait_for_overlap, &w);
>  			break;
>  		}
> +next_stripe:
> +		/* For discard, we always discard one stripe */
> +		if (unlikely((bi->bi_rw & REQ_DISCARD) &&
> +		   !((logical_sector + STRIPE_SECTORS) % conf->chunk_sectors)))

You are using '%' on a sector_t value.  That isn't right - need to use
sector_div().


Thanks,
NeilBrown


--Sig_/REpd/v9rFGVi=aUl5kWkLn9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUChdeznsnt1WYoG5AQL6nxAAlaLeeyBmgpEl/h1g73eYn5SIiHE5YOo5
G/f/XWPVfn8HfMGFu7QT8PdrPKG47+Q55GBPBljVLcqht2INqqr+rSrYbCQ3b30u
R+a+UVID8b/Tov9QX3h9Kr3RjVWWSbU7KqQOuwLbPKf57aNAKDCAskpl7JC9Q1iF
2vOH+plO8FbF6LJMNXW5EmG0Zf4Cbgb2nG883ASA9jaEO4hpolXHw3B/eisqV6fb
/11gHQfySgBOBm9urwpSukT7mCuEYkWkVGfKr0FjmVbuYNJF6rRmCIKzThKK5Hee
tXc8UZq00hIIWZ12X/8XBewhm8L4g5GcjiddXI6DD9AQ7OyqFjlO0pctsQZRfuyp
ZqL9P/3X+jv7ogxZ0yAAwD7+23Jgc/V3BbteTsK07eKnx3AbRtxMKANBM/FHufC9
h5hW6245WslWXTJg/5X4F96k65475dChLSoCbF6GGF7KFIY0do0DlvTaplzVDI8H
1nnW4fnwHnOEYqheHdbwcaC80viw+NSfQWvqlbGzYhqKnTAUZMqWjsaaFPVET1PN
PpDNloscdSj2LJbz/OhnwECEfWpG2pk4ZoyNQbPPzyNeNCzoMgaak+pQ7x4m08St
O/cITrht9letCXISWw7VzG890c01zcq4bNIXS7HUQX2WImJl0K9JOygGiW5IY1Uw
GDz+Rjco1ww=
=aV20
-----END PGP SIGNATURE-----

--Sig_/REpd/v9rFGVi=aUl5kWkLn9--
