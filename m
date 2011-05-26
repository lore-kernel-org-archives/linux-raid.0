From: CoolCold <coolthecold@gmail.com>
Subject: Re: Storage device enumeration script
Date: Thu, 26 May 2011 22:58:41 +0400
Message-ID: <BANLkTimqPRxqF5McHEqSKA5N_Wa=t4vAxw@mail.gmail.com>
References: <4DDDC301.7090608@turmel.org>
	<1306403130.9437.109.camel@torbjorn>
	<4DDE3BF1.7030105@turmel.org>
	<4DDE9213.2070508@turmel.org>
	<20110526235415.584ae2e2@natsu>
	<4DDE95C1.5030401@turmel.org>
	<20110527001235.2b47572e@natsu>
	<4DDE9A61.2070201@turmel.org>
	<1306435355.3684.7.camel@ts-workstation>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1306435355.3684.7.camel@ts-workstation>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Torbj=F8rn_Skagestad?= <torbjorn@itpas.no>
Cc: Phil Turmel <philip@turmel.org>, Roman Mamedov <rm@romanrm.ru>, linux-raid@vger.kernel.org, Roman Mamedov <roman@rm.pp.ru>, John Robinson <john.robinson@anonymous.org.uk>, =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
List-Id: linux-raid.ids

I guess we should move off this list, may be continue on github comment=
s.

On Thu, May 26, 2011 at 10:42 PM, Torbj=F8rn Skagestad <torbjorn@itpas.=
no> wrote:
> Hi,
>
> I'm hitting this as well.It seems to be triggered by my non-existing
> floppy device.
>
> As there is no real floppy device connected, no driver is loaded, so =
we
> never see a /driver directory. This loop then goes all the way up to =
/,
> where it loops forever at 100% cpu.
>
>
> from probe_controller()
> 151 while cpath and not os.path.exists(cpath+'/driver'):
> 152 =A0 =A0 =A0 =A0 =A0 =A0 cpath =3D os.path.dirname(cpath)
> 153 =A0 =A0 =A0 =A0 =A0 =A0 if cpath in controllers:
> 154 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return controllers[cpath]
>
>
> On Thu, 2011-05-26 at 14:22 -0400, Phil Turmel wrote:
>> On 05/26/2011 02:12 PM, Roman Mamedov wrote:
>> [...]
>> > Now it locks up with 100% CPU load and no output, I waited for a c=
ouple of
>> > minutes. On Ctrl-C:
>> >
>> > ^CTraceback (most recent call last):
>> > =A0 File "./lsdrv", line 274, in <module>
>> > =A0 =A0 probe_block('/sys/block/'+x)
>> >
>> > $ ls /sys/block/
>> > etherd!e1.5 =A0etherd!e2.1 =A0md0 =A0md2 =A0sda =A0sdc =A0sde =A0s=
dg
>> > etherd!e1.6 =A0fd0 =A0 =A0 =A0 =A0 =A0md1 =A0md4 =A0sdb =A0sdd =A0=
sdf
>> >
>> > The first two devices are actually down at this moment, maybe that=
's the
>> > reason? Still I'd expect not 100% CPU load by lsdrv, but 0% CPU an=
d 100%
>> > iowait in this case.
>>
>> Sounds like an infinite loop, or infinite recursion. =A0Could you ap=
ply the temporary patch below so I can see how far the probing got?
>>
>> > Output of the old (bash) lsdrv:
>> >
>> > Controller device @ pci0000:00/0000:00:06.0 [pata_amd]
>> > =A0 IDE interface: nVidia Corporation CK804 IDE (rev f2)
>> > =A0 =A0 host8: [Empty]
>> > =A0 =A0 host9: [Empty]
>> > Controller device @ pci0000:00/0000:00:07.0 [sata_nv]
>> > =A0 IDE interface: nVidia Corporation CK804 Serial ATA Controller =
(rev f3)
>> > =A0 =A0 host6: /dev/sdd ATA Hitachi HDS5C302 {SN: ..............}
>> > =A0 =A0 host7: /dev/sde ATA WDC WD15EADS-00S {SN: ..............}
>> > Controller device @ pci0000:00/0000:00:08.0 [sata_nv]
>> > =A0 IDE interface: nVidia Corporation CK804 Serial ATA Controller =
(rev f3)
>> > =A0 =A0 host10: /dev/sdf ATA WDC WD20EADS-00S {SN: ..............}
>> > =A0 =A0 host11: /dev/sdg ATA WDC WD20EADS-00S {SN: ..............}
>> > Controller device @ pci0000:00/0000:00:0d.0/0000:02:00.0 [ahci]
>> > =A0 SATA controller: Marvell Technology Group Ltd. 88SE9123 PCIe S=
ATA 6.0 Gb/s
>> > controller (rev 10) host4: /dev/sdc ATA Hitachi HDS5C302 {SN: ....=
=2E.........}
>> > =A0 =A0 host5: [Empty]
>> > Controller device @ pci0000:00/0000:00:0e.0/0000:01:00.0 [sata_mv]
>> > =A0 SCSI storage controller: Marvell Technology Group Ltd. 88SX704=
2 PCI-e 4-port
>> > SATA-II (rev 02) host0: [Empty]
>> > =A0 =A0 host1: [Empty]
>> > =A0 =A0 host2: /dev/sda ATA ST31000528AS {SN: ..............}
>> > =A0 =A0 host3: /dev/sdb ATA Hitachi HDS72202 {SN: ..............}
>>
>> The old code never attempted to recurse into the layers of block dev=
ices, so it can't have recursion problems.
>>
>> Phil
>>
>> 8<-------------------------
>>
>> diff --git a/lsdrv b/lsdrv
>> index d1caaf8..37728c1 100755
>> --- a/lsdrv
>> +++ b/lsdrv
>> @@ -145,6 +145,7 @@ def sect2size(sectors):
>> =A0# the struct object w/ filled in details.
>> =A0controllers=3Ddict()
>> =A0def probe_controller(cpathlink):
>> + =A0 =A0 print "Probing controller %s" % cpathlink
>> =A0 =A0 =A0 cpath =3D os.path.realpath(cpathlink)
>> =A0 =A0 =A0 if cpath in controllers:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return controllers[cpath]
>> @@ -186,6 +187,7 @@ def probe_controller(cpathlink):
>> =A0# controller.
>> =A0phydevs=3Ddict()
>> =A0def probe_device(devpathlink, nodestr):
>> + =A0 =A0 print "Probing device %s" % devpathlink
>> =A0 =A0 =A0 devpath =3D os.path.realpath(devpathlink)
>> =A0 =A0 =A0 if devpath in phydevs:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return phydevs[devpath]
>> @@ -214,6 +216,7 @@ def probe_device(devpathlink, nodestr):
>> =A0blockbyname=3Ddict()
>> =A0blockbynode=3Ddict()
>> =A0def probe_block(blocklink):
>> + =A0 =A0 print "Probing block %s" % blocklink
>> =A0 =A0 =A0 name=3Dblocklink.rsplit('/', 1)[-1]
>> =A0 =A0 =A0 if name in blockbyname:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return
>
> --
> Torbj=F8rn Skagestad
> Ide Til Produkt A/S
>
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
