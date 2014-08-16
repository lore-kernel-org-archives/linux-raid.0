From: NeilBrown <neilb@suse.de>
Subject: Re: memory leak with linux-3.14.16
Date: Sun, 17 Aug 2014 06:36:58 +1000
Message-ID: <20140817063658.79406706@notabene.brown>
References: <201408161345.s7GDj5gR027016@portal.naev.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/M7UbLii=DszG2+QE6T49MdT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201408161345.s7GDj5gR027016@portal.naev.de>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Koch <mdraid.pkoch@dfgh.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/M7UbLii=DszG2+QE6T49MdT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 16 Aug 2014 15:45:05 +0200 mdraid.pkoch@dfgh.net (Peter Koch) wrote:

> Dear Neil,
>=20
> > The only bug I know of was fixed in 3.14.6.
> > I said 3.14.16 before - sorry about typo.
>=20
> No wonder 3.14.16 behaves exactly as 3.14.12 did
>=20
> My server now has reshaped 2.28TB and lost 9.14GB of RAM
> so memory is still leaking at 4GB per TB
>=20
> > Hmm... don't know about that bug.
> > Does /proc/slabinfo show some slab much bigger than the rest?
>=20
> I'm not a memory expert, so I made a copy of /proc/slabinfo and
> compared this copy with /proc/slabinfo in an endless loop.
>=20
> There are two values which are unusually high and
> are going up constantly:
>=20
> radix_tree_node   403942
> kmalloc-256       38283576
>=20
> 38283576 chunks of 256 bytes are exactly those 9.14GB of
> RAM that have leaked so far.
>=20
> > If you gracefully shutdown and reboot it should keep pick up where it l=
eft
> > off but with more memory free.
>=20
> Last time my machine crashed when about 10TB of data was reshaped.
> And my machine has 32GB of RAM plus 8GB of swap. According to my
> calculations I need 13TB * 4GB/TB =3D 52GB of RAM, so adding another
> 20GB of swapspace should keep my server running until the reshape
> has finished.

That won't help.  Data stored in kmalloc-256 won't get swapped out - it sta=
ys
in RAM.  So unless you can hot-plus 20Gig of RAM ....

NeilBrown

--Sig_/M7UbLii=DszG2+QE6T49MdT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+/A6jnsnt1WYoG5AQLIcBAAqr2G9toEwPokN59N0KYcmD6hAoDbf77e
JJxNnE0ZEl6QGt+b6cDQBKa70MwZGyIcJrXMytLBzSSIRTQWAi+IXDuaRfZCr388
ZuPl8epZcPYvQ+IO4jHlj2BiNaTJYHe7ik0/1Oa7KLQar+72uWo6p8+KWr7Hkn7l
2v4KAgjwA43I0v4Dc6VLJNzvGI75i4omb1XUg0KYOwqMFNSzyUwfI4YVSV3UBnic
J4rnPQ8Lgw6g93q/Vq3nwOIUIxm3q8NJHgHGxNEozxNKxGEoTi7YADu1Q1YaJou0
zdkrnvx3ONDqGEX1T1c98mleb/PDFmloFJ+KMVEN/2mKtxzEKkOpEiJc/A8H01S+
mdcXaQfkBGwOpVpo7JVi+L8a++sOs14ENPnYN4tIm4vWVaMiboxFMWT6c3H3kUsm
Og+JX5AA+TaCzzaXETXUHuiy8f+i3f3ViSId90b1lSpAvQRmdUNKmwNXoE+c62u9
vu99wPaIvzuwsYz64DVi3ZiEs5SCJiwR01lZ6Wqq1Buy0FXYKl1YIE/gCEXaM4aa
bRGBIxUBqMuugJ05/pTCwBSX3Agm1Tue8bs2PHz8YO/a/1PoD7JqSzsyIcbD4Lot
dFKf41cO4BrU8DWuwFluxKYrFKjaIo7Zk/+yLMemA3VJKcOkCTTRpHFGDgE1hIsy
SbSpXNSMLkw=
=LT7W
-----END PGP SIGNATURE-----

--Sig_/M7UbLii=DszG2+QE6T49MdT--
