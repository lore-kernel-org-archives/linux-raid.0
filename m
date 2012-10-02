From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/6] Fix return code for --detail-platform
Date: Tue, 2 Oct 2012 16:38:21 +1000
Message-ID: <20121002163821.4ae70873@notabene.brown>
References: <20120926114202.328.71156.stgit@gklab-128-174.igk.intel.com>
	<20120926114257.328.56556.stgit@gklab-128-174.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PyWo0QgaJFo7UmjW912vGkL"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120926114257.328.56556.stgit@gklab-128-174.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

--Sig_/PyWo0QgaJFo7UmjW912vGkL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Sep 2012 13:42:58 +0200 Maciej Naruszewicz
<maciej.naruszewicz@intel.com> wrote:

> Variable 'err' is initially set to 1, so changing its value with
> '|=3D' won't set it to 0 even if the operation is successful.
>=20
> Signed-off-by: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
> ---
>  Detail.c |    1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/Detail.c b/Detail.c
> index 57faf3c..96d1ff6 100644
> --- a/Detail.c
> +++ b/Detail.c
> @@ -640,6 +640,7 @@ int Detail_Platform(struct superswitch *ss, int scan,=
 int verbose, int export, c
>  	if (!scan)
>  		return err;
> =20
> +	err =3D 0;
>  	for (i =3D 0; superlist[i]; i++) {
>  		struct superswitch *meta =3D superlist[i];
> =20
Good catch.

Applied, thanks.
NeilBrown

--Sig_/PyWo0QgaJFo7UmjW912vGkL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGqL3Tnsnt1WYoG5AQKavg//VkYLRXH6FAfsYwclj6aYpE8GT/cSYqG3
WLqkAr/YMv9A0n9DuYnZwMmvtyrZgK5bfsgDCi0iLir3+EX0IODXRDlw7ZRaqSsv
a7pYJP3cijoxpLwaxJfSPavkllKRhy53e5fwlSPaTTz1cMF+EZ1WfTVt9FPucG/f
Ep5cisuvFZjHaEwOddq/3r07AulfF2QjimrofhjeXIE++nsW3zyyrXq3H62X+Yrs
UERJhlVag6bDdtek18Q39eDS7xElXBRIXkd7QINA8PdMAVp1tVEiDyQpZohNbUYf
PKbh1NMR7O3d5BmRInnR+z8yrupxiB5Qtf+NWFvo9KUJwPgvFVh5wC/Cqz7OCjMU
Nqaqb2P6i4Y7izWAyLv6XqhkZ3XeBJgvjBgV1VAmnAW+60psJTujeeKvC9lKWs0p
aF75efDFULsLgxBC+7SBIDJvzzLtqonVlaTVcLD0Qguj9bP5x+e/Yo2JdPwjvy2E
U553TKfJkFVyCs2okQoDZmmi4n3YISMQcWYz5Eun/4HS6KseJRW7j5H6RvS6FvCb
ThXpnhpc/SduQcuna2j4TeqKepcmjdKcz5fGzxz7cKqQU2MXgRp5ENZLbkpi2lzY
owuA72s7wSGDV81oUBAVuNlZJqQUNqaQjaQ6XROBHx0AHhvyN9WwThQySCRrW8ba
ctbNBzjfkjs=
=OQCN
-----END PGP SIGNATURE-----

--Sig_/PyWo0QgaJFo7UmjW912vGkL--
