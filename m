From: Gregory Leblanc <gleblanc@linuxweasel.com>
Subject: Re: EIO AP-1680 ATA133 RAID PCI Controller
Date: 11 Feb 2003 13:16:31 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1044998190.12695.3.camel@gregdell>
References: <3E4329CE.5020706@netscape.net> <3E47E248.3080006@mvista.com>
	 <3E48871A.3010709@netscape.net>  <3E493005.4030702@mvista.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-E3n9VkeUvCPHtVtit7tK"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E493005.4030702@mvista.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-E3n9VkeUvCPHtVtit7tK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2003-02-11 at 09:16, Steven Dake wrote:
> I don't know the specifics of those cards, but if they include an i/o=20
> processor, they are a hardware RAID.
>=20
> Keep in mind that unless you want to boot or use a RAID 5, or want to=20
> share your RAID volumes between different operating systems, there is=20
> little reason to purchase a hardware RAID card.  Software RAID is quite=20
> sufficient for most needs and the host processor running at 2+ ghz is=20
> much better at RAID then a 60 mhz i960 IOP.  Keep in mind, though, that=20
> hardware RAID adaptors have built in xor accelerators which can do=20
> multiple xors in one instruction in hardware, allowing for much better=20
> xor performance then the intel or ppc processor can do.

While the performance of RAID 5 using software RAID is generally far
superior to that provided by hardware RAID, host CPU usage can be
-quite- high in high-load situations.  The benchmarks recently posted
had cpu usage numbers at over 90% on most sequeential writes and reads.
	Greg

--=-E3n9VkeUvCPHtVtit7tK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQA+SWgunAkVXO6fw4sRAoQzAJ9/LZ4qWKSF2BWXfe+MyyRP5gY0JgCfQYov
TXf6Yq7XQxmcc/kFWy1PQKY=
=Hoij
-----END PGP SIGNATURE-----

--=-E3n9VkeUvCPHtVtit7tK--

