From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: More tales of horror from the linux (HW) raid crypt
Date: Wed, 22 Jun 2005 20:49:18 -0400
Message-ID: <1119487758.5501.185.camel@localhost.localdomain>
References: <5d96567b05061804477325d743@mail.gmail.com>
	 <200506221316.33178.hjm@tacgi.com>
	 <1119474566.11039.12.camel@dhcpc226.office.pivotlink.com>
	 <200506221443.28613.hjm@tacgi.com>
	 <1119477636.5501.161.camel@localhost.localdomain>
	 <1119485655.42b9fed75fc87@mail.pivotlink.com>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wrd87D2XpfUeK4TaSFKS"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1119485655.42b9fed75fc87@mail.pivotlink.com>
Sender: linux-raid-owner@vger.kernel.org
To: bdameron@pivotlink.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-wrd87D2XpfUeK4TaSFKS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2005-06-22 at 17:14 -0700, bdameron@pivotlink.com wrote:
> Quoting Ming Zhang <mingz@ele.uri.edu>:
>=20
> > will this 24 port card itself will be a bottleneck?
> >=20
> > ming
>=20
> Since the card is PCI-X the only bottleneck on it might be the Processor =
since=20
> it is shared with all 24 ports. But I do not know for sure without testin=
g it.=20
> I personally am going to stick with the new 16 port version. Which is a P=
CI-
> Express card and has twice the CPU power. Since there are so many spindle=
s it=20
> should be pretty darn fast. And remember that even tho the drives are 150=
MBps=20
> they realistically only do about 25-30MBps.=20

the problem here is taht each HD can stably deliver 25-30MBps while the
PCI-x will not arrive that high if have 16 or 24 ports. i do not have a
chance to try out though. those bus at most arrive 70-80% the claimed
peak # :P



>=20
> Brad Dameron
> SeaTab Software
> www.seatab.com=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-wrd87D2XpfUeK4TaSFKS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBCugcOSYbkL5BnVYoRAidNAJsFBk/U3a4N/XBL0D8wumQQtuZwGACfeD35
60vEU56HzURoEVNGSI3AMUg=
=Ykiq
-----END PGP SIGNATURE-----

--=-wrd87D2XpfUeK4TaSFKS--

