From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] mdmon: honour --offroot, again
Date: Thu, 12 Sep 2013 15:42:50 +1000
Message-ID: <20130912154250.09c986c2@notabene.brown>
References: <1378930519-7679-1-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/B73qbFnjTJ9W9VFA3_GxZO/"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1378930519-7679-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/B73qbFnjTJ9W9VFA3_GxZO/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Sep 2013 22:15:19 +0200 mwilck@arcor.de wrote:

> commit 3e32ba9d removed support for --offroot, and a9c15847 made
> mdmon use @ in argv[0] only when started from initrd.
>=20
> This breaks mdadm in OpenSUSE 12.3, which starts mdmon from the
> root file system and relies on --offroot to work as documented earlier.
>=20
> Reintroducing --offroot as an undocumented option, as its use is going to
> go away soon anyway.
>=20
> If this can't be applied, it should probably be included as distro-specif=
ic
> patch if mdadm 3.3 is built for OpenSUSE 12.3. I haven't checked if the
> patch is necesary for OpenSUSE Factory, too.
>=20
> Signed-off-by: Martin Wilck <mwilck@arcor.de>
> ---
>  mdmon.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/mdmon.c b/mdmon.c
> index f0b0623..8cd53d8 100644
> --- a/mdmon.c
> +++ b/mdmon.c
> @@ -320,7 +320,7 @@ int main(int argc, char *argv[])
>  			dofork =3D 0;
>  			break;
>  		case OffRootOpt:
> -			/* silently ignore old option */
> +			argv[0][0] =3D '@';
>  			break;
>  		case 'h':
>  		default:

Aggh...  This is all pretty horrible isn't it?

I've applied your patch because I don't think it can break anything and it
could possible help as you say.

Thanks,
NeilBrown

--Sig_/B73qbFnjTJ9W9VFA3_GxZO/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUjFUWjnsnt1WYoG5AQIqURAAvFdEBZH6GJ8nbrBhy2iAodDArpB09SQW
uLR068WFRNPPi1OvTerrgXHvxPQaQEApWjoYAXAWi1v3piGTsLHwQGAX6W3FsXXY
zhhO6aUzfqC6nfSuTNIKVXI1ISWQL0yA6srl1xwPn+sK+/KBtSBbuTeEC9clWZgR
X8PIcMp5t6WyYd8cDPMwzbDBw52eJDmZqbp3AWoukaoBFk5hFI+uaHsdkfHthpGT
dIBCVF7sJMcxOP2XMD/Qn4toxqN1tkNoENfLGXozSqZ2LqZ9DK060pO0ugHmfxmL
iFwtYvNMNsdPnTt52gjfNNj6jyzCHqF4cgTT+HBIwtmGYkK8PxchXKs6PxaBywkP
qccTjR/9zpXn29dLqsxTsx7rWNcaSV9zLBWYnpfrRlGXvFk6JfdvchqstUtu7aKa
RxBB6KIkKTr3e7yK7HHWib48fKq1iTI8th8ZmcFa5lo8zCqBHRQDc9NQjMdMNTD9
JSSD2cA9LcSErwczkN84mqDOoXKL9y1tmpq229Egy4Mr+Q2E/2rSh8MtLq6FD9yv
gEEUQpMeuKHbT/8Bdz9R5XUW1SYqbgXNSjP5jjueViZbJvuLHE+z8AcMqmIroZRl
RILcMKh7moSP1A2vLNH6ROm4lQ1ThbqNcfuCuskj47I08Nvw7r9kaVR3tpVt5GjL
goyH4mWQyjI=
=G5IJ
-----END PGP SIGNATURE-----

--Sig_/B73qbFnjTJ9W9VFA3_GxZO/--
