From: NeilBrown <neilb@suse.com>
Subject: Re: raid-1 starting with 1 drive after brief hiatus with cruddy controller.
Date: Mon, 19 Jun 2017 07:00:28 +1000
Message-ID: <87y3sp3tar.fsf@notabene.neil.brown.name>
References: <20170618001410.6fa96469@e20> <5946867B.5010200@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5946867B.5010200@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, "r23@anchordrop.net" <r23@anchordrop.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Sun, Jun 18 2017, Wols Lists wrote:

> Hmmm. I don't want to suggest too much, but the array is expecting two
> devices, so saying just "/dev/sdb2" is probably its invalid argument.
> Try changing that to "/dev/sdb2 missing".

"missing" is only relevant for --create

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAllG6e4ACgkQOeye3VZi
gbkxkA//ZfI8K8GbmaA7JRXxwIxmK+gg1qBQIh8OaIt+h2JRvODcBClUaYlf8uFq
jXzqzZhGWj+94rPJK4sujwBYzTS/pn45lgQQBJrSvkIMWn+vm72nCRPbzPN2wFHr
F1LP18tc3bAkMcmO6OyIapaO2XyPD57wCZ8GqJK/BEk6R3ilp68iWbD/FKp6//j8
u/UigW7S/RXEwYOHrY/eh+dKSB67uPKDw5EgY667EtJ9eUe2IAQbQt/AoTZeCTDi
nwHCgQMcnAwXsv1WY845SaJY5IWl207e80mPTHnCwTBimfjiOBA0F2MTLrrUzrOV
YymFpa4OImSX6KikqI4wVl8uDdXZMbstj8CH5y8uX9N7pIKY70hW0zibbaT+tNuZ
CFJiGaQ6qy2q3DEIHtCUBhS/Nt2BN84ujQf28NRUmcq7mcXZzqJwNUzLZILRG+dW
87uIqLqAFFfHcieLy3gZ0EJTold0dhD1aTjms+HHDaTDx+U8hzQeeV5VqP9kJ1ga
u+c9mj63soc1ASygb/CTSgViFPKHRveoI6uvdurwXHzGiVKxUcmNAqGP38nQrAIJ
6yKmGKOxN6ybIltJPiaOhumNtTnVnHhu22BWeVngtWtgDEBC/a+hNCIKXr6x4PoX
b3QlSLl+O5olzDicUcEvFi5XRsY7KuW3PnJMU9cJgsyEVAc08Tc=
=NWXI
-----END PGP SIGNATURE-----
--=-=-=--
