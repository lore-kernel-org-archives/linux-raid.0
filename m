From: NeilBrown <neilb@suse.de>
Subject: Re: Changed the SATA ports of two disks in RAID10 and raid
 disappeared
Date: Thu, 22 Sep 2011 16:40:06 +1000
Message-ID: <20110922164006.763ef4c7@notabene.brown>
References: <4E774458.3070107@pum.edu.pl>
	<4E7AD258.2040201@pum.edu.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HObfh=jJ/XJ/_8tctnJy_mq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E7AD258.2040201@pum.edu.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Piotr Legiecki <piotrlg@pum.edu.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/HObfh=jJ/XJ/_8tctnJy_mq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 22 Sep 2011 08:14:48 +0200 Piotr Legiecki <piotrlg@pum.edu.pl> wrot=
e:

> Piotr Legiecki pisze:
> > Hi
> >=20
> > I have RAID10 with 4 disks. Two of them are connected to 3ware PCIe 4=20
> > ports SATA controler and the other two on the motherboard SATA ports. I=
=20
> > wanted to reconnect those two disks connected to motherboard to 3ware c=
ard.
> >=20
> ...
>=20
> >=20
> > So two questions are important now.
> > 1. How to run this array (safely) again on old ports
>=20
> Well, that was easy, I have just assembled the array again.
>=20
> > 2. How to change the ports to new ones? In a proper way.
>=20
> Hm, no answer here... still I don't want to repeat my errors.

Find out why the new ports make the devices look slightly smaller and
un-break them.


>=20
> >=20
> > The other thing bothers me o bit. Why there is
> > mdadm: metadata format 00.90 unknown, ignored. warnig? AFAIR it was=20
> > almost from the beggining of my md arrays on this computer.
>=20
> Solution?

Somewhere in /etc/mdadm.conf you have "00.90" where you really want "0.90".
More recent versions of mdadm are more forgiving.

NeilBrown


>=20
> P.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/HObfh=jJ/XJ/_8tctnJy_mq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOethGG5fc6gV+Wb0RAlnQAKDXb4HlQwkvT86BZ76sgxZfRH3GfACg0gVV
laY06+9qBmvKZYSekSeU2/M=
=8sRk
-----END PGP SIGNATURE-----

--Sig_/HObfh=jJ/XJ/_8tctnJy_mq--
