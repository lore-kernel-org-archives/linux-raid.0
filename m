From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Manage.c: fix make everything compilation error
Date: Tue, 14 Aug 2012 10:00:52 +1000
Message-ID: <20120814100052.0f991e9d@notabene.brown>
References: <20120813095619.21893.87478.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BumZf/80=ocZU8QP618s++U"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120813095619.21893.87478.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com, ed.ciechanowski@intel.com, Jacek.Danecki@intel.com
List-Id: linux-raid.ids

--Sig_/BumZf/80=ocZU8QP618s++U
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Aug 2012 11:56:19 +0200 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> This patch fixes the following make everything compilation error:
> Manage.c: In function =E2=80=98Manage_add=E2=80=99:
> Manage.c:538: error: =E2=80=98dev_st=E2=80=99 may be used uninitialized i=
n this function
> make: *** [mdadm.Os] Error 1
>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  Manage.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/Manage.c b/Manage.c
> index d5fc974..f83af65 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -535,7 +535,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  	       char *update, unsigned long rdev, unsigned long long array_size)
>  {
>  	unsigned long long ldsize;
> -	struct supertype *dev_st;
> +	struct supertype *dev_st =3D NULL;
>  	int j;
>  	mdu_disk_info_t disc;
> =20

applied, thanks.

NeilBrown


--Sig_/BumZf/80=ocZU8QP618s++U
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCmVNDnsnt1WYoG5AQKxMw/9EfAtKkJVtLpzJs4url2vK4gDDj3Zb3mg
yDD/eL10r58uh0KEdXmp+IqT12JMy5Eee7tVd6c+qnK7q0IzSbU+rHwG4IrdItpS
w66o5rYPJs5g1lCc4Ijbsv66zUTvgIObNmsdEq7ZAjspFY24W18+hze85ed/2HkE
072xNwDgsqgLto/iyj+jDtZrW9WI0SSRucWHCWvFN5EB65Hm8MXwpbjhxXMwx6jj
1cakk944d/Vai9abkFIPhky5hctT1pC6ZZHTfOslAXpQ+glVLOh413CcSA6EZpmG
XbFc4izZYUd5WkJ+xMv1rre8ZOqMXSk7QQ94siUl3dEet+749eiuAijq3i27908b
2hUKsR6u+qHOP7zs0sRWEoS0uewxRA5/AcO94n5nYG8KEAYSO+AQ5Jvy0IR83Q9a
T641sFM/LljOpMQCBb4lfQeUzkgXQhMww6goRH8iC0GM9HD9yWdVjyRPToY/Oxfs
JV39dUCeYo8t8iaA6GZ3bi4bi3nehINVymMohWdA4Z3HB34fvWJumiBVrLrweSis
bp6iHI24ma47ojmT3p+UsLrW5PXWVCWIqSu9n9aDCnljzsAPoza4swUrL8qMdEwV
jOKBgDnwRvVu7vxEBTxK/HYTSA6RzIPWEyzZn8AevFySsc2mF6VtmyVnlVDrShCC
HfZgQnH+jBA=
=9VGk
-----END PGP SIGNATURE-----

--Sig_/BumZf/80=ocZU8QP618s++U--
