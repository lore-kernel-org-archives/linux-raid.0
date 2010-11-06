From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Determining which spindle is out of order
Date: Sat, 6 Nov 2010 15:16:09 -0500
Message-ID: <2E.A4.19545.487B5DC4@cdptpa-omtalb.mail.rr.com>
References: <4CD5AEDE.50501@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD5AEDE.50501@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Phil Turmel' <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Phil Turmel
> Sent: Saturday, November 06, 2010 2:39 PM
> To: Jan Ceuleers
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Determining which spindle is out of order
> 
> On 11/06/2010 12:45 PM, Jan Ceuleers wrote:
> > On 06/11/10 17:02, Phil Turmel wrote:
> >> Indeed.  The sysfs layout changed since kernel 2.6.18.  I'm guessing
> the use of
> >> CONFIG_SYSFS_DEPRECATED and/or CONFIG_SYSFS_DEPRECATED_V2 will
> interfere with my
> >> script in current kernels.
> >
> > Nice.
> >
> > Output on one of my machines is however not as expected:
> >
> > Controller device @ pci0000:00/0000:00:1c.1/0000:02:00.0 [ahci]
> >   SATA controller: JMicron Technology Corp. JMB360 AHCI Controller (rev
> 02)
> >     host4: [Empty]
> > Controller device @ pci0000:00/0000:00:1f.2 [ata_piix]
> >   IDE interface: Intel Corporation 5 Series/3400 Series Chipset 4 port
> SATA IDE Controller (rev 06)
> >     host0: /dev/sda ATA WDC WD20EADS-00R {SN: WD-WCAVY4080404}
> >     host1: /dev/sdb ATA ST3500418AS {SN: 9VMK33L9}
> >     host1: /dev/sdc ATA ST3500418AS {SN: 9VMM6EY4}
> > Controller device @ pci0000:00/0000:00:1f.5 [ata_piix]
> >   IDE interface: Intel Corporation 5 Series/3400 Series Chipset 2 port
> SATA IDE Controller (rev 06)
> >     host2: [Empty]
> >     host3: [Empty]
> >
> > This machine has seven SATA ports: one provided by the JMicron chip, the
> other six by the Intel H55 south bridge. Only three ports are currently
> used, but I had expected another [Empty] entry.
> >
> > Here's what's in /sys/devices:
> >
> > root@zotac:~# find /sys/devices/ -name scsi_host
> > /sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/host4/scsi_host
> > /sys/devices/pci0000:00/0000:00:1f.2/host0/scsi_host
> > /sys/devices/pci0000:00/0000:00:1f.2/host1/scsi_host
> > /sys/devices/pci0000:00/0000:00:1f.5/host2/scsi_host
> > /sys/devices/pci0000:00/0000:00:1f.5/host3/scsi_host
> >
> > Not sure what to make of that...
> 
> I'm guessing it's an artifact of IDE compatibility mode.  You can see
> host1 reports two drives, and my script is only expecting one.  Master vs.
> slave emulation, perhaps?  Can you check your BIOS for legacy IDE vs. AHCI
> mode setting?
> 
> I suspect my script will have similar problems with port multipliers.

	Both of my servers employ PMs, and it's working on one of them.
Actually, it's working on the PMs, but not the boot drives, which are hosted
off the motherboard.  They are IDE, so that's not too surprising.

Controller device @ pci0000:00/0000:00:02.0/0000:02:00.0/0000:03:00.0
[sata_sil24]
  Mass storage controller: Silicon Image, Inc. SiI 3124 PCI-X Serial ATA
Controller (rev 02)
    host5: /dev/sda ATA WDC WD15EADS-00R {SN: WD-WCAVY0111608}
    host5: /dev/sdb ATA WDC WD15EADS-00R {SN: WD-WCAVY0123958}
    host5: /dev/sdc ATA WDC WD15EADS-00R {SN: WD-WCAUP0013905}
    host5: /dev/sdd ATA WDC WD15EADS-00P {SN: WD-WMAVU1944127}
    host7: /dev/sde ATA WDC WD15EARS-00Z {SN: WD-WMAVU2315499}
    host7: /dev/sdf ATA WDC WD15EARS-00Z {SN: WD-WMAVU1169621}
    host7: /dev/sdg ATA WDC WD15EARS-00Z {SN: WD-WMAVU1313973}
    host7: /dev/sdh ATA WDC WD15EADS-00P {SN: WD-WCAVU0303989}
    host9: /dev/sdi ATA WDC WD15EADS-00P {SN: WD-WMAVU1822645}
    host9: /dev/sdj ATA WDC WD15EARS-00Z {SN: WD-WMAVU2904844}
    host10: [Empty]
Controller device @ pci0000:00/0000:00:11.0 [ahci]
  SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller [IDE
mode]
    host0: [Empty]
    host1: [Empty]
    host2: [Empty]
    host3: [Empty]
Controller device @ pci0000:00/0000:00:14.4/0000:06:06.0 [sata_via]
  RAID bus controller: VIA Technologies, Inc. VT6421 IDE RAID Controller
(rev 50)
    host4: [Empty]
    host6: [Empty]
    host8: /dev/sr0 LITE-ON DVD SOHD-167T

