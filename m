From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/3] execl() only returns in case of error
Date: Tue, 22 Jan 2013 16:48:09 +1100
Message-ID: <20130122164809.641d05bd@notabene.brown>
References: <1358774578-2183-1-git-send-email-Jes.Sorensen@redhat.com>
	<1358774578-2183-4-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ux/X3DvYSg0BryzZb.yuitz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1358774578-2183-4-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, dledford@redhat.com, harald@redhat.com
List-Id: linux-raid.ids

--Sig_/ux/X3DvYSg0BryzZb.yuitz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Jan 2013 14:22:58 +0100 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> In case exec fails, fall through and print warning rather than just
> calling exit(1) silently.
>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  util.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/util.c b/util.c
> index 500b2bd..68fd27e 100644
> --- a/util.c
> +++ b/util.c
> @@ -1705,7 +1705,6 @@ int start_mdmon(int devnum)
>  					}
>  				}
>  		}
> -		exit(1);
>  	case -1: pr_err("cannot run mdmon. "
>  			 "Array remains readonly\n");
>  		return -1;

???
Print the warning, and (still in the child) return to whoever called
start_mdmon()?  Not a good idea.

If we want an error when mdmon fails (might be a good idea) we should print
it after the 'wait' returns an error, not in the child.

Thanks,
NeilBrown

--Sig_/ux/X3DvYSg0BryzZb.yuitz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIUAwUBUP4oGjnsnt1WYoG5AQJsEQ/1HyAM+dL4/cMoReAsbENGdPNNVhQaWOqO
ITLNdq8+mdggg4CaTv7vkbsf42SGrQWE3ARpxBOi9gp1byVvSCA7sGrIrAVQUwDy
KBJv9NnGVswVB/wBSFgIXjo04As5618qKapZ4CttZD77P76PUpwyDEzgRE7hOHcd
WKRBf/8M3Mfu6F1+5cckn1usKtRdisXqyC1W2KDqNVYmLuQd5qeOrJgQoBvTs49J
3/bP9hG21dWAmJyKyqAGep7pYl0Fy9njyMPbVyiWpJcdfSu5ALTKPYsbj5/RVctG
1PJbKU7w3Teo7fsNNhmOHicQ+abY4OA7KMtaIqwSa3qmdXwNWUwwiqBUa12DQfOU
yz7aZvgW8zrvgT+YcZJMoww6x91cT0LkJddfzVGJE7VG4wHhriesHpdJ5WC2NHF/
sUjQaF4CT0aBVPi6afl4EoqX99t1H+mddBm2lr8UoCB+BPyaQYnQPgt3+mAcx5ds
90K+73KR8SKNOEndejfVnyPtns6+1pCaOS4pmoUJaSjTqAtG6FZ0snWBZu35bqeR
Un72sOCgoAfi4cTwU9Vjr/p/r2DWLh/3nAg3j8A5SJLi+jPk1cmG2fz8L+xPVOk6
X4hNIaPZji1B5xbIs1B5qi/raGiHjvTUA0Xwm4KDDX7QIULH8usGiUB1j5noZc9o
FaYXI2O60A==
=V54K
-----END PGP SIGNATURE-----

--Sig_/ux/X3DvYSg0BryzZb.yuitz--
