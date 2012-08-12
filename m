From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] fix handling of CPPFLAGS
Date: Mon, 13 Aug 2012 08:13:12 +1000
Message-ID: <20120813081312.308af64f@notabene.brown>
References: <1344799457-2478-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zN=gs.=ycK71ZLOr.+q.nfN"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1344799457-2478-1-git-send-email-vapier@gentoo.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/zN=gs.=ycK71ZLOr.+q.nfN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 12 Aug 2012 15:24:15 -0400 Mike Frysinger <vapier@gentoo.org> wrote:

> The current Makefile ends up ignoring the system CPPFLAGS settings,
> so make sure we append the variable.  Also, the old metadata logic
> has a typo with the flag name.
>=20
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  Makefile |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/Makefile b/Makefile
> index 315455b..704b374 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -48,12 +48,10 @@ CWFLAGS +=3D -Wp,-D_FORTIFY_SOURCE=3D2 -O
>  endif
> =20
>  ifdef DEBIAN
> -CPPFLAGS :=3D -DDEBIAN
> -else
> -CPPFLAGS :=3D
> +CPPFLAGS +=3D -DDEBIAN
>  endif
>  ifdef DEFAULT_OLD_METADATA
> - CPPFLAG +=3D -DDEFAULT_OLD_METADATA
> + CPPFLAGS +=3D -DDEFAULT_OLD_METADATA
>   DEFAULT_METADATA=3D0.90
>  else
>   DEFAULT_METADATA=3D1.2


Applied,
thanks,
NeilBrown

--Sig_/zN=gs.=ycK71ZLOr.+q.nfN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCgqeDnsnt1WYoG5AQKGjQ//Z+TXGybVnxRmgy5II6azkSfGoL7RmBZj
3EutmpzPHZU8cUKgvaMGJV1rbLCoWjFUQpj9MAOYzkvtTbKgu4HI+kg8qTuNK5Xo
I6FR5uaqtNmr7Bajv9Z2rARE8Ma3a3vtMFY7qnvjbj9KxWBKsHxbIidQHc5y4v+/
eA6ul+4MHYaLhaBWzHL5rJnQpaS9Rxfno3bOUN/HQ1TKYVRjs7i5Wd0VRKNRJgcV
GtFJ9J+RSX0U5CPJ5/nxOMaWZTytAFL+zu3tCOWNr1WDdSfW9qs9Gb38GsrrZpyq
0HSZHLa7vrOoG/RkcT8I/Jmm2+9S44QjPG+mEkp4NGaU1QTihaqiCLiL85Gub9tF
oBEvXaupOuT3xScJCHJCRTJQM58SKrnRf3NE0vfNSw2d/NCmOe5CnKAPRJj3f6VS
qYkMQiPwcitvxRYhbH1BD3szyVGZQSnmUFbgcgfIGp8X0aEJMYTFrXoFPSuKeHez
RChLGzwPham/0OFpd3CSL1xdesXOftB+zlH1GKAgkWgUdtw6ICa4GSXhRgLzGqo9
j3IEekXZYKNIZAw58Rd7WNCByihjrS1SHCsa3y419AlXAA/JcMHRFYapvR8gkuM7
zrgtzDEXmOa4aETxzp7uLKz1lreonbY6KXy84kMqypqsxmRcBlE3sCxaDiP4fzjJ
djEJg+Ee2Ms=
=Yygn
-----END PGP SIGNATURE-----

--Sig_/zN=gs.=ycK71ZLOr.+q.nfN--
