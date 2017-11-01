From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] Monitor: Allow taking spare from rebuilding array
Date: Wed, 01 Nov 2017 12:30:36 +1100
Message-ID: <87y3nqvl8j.fsf@notabene.neil.brown.name>
References: <eddc14d2-8210-a73d-d879-7d709de4fde1@digitalgarden.no>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <eddc14d2-8210-a73d-d879-7d709de4fde1@digitalgarden.no>
Sender: linux-raid-owner@vger.kernel.org
To: Erik Berg <erikberg@digitalgarden.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 25 2017, Erik Berg wrote:

> When you have a box with 60 8TB drives, 8 RAID6 sets and 12 spares
> assigned to the first set, and the first set has a failed disk and is
> rebuilding, spares aren't given to other sets with failing disks.
> Waiting 2-3 days for a rebuild to complete before giving out spares to
> other failing sets seems excessive.

True.
One way around this is to have an inactive array that just contains
spares.
It is probably awkward to create such an array with current mdadm
thought :-(


> ---
>  Monitor.c | 36 ++++++++++++++++++++++++++++++++----
>  1 file changed, 32 insertions(+), 4 deletions(-)
>
> diff --git a/Monitor.c b/Monitor.c
> index b60996b..b1178fd 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -781,14 +781,41 @@ static int check_donor(struct state *from, struct s=
tate *to)
>  		 */
>  		if (sub->active < sub->raid)
>  			return 0;
> -	if (from->metadata->ss->external =3D=3D 0)
> -		if (from->active < from->raid)
> -			return 0;
>  	if (from->spare <=3D 0)
>  		return 0;
>  	return 1;
>  }
>=20=20
> +int spare_rebuilding(struct state *dev)
> +{
> +	mdu_disk_info_t disk;
> +	mdu_array_info_t array;
> +
> +	int fd =3D open(dev->devname, O_RDONLY);
> +	if (fd < 0) {
> +		pr_err("cannot open %s: %s\n",
> +			dev->devname, strerror(errno));
> +		return 1;
> +	}
> +
> +	md_get_disk_info(fd, &disk);

This is wrong. md_get_disk_info requires that disk.number be set,
and it returns the info for that disk.

You need to pass 'd' from choose_spare() into  spare_rebuilding(),
and set
 disk.number =3D d;

Did you test your code? :-)

> +	md_get_array_info(fd, &array);

You only use 'array' to get 'array.raid_disks', and that should be the
same as dev->raid.

> +
> +	close(fd);
> +
> +	if ((disk.state &
> +	     ((1 << MD_DISK_ACTIVE) | (1 << MD_DISK_SYNC) |
> +	      (1 << MD_DISK_REMOVED) | (1 << MD_DISK_FAULTY) |
> +	      (1 << MD_DISK_JOURNAL))) =3D=3D 0) {

dev->devstate[d] already contains disk.state, and has be tested against
zero, so the above is not needed.

> +
> +		if (disk.raid_disk < array.raid_disks &&
> +		    disk.raid_disk >=3D 0)
> +			return 1;

This is the important test. If raid_disk is -1, the device is really a
spare.  If >=3D 0, it isn't.

Maybe it would be better to add a 'devrole' array to 'struct state', and
collect this information in check_array().  Then spare_rebuilding() would
become trivial.

So I don't much like the code, but the concept seems sound.

Thanks,
NeilBrown


> +	}
> +
> +	return 0;
> +}
> +
>  static dev_t choose_spare(struct state *from, struct state *to,
>  			  struct domainlist *domlist, struct spare_criteria *sc)
>  {
> @@ -821,7 +848,8 @@ static dev_t choose_spare(struct state *from, struct =
state *to,
>  				pol_add(&pol, pol_domain,
>  					from->spare_group, NULL);
>  			if (domain_test(domlist, pol,
> -					to->metadata->ss->name) =3D=3D 1)
> +					to->metadata->ss->name) =3D=3D 1 &&
> +			    !spare_rebuilding(from))
>  			    dev =3D from->devid[d];
>  			dev_policy_free(pol);
>  		}
> --=20
> 2.14.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAln5I74ACgkQOeye3VZi
gbnM1RAAvIW8vtbqD5bAITc3CPw4gWNn3rS9fMihSeKbWHadcXqCnTHitm/h7AiG
+ADWjKNc3kbdcUiv7umIT/oxcHRxHNpmJ2LYQ1VoSb09jFSrbhUnlJRDzrPn3XN9
ueIzoF38SkYLuIx/FuKld6ESeQchnzrFZbOeFB7rXn+M9RkZmvZLu1OqJuHebI+G
3ILyN3tT1D+BKjGOtOAxdiaRUX43FeUlfk4zn8b0i97GTsNcJNvnNe8KZ0iDD4X+
XrGn1oO6u3WIjX2kT0F39BL9auJqPTei/ktV+0ckdSpx37ehn6wRZ4xQVzTQ2KSn
XRzbD4dhiiS+4EM4uohEWKYm7ESDUjZvZYYPMfdubDCyZXaOLtcOLmemY+4yK5VH
eJdMmfrtJslGCA6BBB3OMWei8Uj6LaWWo7dClQ7akRAoJxCB748IhRXlJ9+qNjK5
qFluco+fkA1LXzVj/f7PM58ObMffgWDGMImzZtCkfNIpnioox6kMmv6RpwA3ldFI
nysjFZsC5I5vwA1+c+EYQeKcnrsuOjqFo+OLdMklAagwQnYFBXnt5ZhINLG2sOLV
wuUE312Rb9uFbnQ5kWdLb98iPvHawiBIobUfj7fVFFxPh65J21WZssiQXpXN7hU+
5X6WNJEJy/Y1XyFOOpf7felwDoARHcv8kMr5van7qSfd6PoyoUE=
=8qwk
-----END PGP SIGNATURE-----
--=-=-=--
