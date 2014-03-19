From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/1] Work around architectures having statfs.f_type
 defined as long
Date: Thu, 20 Mar 2014 09:24:56 +1100
Message-ID: <20140320092456.5366169a@notabene.brown>
References: <1395235562-24672-1-git-send-email-Jes.Sorensen@redhat.com>
	<1395235562-24672-2-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SH/FujIWSQnLcR0Dtz+9RzF"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1395235562-24672-2-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, arnd@arndb.de, ralf@linux-mips.org
List-Id: linux-raid.ids

--Sig_/SH/FujIWSQnLcR0Dtz+9RzF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 19 Mar 2014 14:26:02 +0100 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> Having RAMFS_MAGIC defined as 0x858458f6 causing problems when trying
> to compare it directly against statfs.f_type being cast from long to
> unsigned long.
>=20
> This hack is extremly ugly, but it should at least do the right thing
> for every situation.
>=20
> Thanks to Arnd Bergmann for suggesting the fix.
>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  util.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/util.c b/util.c
> index e32d97a..afb2bb1 100644
> --- a/util.c
> +++ b/util.c
> @@ -1946,9 +1946,13 @@ int in_initrd(void)
>  {
>  	/* This is based on similar function in systemd. */
>  	struct statfs s;
> +	/* statfs.f_type is signed long on s390x and MIPS, causing all
> +	   sorts of sign extension problems with RAMFS_MAGIC being
> +	   defined as 0x858458f6 */
>  	return  statfs("/", &s) >=3D 0 &&
>  		((unsigned long)s.f_type =3D=3D TMPFS_MAGIC ||
> -		 (unsigned long)s.f_type =3D=3D RAMFS_MAGIC);
> +		 ((unsigned long)s.f_type & 0xFFFFFFFFUL) =3D=3D
> +		 ((unsigned long)RAMFS_MAGIC & 0xFFFFFFFFUL));
>  }
> =20
>  void reopen_mddev(int mdfd)


Applied, thanks.

NeilBrown


--Sig_/SH/FujIWSQnLcR0Dtz+9RzF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUyoZODnsnt1WYoG5AQLL8g/9FPe2GDeD+chQxtmBDi/osMawCf2Jbcjz
zVSgj83i6uoclFXd921avrZhaAMsu9gno0krV5l1eLIlx4u/eP+qRpa6P412E1ql
TRPJPrVqlYz3FPsbltgXN1STXvv42bfUujVnr+tBdlgjNjFekNIaJ1g+tQsx3V3T
pVDl/xjs8jvwC5UwyFWROKc9spgmtOeifG0bLp01b3dqT+pkPWpKMhIUn39xzK5y
MVna8wj9W2YPzOLfDRbrnPgBQFQ2Xiucrcxfmcg1t8Koqmlgy8fih0Ks38cJNhDE
CI+GseHJ+c68vDGpWi/B8maqqxTVWDk6uWbyo+FDFbcQcbpuKZUlmCaIhNsNn3vC
t46s0VE719bt5Uv8JcfIkyBcUOOXYDOwUGn97Ch9UyQfEIkT0aXJT8v3OzcDiXcr
n4X7pQVzCT4i31J+wZLyNC9En0s8KGUkiC3YKgGeRw5WUzwFDR217LGB8kdAYQq0
DfSOObgN1BLb5DTyxbKCIJvYLm4KyjbfGEyDA0mNFOzhGQ6I+tg9lsYa14BbkqEa
8UPsZehU/Kho4SqBeh5l8zPme/UlQtLrABP1DFAKV4NsCT/0BDqwfxTDv1wvc/zT
0ibeX5rbwmiapuODbgD1rcPe62g9eTO1n+Tb99iTtxQhdBnQqPw5BFa9jILGGQjr
VK6wahpvS6g=
=jsiO
-----END PGP SIGNATURE-----

--Sig_/SH/FujIWSQnLcR0Dtz+9RzF--
