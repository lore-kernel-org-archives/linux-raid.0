From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] raid5: Avoid doing more read on dev of a stripe at the
 same time
Date: Thu, 20 Sep 2012 12:51:44 +1000
Message-ID: <20120920125144.0ed69ec3@notabene.brown>
References: <2012091510203206229010@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3obcSwKj+bf_1yc+Q_cuN52"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2012091510203206229010@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jianpeng Ma <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/3obcSwKj+bf_1yc+Q_cuN52
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 15 Sep 2012 10:20:35 +0800 "Jianpeng Ma" <majianpeng@gmail.com> wro=
te:

> In func 'ops_run_bio' if you read the dev which the last reading
> of this dev didn't return,it will destrory the  req/rreq'source of rdev.
> It may call hung-task.
> For example, for badsector or other reasons, read-operation only used
> stripe instead of chunk_aligned_read.
> First:stripe 0;second: stripe 8;third:stripe 16.At the block-layer,three
> bios merged.
> Because media error of sector from 0 to 7, the request retried.
> At this time, raid5d readed stripe0 again.But it will set 'bio->next =3D
> NULL'.So the stripe 8 and 16 didn't return.
>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>

Hi,
 I'm really trying, but I cannot understand what you are saying.

I think the situation that you are describing involves a 24 sector request.
This is attached to 3 stripe_heads - 8 sectors each - at address 0, 8, 16.

So 'toread' on the first device of each stripe points to this bio, and
bi_next is NULL.

The "req" bio for each device is filled out to read one page and these three
'req' bios are submitted.  The block layer merges these into a single reque=
st.

This request reports an error because there is a read error somewhere in the
first  8 sectors.

So one, or maybe all, of the 'req' bios return with an error?
Then RAID5 marks that device as being bad and reads from the other devices =
to
recover the data.

Where exactly does something go wrong?  which bio gets bi_next set to NULL
when it shouldn't?

If you could explain with lots of detail it would help a lot.

Thanks,
NeilBrown


> ---
>  drivers/md/raid5.c |   13 ++++++++++---
>  drivers/md/raid5.h |    1 +
>  2 files changed, 11 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index adda94d..e52ba1b 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -547,9 +547,14 @@ static void ops_run_io(struct stripe_head *sh, struc=
t stripe_head_state *s)
>  				rw =3D WRITE_FUA;
>  			else
>  				rw =3D WRITE;
> -		} else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
> -			rw =3D READ;
> -		else if (test_and_clear_bit(R5_WantReplace,
> +		} else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags)) {
> +			/*The last read did not return,so skip this read*/
> +			if (test_and_set_bit(R5_Reading, &sh->dev[i].flags)) {
> +				clear_bit(R5_LOCKED, &sh->dev[i].flags);
> +				continue;
> +			} else
> +				rw =3D READ;
> +		} else if (test_and_clear_bit(R5_WantReplace,
>  					    &sh->dev[i].flags)) {
>  			rw =3D WRITE;
>  			replace_only =3D 1;
> @@ -700,6 +705,7 @@ static void ops_run_io(struct stripe_head *sh, struct=
 stripe_head_state *s)
>  			pr_debug("skip op %ld on disc %d for sector %llu\n",
>  				bi->bi_rw, i, (unsigned long long)sh->sector);
>  			clear_bit(R5_LOCKED, &sh->dev[i].flags);
> +			clear_bit(R5_Reading, &sh->dev[i].flags);
>  			set_bit(STRIPE_HANDLE, &sh->state);
>  		}
>  	}
> @@ -1818,6 +1824,7 @@ static void raid5_end_read_request(struct bio * bi,=
 int error)
>  	}
>  	rdev_dec_pending(rdev, conf->mddev);
>  	clear_bit(R5_LOCKED, &sh->dev[i].flags);
> +	clear_bit(R5_Reading, &sh->dev[i].flags);
>  	set_bit(STRIPE_HANDLE, &sh->state);
>  	release_stripe(sh);
>  }
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index a9fc249..a596df8 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -298,6 +298,7 @@ enum r5dev_flags {
>  	R5_WantReplace, /* We need to update the replacement, we have read
>  			 * data in, and now is a good time to write it out.
>  			 */
> +	R5_Reading,	/* this dev on reading on lld*/
>  };
> =20
>  /*


--Sig_/3obcSwKj+bf_1yc+Q_cuN52
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFqEwDnsnt1WYoG5AQJqZQ/+OYMp609XUT1JmOayPucs5Y2U7i7kkUTq
GZZz1VWL7cPqQfi8N9ZKYOC4BzzxSe8/bkUkNBZ19b36Qo61u9hl1uwhRvrzmkLM
Q1NAcR/WPx9dWp6DQzcf9Eu9LLypedKuStzKyHPTaeQDB3BbJxkey6DdfB+knzC4
RLl9oxXp0rFRWhvN1/uY4MNi08XTpKqFN5nY41E02lUV3ZJ/0Z8GkzYP2YtaZwLH
GVZwqVhFdiLUYTeT5VYnSaQkYuvKAerD7KXq3ylwDzdHpIGv67kVIpNgK47zPWgH
tnKde/P+FG7lTi+vAlwVd+FRVmWV/2dpoi4f8xY6Ar4U6H120dIRqYpUXYvJ0RNd
fHtwZjdSPKOM3RdZZ6cwxi8j0ZcEaBz8OUm1qsh1kqCWcMv1YgtfDuYKrVrvp2eW
FYwtLD+ZM1hc+/EUwxP8HlqyJIiDL3ubCpYWczUFbwrvpV+8EpEdwvmvQ9LFJgC+
JZb6V40Kwpq5lvUo7cSGeRm/5wwmdyVlofgGr06ve6JziL7JPVQqFUdwnIxbjAHV
FNHISFi4wI8g04fLchrlzQUhmVpYPYLSDCn3PCabHoTb+SkV/+SNJelVRn0ltp79
KlXxoUTjEuRqYiZpcs2QZ2LvJ1lfJdXPT0hzahMdyWhtTH0DS8oL1+Q/xN3VY5Ft
f4eRUiU1+30=
=+EGl
-----END PGP SIGNATURE-----

--Sig_/3obcSwKj+bf_1yc+Q_cuN52--
