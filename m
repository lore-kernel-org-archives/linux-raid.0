From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Recommended pci-e 1x SATA cards.
Date: Thu, 14 Apr 2011 16:54:33 +0600
Message-ID: <20110414165433.7a7d1cdc@natsu>
References: <4DA6CCFE.8020708@crc.id.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/mu3S+WYS.iiX+LSds4RIgKU"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DA6CCFE.8020708@crc.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Haigh <netwiz@crc.id.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/mu3S+WYS.iiX+LSds4RIgKU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Apr 2011 20:31:26 +1000
Steven Haigh <netwiz@crc.id.au> wrote:

> I'm looking at adding a couple of SATA ports to my home server and=20
> figure its probably better to get a 1x pci-e card instead of using the=20
> PCI bus.
>=20
> Has anyone got any recommendations on cheap pci-e SATA cards that work=20
> well with linux?
>=20
> Any comments on these?
> http://cgi.ebay.com.au/PCI-E-PCIE-RAID-Express-Card-SATA-II-Controller-A2=
4-/220762966195?pt=3DAU_Computer_Components_Controller_Cards&hash=3Ditem336=
67f88b3
>=20
> http://cgi.ebay.com.au/PCI-E-PCIE-RAID-Express-Card-2-SATA-II-2-eSATA-A25=
-/300543913241?pt=3DAU_Components&hash=3Ditem45f9d02d19
>=20
> This is a jMicron adapter - but I haven't heard much good or bad about th=
em.
> http://cgi.ebay.com.au/PCI-E-PCIE-Express-Card-2-SATA-RAID-II-Controller-=
/260745100434?pt=3DAU_Computer_Components_Controller_Cards&hash=3Ditem3cb59=
e7c92
>=20
> Any others that people recommend?
>=20

JMicron is okay, it's an AHCI compatible controller, so does not even requi=
re
its own driver module, it just uses 'ahci'. Keep in mind that it is not a
PCI-E 2.0 device, and the transfer speed will be limited to 250 MB/sec over
both ports (and because of various overheads, something closer to 200 MB/se=
c).
A couple of modern disks can easily reach and become limited by that.

I suggest that you avoid Silicon Image 3132, they have data corruption issue
(on some board designs?), triggered or amplified by transferring via both
ports at the same time, at full speed.

If you can spend a bit more, try finding a controller based on Marvell 9123,
which is a 2-port SATA3 chip for PCI-E 2.0. For example "ASRock SATA3 Card"
which is sold separately (from motherboards) for about $33.
https://encrypted.google.com/search?hl=3Den&source=3Dhp&q=3DASRock%20SATA3%=
20Card
The only downside of that device, is that it doesn't seem to be compatible
with PCI-E 1.0, it is 1.1/2.0 only, so will not work on many old motherboar=
ds.

--=20
With respect,
Roman

--Sig_/mu3S+WYS.iiX+LSds4RIgKU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2m0mkACgkQTLKSvz+PZwhkswCfZ7vd2BnMDeU0Rpk1nSn+TujT
FvEAnA98+MiWjWUiWRTC3typ9vodwQXw
=b/4V
-----END PGP SIGNATURE-----

--Sig_/mu3S+WYS.iiX+LSds4RIgKU--
