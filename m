From: NeilBrown <neilb@suse.de>
Subject: Re: linear raid, is partial recovery possible?
Date: Tue, 29 Nov 2011 07:46:37 +1100
Message-ID: <20111129074637.5a7d3371@notabene.brown>
References: <BLU0-SMTP248DE7134BCABFEB83181BD98B20@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3zknu6AUath818z=lxFzcMI"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP248DE7134BCABFEB83181BD98B20@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: wilsonjonathan <piercing_male@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/3zknu6AUath818z=lxFzcMI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Nov 2011 20:06:35 +0000 wilsonjonathan <piercing_male@hotmail.co=
m>
wrote:

> Quick question regarding linear raid.
>=20
> If a disk fails on a linear raid I understand how the raid is
> non-recoverable, as a whole, as it has lost a chunk of data.
>=20
> However is it possible to recover the data from the non-failed portion
> of the raid as I assume linear works by starting at one end of the array
> and slowly progresses to the other?
>=20
> Or perhaps it is dependent on the file system on the array, eg. ext
> works by trying to place files distant to each other to help reduce the
> possibility of fragmentation?
>=20
> Perhaps the filesystem meta data, or some portion, may span between two
> physical drives which would corrupt its table?
>=20
> And obviously if a file spans two disks it would be missing part of its
> data?

Yes.

>=20
> Does the raid underlying a file system do its own things, re-space,
> physical data layout, etc; or does/can a file system impact on the
> workings of an array?

It is entirely up to the filesystem.  The RAID just catenates the spaces
together into one big space.  The filesystem decides where in that space to
put all the different things it wants to write.


If you loose one drive from a linear array then recovery would be very
difficult and have no guarantees.

>=20
> The more I look into software raid the more fasinated I become with it
> and its inner workings. While its way beyond me in some of the maths and
> the fact I am un-proficient in C it has really caught my intrigue, and
> all because I wanted to set up a small home server ;-)
>=20

That's just the beginning -- before you know it you will be studying the
maths and learning more C - you won't be able to help yourself!

NeilBrown

--Sig_/3zknu6AUath818z=lxFzcMI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTtPzLTnsnt1WYoG5AQKRlhAAm8ttdjtZaehgkp3Z9GbZyaLCc6Pr/epH
gVRPH7d+vIUV/6ftF4pjjxYUsT9M2e1Uf1MAe578gFWAH6auGzek9HlGv96Dowky
jwahFuPUwMmGngJks5vg3m4X0VBpYG0zUtteITOse1FHDpxX+f/7x1CWtDyM7DSi
xXxbz+jAsembBajw9rvy2a5tq+B+Sst52Qk7nZKp03LrAVKz9JExs17ZAF33Pojc
4U+aCBxL93TNOhrfmFurtfkRE1T1sTrIHyzqsGTYS6JVBkGR1VDop+p2HLD8Zmj/
y3tNh4hfeeR6UbvaEUjaduRSwPbHX0Hc25wrY72ThAHll2VQFJ0OBKz1OlABxN6P
GKiNLuN1wmV/3TDX0YH4F78EgIQW9M4+KhPJ9TvWRq7Wl0qyd0OsgmzOM0yn6MiW
Lwwr1ZsjEfucuXWO0RVy5b9GIaEUrc990NqX7xBE6bOGKF8LmYAenyjfgzl3RWMk
k795NzxAAnYqvdmxrajn59Yo+/itYmR388jPiAwpdOBw96t4STFU3pX3Wm7/8jvL
IsHKtxl2PpHSoNq3LPc+fMjgeqTnPPNo4E9+wW2JsX29NzlQk6lkJItRc+JLNChC
nhzLsiwAkg20Of4Bs3RwdzQtiCualKTsF35AcPSp4TmstyebF/G6xVR4e6NQNXnh
KrWtPKW3qjQ=
=Qrjo
-----END PGP SIGNATURE-----

--Sig_/3zknu6AUath818z=lxFzcMI--
