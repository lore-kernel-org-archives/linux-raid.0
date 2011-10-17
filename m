From: NeilBrown <neilb@suse.de>
Subject: Re: [mdadm PATCH 2/2] Fix unterminated buffer after readlink() call
Date: Mon, 17 Oct 2011 11:19:19 +1100
Message-ID: <20111017111919.41c8157c@notabene.brown>
References: <201110131122.14099.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/E.mTPFTotNi.D_dTjGSC2ml"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201110131122.14099.thomas.jarosch@intra2net.com>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/E.mTPFTotNi.D_dTjGSC2ml
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Oct 2011 11:22:13 +0200 Thomas Jarosch
<thomas.jarosch@intra2net.com> wrote:

>=20
> Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
> ---
>  mdopen.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>=20
> diff --git a/mdopen.c b/mdopen.c
> index 0a17421..555ab84 100644
> --- a/mdopen.c
> +++ b/mdopen.c
> @@ -360,8 +360,12 @@ int create_mddev(char *dev, char *name, int autof, i=
nt trustworthy,
> =20
>  			if (lstat(chosen, &stb) =3D=3D 0) {
>  				char buf[300];
> +				ssize_t link_len =3D readlink(chosen, buf, sizeof(buf)-1);
> +				if (link_len >=3D 0)
> +					buf[link_len] =3D '\0';
> +
>  				if ((stb.st_mode & S_IFMT) !=3D S_IFLNK ||
> -				    readlink(chosen, buf, 300) <0 ||
> +				    link_len < 0 ||
>  				    strcmp(buf, devname) !=3D 0) {
>  					fprintf(stderr, Name ": %s exists - ignoring\n",
>  						chosen);


Thanks.  I've applied this and the other one.

NeilBrown


--Sig_/E.mTPFTotNi.D_dTjGSC2ml
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTpt0iDnsnt1WYoG5AQJhVxAAk+UtJthViCLCyfm30jmcCUMp4o1GSN0p
WPBMUvH3ma+Q0dj8Fre0VY0sT6OdspVEclPpvei39MZIJOZuQdXlVyBuKb+5Ii9s
3uyPc2sMiBSyqoqsuqCmfy0QR9aCpa37VdT4RoVuy0AunY7yQbvcLy0nxFAIig6l
8zW7c6qdSKpDF3skW3PshiNK/tEho7luGmODM92YJesvatcDmX+gQbYU7uhljbxq
79ih/NgdY8X5hCiZySZYULJ7WulprquQGzkU7ZpYfLwzgBhI6RlqETSi0Jjdhj4E
BeScG/s2qw0NKke9UK+00F0ZCYSWWLLV8Rv+5g+8g8bmwWGi1IdHvYKPQ2ApMHpp
dmLjMMkwq57uMmadJm32Npo9QiWPCxi/alHnG1cWnGjFViOmRT/7qoS7391vQt2n
swnAjigRNWTTJ+RKM2RE4w0jl60vT/6B4692Kj1dko4yCRstYO4KPS2l8tY0jTfv
1Ch5cXiXwJJyVy8edzrPszmx9B8Mz4+ACBVyUU80KE0BVnbyyiXQpMFHfiTMgXXm
+629nLKqEaDtVpuf1BCOASezLEUOWmwnZzBoxS6ak/0Irzg8G+7GhmEXHhB2NZtJ
SfnFK4Na+WYLX8oILt/cewwbe9ij3JanzYc+zkilKXEMWqclxDzgx3M4z3kYp7f3
HvWCkSy942g=
=4f2J
-----END PGP SIGNATURE-----

--Sig_/E.mTPFTotNi.D_dTjGSC2ml--
