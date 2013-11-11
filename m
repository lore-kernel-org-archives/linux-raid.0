From: NeilBrown <neilb@suse.de>
Subject: Re: 3.12: raid-1 mismatch_cnt question
Date: Tue, 12 Nov 2013 08:55:56 +1100
Message-ID: <20131112085556.766f095b@notabene.brown>
References: <000f01ced948$2fbab140$8f3013c0$@lucidpixels.com>
	<527E8B74.70301@shiftmail.org>
	<008301cedd9d$fc254cf0$f46fe6d0$@lucidpixels.com>
	<527F7FF5.3000002@shiftmail.org>
	<000301cedec0$1fa72d60$5ef58820$@lucidpixels.com>
	<5280BA1E.6060604@shiftmail.org>
	<CAO9zADyyXiw91y=GwArcC9wUrhRPNNxp_XMAgtcPxR=fiZZY1g@mail.gmail.com>
	<21121.19173.938188.985528@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hb1W5z7Yq.s=rz1tQ3iiICr"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21121.19173.938188.985528@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, joystick <joystick@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/hb1W5z7Yq.s=rz1tQ3iiICr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Nov 2013 16:23:49 -0500 "John Stoffel" <john@stoffel.org> wrote:

>=20
> I thought you could also get a mis-match count from open mmap'd files,
> which aren't completely written to one disk or another? =20
>=20

The only cause I can imagine for the mismatch count increasing is for a page
of memory to be change while it is being written out (so each device sees a
different value) and then for the page to be invalidated (so the dirty page
never gets written out again).

The only way to change a page while it is being written out is (I think)
through memory mapping (though this could have change, "write" might achieve
it).

But normally if you change a memory mapped page while it is being written it
will be marked 'dirty' and so will be written out again - the same to both
devices.

You could possibly modify a mem-mapped file, and then delete it before the
latest changes were written, but think that would be unlikely to do on
purpose.

Swap is the most likely cause.  If some pages in a process were written out
and changed during the writeout, and then the process was killed, you could
easily get a mismatch persisting.

But that doesn't seem to be the case here.

So I don't know what would be causing it.

NeilBrown

--Sig_/hb1W5z7Yq.s=rz1tQ3iiICr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUoFSbDnsnt1WYoG5AQL5XBAAnqfD1oo8FwHlLzn4hNzVixHLH7fMzuLx
cKVBUebG66yfGKPyFqZtt8Wmk0SvQfFmDXAM+4/QqS1R1HyGwVvKI2DFZbWCcaj+
JdC4BDGg4PB1v9oTiHrJelGjcus9CQhXGFeyTsDqPfqOoX7YrYOZ0dFJkmQgI5AY
Xo1c9ih0qiz0y7qH0mwet4AegrO68RjibLWk1XcqgKL6T8SzdWt12MfFUJddBYsI
LT6Vz7ExHGfvttvO930WwD+4SCgL2rqL8UxKFdIxOglW1gbZxw6HJdJ2Tp9vTvi0
PxQZ8vQZneKHxT8Wl3bPpCI0ELE5PyLZ/FodkGMAdV3PZhOfk1CaoCssDtmMHeFv
LrKnff/ks4t3M/mCcVyP062RZi9j9TzQ5l5OjTd7wF7A2bvNwGZoDCuUbfM/8LVg
wq0Bnr9HB50BOl7kc4svgf81VD8m7A9lYdOGCLU9B2oA7CpkbgzM49fmUzjWe7B+
UgFOl97288d1RiTkWtw+AtV/8dJraQ/9MRojYqUIvNZoOI9DU3KW/6ejswTdcYtj
42bQc6OpbCLbeQxJ1T7W7I4dJgsgkbcJVbz9utqmuwM46+9c+FXd6+QVqSC3JtO7
iauPKuIqVF2V1iDPH856KjJB1XGGe8mixy6+Gjc6Gl4Gn8r3rArAShLzY437jf5W
VMKuAaeAkeQ=
=uP/C
-----END PGP SIGNATURE-----

--Sig_/hb1W5z7Yq.s=rz1tQ3iiICr--
