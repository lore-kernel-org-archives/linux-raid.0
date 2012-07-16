From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC PATCH V1] raid5: Add R5_ReadNoMerge flag which prevent bio
 from merging at block layer
Date: Mon, 16 Jul 2012 15:48:22 +1000
Message-ID: <20120716154822.2774ff5e@notabene.brown>
References: <201207131913329371733@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Co2XmotXG=unM9YfG_Z923v"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201207131913329371733@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/Co2XmotXG=unM9YfG_Z923v
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Jul 2012 19:13:35 +0800 majianpeng <majianpeng@gmail.com> wrote:

> Because bios will merge at block-layer,so bios-error may caused by other
> bio which be merged into to the same request.
> Using this flag,it will find exactly error-sector and not do redundant
> operation like re-write and re-read.
>=20
> V0->V1:Using REQ_FLUSH instead REQ_NOMERGE avoid bio merging at block
> layer.
>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/raid5.c |   14 ++++++++++++--
>  drivers/md/raid5.h |    1 +
>  2 files changed, 13 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 04348d7..059989f6 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -640,6 +640,9 @@ static void ops_run_io(struct stripe_head *sh, struct=
 stripe_head_state *s)
>  			else
>  				bi->bi_sector =3D (sh->sector
>  						 + rdev->data_offset);
> +			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
> +				bi->bi_rw |=3D REQ_FLUSH;
> +
>  			bi->bi_flags =3D 1 << BIO_UPTODATE;
>  			bi->bi_idx =3D 0;
>  			bi->bi_io_vec[0].bv_len =3D STRIPE_SIZE;
> @@ -1739,7 +1742,9 @@ static void raid5_end_read_request(struct bio * bi,=
 int error)
>  			atomic_add(STRIPE_SECTORS, &rdev->corrected_errors);
>  			clear_bit(R5_ReadError, &sh->dev[i].flags);
>  			clear_bit(R5_ReWrite, &sh->dev[i].flags);
> -		}
> +		} else if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
> +			clear_bit(R5_ReadNoMerge, &sh->dev[i].flags);
> +
>  		if (atomic_read(&rdev->read_errors))
>  			atomic_set(&rdev->read_errors, 0);
>  	} else {
> @@ -1784,7 +1789,11 @@ static void raid5_end_read_request(struct bio * bi=
, int error)
>  		else
>  			retry =3D 1;
>  		if (retry)
> -			set_bit(R5_ReadError, &sh->dev[i].flags);
> +			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags)) {
> +				set_bit(R5_ReadError, &sh->dev[i].flags);
> +				clear_bit(R5_ReadNoMerge, &sh->dev[i].flags);
> +			} else
> +				set_bit(R5_ReadNoMerge, &sh->dev[i].flags);
>  		else {
>  			clear_bit(R5_ReadError, &sh->dev[i].flags);
>  			clear_bit(R5_ReWrite, &sh->dev[i].flags);
> @@ -4504,6 +4513,7 @@ static int  retry_aligned_read(struct r5conf *conf,=
 struct bio *raid_bio)
>  			return handled;
>  		}
> =20
> +		set_bit(R5_ReadNoMerge, &sh->dev[dd_idx].flags);
>  		handle_stripe(sh);
>  		release_stripe(sh);
>  		handled++;
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 2164021..6767d07 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -273,6 +273,7 @@ enum r5dev_flags {
>  	R5_Wantwrite,
>  	R5_Overlap,	/* There is a pending overlapping request
>  			 * on this block */
> +	R5_ReadNoMerge, /* prevent bio from merging in block-layer */
>  	R5_ReadError,	/* seen a read error here recently */
>  	R5_ReWrite,	/* have tried to over-write the readerror */
> =20


Thanks, I've applied this.

We should probably do a similar thing in fix_read_error and
fix_sync_read_error in RAID1 and RAID10...

Thanks,
NeilBrown


--Sig_/Co2XmotXG=unM9YfG_Z923v
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAOrJjnsnt1WYoG5AQIHqBAAg5bSKSeNnaGCd+/HkUk2YVP3CpXjcGlJ
/Sb8gKKvyJKR3YDKs7ogOCYrD2ysT8aQrrYTfLn88u4LpFKzbPktGM/aDOD+kccs
qqKOrJuSZK3VPOHM8NtpCM3LfKhNJ1PFUz+aUmbhaccd5RayRoxMbXQVAGP4h9Jj
4hFW1vJoUYZzvYZ9DdmpOWxVjfFZWX3DQplSI2tFHMV388yqJJUVbnrhXhfLPZlR
dXM1rhYTNJ9ODL9gf16rtFjQKUpLSJ6ZSmzlS0mmaWUNVbIWiK7VBW5VaUS1Rgxz
OC9Zond7uMyvB8YVroQsU4KxkUsrYPi2aU7oSu+ZLa5SIgXhdTdhgZoTnf9rJ6pT
2uZz+EGTrVXNcftnd+VyYbZRQYYyODTuChNlb22baEbzfFFjFiSCsqYCvCB4IiFO
fb1ihBydaNbt9AQL7nFgpgQLwTcxoFiSiVmhepBAx2RcmiTYqfLyE6H/GAjOBu2t
c0wbGp/5QHyi2lWjXfUQOAB5hRP3I9JKQrvpVwkV2Iq9vIsba7oVW/QQthztHZa5
YPbli/3kH8iIcbO5aY4qXuF53ow1l2aw7niwjN62vXSeg77ZQ2ImJO/B+7GvoEYP
DEKLf64yBV9Q3J344svCQIAZuOnCpR4gfp32lJBx58xBhRxLXic4JBVDcuofPxVY
xodpx2SAdcM=
=kHTN
-----END PGP SIGNATURE-----

--Sig_/Co2XmotXG=unM9YfG_Z923v--
