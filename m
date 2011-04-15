From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Recommended pci-e 1x SATA cards.
Date: Fri, 15 Apr 2011 10:58:46 +0600
Message-ID: <20110415105846.1c4ec630@natsu>
References: <4DA6CCFE.8020708@crc.id.au>
	<20110414185304.5bc1cca5@natsu>
	<4DA6F3B2.8080402@crc.id.au>
	<4DA7513C.5020505@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/IVae.Ua7vPM/LK=CXPze=8I"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DA7513C.5020505@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Steven Haigh <netwiz@crc.id.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/IVae.Ua7vPM/LK=CXPze=8I
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Apr 2011 14:55:40 -0500
Stan Hoeppner <stan@hardwarefreak.com> wrote:

> Steven Haigh put forth on 4/14/2011 8:16 AM:
>=20
> > That is a very nice writeup... I searched for the HighPoint Rocket 620 -
> > listed as $24.99 on NewEgg - but Australian suppliers seem to have it
> > above $100AUD. The cheapest price I found was $54AUD - and they were out
> > of stock.
>=20
> This is the card you should get:
> http://www.sybausa.com/productInfo.php?iid=3D536
> http://www.newegg.com/Product/Product.aspx?Item=3DN82E16815124027
>=20
> It's the same Syba Sil3132 based card BackBlaze uses in their 45 drive
> mdadm managed pods.
>=20

Did you read the second link you posted, specifically the Feedback section?
That's one more confirmation of corruption issue we discussed in this threa=
d.

"Cons: Corrupts data when reading from two drives at once (!)
Other Thoughts: I bought this to add 2 SATA ports to my desktop. The cheap
software-based PCIe --> 2x SATA cards seem to be based on SIL3132 or JMB363
chipsets (this is a SIL3132), but this was more highly rated so I went with
it. My intention was to add two individual hard drives to my system, with no
RAID involved. Things seemed fine at first, until I used TeraCopy, which do=
es
a CRC after file copy operations. It revealed occasional mismatches when
copying files to either drive.  Then I noticed MD5 hashes of files on the
drives, taken sequentially, differing without any changes to the files'
contents. The final straw was that reading from each of the two separate
drives simultaneously would result in silent read errors,  to the point whe=
re
the file would be heavily corrupted but the OS didn't care.   I stopped usi=
ng
the controller and bought a 3ware one instead, and it's been working
flawlessly.   I don't know if this is a problem specific to this controller=
 or
its chipset, but I would not recommend it."
http://www.newegg.com/Product/Product.aspx?Item=3DN82E16815124027

--=20
With respect,
Roman

--Sig_/IVae.Ua7vPM/LK=CXPze=8I
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2n0IYACgkQTLKSvz+PZwgOFgCdGbRKF8CN7gfMEPgVK+/VKzGn
4mYAn1c0PTxvxwoYlcyq1DV1NUsSyigy
=Gqhg
-----END PGP SIGNATURE-----

--Sig_/IVae.Ua7vPM/LK=CXPze=8I--
