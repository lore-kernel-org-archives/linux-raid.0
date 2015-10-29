From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md/raid5: fix locking in handle_stripe_clean_event()
Date: Thu, 29 Oct 2015 09:34:54 +0900
Message-ID: <87r3kebjgx.fsf@notabene.neil.brown.name>
References: <1446022340-1453-1-git-send-email-klamm@yandex-team.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1446022340-1453-1-git-send-email-klamm@yandex-team.ru>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Roman Gushchin <klamm@yandex-team.ru>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28 2015, Roman Gushchin wrote:

> After commit 566c09c53455 ("raid5: relieve lock contention in get_active_=
stripe()")
> __find_stripe() is called under conf->hash_locks + hash.
> But handle_stripe_clean_event() calls remove_hash() under
> conf->device_lock.
>
> Under some cirscumstances the hash chain can be circuited,
> and we get an infinite loop with disabled interrupts and locked hash
> lock in __find_stripe(). This leads to hard lockup on multiple CPUs
> and following system crash.
>
> I was able to reproduce this behavior on raid6 over 6 ssd disks.
> The devices_handle_discard_safely option should be set to enable trim
> support. The following script was used:
>
> for i in `seq 1 32`; do
>     dd if=3D/dev/zero of=3Dlarge$i bs=3D10M count=3D100 &
> done
>
> Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
> Cc: Neil Brown <neilb@suse.de>
> Cc: Shaohua Li <shli@kernel.org>
> Cc: linux-raid@vger.kernel.org
> Cc: <stable@vger.kernel.org> # 3.10 - 3.19

Hi Roman,
 thanks for reporting this and providing a fix.

I'm a bit confused by that stable range: 3.10 - 3.19

The commit you identify as introducing the bug was added in 3.13, so
presumably 3.10, 3.11, 3.12 are not affected.
Also the bug is still present in mainline, so 4.0, 4.1, 4.2 are also
affected, though the patch needs to be revised a bit for 4.1 and later.

Does that match your understanding?  Or is there something that I am
missing?

Thanks,
NeilBrown

> ---
>  drivers/md/raid5.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index e421016..5fa7549 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3060,6 +3060,8 @@ static void handle_stripe_clean_event(struct r5conf=
 *conf,
>  		}
>  	if (!discard_pending &&
>  	    test_bit(R5_Discard, &sh->dev[sh->pd_idx].flags)) {
> +		int hash =3D sh->hash_lock_index;
> +
>  		clear_bit(R5_Discard, &sh->dev[sh->pd_idx].flags);
>  		clear_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags);
>  		if (sh->qd_idx >=3D 0) {
> @@ -3073,9 +3075,9 @@ static void handle_stripe_clean_event(struct r5conf=
 *conf,
>  		 * no updated data, so remove it from hash list and the stripe
>  		 * will be reinitialized
>  		 */
> -		spin_lock_irq(&conf->device_lock);
> +		spin_lock_irq(conf->hash_locks + hash);
>  		remove_hash(sh);
> -		spin_unlock_irq(&conf->device_lock);
> +		spin_unlock_irq(conf->hash_locks + hash);
>  		if (test_bit(STRIPE_SYNC_REQUESTED, &sh->state))
>  			set_bit(STRIPE_HANDLE, &sh->state);
>=20=20
> --=20
> 2.4.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWMWmuAAoJEDnsnt1WYoG5NBMP/1LTKamNNx65B5M0ATat3og/
IsDKfE81hOgAO9LhbaXuXY/oQpRKDKqFFIJtXekzYKiRxb7Kk8cNU0LYPXUZ/7mL
yeDKzd1hagqEPxJvzpDDolKuTLyOa0UuylSoUWlmynHNf2uTCcKd2n0M6NsoHO1J
pQqT9M5smN5m+b+dx2AaYK9JaSDFc+AGQBO11x0Z2xmXKbk4iqWS+umflVO2mr8K
g7sKeWXh79yMJ8DfL5JCuYIvejzhMXCJR3P21zr5UKhUG0Lx2r8iUTnN8RqvKIML
i1PpbVWcn0HrbRzdcvMZtJXWSeN4XeapD1tcomSr3TPs8fJHwdVXqfJxO5GVBQZf
G4P12as/wIbYOzTbg+HJ66S8u5xNZhNkGiFtJVG2zbMPb83PalsjMoB8MByw9BFI
050oy2iR5LtAfYiIHZotZoXvw9tA5hwrCHCtFOJNJ22yvK2k1xyjOYoGqWbyEm85
Pql3s4VFOGhzkTpEXVZBcZHeE1+0eIo6A0InSO6n9GFU1GuJi/iW03pOmrsA0qqF
zQrU75qsnjqYoUuBH8xrfErmu473OIV7c4xOqQy41vtcr4EKyjNVz+gBtdrqXkhd
4HJ0Yqt+mSeUUW4PYvmGxOOPe13V244wlYNA3gXQC9YFZOuCRpgfsOPqjjVAxC2G
W8p7RU18AJBQ2+rxOp7j
=Oc1w
-----END PGP SIGNATURE-----
--=-=-=--
