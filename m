From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 questions (mdadm 3.2.6/3.3.x)
Date: Sat, 12 Jul 2014 11:20:34 +1000
Message-ID: <20140712112034.6b04d49f@notabene.brown>
References: <53C06815.2020302@dobrotescu.ca>
	<B953BC37-3769-4D9A-97FF-5EFE7C59EEA4@colorremedies.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/gjmpyLj4R6IncGTBq/aQb+3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B953BC37-3769-4D9A-97FF-5EFE7C59EEA4@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Vlad Dobrotescu <vlad@dobrotescu.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/gjmpyLj4R6IncGTBq/aQb+3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 11 Jul 2014 19:09:48 -0600 Chris Murphy <lists@colorremedies.com>
wrote:

> > 7. I am sure I read somewhere (can't find the source anymore) that the =
"new" RAID features of LVM2 are based on a fork from the md code. If this i=
s true, are you guys are contributing to that project as well?
>=20
> It's a good question, I'm not certain but my understanding is device mapp=
er is leveraging existing md code in the kernel, rather than having forked =
and duplicated that code. They have their own user space tools and on-disk =
metadata so you can't use mdadm to manage it.

Your understanding is correct.  It is the same code for managing RAID
functionality, but different code for managing metadata and different
user-space tools.
I'm hoping that one day the RAID support in LVM2 will be better than mdadm,
and then I can just fade away and no-one will notice that I am gone.

http://downatthirdman.files.wordpress.com/2010/06/grinning-chesire-cat.jpg

NeilBrown

--Sig_/gjmpyLj4R6IncGTBq/aQb+3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU8CNYjnsnt1WYoG5AQJ7wA/+PR20pBFJOWmNYcBjnVuwdM06iPLJQBdW
VB5CzXG+qDmKnJRwUlyHhclTKuPgtgsTzbnGKdOJLFVKLels0Wpyz1nKxMzg7Vgv
zCisvP0vPtYM1I7guddEYtoohlFwcXmMYAqvBsOr/JKoczKRatvMrwpdys8RefEX
8/UYqAU0ullrqUywj/OOoun7rvbUcx0rNM5/6JXn5hk/0uMXRwQipLjjtUSr0QKW
fiuoFN3NRlDpM2+rXrMO9RUuiLlIVQRh5z7llESpAh2+MWb//vWzpyRSB6+SiGq6
4dN+SauxbUCkFUjYsi5EqbgZOEFUmKE3KJ1ZOWWnfljlgtlhfoEjwd2E0oNHS6EU
T9L7nDns9n1mjkAoj3yU4R+wxwjDINeL93uGrhQ3ayYsI4EjQm+nvfz0DvPblybN
jzZEGogrN0OO0XOc5QuR2ufAyC6x1htRJqdbGsRSAlIf/3vEMfwXy7mL4jxOOUcp
BzNcRRO7+wtYSETixqJErB9vgKQqmSKxSCHEN73CpKtdbUmTSzl+M0UQG910i1WH
axNgvTnlA49b9Ytm2cQx0AoHLLoGCPGjOl9JtZhXcqgJ1wuq4gDxc7Q3i3tKurtc
SfmbhUp9rSHt37uP7DYKbm9q33Cjut2pcjmloQAtb+l8XU7HblUtnvie+kBX31Mh
O4mPEP3xYN8=
=UNch
-----END PGP SIGNATURE-----

--Sig_/gjmpyLj4R6IncGTBq/aQb+3--
