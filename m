From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] udev-rules: prevent systemd from mount devices before
 they are ready.
Date: Thu, 2 Aug 2012 10:09:30 +1000
Message-ID: <20120802100930.20c5cb9b@notabene.brown>
References: <1343724827-2179-1-git-send-email-harald@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/D0RtzqS2dEv40PEaM3sMIwT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1343724827-2179-1-git-send-email-harald@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: harald@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/D0RtzqS2dEv40PEaM3sMIwT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 31 Jul 2012 10:53:47 +0200 harald@redhat.com wrote:

> From: Harald Hoyer <harald@redhat.com>
>=20
> In the "add" uevent, ATTR{md/array_state} does not exist, so the next
> rule does not kick in.
>=20
> When an array is assembled incrementally, systemd might see it
> before it is ready, try to mount it, fail, and give up.
> Result is that array doesn't get mounted.
>=20
> If we ask udev to tell systemd that it isn't ready yet in this
> case, systemd waits until it is ready, and all are happy.
> ---
>  udev-md-raid.rules | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/udev-md-raid.rules b/udev-md-raid.rules
> index 814c897..da9d3c5 100644
> --- a/udev-md-raid.rules
> +++ b/udev-md-raid.rules
> @@ -27,7 +27,7 @@ ENV{DEVTYPE}=3D=3D"partition", GOTO=3D"md_ignore_state"
>  # container devices have a metadata version of e.g. 'external:ddf' and
>  # never leave state 'inactive'
>  ATTR{md/metadata_version}=3D=3D"external:[A-Za-z]*", ATTR{md/array_state=
}=3D=3D"inactive", GOTO=3D"md_ignore_state"
> -TEST!=3D"md/array_state", GOTO=3D"md_end"
> +TEST!=3D"md/array_state", ENV{SYSTEMD_READY}=3D"0", GOTO=3D"md_end"
>  ATTR{md/array_state}=3D=3D"|clear|inactive", ENV{SYSTEMD_READY}=3D"0", G=
OTO=3D"md_end"
>  LABEL=3D"md_ignore_state"
> =20

Thanks!

applied.

NeilBrown

--Sig_/D0RtzqS2dEv40PEaM3sMIwT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUBnFOjnsnt1WYoG5AQL8VQ//UTzfO/0wpwPwAQsSy7GK6DcRyD1tqmDC
Q41LSjDGRfVj386zUsvCSzLCSVJtenJcEYc/WJBrVrhj/ySraFH2IipXPxm/kkAg
DtlENnoy00TNDqK4vqtLl1bW9tsiJpL9iQ5qx8RbZSZxsJqhutoriLh4OQNjTiOX
lPHQbRSBQSxOymlYrJez1bNGTCyL80vJiiyqJPNGiIGn+RA4usxDR2HKasHq2/GA
NXOCAPHijozSvmRuc6kcBU3A7MWJLjCq+QAkrkGJQ/hukPFUwRlIZPfN8OffLGjk
xt25GxELGYfbyhQXGupwt4Gh9ZRHw590m3By/PRBxEcbDHlZK397GazyYLouutS7
SpfmKaZxzdSAArjij0aBLp47QcgDsIaKp/N6yIlusXUH3ufL0KujFpjKU30KbJ3C
p0dPpAU07Tmpnbp4lFQXE/uJzZr/ncO5widTepFoSjgLhnE+Cvx7Nfg4La/Lo5zq
83XR19ZcSYrpUu419EMccYdNVRa4KtHvnVx1mY3m6ZHkYbpyf9Vu1WlzS4mxB6uO
AM6q6JexIZp/XKuCWuFpA+WRbDEc7lm6rrvqje8oN4M5kK+9qwH8QYVldNShS2QI
UNZp2hgf+c/+BFICy1q+lfMOVo75wbVUjOWoueH8ePyoVe8+FumAbmZ3nmv0sTg6
wdHliguLqVU=
=3JXf
-----END PGP SIGNATURE-----

--Sig_/D0RtzqS2dEv40PEaM3sMIwT--
