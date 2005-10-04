From: Andy Smith <andy@lug.org.uk>
Subject: Re: Checking the sanity of SATA disks
Date: Tue, 4 Oct 2005 14:56:08 +0000
Message-ID: <20051004145608.GL6594@strugglers.net>
References: <20051004142913.GK6594@strugglers.net> <62b0912f0510040742v3d0983b2mf5b93a17e8ed8bba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OJ1sN5DXOQA+AkrV"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <62b0912f0510040742v3d0983b2mf5b93a17e8ed8bba@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--OJ1sN5DXOQA+AkrV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 04, 2005 at 02:42:58PM +0000, Molle Bestefich wrote:
> Andy Smith wrote:
> > I tried simply doing a
> >
> >         dd if=3D/dev/sd[abcd] of=3D/dev/null
> >
> > To check each disk in a very unsubtle fashion, but it drives the
> > load average on the machine way way up (like to 20+)
>=20
> Checked that the disks are using DMA transfers (use 'hdparm')?

$ sudo hdparm /dev/sda

/dev/sda:
 HDIO_GET_MULTCOUNT failed: Inappropriate ioctl for device
 IO_support   =3D  0 (default 16-bit)
 readonly     =3D  0 (off)
 readahead    =3D 256 (on)
 geometry     =3D 14946/255/63, sectors =3D 122942324736, start =3D 0
$ sudo hdparm -d /dev/sda

/dev/sda:

Well that doesn't look right.

=46rom dmesg:

ata1: SATA max UDMA/133 cmd 0x9E0 ctl 0xBE2 bmdma 0xDB00 irq 11
ata2: SATA max UDMA/133 cmd 0x960 ctl 0xB62 bmdma 0xDB08 irq 11
ata1: dev 0 cfg 49:2f00 82:7c6b 83:7b09 84:4003 85:7c69 86:3a01 87:4003 88:=
407f
ata1: dev 0 ATA, max UDMA/133, 240121728 sectors:
ata1: dev 0 configured for UDMA/133
ata2: dev 0 cfg 49:2f00 82:7c6b 83:7b09 84:4003 85:7c69 86:3a01 87:4003 88:=
407f
ata2: dev 0 ATA, max UDMA/133, 240121728 sectors:
ata2: dev 0 configured for UDMA/133
  Vendor: ATA       Model: Maxtor 6Y120M0    Rev: YAR5
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sda: 240121728 512-byte hdwr sectors (122942 MB)
SCSI device sda: drive cache: write back
SCSI device sda: 240121728 512-byte hdwr sectors (122942 MB)
SCSI device sda: drive cache: write back
 sda: sda1 sda2 sda3
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 0
  Vendor: ATA       Model: Maxtor 6Y120M0    Rev: YAR5
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdb: 240121728 512-byte hdwr sectors (122942 MB)
SCSI device sdb: drive cache: write back
SCSI device sdb: 240121728 512-byte hdwr sectors (122942 MB)
SCSI device sdb: drive cache: write back
 sdb: sdb1 sdb2 sdb3
Attached scsi disk sdb at scsi1, channel 0, id 0, lun 0
Attached scsi generic sg1 at scsi1, channel 0, id 0, lun 0,  type 0
ata3: SATA max UDMA/133 cmd 0x9F0 ctl 0xBF2 bmdma 0xE100 irq 10
ata4: SATA max UDMA/133 cmd 0x970 ctl 0xB72 bmdma 0xE108 irq 10
ata3: dev 0 cfg 49:2f00 82:7c6b 83:7b09 84:4003 85:7c69 86:3a01 87:4003 88:=
407f
ata3: dev 0 ATA, max UDMA/133, 240121728 sectors:
ata3: dev 0 configured for UDMA/133
ata4: dev 0 cfg 49:2f00 82:7c6b 83:7b09 84:4003 85:7c69 86:3a01 87:4003 88:=
407f
ata4: dev 0 ATA, max UDMA/133, 240121728 sectors:
ata4: dev 0 configured for UDMA/133
  Vendor: ATA       Model: Maxtor 6Y120M0    Rev: YAR5
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdc: 240121728 512-byte hdwr sectors (122942 MB)
SCSI device sdc: drive cache: write back
SCSI device sdc: 240121728 512-byte hdwr sectors (122942 MB)
SCSI device sdc: drive cache: write back
 sdc: sdc1 sdc2 sdc3
Attached scsi disk sdc at scsi2, channel 0, id 0, lun 0
Attached scsi generic sg2 at scsi2, channel 0, id 0, lun 0,  type 0
  Vendor: ATA       Model: Maxtor 6Y120M0    Rev: YAR5
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdd: 240121728 512-byte hdwr sectors (122942 MB)
SCSI device sdd: drive cache: write back
SCSI device sdd: 240121728 512-byte hdwr sectors (122942 MB)
SCSI device sdd: drive cache: write back
 sdd: sdd1 sdd2 sdd3
Attached scsi disk sdd at scsi3, channel 0, id 0, lun 0
Attached scsi generic sg3 at scsi3, channel 0, id 0, lun 0,  type 0


--OJ1sN5DXOQA+AkrV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD4DBQFDQpgIIJm2TL8VSQsRAnLoAJ93aF40MkGv/IcLkqdVqE0nYvT+CACXcn3S
Eho1+4m3lP3ePYJvuegmRQ==
=2QXA
-----END PGP SIGNATURE-----

--OJ1sN5DXOQA+AkrV--
