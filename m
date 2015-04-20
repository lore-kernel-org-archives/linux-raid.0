From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/6] md-cluster: correct the num for comparison
Date: Mon, 20 Apr 2015 11:48:04 +1000
Message-ID: <20150420114804.6e570389@notabene.brown>
References: <20150414154232.GA4079@shrek.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Jr4w6wF9dDBLoa2P6fzb8yQ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150414154232.GA4079@shrek.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: GQJiang@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Jr4w6wF9dDBLoa2P6fzb8yQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Apr 2015 10:42:32 -0500 Goldwyn Rodrigues <rgoldwyn@suse.de> wro=
te:

> Author: Guoqing Jiang <gqjiang@suse.com>
>=20
> Since the node num of md-cluster is from zero, and
> cinfo->slot_number represents the slot num of dlm,
> no need to check for equality.
>=20
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  drivers/md/md-cluster.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 96679b2..6bdc45e 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -612,7 +612,7 @@ static int join(struct mddev *mddev, int nodes)
>  	if (ret)
>  		goto err;
>  	wait_for_completion(&cinfo->completion);
> -	if (nodes <=3D cinfo->slot_number) {
> +	if (nodes < cinfo->slot_number) {
>  		pr_err("md-cluster: Slot allotted(%d) greater than available slots(%d)=
", cinfo->slot_number - 1,
>  			nodes);
>  		ret =3D -ERANGE;

I'll apply this, but it would be nice to fix the error message too.
If 'nodes' is 3 and 'slot_number' is 4, then the message would be
   md-cluster: Slot allotted(3) greater than available slots(3)
which looks weird.
(it should be "is greater", and there should be a "." at the end of the
sentence).

NeilBrown

--Sig_/Jr4w6wF9dDBLoa2P6fzb8yQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVTRa1Dnsnt1WYoG5AQKD9hAAhqbdhrmwbtsbptXMKYFocPIWjLEbG9AW
8+eC9uaEuEi3LCiVwIWRA7BxaDfD/icYdr+geEdj0RxWR8UF5drW5DXHWQK+B9dh
Y1NG66ldZ0T0cbLJKc2iOJ+qvyb/SLrEd/hVs3tdP7/KqlUJ9RrMBdRW/oZLJRHp
EwrbYd7ucdTcdUagcMTWWLV6t7d/kC2611hLZeglfLF0N9YFoN8ygrs+oV1+dkg3
xis/D9ezFqyoFl3RZ7Bcnk9amea8DgBIuyiqt+plQB3dYixtEhmLM6y/+nyHDUzH
MvmmL8tP7ixC8mVG6BEzPN5zDOdj4fMr+hUxhbvaTpDXQqxFhnWHnlp/fwjuugWR
5qL6hhjb10PzXl8KpxaVZCMRY7O/2O4Ef22RaZCYa09nPOIvWDdEXKBjb3s0iB6c
7VpD6LoFJhLuNWw52v2n3O7rjST06w0dsB7Z9pmiBPc7gFXBhIYyrembmq2dQbQl
4sQqh+cRD0XkEvfAOe7dAI0Ta98Cqlf0rLd9AFbaHdTlzxKVq+kTY1cKLUcmvZzg
kBG77Tx1XfT+NVFQJNaCLGaoCzSgoMnOwruzjQ+CPh45+knGmnOBz9lBaVjbsSdc
ghb8v2Yo3wB9gLWGrSIPYCRmmPhvX58C7biosMAI3v6iIAJ+ClDpC2VsIBjY6Hxe
kOdfn2up0Co=
=4gNg
-----END PGP SIGNATURE-----

--Sig_/Jr4w6wF9dDBLoa2P6fzb8yQ--
