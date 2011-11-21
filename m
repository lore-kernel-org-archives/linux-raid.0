From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] fix: correct metadata's update communication
Date: Mon, 21 Nov 2011 16:19:56 +1100
Message-ID: <20111121161956.06352812@notabene.brown>
References: <20111118143433.14114.6361.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/w5XuocxoOWWE38Y=8C=U9=A"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111118143433.14114.6361.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

--Sig_/w5XuocxoOWWE38Y=8C=U9=A
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 18 Nov 2011 15:34:33 +0100 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> The problem occurs when array under migration is assembled incrementally.
> st->update_tail is not initialized in function
> assemble_container_content() and during reshape
> the checkpoint information in metadata is not being updated.
>=20
> The value of st->update_tail is now initialized in function
> assemble_container_content() and during reshape the checkpoint
> information in metadata is being updated correctly on all disks.
>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  Assemble.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>=20
> diff --git a/Assemble.c b/Assemble.c
> index 3c8e74d..74708d1 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1585,6 +1585,9 @@ int assemble_container_content(struct supertype *st=
, int mdfd,
>  				if (!mdmon_running(st->container_dev))
>  					start_mdmon(st->container_dev);
>  				ping_monitor_by_id(st->container_dev);
> +				if (mdmon_running(st->container_dev) &&
> +						st->update_tail =3D=3D NULL)
> +					st->update_tail =3D &st->updates;
>  			}
> =20
>  			err =3D Grow_continue(mdfd, st, content, backup_file,


This and the previous patch ( [PATCH] imsm: fix: correct printing value of
blocks per migration unit) applied - thanks.

NeilBrown


--Sig_/w5XuocxoOWWE38Y=8C=U9=A
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTsnffDnsnt1WYoG5AQK27BAAoIdQwWB4zXwpj4+rZJq2yHvJUYUcGZ9V
9T8z/FOqRMojHloPCRkryIP2SEgLaJSquIkzkHD2IKJ41O/4Z2g5lbIVfbyH73Us
n2rC2Gr0jQdFfmk2tOJxGuHzUXFqnFE1aKGcdKcp7nU93L+tUqjIP7BEMvSyrZvV
U/c7a053XodBtgq7eyqRiHkdwnENlmYWXIF8b2qmXhYY3CL+jbDSp0/4zus7KsWY
sD+7DJCJEnLt8WJqSfw6hyer3d39M+r/cE4O1EVOLn+k8cgQ10O26WHLe2Ky/TDb
RlZZiPPn9PoZnJWBwiBUQq/5XqgsO2khNJiuyuYIQNS0QBZs8Oc1kMOvDNS/ciS1
NCnvsd01TJxFt2pfvY8gvVp3U1bS5D8IkCihNcXOlejgI9Tjk728BWhrHiR79HNB
vWE4g/c41PMVCzh+GH5pphKvtLy8Aea+shZDguBW2wEpdc1x5HDFGlhRNyLBGQuW
3feNBVoDEOhhn2pBnbh0cKR+1kTKuBd5dqyIg+dS7GwSjzRjvQ8Lq4MQw44KUVSK
Nq0nc85OkBC7TZgXBXDFopCkkhDzkRdIJoIjRgXxGkvDIanh7S9XTTCF31hKc4cg
YDtHW0K+vCVXXzV/j21IJH90R5eh35lR6ORTG7qzp4pPIfMbjq6zSnt5Kh9eVBRK
bs+teL674ac=
=XUU0
-----END PGP SIGNATURE-----

--Sig_/w5XuocxoOWWE38Y=8C=U9=A--
