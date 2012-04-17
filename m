From: NeilBrown <neilb@suse.de>
Subject: Re: [patch]raid5: support sync request
Date: Tue, 17 Apr 2012 16:46:35 +1000
Message-ID: <20120417164635.733b1776@notabene.brown>
References: <4F8CFB12.306@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/gL6P6cTrC9IqgP+_66O=qk5"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F8CFB12.306@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/gL6P6cTrC9IqgP+_66O=qk5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Apr 2012 13:09:38 +0800 Shaohua Li <shli@kernel.org> wrote:

>=20
> REQ_SYNC is ignored in current raid5 code. Block layer does use it to do=
=20
> policy,
> for example ioscheduler. This patch adds it.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>   drivers/md/raid5.c |   12 ++++++++++--
>   drivers/md/raid5.h |    1 +
>   2 files changed, 11 insertions(+), 2 deletions(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2012-04-17 11:59:24.556008869 +0800
> +++ linux/drivers/md/raid5.c	2012-04-17 12:06:06.306007114 +0800
> @@ -518,6 +518,8 @@ static void ops_run_io(struct stripe_hea
>   			replace_only =3D 1;
>   		} else
>   			continue;
> +		if (test_and_clear_bit(R5_SyncIO, &sh->dev[i].flags))
> +			rw |=3D REQ_SYNC;
>=20
>   		bi =3D &sh->dev[i].req;
>   		rbi =3D &sh->dev[i].rreq; /* For writing to replacement */
> @@ -1114,6 +1116,8 @@ ops_run_biodrain(struct stripe_head *sh,
>   				dev->sector + STRIPE_SECTORS) {
>   				if (wbi->bi_rw & REQ_FUA)
>   					set_bit(R5_WantFUA, &dev->flags);
> +				if (wbi->bi_rw & REQ_SYNC)
> +					set_bit(R5_SyncIO, &dev->flags);
>   				tx =3D async_copy_data(1, wbi, dev->page,
>   					dev->sector, tx);
>   				wbi =3D r5_next_bio(wbi, dev->sector);
> @@ -1131,13 +1135,15 @@ static void ops_complete_reconstruct(voi
>   	int pd_idx =3D sh->pd_idx;
>   	int qd_idx =3D sh->qd_idx;
>   	int i;
> -	bool fua =3D false;
> +	bool fua =3D false, sync =3D false;
>=20
>   	pr_debug("%s: stripe %llu\n", __func__,
>   		(unsigned long long)sh->sector);
>=20
> -	for (i =3D disks; i--; )
> +	for (i =3D disks; i--; ) {
>   		fua |=3D test_bit(R5_WantFUA, &sh->dev[i].flags);
> +		sync |=3D test_bit(R5_SyncIO, &sh->dev[i].flags);
> +	}
>=20
>   	for (i =3D disks; i--; ) {
>   		struct r5dev *dev =3D &sh->dev[i];
> @@ -1146,6 +1152,8 @@ static void ops_complete_reconstruct(voi
>   			set_bit(R5_UPTODATE, &dev->flags);
>   			if (fua)
>   				set_bit(R5_WantFUA, &dev->flags);
> +			if (sync)
> +				set_bit(R5_SyncIO, &dev->flags);
>   		}
>   	}
>=20
> Index: linux/drivers/md/raid5.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.h	2012-04-17 11:59:26.866008859 +0800
> +++ linux/drivers/md/raid5.h	2012-04-17 12:00:29.196008586 +0800
> @@ -285,6 +285,7 @@ enum r5dev_flags {
>   			 */
>   	R5_Wantdrain,	/* dev->towrite needs to be drained */
>   	R5_WantFUA,	/* Write should be FUA */
> +	R5_SyncIO,	/* The IO is sync */
>   	R5_WriteError,	/* got a write error - need to record it */
>   	R5_MadeGood,	/* A bad block has been fixed by writing to it */
>   	R5_ReadRepl,	/* Will/did read from replacement rather than orig */

Thanks.
There was some interesting white-space damage in this patch, but I sorted it
out and applied it.

However I'm not convinced that it is correct.  It is probably better than
nothing so I'll allow it for now, but you might want to fix it up to make it
better.

The point of REQ_SYNC is to remove any delays in handling the write, and get
it to disk as soon as possible.
However with RAID5, the write isn't complete until all the blocks in the
stripe have been written, so just setting REQ_SYNC on the write for one of
the blocks may not achieve the goal.
You at least need to use REQ_SYNC on the parity block, and you probably want
it on all the blocks in the stripe.

So rather than setting R5_SyncIO on the dev, you should be setting in on the
whole stripe_head.

Similarly WantFUA should affect all device writes in the strip as they all
need to hit the media for any of the data to be considered 'safe'.

If you would like to fix both of those issues at once, that would be great =
:-)

Thanks,
NeilBrown



--Sig_/gL6P6cTrC9IqgP+_66O=qk5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT40Ryznsnt1WYoG5AQIVeBAAvmQneM++scVYSXpHagPybcH+2XJk9PXD
Ds/7vLzmBRWzBj8WfJ2d6L1q3wtAd5sE16lS9ILyghUSNtuBVf9Ltc8nE9cf6C4R
lhsp8eyH7klJrflVOTbeXw7PQULQ7fnE0oq1JMnrTWem8nBUOqza1qGGhcRfDtWV
yXJSWWXNy48btZksIRPRm/ALh2GzJfFAdLVoQ78HlD8W3+qQbNZHA3YCns+IHWZz
6ovL9EHO0q0q5+IYSPwnK/o7bmCQB5IFRGOPGyjnzODXXX1PjjICfNmSiUhjnWXf
Ymh8tqSaZd3jfHD5jhNC0/AbeSpyeFiQG0cN8X0sVTMwan5wU5HE75hLbwDvwBI7
h/CDjwPEAGOFM7Z7KYLkpDSKG0K3PTHtfVn6y6/nPLp6FFIUQxmSPRiVuvcNDiko
qQNVNZGzarb9W5p/YWwUnTjCsLhEEWXNbgkLwbIdh+EgDA2wed/XnYVngpEfW1Cq
5Ytr09jWhFo0Z7w6RWuL8ao7n6qVvnrS4tDckHSFjRMoo751Ny5WEikaBn23p/5d
hR2Swg8EAj0KS24lrdTh+CTZogsq6YVtxb0iZ6J6q63udDVvk3B6CADJygUW/Dqi
obl+CsMykIzUXLHabqHGYRUUYrYkFDJAwGxkOd3RKi+DsG8aEKLN+VEP3wy3h58l
KAXu9GIj1l4=
=uh+y
-----END PGP SIGNATURE-----

--Sig_/gL6P6cTrC9IqgP+_66O=qk5--
