From: =?ISO-8859-1?Q?Torbj=F8rn?= Skagestad <torbjorn@itpas.no>
Subject: Re: Storage device enumeration script
Date: Thu, 26 May 2011 14:05:05 +0200
Message-ID: <1306411505.9437.130.camel@torbjorn>
References: <4DDDC301.7090608@turmel.org>
	 <1306403130.9437.109.camel@torbjorn> <4DDE249C.7080004@anonymous.org.uk>
	 <4DDE3E60.3010408@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-afAwg1qHC1EGE1vh/MaI"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDE3E60.3010408@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org, Roman Mamedov <roman@rm.pp.ru>
List-Id: linux-raid.ids


--=-afAwg1qHC1EGE1vh/MaI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-05-26 at 07:49 -0400, Phil Turmel wrote:
> On 05/26/2011 05:59 AM, John Robinson wrote:
> > On 26/05/2011 10:45, Torbj=C3=B8rn Skagestad wrote:
> >> Hi,
> >>
> >> Great tool, thanks for sharing.
> >>
> >> I had to add some error handling to get it to work properly.
> >> Currently it runs on Ubuntu 10.04, 10.10 and 11.04.
> >>
> >> Added the check John Robinson asked for as well.
> >>
> >> Attached patch for those interested.
> >=20
> > Thanks, Torbj=C3=B8rn!
> >=20
> > Getting there:
> >=20
> > [root@beast lsdrv]# python2.6 lsdrv
> > PCI [pata_marvell] 03:00.0 IDE interface: Marvell Technology Group Ltd.=
 88SE6121 SATA II Controller (rev b2)
> >  =E2=94=94=E2=94=80scsi 0:0:0:0 HL-DT-ST DVD-RAM GH22NP20
> >     =E2=94=94=E2=94=80sr0: Empty/Unknown 1.00g
> > PCI [ahci] 00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Fa=
mily) SATA AHCI Controller
> >  =E2=94=9C=E2=94=80scsi 2:0:0:0 ATA Hitachi HDS72101
> >  =E2=94=82  =E2=94=94=E2=94=80sda: Empty/Unknown 931.51g
> > Traceback (most recent call last):
> >   File "lsdrv", line 387, in <module>
> >     show_blocks(" %s " % branch[0], [phy.block])
> >   File "lsdrv", line 339, in show_blocks
> >     show_blocks("%s %s " % (indent, branch[0]), [blockbyname[x] for x i=
n subs])
> > KeyError: 'sda1'
> >=20
> > Now, something's not getting picked up about sda. Looking at Mathias' "=
sweet" output, it's not coping with the (DOS) partition table. Another vari=
ation on my kernel's /sys or still to old a Python or ...?
>=20
> Hmmm.  I'll set up another CentOS VM.  If I recall correctly, that kernel=
 has the original block devices in folders named '.../block:sda1' instead o=
f '.../block/sda1'.  I'll have to identify this in the initial sweep throug=
h sysfs.
>=20

For CentOS 5.4 (2.6.18-128.1.14) it is /sys/block/sda/sda[1-9]


> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Torbj=C3=B8rn Skagestad
Id=C3=A9 Til Produkt AS
torborn@itpas.no

--=-afAwg1qHC1EGE1vh/MaI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk3eQfEACgkQ4RjLWGFqSIZ99wCdFBqdaJ56Or8uMlaY/TheCo5t
ldkAnjqsWO2Z8EpEeB3a7OMOvqkOoDjH
=g7oO
-----END PGP SIGNATURE-----

--=-afAwg1qHC1EGE1vh/MaI--

