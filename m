From: NeilBrown <neilb@suse.de>
Subject: Re: Recovering an Array with inconsistent Superblocks
Date: Tue, 7 Jan 2014 11:26:27 +1100
Message-ID: <20140107112627.32894e72@notabene.brown>
References: <1388829881.16265.20.camel@vessel>
	<52C835C9.3050707@turmel.org>
	<1388873143.7641.20.camel@vessel>
	<52C8C433.5030403@turmel.org>
	<1388912870.3591.4.camel@vessel>
	<20140105205612.093276ef@notabene.brown>
	<1388918703.3591.20.camel@vessel>
	<52C9A399.5040802@turmel.org>
	<1389016846.25272.5.camel@vessel>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2/kwNwfNh3ptHkFZYspPUvI"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1389016846.25272.5.camel@vessel>
Sender: linux-raid-owner@vger.kernel.org
To: Fabian Knorr <knorrfab@fim.uni-passau.de>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/2/kwNwfNh3ptHkFZYspPUvI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 06 Jan 2014 15:00:46 +0100 Fabian Knorr <knorrfab@fim.uni-passau.de>
wrote:

> Many thanks to both of you, Phil and Neil!
>=20
> Everything works flawlessly now and I had no data loss whatsoever.
>=20
> > Long term, consider creating a new array with metadata type 1.x so you
> > can use a bitmap.  If you ever have an event like this, where one or
> > more devices are disconnected then reconnected, it'll greatly shorten
> > the recovery time.
>=20
> But it's not possible to upgrade the metadata version of an existing
> array, is it?=20

With mdadm-3.3 you can assemble an array with 0.90 metadata using

  mdadm --assemble --update=3Dmetadata /dev/mdWHATEVER /dev/.....

and it will be converted to 1.0 metadata.

NeilBrown

--Sig_/2/kwNwfNh3ptHkFZYspPUvI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUstJsznsnt1WYoG5AQJBqw/+PqWCi+UESMY10sgcLF/Uh8lh0dDirisl
6Zni3/LRM13KUkmttTIWjaggbt+Z9OymTUYbsr6y1wHEYnOzjZelOPdmXPj6Llq5
/u7O0VE0kbVmyZ3UAJVnYULsYfTkervF0mWmD8TN+g+X2KnCj3lzJ9o4q2rsWxnZ
u+kwN/ERiW5cY6dOaimutYo2CrROvgypmZldOmA1UoFh9m5lzHGF59UrxL5ffwF3
IfT7OoL7kcpn3QyAXisYJRyCN2ZdPpPODHRGz5VsjVhEQkb5N6gCPoggazjYT5Sa
tfjra4/PkyScr5LpemkOBOmyzPTerfqfJ9glmO0Qvn27dIHt2/ZfPwTlKzBPaZGL
AcNKtV+Tt5ks5Osa+M/NUXKfVUq8za9UCeJ9z93RfUf0pEDlXZpe/IyltUkhlex2
Aa2bA7jv1X46TadHiZihxgVN1O3Z4jkNiQTLby5mFCNzCmt41cAPonxLtno/tMqs
DrU1b9Vxt/YMiiPvBaSvjanGBV2vFrCBhrKq9NR0Z7W85dWGuKVeGDedTeY5FJub
uHiGLacIHiKamcJ/lGYkoAswWNREy8MkK7b/Rr48lgnxiqAXbHeCBryo2zYOq/Sz
42bXXRyx6UJNZHV13ENvvEtMIXMWQxJrrTJsXW2T4qh6Tjjig8hh0lWhEzsYAIpR
msvl8eXg/JY=
=xiM3
-----END PGP SIGNATURE-----

--Sig_/2/kwNwfNh3ptHkFZYspPUvI--
