From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/1] Quiet down automated tool checking noise
Date: Thu, 25 Apr 2013 07:16:10 +1000
Message-ID: <20130425071610.013a58d3@notabene.brown>
References: <1366815616-28045-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/RKtGGU5=dnrEfrp2H1+q/Ov"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1366815616-28045-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/RKtGGU5=dnrEfrp2H1+q/Ov
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 24 Apr 2013 17:00:15 +0200 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> Hi,
>=20
> Had an automated tool checking the help page moan that -a wasn't
> documented in the --help output, so lets just add that and keep the
> noise down :)

Should we add=20
   --foreground -F
too?

NeilBrown

>=20
> Cheers,
> Jes
>=20
>=20
>=20
> Jes Sorensen (1):
>   mdmon: Document that -a is equivalent to --all in --help output
>=20
>  mdmon.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20


--Sig_/RKtGGU5=dnrEfrp2H1+q/Ov
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXhLmjnsnt1WYoG5AQJnBRAAlp41+tIU5N4ag+hApNKg3Hym45cyRnRD
B+fuDCNtpIrq4OgtxEbQ6w/1+4rbMZlL863z0Ap4hIKWpSlDZJPaRsDQAC4Auxbu
KYWts8JNakYDYU6j+ITpKZPH20SKKi/hkxE8KmmSyb535xEMEmtpEZs2CJnYWfF6
ltBccr2ywYmJHMje4zI/N0t+NewBHsOmLTQZW8DSpbShRqtdjYbXiausJ/DbDk1p
V/VWZQ5pSSUlGS9pZYmckqdQfk1stK2fGW7S6v7JkZQPsqvZzYrx2EFwLlp62T0k
ROV1Q7HnBwRw79Fg+ljuTqplYlomLZAIQWdMfr7U0FlH9EgYRdq2P15N70+R4tEg
HLuMHXqiHwQof4Gvj4+/M35w7sh3WIgBP5YsLaqdiaA9id0AJuRJnutM7fpEmJn8
lRrgSwzCRLkpMhGKUMe4fGySizoerZELycmTc+eOHeGeEx8yp5fl30xRX5LanVMr
x1WXH2nLAUn0i8fKGFVt1PER2LDkOL4Rh2G0YE2QjJFCOS9VAEVjJyqzV4xaQgy7
WBOA/SZNE6GYaQsqquqig0K97WSMwLpZsfHYXoj9eAoGuzo79JWtrwnhkZw1menb
ifW3954TvNoQL1L/HLircUgLAIXCKDFRiMe6pKs7QTpWSqN5QmuC0J7PxuqnCMRm
UOiXCPE4Tgs=
=rZLh
-----END PGP SIGNATURE-----

--Sig_/RKtGGU5=dnrEfrp2H1+q/Ov--
