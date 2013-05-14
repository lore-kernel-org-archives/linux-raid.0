From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Corruption during RAID5->RAID6 migration
Date: Wed, 15 May 2013 03:13:03 +0600
Message-ID: <20130515031303.653f6d56@natsu>
References: <CAJDy474SBN7qMgccmkzc++=ZP43L1M=jVkyx_YVkqdZmbvwZfg@mail.gmail.com>
	<20130515020814.77ff1407@natsu>
	<CAJDy477412O8_saeP-YYxXSoQsgMy8jEgdfXa7p5_2V54nMG=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6Eflamyq/6H/uUe/HkCs6+0"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJDy477412O8_saeP-YYxXSoQsgMy8jEgdfXa7p5_2V54nMG=Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: James Doebbler <jamesdoebbler@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/6Eflamyq/6H/uUe/HkCs6+0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 14 May 2013 15:56:57 -0500
James Doebbler <jamesdoebbler@gmail.com> wrote:

> Roman,
>=20
> I suppose that means you think it's hardware-related then.  Do you
> have any suggestions on what/how I might be able to recover?
>=20
> Hardware details:
>=20
> The motherboard is ECS A785GM-M with 6x internal SATAII and 2x eSATAII
> I have installed 2 x SYBA SD-SA2PEX-2IR (SiI3132 Chipset), each with
> 2x onboard SATAII

Hello,

This card and in fact the 3132 chipset is known to corrupt data when both
ports are accessed simultaneously at high speed.

> http://lime-technology.com/wiki/index.php/Hardware_Compatibility
> SYBA (PCI-E X1) 2 port SATA II (SiI3132)
> Beware!!! There are numerous providers of SiL3132-based addon cards, and =
a few of them (unknown how many) are known to be faulty, causing unseen (SI=
LENT) data corruption - see
> http://lime-technology.com/forum/index.php?topic=3D18428.msg167122#msg167=
122
> http://lime-technology.com/forum/index.php?topic=3D21052.msg187437#msg187=
437

Earlier discussions on linux-raid:
http://comments.gmane.org/gmane.linux.raid/30629
http://permalink.gmane.org/gmane.linux.raid/33369
http://comments.gmane.org/gmane.linux.raid/33346

Some more reports:
http://s.lowendshare.com/4/1368565867.495.2013-05-14T211035Z-syba3132.png
http://forum.ixbt.com/topic.cgi?id=3D11:35147-39#1199 (Russian)

--=20
With respect,
Roman

--Sig_/6Eflamyq/6H/uUe/HkCs6+0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlGSqN8ACgkQTLKSvz+PZwhu0QCdGp3yPhqzcvduDkYaC8AMyPpQ
uPUAnjYfa1sk5sli48KSyx/IzIz6eveH
=twCT
-----END PGP SIGNATURE-----

--Sig_/6Eflamyq/6H/uUe/HkCs6+0--
