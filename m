From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Determining which spindle is out of order
Date: Sat, 6 Nov 2010 05:22:28 -0500
Message-ID: <30.2B.19545.E5C25DC4@cdptpa-omtalb.mail.rr.com>
References: <4CD1DA2E.5060205@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD1DA2E.5060205@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Phil Turmel' <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Phil Turmel
> Sent: Wednesday, November 03, 2010 4:55 PM
> To: Nat Makarevitch
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Determining which spindle is out of order
> 
> On 11/3/2010 2:13 PM, Nat Makarevitch wrote:
> > Hi,
> >
> > After a spindle (physical hard disk, a "drive") failure in a "md" RAID
> array,
> > how can we know which spindle must be replaced?
> >
> > We want to avoid extracting a working spindle by mistakenly thinking it
> is the
> > faulty one...
> 
> I wrote a little script that would tell me device name and serial number
> for each host port on my motherboard, along with anything else that lists
> a scsi host in sysfs.  Output like so:
> 
> Controller device @ pci0000:00/0000:00:1c.1/0000:06:00.0 [ahci]
>   RAID bus controller: Marvell Technology Group Ltd. 88SE6145 SATA II PCI-
> E controller (rev a1)
>     host4: [Empty]
>     host5: /dev/sdd ATA WDC WD5000AAKS-7 {SN: WD-WMAWF1370668}
>     host6: [Empty]
>     host7: [Empty]
>     host8: [Empty]
> Controller device @ pci0000:00/0000:00:1f.1 [ata_piix]
>   IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller
> (rev 01)
>     host9: [Empty]
>     host10: [Empty]
> Controller device @ pci0000:00/0000:00:1f.2 [ahci]
>   SATA controller: Intel Corporation 82801GR/GH (ICH7 Family) SATA AHCI
> Controller (rev 01)
>     host0: /dev/sda ATA ST31000333AS {SN: 9TE1LTW0}
>     host1: /dev/sdb ATA ST31000333AS {SN: 9TE1MAJT}
>     host2: /dev/sdc ATA ST31000333AS {SN: 9TE1MV1R}
>     host3: /dev/sr0 HL-DT-ST BD-RE GBW-H20L
> 
> Shows me my empty ports, too.  As long as I keep my cables straight to my
> hot-swap bays, getting the right drive is a snap.

	I haven't had a chance to dig into the script, but it doesn't
produce any output when I run it on one of my servers, and on the other one
it produces errors on line 7, but otherwise seems to work.

