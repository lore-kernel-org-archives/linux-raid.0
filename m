From: NeilBrown <neilb@suse.com>
Subject: Re: raid5d hangs when stopping an array during reshape
Date: Thu, 25 Feb 2016 11:31:04 +1100
Message-ID: <87r3g1ljg7.fsf@notabene.neil.brown.name>
References: <5683E00C.1050005@intel.com> <CAA9_cmc3Ps2KZ6Ry-RRb96HRJxVHg51Rbnh5ckKpfhzShDnJDg@mail.gmail.com> <20160225000300.GA16254@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160225000300.GA16254@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 25 2016, Shaohua Li wrote:

>
> As for the bug, write requests run in raid5d, mddev_suspend() waits for a=
ll IO,
> which waits for the write requests. So this is a clear deadlock. I think =
we
> should delete the check_reshape() in md_check_recovery(). If we change
> layout/disks/chunk_size, check_reshape() is already called. If we start an
> array, the .run() already handles new layout. There is no point
> md_check_recovery() check_reshape() again.

Are you sure?
Did you look at the commit which added that code?
commit b4c4c7b8095298ff4ce20b40bf180ada070812d0

When there is an IO error, reshape (or resync or recovery) will abort
and then possibly be automatically restarted.

Without the check here a reshape might be attempted on an array which
has failed.  Not sure if that would be harmful, but it would certainly
be pointless.

But you are right that this is causing the problem.
Maybe we should keep track of the size of the 'scribble' arrays and only
call resize_chunks if the size needs to change?  Similar to what
resize_stripes does.

It might also be good to put something like
  WARN_ON(current =3D=3D mddev->thread->task);
in mddev_suspend() ... or whatever code would cause this sort of error
to trigger a warning early.

Thanks,
NeilBrown

>
> Artur, can you check if below works for you?
>
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 464627b..7fb1103 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8408,8 +8408,7 @@ void md_check_recovery(struct mddev *mddev)
>  		 */
>=20=20
>  		if (mddev->reshape_position !=3D MaxSector) {
> -			if (mddev->pers->check_reshape =3D=3D NULL ||
> -			    mddev->pers->check_reshape(mddev) !=3D 0)
> +			if (mddev->pers->check_reshape =3D=3D NULL)
>  				/* Cannot proceed */
>  				goto not_running;
>  			set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
>
> Thanks,
> Shaohua

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWzktIAAoJEDnsnt1WYoG5C44P/3wTph1rVnmVAi3kJzc6/p2s
4l42bgYaITwflPC4PpSDLnrpMV3Yakr5X1RH60nZC5HB7PmGV3wjWjiPGyQWpwWo
cQ768a/psQZZo+DrXkghopRxM4ZhUUVJBQ4Sn6KM4Iav9iRrxFJHENtLiM1jGltO
KEcO+7Op2vUnCFzAzMTMmjW+sKKaZUsc0wUuXFgaJF2bNwmJsLVlEl04K+cYhRRH
rLqbwHoGVVZcjWlKxKQY0IPbBYAUjRqQI9e9nRb0tM/Pr96me7z8WcFMp7lq5I6E
NLqy3uog0RaQmPD6LyZI7JrKff8ydPtBt4m6dUocHWKulsV1yESfuQFM3ejYlSvW
GjBfJhE+Zc00Y0WQto/hZ5warBemSVlhVs/vVgpTS6st5jFPsBYT6LX23F7mZfUe
5t1OuPAjaggD2mffv4carkI13AiT1Ic8kUUugxc40W8lA7reG2Xxci3/nviAoqCa
DfhwvU40sL+JcTIMHWNI5AOfrx5NXlVw9bdIHwvx7T70ZtUUq8rxws7d2H0vJkRq
yHzzYdBvvSDSpv0WQsWvBol/uJ0PuIBxDv9IE/viAK9AGR8lrohDdYSWgDsqA9Ym
PHeNt4OliP+iYTgtWqJVsTWh94MjtVqX6NDtg/JaylJhQGwHR+Ic/fpzaoVcxKBA
zJmwHJIPUoxz5Ei3Y3ow
=bKm5
-----END PGP SIGNATURE-----
--=-=-=--
