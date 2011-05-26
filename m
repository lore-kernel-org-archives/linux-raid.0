From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Storage device enumeration script
Date: Fri, 27 May 2011 00:12:35 +0600
Message-ID: <20110527001235.2b47572e@natsu>
References: <4DDDC301.7090608@turmel.org>
	<1306403130.9437.109.camel@torbjorn>
	<4DDE3BF1.7030105@turmel.org>
	<4DDE9213.2070508@turmel.org>
	<20110526235415.584ae2e2@natsu>
	<4DDE95C1.5030401@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/grjAWo9KDyu5JOWPPkRrSSg"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDE95C1.5030401@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: =?UTF-8?B?VG9yYmrDuHJu?= Skagestad <torbjorn@itpas.no>, linux-raid@vger.kernel.org, Roman Mamedov <roman@rm.pp.ru>, John Robinson <john.robinson@anonymous.org.uk>, CoolCold <coolthecold@gmail.com>, Mathias =?UTF-8?B?QnVyw6lu?= <mathias.buren@gmail.com>
List-Id: linux-raid.ids

--Sig_/grjAWo9KDyu5JOWPPkRrSSg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 26 May 2011 14:02:41 -0400
Phil Turmel <philip@turmel.org> wrote:

> Hi Roman,
>=20
> On 05/26/2011 01:54 PM, Roman Mamedov wrote:
> > On Thu, 26 May 2011 13:46:59 -0400
> > Phil Turmel <philip@turmel.org> wrote:
> >=20
> >> if you just want the latest script:
> >>
> >> https://github.com/pturmel/lsdrv/raw/HEAD/lsdrv
> >=20
> > I already reported this earlier, but still in this version:
> >=20
> > Traceback (most recent call last):
> >   File "./lsdrv", line 274, in <module>
> >     probe_block('/sys/block/'+x)
> >   File "./lsdrv", line 226, in probe_block
> >     dev.phy =3D probe_device(blkpath+'/device', nodestr)
> >   File "./lsdrv", line 193, in probe_device
> >     vendor=3Dfileline1(devpath+'/vendor'),
> >   File "./lsdrv", line 49, in fileline1
> >     fh =3D open(filename, 'r')
> > IOError: [Errno 2] No such file or directory:
> > '/sys/devices/platform/floppy.0/vendor'
>=20
> I used the wrong exception type.  Fix pushed.  Try again?

Now it locks up with 100% CPU load and no output, I waited for a couple of
minutes. On Ctrl-C:

^CTraceback (most recent call last):
  File "./lsdrv", line 274, in <module>
    probe_block('/sys/block/'+x)

$ ls /sys/block/
etherd!e1.5  etherd!e2.1  md0  md2  sda  sdc  sde  sdg
etherd!e1.6  fd0          md1  md4  sdb  sdd  sdf

The first two devices are actually down at this moment, maybe that's the
reason? Still I'd expect not 100% CPU load by lsdrv, but 0% CPU and 100%
iowait in this case.

Output of the old (bash) lsdrv:

Controller device @ pci0000:00/0000:00:06.0 [pata_amd]
  IDE interface: nVidia Corporation CK804 IDE (rev f2)
    host8: [Empty]
    host9: [Empty]
Controller device @ pci0000:00/0000:00:07.0 [sata_nv]
  IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
    host6: /dev/sdd ATA Hitachi HDS5C302 {SN: ..............}
    host7: /dev/sde ATA WDC WD15EADS-00S {SN: ..............}
Controller device @ pci0000:00/0000:00:08.0 [sata_nv]
  IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
    host10: /dev/sdf ATA WDC WD20EADS-00S {SN: ..............}
    host11: /dev/sdg ATA WDC WD20EADS-00S {SN: ..............}
Controller device @ pci0000:00/0000:00:0d.0/0000:02:00.0 [ahci]
  SATA controller: Marvell Technology Group Ltd. 88SE9123 PCIe SATA 6.0 Gb/s
controller (rev 10) host4: /dev/sdc ATA Hitachi HDS5C302 {SN: .............=
.}
    host5: [Empty]
Controller device @ pci0000:00/0000:00:0e.0/0000:01:00.0 [sata_mv]
  SCSI storage controller: Marvell Technology Group Ltd. 88SX7042 PCI-e 4-p=
ort
SATA-II (rev 02) host0: [Empty]
    host1: [Empty]
    host2: /dev/sda ATA ST31000528AS {SN: ..............}
    host3: /dev/sdb ATA Hitachi HDS72202 {SN: ..............}


--=20
With respect,
Roman

--Sig_/grjAWo9KDyu5JOWPPkRrSSg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3emBMACgkQTLKSvz+PZwhLQQCeJoqmJ1PCyfI4P2t5fjBTwnhV
t4QAn0TqRkcF7adkY9E71jXCbT8GvBAD
=FbN5
-----END PGP SIGNATURE-----

--Sig_/grjAWo9KDyu5JOWPPkRrSSg--
