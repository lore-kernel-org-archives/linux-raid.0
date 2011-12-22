From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] FIX: Verify if array name doesn't exist already
Date: Fri, 23 Dec 2011 07:15:22 +1100
Message-ID: <20111223071522.4224782e@notabene.brown>
References: <20111222142109.5678.19199.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/asAz9SHF9RB1nyLmqBe_KNr"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111222142109.5678.19199.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/asAz9SHF9RB1nyLmqBe_KNr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 22 Dec 2011 15:21:10 +0100 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> When e.g. array name (an) is correct and it is the same as container name=
 (cn),
> file element creation /dev/md/an will replace /dev/md/cn.
> This can cause that user cannot access container using /dev/md/cn.
>=20
> Verify during array creation if chosen name is not already existing one.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>=20
>  Create.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
>=20
> diff --git a/Create.c b/Create.c
> index 5d1548b..e522d8e 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -558,6 +558,17 @@ int Create(struct supertype *st, char *mddev,
>  		map_unlock(&map);
>  		return 1;
>  	}
> +	/* verify if chosen_name is not in use,
> +	 * it could be in conflict with already existing device
> +	 * e.g. container, array
> +	 */
> +	if (stat(chosen_name, &stb) !=3D -1) {
> +		fprintf(stderr, Name ": Array name %s is in use already.\n",
> +			chosen_name);
> +		close(mdfd);
> +		map_unlock(&map);
> +		return 1;
> +	}
>  	mddev =3D chosen_name;
> =20
>  	vers =3D md_get_version(mdfd);


Thanks.  However I would rather use map_by_name to check for prior existenc=
e,
as create_mddev can actually create the device in /dev if udev is not in us=
e.

So this is what I have committed.

NeilBrown

commit 3e9df86add05b3a759148a8a1760a44887654322
Author: Adam Kwolek <adam.kwolek@intel.com>
Date:   Fri Dec 23 07:13:55 2011 +1100

    FIX: Verify if array name doesn't exist already
   =20
    When e.g. array name (an) is correct and it is the same as container na=
me (cn),
    file element creation /dev/md/an will replace /dev/md/cn.
    This can cause that user cannot access container using /dev/md/cn.
   =20
    Verify during array creation if chosen name is not already existing
    one.
   =20
    [Changed to use map_by_name() rather than stat() to determine prior
     existence - NeilBrown]
   =20
   =20
    Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Create.c b/Create.c
index 5d1548b..90ff3ed 100644
--- a/Create.c
+++ b/Create.c
@@ -558,6 +558,18 @@ int Create(struct supertype *st, char *mddev,
 		map_unlock(&map);
 		return 1;
 	}
+	/* verify if chosen_name is not in use,
+	 * it could be in conflict with already existing device
+	 * e.g. container, array
+	 */
+	if (strncmp(chosen_name, "/dev/md/", 8) =3D=3D 0
+	    && map_by_name(&map, chosen_name+8) !=3D NULL) {
+		fprintf(stderr, Name ": Array name %s is in use already.\n",
+			chosen_name);
+		close(mdfd);
+		map_unlock(&map);
+		return 1;
+	}
 	mddev =3D chosen_name;
=20
 	vers =3D md_get_version(mdfd);

--Sig_/asAz9SHF9RB1nyLmqBe_KNr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTvOP2jnsnt1WYoG5AQJvdQ/+Olk6lRbAa4OLniSqyk4k5mDAAGYeLBCO
epdowtE1yNakZQumYJktT2i6AIi+RAyOl1TnMn0HuX+1y1ElFLe4F5E4JnSY1dfs
kGE+sd/v+azKd0z6f9dbkjOO+M+wsJbvGy2QOYjo/82g5xTouuvNJK0Z45vYK1tA
HF+WsAaNnr48XtyEQq5rAtfVwW4hslfbgp73uzqMbKe8ixKQ7K/VklUAKjmjR1Qq
HcZWPz4L/0YHp9dGPIVYd2XNbZDjX4bF52k250JWtSs0bd2/WMoaRnxNFXctOq/M
7rqNtMWPeyaKzoJsp2BrLr89DDnQRC6ohlzJydZwfb9NJefcFDXXv9sDhkTkUJ7E
izZ546+eBuND7XPIQO6RMYrX62936/UssLmzau6+W1BFdFM6A7rm0xysOb+BtIog
qb51Q9Llt4muRjW7npI0m3eaGIfQHX26emFyT0XvuVEylixLx//g/ifFLiTF9QKt
QvVtYWAJfG9cIIvXbaVlVKz8E/ZFRu4vteogoUubsJNWnOBKDWYROGQ5gy0HlWFE
8szelchf+2JjcsLI61tNj1ltqBM/KQHDlMfvE/udMEAIS0s0LpeTefi9hrncoGH5
El86trD4FQIAhkypeiXhOuaf595Gwn6E19yQEAc5VpXdlCSz3sE+q2LZ+hetNWp8
q/dGIykZahw=
=HNGP
-----END PGP SIGNATURE-----

--Sig_/asAz9SHF9RB1nyLmqBe_KNr--
