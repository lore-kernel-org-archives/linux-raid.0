From: NeilBrown <neilb@suse.de>
Subject: Re: Reshape/Grow to fewer but bigger devices
Date: Wed, 31 Jul 2013 13:28:58 +1000
Message-ID: <20130731132858.10c67a46@notabene.brown>
References: <CAHhAHviuST+LXb36-XOz+UtZiFv0j8AX+iZ0_gS2MCWZaYhiQg@mail.gmail.com>
	<CAHhAHvhek+ObrM3drgyfs3EH6itoyB2WjxkBK2TcmORw0N_STQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Al4d9iPXe84BKLWy3zGCRuH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHhAHvhek+ObrM3drgyfs3EH6itoyB2WjxkBK2TcmORw0N_STQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Nilsson <nikize@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Al4d9iPXe84BKLWy3zGCRuH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 31 Jul 2013 01:33:46 +0200 Christian Nilsson <nikize@gmail.com> wro=
te:

> Hi,
>=20
> I have tried to find an answer, but my "search fu powers" are now
> coming to a end.
> What i want to do was more or less detailed by Neil in
> http://marc.info/?l=3Dlinux-raid&m=3D129785210102555
> the section titled "When reshaping an array to fewer devices, allow
> 'size' to be increased"
>=20
> but just to explain:
> I have a 9 devices in a RAID5
> 6 of these are now 2TB disks (I really love hot replace!)
> while the other 3 are still 1TB disks
>=20
> I would now like to grow the array to 6x2TB instead of the present 9x1TB.
>=20
> Is this possible and I just can't find how, or have there just been to
> many other great features instead?
> (I have started a ext4 offline shrink.. but it is a real pain.)
>=20

Sorry, but this function hasn't been implemented yet.

NeilBrown

--Sig_/Al4d9iPXe84BKLWy3zGCRuH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUfiEejnsnt1WYoG5AQJ3Fg//eVBi4LJ+36Dg5avcMXt+KMlBNsIk4ZuU
o5trP7PciBaEkhOw2DuwOsiOm2VAjI6BsUSVoL9uniszJYBppm4YFecVwfwkENFA
ppz/q59IVlEuFykBe9p9GNmkcImo/2n39j0feAVKXQ2TOE2C6+48Ji9l7T8/3yK8
bLSNaC5XPRI3QA5CeSe3OO08zPtRUwuzL2o8SRGH9TX+gepW+v66HvvY/SLiFQvv
ZEbj6I775R7W6VB9Whtruc9XNsbvrCyQm53EIzNqkkz6NsYXgsMgKG1lsB85o7BQ
A/zgUMaJOmt3qyRiOr6koLJB6mTbRDqx3Z91ORhJU2r/pzl0aZOf3TMuMynp2qPY
nh37af4B26W6EQYBkYxHGKAmGh3bKMvOAoDcfdW6A429ImCmLwa9nHqDl3HjLZhb
FMr4gF5AQUR93W1zhkh1sQe4nA6kOyhZXuHa2COgpw08rrzfqlT0cj5mqK074AtE
jjNk/kYLXtORz2f939EMqCYx9FD3Eo/af1NtGANp4ScyDihqo8uETZ0fw1lcEpT2
yXMPfhQzfXzhau1EEVWKgeyRZZcr7dajjJMAubVB4matH6oRosPCAp1tF/vJ9toL
nxhof4Xtcc7i54blfIjxFi1aePezDGw3rQIO5PKplLmzViIHBT81EnBtFrRUv7dA
J4xTuguEmdE=
=WNtb
-----END PGP SIGNATURE-----

--Sig_/Al4d9iPXe84BKLWy3zGCRuH--
