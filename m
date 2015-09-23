From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/2] md: clear CHANGE_PENDING in readonly array
Date: Wed, 23 Sep 2015 16:05:33 +1000
Message-ID: <87eghpy8k2.fsf@notabene.neil.brown.name>
References: <bda150068cfdb69bf8b632c32dc2a7db17c919f4.1442596586.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bda150068cfdb69bf8b632c32dc2a7db17c919f4.1442596586.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Shaohua Li <shli@fb.com> writes:

> If faulty disks of an array are more than allowed degraded number, the
> array enters error handling. It will be marked as read-only with
> MD_CHANGE_PENDING/RECOVERY_NEEDED set. But currently recovery doesn't
> clear CHANGE_PENDING bit for read-only array.  If MD_CHANGE_PENDING is
> set for a raid5 array, all returned IO will be hold on a list till the
> bit is clear. But recovery nevery clears this bit, the IO is always in
> pending state and nevery finish. This has bad effects like upper layer
> can't get an IO error and the array can't be stopped.
>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/md.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 95824fb..c596b73 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8209,6 +8209,7 @@ void md_check_recovery(struct mddev *mddev)
>  			md_reap_sync_thread(mddev);
>  			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>  			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> +			clear_bit(MD_CHANGE_PENDING, &mddev->flags);
>  			goto unlock;
>  		}
>=20=20
> --=20
> 1.8.1

Hi,
 I can see that clearing MD_CHANGE_PENDING there is probably correct -
 bug introduced by
   Commit: c3cce6cda162 ("md/raid5: ensure device failure recorded before w=
rite request returns.")

 However I don't understand your reasoning.  You say that the array is
 marked as read-only, but I don't see how that would happen.  What
 causes the array to be marked "read-only"?

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWAkEtAAoJEDnsnt1WYoG5svYP/jdsPL6WCwFQqaHXzjuJdbkI
OX4WLfOQ1Xxu1ittlYwk9yLiaHmfvixx1bZWAZqkxGFP7NPeNZdF8mmGwbGxitga
BG7TLYwYr8v5jtIBMjsyyE0YTqjfTNuVVM6Nwecg1AJGjI7jTpjMoWhlgLLJrqH5
epbfzDsr2CF/g2+FLQFiBn/AMAX6XWUmxjvr++Zs6KGKFzAd7FN3Z7d7D81r1Yg4
LiBeTTD3X9ajfuqAnNZwH+shos1M3RPVJDsZRhuHpfzcV5mDCYNY00m8LjJODitR
YHgFL1Ma8ACYajIgj1APE9skHdicVF8pawUmtLkLNVHZag0/0H3TZ3MdWSkhoMpk
gMbJnj4V050H6AX0plxCpwqsYW8EQu3ypSQAjKQupgb3N6vNVulpfEJrM3IjQD28
xWBcFlatUVIe1QOUYIID5vX6COvMR6bE7OI0T6lp588JUqnGbreFs11W+/tWnIt5
c8lzKADfdArOsClGsj9dExsCgkuExnrUev+U4tzFkOmfjURdKAyryNyv9ruPfyRr
9RzurXPJaWjkNs6Q1rF7cP8xuTk+4DuHADw98XvHvH7G4Gf43wI1IlcfQh9h9Qzq
BSw1T87F3lzpCKI346dgpS7vXwPD3xHocpt+13BDf2GR5qAmn4sOgDqEaNtVm+Hn
oX49UXzajC6JGDQJIRbk
=+oy/
-----END PGP SIGNATURE-----
--=-=-=--
