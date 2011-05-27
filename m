From: =?ISO-8859-1?Q?Torbj=F8rn?= Skagestad <torbjorn@itpas.no>
Subject: Re: Storage device enumeration script
Date: Fri, 27 May 2011 13:26:48 +0200
Message-ID: <1306495608.9437.140.camel@torbjorn>
References: <42.A9.00666.D9CEEDD4@cdptpa-omtalb.mail.rr.com>
	 <4DDEED47.1040809@fnarfbargle.com> <20110527095840.427d90be@natsu>
	 <alpine.DEB.2.00.1105271142110.25096@unicorn.drogon.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MXhvSv7HsB0jwIbfTe/t"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1105271142110.25096@unicorn.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-MXhvSv7HsB0jwIbfTe/t
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Some info can be found here https://github.com/pturmel/lsdrv

The output will typically be like this:

Controller platform [None]
 =E2=94=94=E2=94=80platform floppy.0
    =E2=94=94=E2=94=80fd0: Empty/Unknown 4.00k
PCI [pata_jmicron] 03:00.1 IDE interface: JMicron Technology Corp. JMB362/J=
MB363 Serial ATA Controller (rev 02)
 =E2=94=9C=E2=94=80scsi 0:x:x:x [Empty]
 =E2=94=94=E2=94=80scsi 2:x:x:x [Empty]
PCI [ahci] 03:00.0 SATA controller: JMicron Technology Corp. JMB362/JMB363 =
Serial ATA Controller (rev 02)
 =E2=94=9C=E2=94=80scsi 12:0:0:0 ATA THROTTLE
 =E2=94=82  =E2=94=94=E2=94=80sdu: Empty/Unknown 7.51g
 =E2=94=82     =E2=94=9C=E2=94=80sdu1: Empty/Unknown 243.00m
 =E2=94=82     =E2=94=82  =E2=94=94=E2=94=80Mounted as /dev/sdu1 @ /boot
 =E2=94=82     =E2=94=9C=E2=94=80sdu2: Empty/Unknown 1.00k
 =E2=94=82     =E2=94=94=E2=94=80sdu5: Empty/Unknown 7.27g
 =E2=94=82        =E2=94=9C=E2=94=80dm-0: Empty/Unknown 6.90g
 =E2=94=82        =E2=94=82  =E2=94=94=E2=94=80Mounted as /dev/mapper/serve=
r-root @ /
 =E2=94=82        =E2=94=94=E2=94=80dm-1: Empty/Unknown 368.00m
 =E2=94=94=E2=94=80scsi 13:0:0:0 ATA WDC WD10EACS-00Z
    =E2=94=94=E2=94=80sdv: Empty/Unknown 931.51g
       =E2=94=94=E2=94=80md1: Empty/Unknown 3.64t
          =E2=94=94=E2=94=80dm-3: Empty/Unknown 3.64t
             =E2=94=94=E2=94=80Mounted as /dev/mapper/big1 @ /mnt/big1
PCI [pcieport] 00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) P=
CI Express Port 1 (rev 02)
 =E2=94=9C=E2=94=80scsi 15:0:0:0 ATA WDC WD20EARS-00J
 =E2=94=82  =E2=94=94=E2=94=80sdy: Empty/Unknown 1.82t
 =E2=94=82     =E2=94=94=E2=94=80sdy1: Empty/Unknown 1.82t
 =E2=94=82        =E2=94=94=E2=94=80md3: Empty/Unknown 7.28t
 =E2=94=82           =E2=94=94=E2=94=80dm-5: Empty/Unknown 7.28t
 =E2=94=82              =E2=94=94=E2=94=80Mounted as /dev/mapper/big3 @ /mn=
t/big3
 =E2=94=9C=E2=94=80scsi 15:0:1:0 ATA WDC WD20EARS-00J
 =E2=94=82  =E2=94=94=E2=94=80sdz: Empty/Unknown 1.82t
 =E2=94=82     =E2=94=94=E2=94=80sdz1: Empty/Unknown 1.82t
 =E2=94=9C=E2=94=80scsi 15:0:2:0 ATA WDC WD20EARS-00J
 =E2=94=82  =E2=94=94=E2=94=80sda: Empty/Unknown 1.82t
 =E2=94=82     =E2=94=94=E2=94=80sda1: Empty/Unknown 1.82t
 =E2=94=9C=E2=94=80scsi 15:0:3:0 ATA WDC WD20EARS-00J
 =E2=94=82  =E2=94=94=E2=94=80sdw: Empty/Unknown 1.82t
 =E2=94=82     =E2=94=94=E2=94=80sdw1: Empty/Unknown 1.82t
 =E2=94=94=E2=94=80scsi 15:0:4:0 ATA WDC WD20EARS-00J
    =E2=94=94=E2=94=80sdae: Empty/Unknown 1.82t
       =E2=94=94=E2=94=80sdae1: Empty/Unknown 1.82t
---snip---


On Fri, 2011-05-27 at 11:45 +0100, Gordon Henderson wrote:
> On Fri, 27 May 2011, Roman Mamedov wrote:
>=20
> > On Fri, 27 May 2011 08:16:07 +0800
> > Brad Campbell <brad@fnarfbargle.com> wrote:
> >
> >> On 27/05/11 08:13, Leslie Rhorer wrote:
> >>>>
> >>> 	I can't speak to Ubuntu, but Debian evidently does not.  I don't
> >>> know what "pvs" is, but neither bash nor Python recognize it as a fil=
e
> >>> anywhere in the path.
> >> apt-get install lvm2.
> >
> > Sure, but lsdrv shouldn't assume lvm2 is installed or require it to be
> > installed. Not everyone uses LVM, and simply installing it automaticall=
y adds
> > things to initramfs (PV/VG/LV detection?), which can slow down boot-up =
process.
>=20
> As well as not using LVM, some of us don't even use udev... Or kernels=
=20
> with modules...
>=20
> Can someone post the output of this utility so I can see what it's=20
> actually doing?
>=20
> (I don't have python on all my servers either)
>=20
> Cheers,
>=20
> Gordon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Torbj=C3=B8rn Skagestad
Id=C3=A9 Til Produkt AS
torborn@itpas.no

--=-MXhvSv7HsB0jwIbfTe/t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk3fingACgkQ4RjLWGFqSIZ3+QCfZLVS381tb1aIRwTCBU5K/i1L
q2cAn0iw9hmFkpETNWdNsiqA8Edge8bY
=MQX3
-----END PGP SIGNATURE-----

--=-MXhvSv7HsB0jwIbfTe/t--

