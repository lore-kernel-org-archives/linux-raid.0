From: NeilBrown <neilb@suse.de>
Subject: Re: Question about raid5 disk recovery logic
Date: Mon, 2 Jul 2012 07:44:46 +1000
Message-ID: <20120702074446.3e191fe5@notabene.brown>
References: <CAGRgLy7uJAzTwnuvgXgH=SnKdVBqgPF41eM0N-CYn8bS2BzW9A@mail.gmail.com>
	<20120701180053.504ba439@notabene.brown>
	<CAGRgLy4jdP-ZhiPYMB=-4NYAC7YJsM2nX6SyJcgmMKHpp-FXhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Y5GbSzx9.qXnHbu0GFcGTlA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy4jdP-ZhiPYMB=-4NYAC7YJsM2nX6SyJcgmMKHpp-FXhQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/Y5GbSzx9.qXnHbu0GFcGTlA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 1 Jul 2012 16:36:51 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Thanks, Neil!
> That clarifies.
>=20
> Does this also mean, that when md_do_sync() gets to such
> already-reconstructed stripe, it might reconstruct it once again,
> unless the stripe stays in the stripe cache?

Yes, it will reconstruct it, and that might be "again" if the reconstructed
block has already been written.  If the stripe is still in the cache, I thi=
nk
it will still write that block out again, but won't need to reconstruct it.

NeilBrown


>=20
> Thanks for helping,
> Alex.
>=20
>=20
> On Sun, Jul 1, 2012 at 11:00 AM, NeilBrown <neilb@suse.de> wrote:
> > On Sun, 1 Jul 2012 10:08:40 +0300 Alexander Lyakas <alex.bolshoy@gmail.=
com>
> > wrote:
> >
> >> Hi everybody,
> >> I am trying to understand what happens when raid5 is recovering a
> >> disk, and a write comes to a stripe that has not been recovered yet.
> >> Does md first reconstruct the missing chunk and then applies the
> >> write, or first the write is applied as if the array is still degraded
> >> (and not recovering), and only later the missing chunk is
> >> reconstructed (when the md_do_sync() loop gets to this area)?
> >> I am looking at the stripe handling logic (kernel 2.6.38), can anybody
> >> pls point me at the path that handle_stripe5() takes in that case?
> >>
> >>
> >
> > Hi Alex,
> >
> >  The stripe is still degraded, so md/raid5 treats it like a write to a
> >  degraded array.
> >  Exactly what happens depends one which block is being written.
> >  If the block being written would be stored on the recovering devices, =
then
> >  md will perform a reconstruct-write.  It will read the other data bloc=
ks,
> >  calculate the parity, and write out the parity and the changed data.
> >  Similarly if the parity block is on the recovering device a
> >  reconstruct-write will be needed.
> >  If some other block is being written, md will do a read-modify-write to
> >  calculate the new parity and then write out the parity and data.  In t=
his
> >  case the block on the recovering device will not be written.
> >
> >  I hope that clarifies the situation.
> >
> > NeilBrown


--Sig_/Y5GbSzx9.qXnHbu0GFcGTlA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/DEzjnsnt1WYoG5AQJhmhAAwBNut2aZL9ivep30+3+Yud/OBr5n0TOf
uEiRqnn1HxF1wB2VeaawpArmaoq+nR1HIFKW3TpbuXS11dWPBvqNga0U7zmA2GLC
x3lTrwrpK9VPJSmKYFJA+Le7aZG30rLeM4yGRBaK54DWxqdKi/yU1JeFAmapeXNn
kl1yoDAdADZOYQHCXn6/GigYTuZPIFc+GCTfZh1SJcmbQi1Dw1KUlNrTRSEAdTZJ
oPeDL2592UD/MXNKJoykFM/I98Boq2Qx+XdO05j7kHA0Dtd0H38Pw7atiJ74RnJT
STK2xAnIq35cVpskE2icU7EcNXDSE8QbGdOHZ1C5smAYwaWlkDdQpWl7/CD4qRX0
tUuwqInRG/BHdr4GfyJ9Alx1VxorY+9YZnbV1d3Z7PY4o6ScYklKv4eCkytj8GCO
TQJReNtzId55uFrRGM9VWueoTlzQn2IP0tPs2kcnv/OT1+XCoG/t5R1Q+EqWx2vB
EfJZuiamKQ39GMCB2nea+3HkaS4TLEUbvW6o6TVG/iHQSzas042G3Zs8eLOzC1ub
FoLT6sJszZSpQxNspeLeDSsWI5FiDT5sW+/09WhIWYgEEDhRenZs1KvKZufMgOCm
wB59hSDGsOjOOheuDrDEtY5wDpUCtMLRv5d0W3lNSufXvUrpTJXoLyC4nFrN1926
p+sSqa0PLio=
=PGl8
-----END PGP SIGNATURE-----

--Sig_/Y5GbSzx9.qXnHbu0GFcGTlA--
