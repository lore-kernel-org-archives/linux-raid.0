From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Fix minor typo in mdadm manpage.
Date: Sat, 23 May 2015 09:30:05 +1000
Message-ID: <20150523093005.25666d64@notabene.brown>
References: <1427303869-17319-1-git-send-email-andrew.burgess@embecosm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/kHNvzQ3.LWYAsm2NQ.6Fnco"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1427303869-17319-1-git-send-email-andrew.burgess@embecosm.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Burgess <andrew.burgess@embecosm.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/kHNvzQ3.LWYAsm2NQ.6Fnco
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Mar 2015 17:17:49 +0000 Andrew Burgess
<andrew.burgess@embecosm.com> wrote:

> Appologies if this is the wrong mailing list for this patch.
>=20
> This is a very small patch for the manual page for the mdadm utility.
>=20
> Thanks,
> Andrew
>=20
> ---
> Change 'is and of' to 'is one of' in mdadm manual page.
>=20
> Signed-off-by: Andrew Burgess <andrew.burgess@embecosm.com>
> ---
>  mdadm.8.in | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/mdadm.8.in b/mdadm.8.in
> index a630310..b4a21d9 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -214,7 +214,7 @@ to detect and assemble arrays \(em possibly in an
> =20
>  .P
>  If a device is given before any options, or if the first option is
> -and of
> +one of
>  .BR \-\-add ,
>  .BR \-\-re\-add ,
>  .BR \-\-add\-spare ,

Applied, thanks. (And thanks for the reminder).

NeilBrown

--Sig_/kHNvzQ3.LWYAsm2NQ.6Fnco
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVV+7/Tnsnt1WYoG5AQIw1A//e6ms/5cy1UIVP1Gtpw58bY+BzxJQL7Js
RHRzYIQY+08U4ecmrXOElXJZ/Uk6jgQvDCGYLZhGf7Z3ubJjqia8i/vFZKP3Sn6k
WPxGHEdzJ0o7PStIX1QrhojfB4ZVVFoVq6d3zeU0aZ+k+ov0ffMJysOCMIYMkjzh
JeG4Abyz24EABiDmMDTyBTP7UlfHHRvGKY+C5UsuXUcBUdf+x3b4SeybQOk9sO8R
Oav5j/3T/MfY2H2cbBHsvr20cqLzL1ZAYpq0hZc0BmK5u0XrAKUucyAf8eR+ede3
EEAQS6aWtKINQe5hRms177CNkjOPXPfn+1p3jDevThgp8+DxSG2Oy0kyKKgooZhr
59ofeAcHJkxLYx3mulZN+D60cIgFtHY8XmJjuA44MOXyPPpanEmXXxVS7PNc9akA
2cFXD+8hmIpAJlq1NxprZk3sAg+Y520J8f4J8FQ8dfvl5PJiR8BiUDWRF/DwBXu3
/9Y/FjTDvCvNz5y8XyG3ipwBsrZPUkHDoJ82zvCYrHa1AFhVDYo6uRq84oadUZom
G1OTSVRkTbJ+9+okJ9nasPqK44mDNiSdiDRvU9qFNWT1HpLoiPN+y9S5trFRZxAA
H0LFgyDHmExF32t7ssBA88pHhMd2K7AQ9KeBR9oN0DZbwXw73OpCwhafXj17+VVX
XOojo5dw838=
=RYUb
-----END PGP SIGNATURE-----

--Sig_/kHNvzQ3.LWYAsm2NQ.6Fnco--
