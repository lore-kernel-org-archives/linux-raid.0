From: NeilBrown <neilb@suse.de>
Subject: Re: changing to fewer larger disks
Date: Tue, 29 Jul 2014 12:55:58 +1000
Message-ID: <20140729125558.5d3b40c9@notabene.brown>
References: <alpine.DEB.2.02.1407281545030.7929@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/etL.Y8Lc4H06vzf90BOyc5i"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1407281545030.7929@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/etL.Y8Lc4H06vzf90BOyc5i
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Jul 2014 15:51:57 +0200 (CEST) Mikael Abrahamsson
<swmike@swm.pp.se> wrote:

>=20
> Hi,
>=20
> I just had a thought, now that we're seeing much larger drives becoming=20
> available, like 6TB-drives, it would be nice if it was possible to take a=
n=20
> array consisting of 2TB-drives, replace a few of them with 6TB-drives=20
> (with want-replace) and then tell MD to restripe the entire array onto=20
> these fewer larger drives.
>=20
> Concrete example:
>=20
> 10 bays, currently RAID6 in 9 disks + 1 spare, all disks 2TB ones.
>=20
> If I took out the spare and replaced it with a 6TB drive and one by one,=
=20
> did want-replace so 5 of the drives were 6TB drives, I now potentially=20
> have the space to keep the same contents on 5 6TB drives intead of 9 2TB=
=20
> drives.
>=20
> If I told mdadm to reduce the number of data drives to 5, would it then=20
> intelligently choose the 5 largest ones and keep the data area intact (or=
=20
> even grow it a little), or what would it do? If this is not the case,=20
> could this functionality needed be added to the feature request list,=20
> whereever that list might live?
>=20

This has come up before (once I think, maybe twice - many months ago). I
think I have it on a to-do list somewhere.....

  http://neil.brown.name/blog/20110216044002#8

Yes, it would be nice.  No, it hasn't been implemented.

Now, if only we could find someone keen on turning feature requests into
working code....

NeilBrown

--Sig_/etL.Y8Lc4H06vzf90BOyc5i
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU9cNPjnsnt1WYoG5AQI3NxAAgO8ZQWKE+CbWiCh6mR1YfszkYL99yFGF
qdFUbDnfPmiKEDdxK2qVuFsY8y0Bgj9cbQD7sNAfUX/HbaWTy6bkkOmnRHOycKYR
w/wPgFRai4hR00VUzIGrf3w6iZ1Nwo1CMWZNK751fG7GDeCQG6GGMOvaQL5gO9XJ
NE0gJ3EjA7FQMrzFhBa62hgoDd29/oMEiFQLCE4+vqpLkC6QYRiKsuRAs1fH/XZG
wLv3Baf0wrweEJSrg1qY2BiZbe/goL7Kv2FJYecFGBYmn1jMz7g4UQzl0k2oBKSr
ZSLFjQit3gaZ5SKUeWjUim59QrD3hmbyGcKoEJW1H/jCiRlQnK/EGfiQJTjysBjF
GGthc+cEoFcyGfpb2pobYU0MToDppAGr7WTg+mJknd61ETQH29tpXQiMk7fYFwc8
IEoFlSmLjuhQTio/NGyBmLmWjgHJSMMNsxBCUP6CvcjOA5rtKJ7nRhBVEk3zePVR
WRBcKQUaWQfZNHH2YCX5EHhkDyciUOUncpVx6u36FDnQIFz+ueONRHQzbJV7dSrD
gVgfBwG+GemzK7K+KaDZIH4Edh1j42bTuytY6oAfoFg8fSLMyDGkU11V/cB/Lu6L
msGPTKsi22/C0+JSvhwIu8RGq8N8g25SdDAVTFEoFv7sO0nlGD0gCsvh1MSwc6X+
aFTWpkMkWZE=
=+LDH
-----END PGP SIGNATURE-----

--Sig_/etL.Y8Lc4H06vzf90BOyc5i--
