From: =?ISO-8859-1?Q?Torbj=F8rn?= Skagestad <torbjorn@itpas.no>
Subject: Re: Storage device enumeration script
Date: Thu, 26 May 2011 20:42:35 +0200
Message-ID: <1306435355.3684.7.camel@ts-workstation>
References: <4DDDC301.7090608@turmel.org>
	 <1306403130.9437.109.camel@torbjorn>	<4DDE3BF1.7030105@turmel.org>
	 <4DDE9213.2070508@turmel.org>	<20110526235415.584ae2e2@natsu>
	 <4DDE95C1.5030401@turmel.org> <20110527001235.2b47572e@natsu>
	 <4DDE9A61.2070201@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDE9A61.2070201@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Roman Mamedov <rm@romanrm.ru>, linux-raid@vger.kernel.org, Roman Mamedov <roman@rm.pp.ru>, John Robinson <john.robinson@anonymous.org.uk>, CoolCold <coolthecold@gmail.com>, Mathias =?ISO-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>
List-Id: linux-raid.ids

Hi,

I'm hitting this as well.It seems to be triggered by my non-existing
floppy device.

As there is no real floppy device connected, no driver is loaded, so we
never see a /driver directory. This loop then goes all the way up to /,
where it loops forever at 100% cpu.


from probe_controller()
151 while cpath and not os.path.exists(cpath+'/driver'):
152		cpath =3D os.path.dirname(cpath)
153		if cpath in controllers:
154			return controllers[cpath]


On Thu, 2011-05-26 at 14:22 -0400, Phil Turmel wrote:
> On 05/26/2011 02:12 PM, Roman Mamedov wrote:
> [...]
> > Now it locks up with 100% CPU load and no output, I waited for a co=
uple of
> > minutes. On Ctrl-C:
> >=20
> > ^CTraceback (most recent call last):
> >   File "./lsdrv", line 274, in <module>
> >     probe_block('/sys/block/'+x)
> >=20
> > $ ls /sys/block/
> > etherd!e1.5  etherd!e2.1  md0  md2  sda  sdc  sde  sdg
> > etherd!e1.6  fd0          md1  md4  sdb  sdd  sdf
> >=20
> > The first two devices are actually down at this moment, maybe that'=
s the
> > reason? Still I'd expect not 100% CPU load by lsdrv, but 0% CPU and=
 100%
> > iowait in this case.
>=20
> Sounds like an infinite loop, or infinite recursion.  Could you apply=
 the temporary patch below so I can see how far the probing got?
>=20
> > Output of the old (bash) lsdrv:
> >=20
> > Controller device @ pci0000:00/0000:00:06.0 [pata_amd]
> >   IDE interface: nVidia Corporation CK804 IDE (rev f2)
> >     host8: [Empty]
> >     host9: [Empty]
> > Controller device @ pci0000:00/0000:00:07.0 [sata_nv]
> >   IDE interface: nVidia Corporation CK804 Serial ATA Controller (re=
v f3)
> >     host6: /dev/sdd ATA Hitachi HDS5C302 {SN: ..............}
> >     host7: /dev/sde ATA WDC WD15EADS-00S {SN: ..............}
> > Controller device @ pci0000:00/0000:00:08.0 [sata_nv]
> >   IDE interface: nVidia Corporation CK804 Serial ATA Controller (re=
v f3)
> >     host10: /dev/sdf ATA WDC WD20EADS-00S {SN: ..............}
> >     host11: /dev/sdg ATA WDC WD20EADS-00S {SN: ..............}
> > Controller device @ pci0000:00/0000:00:0d.0/0000:02:00.0 [ahci]
> >   SATA controller: Marvell Technology Group Ltd. 88SE9123 PCIe SATA=
 6.0 Gb/s
> > controller (rev 10) host4: /dev/sdc ATA Hitachi HDS5C302 {SN: .....=
=2E........}
> >     host5: [Empty]
> > Controller device @ pci0000:00/0000:00:0e.0/0000:01:00.0 [sata_mv]
> >   SCSI storage controller: Marvell Technology Group Ltd. 88SX7042 P=
CI-e 4-port
> > SATA-II (rev 02) host0: [Empty]
> >     host1: [Empty]
> >     host2: /dev/sda ATA ST31000528AS {SN: ..............}
> >     host3: /dev/sdb ATA Hitachi HDS72202 {SN: ..............}
>=20
> The old code never attempted to recurse into the layers of block devi=
ces, so it can't have recursion problems.
>=20
> Phil
>=20
> 8<-------------------------
>=20
> diff --git a/lsdrv b/lsdrv
> index d1caaf8..37728c1 100755
> --- a/lsdrv
> +++ b/lsdrv
> @@ -145,6 +145,7 @@ def sect2size(sectors):
>  # the struct object w/ filled in details.
>  controllers=3Ddict()
>  def probe_controller(cpathlink):
> +	print "Probing controller %s" % cpathlink
>  	cpath =3D os.path.realpath(cpathlink)
>  	if cpath in controllers:
>  		return controllers[cpath]
> @@ -186,6 +187,7 @@ def probe_controller(cpathlink):
>  # controller.
>  phydevs=3Ddict()
>  def probe_device(devpathlink, nodestr):
> +	print "Probing device %s" % devpathlink
>  	devpath =3D os.path.realpath(devpathlink)
>  	if devpath in phydevs:
>  		return phydevs[devpath]
> @@ -214,6 +216,7 @@ def probe_device(devpathlink, nodestr):
>  blockbyname=3Ddict()
>  blockbynode=3Ddict()
>  def probe_block(blocklink):
> +	print "Probing block %s" % blocklink
>  	name=3Dblocklink.rsplit('/', 1)[-1]
>  	if name in blockbyname:
>  		return

--=20
Torbj=C3=B8rn Skagestad
Ide Til Produkt A/S

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
