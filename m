From: NeilBrown <neilb@suse.de>
Subject: Re: Intent Bitmap size and performance
Date: Sun, 2 Feb 2014 17:28:32 +1100
Message-ID: <20140202172832.30e33c05@notabene.brown>
References: <20140202003915.GB25441@merlins.org>
	<20140202005646.GC25441@merlins.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZEFHpKZs6.ksMbPKdIKhs/e"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140202005646.GC25441@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ZEFHpKZs6.ksMbPKdIKhs/e
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 1 Feb 2014 16:56:46 -0800 Marc MERLIN <marc@merlins.org> wrote:

> On Sat, Feb 01, 2014 at 04:39:15PM -0800, Marc MERLIN wrote:
> > How can I tell I got the size for my array size?
>=20
> Aah, the clue seems to be in the kernel logs:
> [669348.274368] md7: bitmap file is out of date (0 < 38029) -- forcing fu=
ll recovery
> [669348.299174] created bitmap (15 pages) for device md7
> [669348.316720] md7: bitmap file is out of date, doing full recovery
> [669348.380555] md7: bitmap initialized from disk: read 1 pages, set 2980=
9 of 29809 bits
>=20
> If I got the math right, 30K bits for 8TB is one bit per 266MB.
>=20
> Given that, I'm going to assume that this is not going to impact system
> performance much for most operations.
>=20
> Is my assumption and conclusion correct?
>=20
> Thanks,
> Marc

You can also use "mdadm --examine-bitmap" on one of the component devices to
get more details about the bitmap.

My rule-of-thumb (base on zero hard evidence) is that one bit should
correspond to approximately 1 second of IO.  Your bits correspond to 2 or 3
seconds so that is certainly the right ball park.

As always with RAID, performance is highly dependent on load.
It is quite easy to add and remove bitmaps to/from a live md array so
testing the effect on a particular workload is not that hard.

The default mdadm chooses is a bit complex.  It first chooses an amount of
space to reserve for the bitmap, the it figures what chunk size will allow
the bits to fit in the available space.  Then makes sure that it as least
64Meg.

NeilBrown

--Sig_/ZEFHpKZs6.ksMbPKdIKhs/e
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUu3lkTnsnt1WYoG5AQIU6g/+KYFbg6J1Ix5DJKR7xvlFGxbFeqIa5DoE
Iomhsg8ZETP+dYHgqo26qrIvJeyLTf7EfcrqlYsfDlaGz7zEaS/PVXSl/xCSsrc6
q0V6dVEgbl3yXIxOJKu+6qhJWjPi9d1gbHpcuNU2+vLO0+oiUmKgiwwIgaC0tot7
BXymJPnYajRlD4uEGcFOZqtCVMledg0iZyDSFzOhWpukzBFjI10w3q7xvGVrboaE
Vfu9GJ8/iOJSzNBCuoY8n1JXHd7V8en5t5q8iVoPvq8vpkOaCF7WsKGr89E2NUu1
9iD3WOALgSkXce/mmFOV6QaXy9VnK0xZL7DDM+G35JnksqkrnzYp0EGGCr5nAJxF
Skpmv8X56cIcsYNolm/qiC78xpIVHszC0UHnDJSpuTWB8j5rpnRQSGRjmSsx4WZ6
jF/XrSk268ZbXWcBqvWxr6j32Drclw6hwSBeyMWcOlFxvixrSbo+l+Ao0vPt5DWP
caXiQ5jgcxWj6DpDwiM9z88eAX3NwxP6mwOhVJMWR8z8TIVZfGZxYymeTdjaE/cf
bCeShOIa/m5N0B6Hl+1PCHDd7wUHhi0VjeBtpWUcElbOuSnl1huUcQn6Cp7UnSy+
hRnQDswAoI7H5NEBpo5SYZxsc/xgYsNkH4EO+Y4yNbZr3H74os7nSq64GmIPbDTs
guxrFsp0C4I=
=6BD8
-----END PGP SIGNATURE-----

--Sig_/ZEFHpKZs6.ksMbPKdIKhs/e--
