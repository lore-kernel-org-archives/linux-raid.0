From: NeilBrown <neilb@suse.de>
Subject: Re: looking for advice on raid0+raid5 array recovery with mdadm and
 sector offset
Date: Tue, 21 Jan 2014 09:11:44 +1100
Message-ID: <20140121091144.4873d3ec@notabene.brown>
References: <CANgodhBjRyNDwJwOxepqxX0zMaLtnniYpwWe_k7hjgfRP0UpvA@mail.gmail.com>
	<20140106124143.287894da@notabene.brown>
	<CANgodhCyo7fgEzkg-=jtYkVkNVda50yiaYCCpzPcxAeFxwNUjw@mail.gmail.com>
	<CANgodhC6wKST5B3zKHD-04xHV8DCUm1Rv71c44RWDMuJp6+WGg@mail.gmail.com>
	<CANgodhDZnogCmXDLz75Hidv=HcYoaoj=1thKTqt8htP8gx3CSw@mail.gmail.com>
	<20140120171645.591b17fc@notabene.brown>
	<CANgodhBzYbr6+V6POFy5e9cYPtGFYNcfmR2Z8hE5Vj0jA8YveA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/a=we9MfkUoctbv90FmBJeHM"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANgodhBzYbr6+V6POFy5e9cYPtGFYNcfmR2Z8hE5Vj0jA8YveA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: den Hoog <speedyden@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/a=we9MfkUoctbv90FmBJeHM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Jan 2014 16:43:38 -0500 den Hoog <speedyden@gmail.com> wrote:

> Hello Neil,
>=20
> thanks again for spending time on this when you're already swamped, I
> appreciate it much
>=20
> the commands look logical for my setup (just a type on the chunk size,
> needs tobe capital K)
> I did not dare to fire off the last command last time, but as missing
> seems to be available for imsm, I re-processed all of the commands
> again
>=20
> the Raid0 is created without any trouble (only stating it is already
> part of an array, confirmed with Y), but the raid5 array won't.
> After it also stated sdc sdd sde are part of an array, and confirming
> with Y for the create, it gives the following:
>=20
> "mdadm: unable to add 'missing' disk to container"
> I'm using mdadm - v3.2.6 - 25th October 2012.
> Could it be the 3.2.6 does not support missing for imsm?

That's weird.  I'm sure I tested it yesterday and it worked.
Today it doesn't in exactly the way you describe.
I'll have a poke and see what is happening.

Support for 'missing' with mdadm was supposedly added in 3.2.3...

NeilBrown


--Sig_/a=we9MfkUoctbv90FmBJeHM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUt2fIDnsnt1WYoG5AQLAgw/7ByNlOy7Gn38asVeg0eY0yAN2QiWJYqqH
c2ycA0oCj8K6axg1mMOmETwhwNTy0aRRqT1S2aBlvw4vHKIpJp07zqEOvutnlO/d
rxAbu7khJyzfUfPpgIBJ+lSwn458XmAUvBITTslMenrkwOgpbRDHxER1D+kVWiC1
atnUujE5ChVMT9lWBRLF0XzwSGihwo6Bqcwp/CmSNOkBY/231w7sraPtyGdAQ6jB
d2eYl/oUfAPkQysASonvXukJhyVda9f+ud0McINqShOxM1zv9TFTu0PhLZgH3c4x
/Y/mFUDRmzJ/Lip7dbNqEFvbc+MeRy4fYGpxqoAze+E9kZ/XjHm+EzxYzZeogeey
5NHUpmoIseQdmCVCJSwzCJCU8jSqGOQ1+CjxSJqLm4RMA5btcEzEGoQabcwtky8Q
A5z7cYhLA2ShfI52qsVIFN6auIpJW1BFfY5BGgXIa4/4IhNtyDyPBglJ3j6EcIY1
ef4edSv7Gf39MTwyJUg8FQXfveHHzZOerl1Ij5flBfmNP4Gq/VLaV99kDhBhVLCJ
3CMmQeKSIRklURXwcnV1rNfK934uGowhKAaGeclnbTocqWvrPGiCfs6Y5s8+pfqO
3J84tAcv5n5iY5M0JIaVvPnkjxFSaTr0FJ3KA0PSLCHvOFw22UDt3GzJFLAjL/gK
Xzi1oDnOCvw=
=TYJz
-----END PGP SIGNATURE-----

--Sig_/a=we9MfkUoctbv90FmBJeHM--
