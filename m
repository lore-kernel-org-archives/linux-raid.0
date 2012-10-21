From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 reshape, 2 disk failures
Date: Mon, 22 Oct 2012 09:31:36 +1100
Message-ID: <20121022093136.6a959859@notabene.brown>
References: <CADNH=7FunKmUSREJJz2Lonqjb42gB_WHMQJ7-jmip-X8-1yZnw@mail.gmail.com>
	<C0A56E30-4D1A-44D3-8480-AC70706897B3@colorremedies.com>
	<CADNH=7GRyxe7c1NE-5WQUnkpmorchoYCWYtWgeabHkk4pzVMvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/a7wB5AGMy41HX4./dwugOn="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7GRyxe7c1NE-5WQUnkpmorchoYCWYtWgeabHkk4pzVMvg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?ISO-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, linux-raid RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/a7wB5AGMy41HX4./dwugOn=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Oct 2012 09:03:11 +0100 Mathias Bur=C3=A9n <mathias.buren@gmail.=
com>
wrote:


> Any idea why it says rebuilding, when it's not? Is it going to attempt
> a rebuild after the reshape?

Minor bug in mdadm.
The device is clearly faulty:

    Number   Major   Minor   RaidDevice State
       0       8       65        0      faulty spare rebuilding   /dev/sde1

so mdadm should never suggest that it is also spare and rebuilding.=20
I'll fix that.

What is a little odd is that 'RaidDevice' is still '0'.  Normally when a
device fails the RaidDevice gets set to '-1'.
This doesn't happen immediately though - md waits until all pending requests
have completed and then disassociated with the device and sets raid_disk to
-1.
So you seem to have caught it before the device was fully quiesced .... or
some bug has slipped in and devices that get errors don't fully quiesce any
more....

NeilBrown

--Sig_/a7wB5AGMy41HX4./dwugOn=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUIR3yDnsnt1WYoG5AQLmPg//fC1aknxxDI4l4G/GhpgOaCzSAKErck8k
dbTKN/PS891kit2LC7sF/hIVM8lmP6OWrt0pGFvMRkva0Cr0dEmr5jMibb46yJBj
7q9PnoLNL+Tioz/csveGrQl79CLhPpjsf/H4Pa6kRQSldX9Nf6WqfUiv3wiLeNgT
WZFx00jGBWgyWE4ZKyBy5bhHnDyOFkIK3uYKy7yIYv1/WF5IznnIChunrR/3upU3
mrZ9BhGMKv863Web7irikLcR4tkwyaj1rWOEHubbtmyznc2x6iWZQKcBfrL5G4Xq
LYoO7+GmnCI1Eb/iCX5g1XyTg0yI40E0GGkay43jS4Hds7MXqY8eYtjBratG/Omh
Hx5FJ3ZHsqm2FuKQuLEyuJNf67Glam58wq29LH2a5tUzSt7AJhy3BODkMHX1pEcF
2r9spoFrHojD3Ptwgi/J9pYWTWsmEAvwLBv+X0ve4cHXLzlkgxaGi4LkdxkO/A3E
6G2f6O/hAryedPJbU0psGk7I2RI76265mV3XwXQynYKfbSH1l2WvxDw8CBRT9HPm
za4oekMHmjHa7EkdZmk1N9OkglbuGl7mhOHbQy/yOZOAHqQtxDYgPzFR6My6/egn
OdpkhM2QocQzdE6mnyAKlxAbh4ljTNgoT7FSKF6MbZJHORoMADCKEKLPycDD//MU
hZg5z9emCBc=
=0yHG
-----END PGP SIGNATURE-----

--Sig_/a7wB5AGMy41HX4./dwugOn=--
