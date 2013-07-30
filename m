From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Avoid double close()
Date: Wed, 31 Jul 2013 08:52:56 +1000
Message-ID: <20130731085256.5774273f@notabene.brown>
References: <1375201803-9797-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_bnX//xNoN2TCumm+=hvzL9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1375201803-9797-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/_bnX//xNoN2TCumm+=hvzL9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 30 Jul 2013 18:30:03 +0200 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> Coverity discovered a possible double close(fd2) in Grow.c. Avoided by
> invalidating fd2 after the first close.
>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  Grow.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/Grow.c b/Grow.c
> index c1ae6e8..ff4ed5d 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -4685,6 +4685,8 @@ int Grow_continue_command(char *devname, int fd,
>  				continue;
>  			err =3D st->ss->load_super(st, fd2, NULL);
>  			close(fd2);
> +			/* invalidate fd2 to avoid possible double close() */
> +			fd2 =3D -1;
>  			if (err)
>  				continue;
>  			break;

Applied, thanks.

NeilBrown

--Sig_/_bnX//xNoN2TCumm+=hvzL9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUfhDyDnsnt1WYoG5AQLGtA//Rc05RNJZQluS0CQ9WbAAp+m2Kwm/sNRI
oJnzZzHiXaVWC/PxjprQCiv3MYQhUvV3ZJSH3k6PhBU+r/yspJgf/cHdSnGfx0Li
CzjFyjiQj9dbO1N8+FGK0NnQv1WoMsMXxGVN5O+dUntMgWjmF+B25hAhPWZSzuQc
fxZzDmwoKJN4pom8GWdmnK9vw04BWqL4PU8h2pLkznW/qiczDZ1LK66f5A3d6Xj+
FRD79VRSEHM70zfIXHRoWZgqiONKMWItBEiwEXDNf7dyP/QjJf3uK40mwKGGToGU
To4A1XfTuJyl0qwnfhREby+m+5zGgdh6/+eQZXVNZDyS0xGHc8G3pRJVw31i6ru9
BYChZB63T/PBhEszFblp6jW46pHukAwd3dsqmprZRUoG+6Ywg3HyjwJQOcEsJoPH
TpAUterLphJ0af++BV0EprdlyofOEA4SzDKV0VwNDEa8tA2voW/7HA/eOnEpYQzE
zf3BnI+0vxOwKOzn2TZdljJG9d0ZYcQnZXJLZOkVFuOJ04JP7ERL2PF1Oqpfidu4
r9KyBlGFeOu0EeLDVahxUk1IxquPeLACaeYfI3LY0lOyDpvoPOLCOhd29xVfww3i
rw0yzYoRlz0fD9nOdhpjv4b/44H+n6sznPuVWPU0mYx9svl5kqkUemg602ai1FXa
MkYvx5kFn3k=
=tALs
-----END PGP SIGNATURE-----

--Sig_/_bnX//xNoN2TCumm+=hvzL9--
