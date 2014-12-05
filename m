From: NeilBrown <neilb@suse.de>
Subject: Re: Multiple arrays out of devices belonging to single array
Date: Fri, 5 Dec 2014 22:17:38 +1100
Message-ID: <20141205221738.79d2f8d6@notabene.brown>
References: <54817A83.6020000@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/eJGJKn4.orq4KwZW57cJo4e"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54817A83.6020000@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/eJGJKn4.orq4KwZW57cJo4e
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 05 Dec 2014 12:27:31 +0300 Michael Tokarev <mjt@tls.msk.ru> wrote:

> Hello.
>=20
> We in Debian have 2 rather similar bugreports which are somewhat old:
>  http://bugs.debian.org/599352
>  http://bugs.debian.org/694513
> Last bugreport is against mdadm-3.2.5, so not THAT old.
>=20
> Basically, it smells like there's a possibility for mdadm to assemble
> more than one (degraded) array out of components of the same array.
>=20
> So I wonder if mdadm or kernel have some protection of this situation
> from happening.  Something like looking at already active/assembled
> devices to see if the same UUID is already used before trying to
> assemble another array.
>=20
> It might be better done in kernel because this way the process might
> be freee from races when two mdadm instances tries to do the work in
> parallel.
>=20
> Are these bugs for real?

Certainly are.
Fix in 3.3 I think.

commit 0431869cec4c673309d9aa30a2df4b778bc0bd24
Author: NeilBrown <neilb@suse.de>
Date:   Wed Oct 10 18:27:32 2012 +1100

    Fix up interactions between --assemble and --incremental

is one part of the fix.  I cannot quickly find another patch which obviously
relates to the symptoms described, but my vague memories suggest there was
more than one patch.

NeilBrown

--Sig_/eJGJKn4.orq4KwZW57cJo4e
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVIGUUjnsnt1WYoG5AQK+cg//ej3R0ZsxNIURzIyX5tfB98SEXELBXcht
l3HI4oGYxiDa9ZfaGXkmAQKSaCjvaOCPfB+1YJR9c4n9u1YUmodSu4eIyotIKD2R
wk/dfuTKUuD7ibwUrEn+UnLMyzR6MJiSOwje9e7Apq+sCUbU2guNbo4OK8xrKr64
ierKRHstqD8oKEk2ZYaVhnQ3z4+WUPy8LKlXi7b6Mxs+wpgfN/7DAZ310qC3ZXjN
xqMKf++BZK9aJT5CXhgH2k5HKCojkYmkjbAw5hUINLD/hU5Iy0cdFrW6b6wiIu0X
6AZw7BVA+vQcGGqn6RL2CMIvyeXaf+qVQszTh8ePEOn2JG59CzFyvkyFS9kzyQbr
W4qPI8+UILMjK1S9Rsg4u28N7xalUaaeHBLlNwT/rFF4UA8qfgPrhNMmItKqMvIq
zo4BB54GKvT7a/7AgDiG8Sz4Ee7xKiG1B+2Wh2OmxyrsHj6mr+0TTX4tLSgNDxnH
bOTEkxrNj4lnOJG0dBNq3j4rmgjZWv1J4rMhkixdg6D86r0liWTD4ofoorob2U/k
Xs7es4dN8jAsJQq1HSlGhvx+gXhBuWklkkz17+BdWbEeo6PpAI1JsgbAX8cUmcQ7
WPI/WNIRtXbe6FFTV09xBjhAuZvmMaXnXe56sZuwVZEftH1SYU+Inm5QLdWTBotk
OYXuVUsH5Cc=
=IUnd
-----END PGP SIGNATURE-----

--Sig_/eJGJKn4.orq4KwZW57cJo4e--
