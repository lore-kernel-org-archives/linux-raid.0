From: NeilBrown <neilb@suse.de>
Subject: Re: Extending an existing RAID (10) array
Date: Mon, 8 Jul 2013 08:31:28 +1000
Message-ID: <20130708083128.41a7d0f6@notabene.brown>
References: <987a86de2c602b7d79c3b926fdfced80@kruemel.org>
	<20130704092402.6f3800ec@notabene.brown>
	<51D90BAF.2060901@kruemel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HGFaGiVRCe3LhG5bQrY22dR"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51D90BAF.2060901@kruemel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christian <CvB@kruemel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/HGFaGiVRCe3LhG5bQrY22dR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 07 Jul 2013 08:33:19 +0200 Christian <CvB@kruemel.org> wrote:

> On 04.07.2013 01:24, NeilBrown wrote:
> > I think you are just talking about making the devices bigger without
> > increasing the number of devices.
> > This possible for RAID10 as long as it uses a 'near' or 'offset' layout=
.  It
> > is not support for 'far' layout RAID10.
>=20
> And as I just found out after some googling, growing RAID10 requires at=20
> least kernel 3.4rc. I have Ubuntu 12.04, which has kernel 3.2
>=20
> I'm now thinking I could use a parted magic live cd to grow the array,=20
> and then continue using it with my current linux distribution. Am I=20
> right in this assumption? Or have I missed something?
>=20
> Thanks, Chris

I don't know anything about parted magic live cds, but if you somehow boot
into a nice new kernel that supports resizing RAID10 arrays, and resize the
array and then go back to your old kernel, that should all work.

NeilBrown

--Sig_/HGFaGiVRCe3LhG5bQrY22dR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUdnsQDnsnt1WYoG5AQIrPA//YZ9Alv5SR6e1v2zafkU90/0xnotnFSnQ
4iOX4HkN/mZ55j9B+gPSNko3qT8RJnHYfAdLl2j3Tq+d5h6oSm2ZjNIRVlW50Rri
T1m/5mzGe43LY8vsh09p/hhuLwKc5CVBI1D3TNFuRTrNJrVenFEAb+oAj4MGJeYf
Nak1tkdmJDP3fXo/5zyPm4mFIoUrTj6B49HWylJ5vhflJVT+19B3sETG9lwVnD9o
dlMX4XT5xepTsfYlB9OEe6ehrmRuC+TAIJ7+41uRlpsIuJrHPzeN9VI7hN3idgPb
t2Ba8f3Ogj+CAvbx+dlfpbEXMAvwqw0RhEARPBbpva/ln3oLwAAiGxXbZPKehnq0
7LKhBaA7Waci6hncWw0BcMU885hm902YwV5acGD9ivzyFi+hFkEWZqhLpdz54yFW
mxEoJ2WHjKa6Wb9s4gmcWZgsFnNyNe6jd83NGlFHbzUWlGuUOUjGEdUcGgf3T7jv
gUy74zeCEZbiCzmehDI9tyfvTl5Qm27wLg1kJKB0dtFDg74N3e6+B0gpL5Xj9Q9u
9U93wlMPfbhgE+zIYTxJRJo0/GJYm/QQtrR5PPvHk6YYkn//zz9oRO6orgtieBXw
CY6wbuwKDscTJsI5yDvBO4TGGPkVB9bfPPo0T/46rKq80omIjQL3Pa0wvs2dhbvA
Pa1fT4qZ06Y=
=0zOy
-----END PGP SIGNATURE-----

--Sig_/HGFaGiVRCe3LhG5bQrY22dR--
