From: Phil Turmel <philip@turmel.org>
Subject: Re: Storage device enumeration script
Date: Thu, 26 May 2011 14:22:25 -0400
Message-ID: <4DDE9A61.2070201@turmel.org>
References: <4DDDC301.7090608@turmel.org>	<1306403130.9437.109.camel@torbjorn>	<4DDE3BF1.7030105@turmel.org>	<4DDE9213.2070508@turmel.org>	<20110526235415.584ae2e2@natsu>	<4DDE95C1.5030401@turmel.org> <20110527001235.2b47572e@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110527001235.2b47572e@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: =?ISO-8859-1?Q?Torbj=F8rn_Skagestad?= <torbjorn@itpas.no>, linux-raid@vger.kernel.org, Roman Mamedov <roman@rm.pp.ru>, John Robinson <john.robinson@anonymous.org.uk>, CoolCold <coolthecold@gmail.com>, =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
List-Id: linux-raid.ids

On 05/26/2011 02:12 PM, Roman Mamedov wrote:
[...]
> Now it locks up with 100% CPU load and no output, I waited for a couple of
> minutes. On Ctrl-C:
> 
> ^CTraceback (most recent call last):
>   File "./lsdrv", line 274, in <module>
>     probe_block('/sys/block/'+x)
> 
> $ ls /sys/block/
> etherd!e1.5  etherd!e2.1  md0  md2  sda  sdc  sde  sdg
> etherd!e1.6  fd0          md1  md4  sdb  sdd  sdf
> 
> The first two devices are actually down at this moment, maybe that's the
> reason? Still I'd expect not 100% CPU load by lsdrv, but 0% CPU and 100%
> iowait in this case.

Sounds like an infinite loop, or infinite recursion.  Could you apply the temporary patch below so I can see how far the probing got?

> Output of the old (bash) lsdrv:
> 
> Controller device @ pci0000:00/0000:00:06.0 [pata_amd]
>   IDE interface: nVidia Corporation CK804 IDE (rev f2)
>     host8: [Empty]
>     host9: [Empty]
> Controller device @ pci0000:00/0000:00:07.0 [sata_nv]
>   IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
>     host6: /dev/sdd ATA Hitachi HDS5C302 {SN: ..............}
>     host7: /dev/sde ATA WDC WD15EADS-00S {SN: ..............}
> Controller device @ pci0000:00/0000:00:08.0 [sata_nv]
>   IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
>     host10: /dev/sdf ATA WDC WD20EADS-00S {SN: ..............}
>     host11: /dev/sdg ATA WDC WD20EADS-00S {SN: ..............}
> Controller device @ pci0000:00/0000:00:0d.0/0000:02:00.0 [ahci]
>   SATA controller: Marvell Technology Group Ltd. 88SE9123 PCIe SATA 6.0 Gb/s
> controller (rev 10) host4: /dev/sdc ATA Hitachi HDS5C302 {SN: ..............}
>     host5: [Empty]
> Controller device @ pci0000:00/0000:00:0e.0/0000:01:00.0 [sata_mv]
>   SCSI storage controller: Marvell Technology Group Ltd. 88SX7042 PCI-e 4-port
> SATA-II (rev 02) host0: [Empty]
>     host1: [Empty]
>     host2: /dev/sda ATA ST31000528AS {SN: ..............}
>     host3: /dev/sdb ATA Hitachi HDS72202 {SN: ..............}

The old code never attempted to recurse into the layers of block devices, so it can't have recursion problems.

Phil

8<-------------------------

diff --git a/lsdrv b/lsdrv
index d1caaf8..37728c1 100755
--- a/lsdrv
+++ b/lsdrv
@@ -145,6 +145,7 @@ def sect2size(sectors):
 # the struct object w/ filled in details.
 controllers=dict()
 def probe_controller(cpathlink):
+	print "Probing controller %s" % cpathlink
 	cpath = os.path.realpath(cpathlink)
 	if cpath in controllers:
 		return controllers[cpath]
@@ -186,6 +187,7 @@ def probe_controller(cpathlink):
 # controller.
 phydevs=dict()
 def probe_device(devpathlink, nodestr):
+	print "Probing device %s" % devpathlink
 	devpath = os.path.realpath(devpathlink)
 	if devpath in phydevs:
 		return phydevs[devpath]
@@ -214,6 +216,7 @@ def probe_device(devpathlink, nodestr):
 blockbyname=dict()
 blockbynode=dict()
 def probe_block(blocklink):
+	print "Probing block %s" % blocklink
 	name=blocklink.rsplit('/', 1)[-1]
 	if name in blockbyname:
 		return
