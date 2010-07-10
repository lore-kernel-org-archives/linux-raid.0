From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: mapping ataXX.YY to a /dev/sdX
Date: Sat, 10 Jul 2010 09:05:40 +0200
Message-ID: <4C381BC4.9040903@grumpydevil.homelinux.org>
References: <alpine.DEB.1.10.1007070810540.23489@uplift.swm.pp.se> <87wrt7ijp3.fsf@rimspace.net> <alpine.DEB.1.10.1007071749320.23489@uplift.swm.pp.se> <4C35A2FC.5080402@buttersideup.com> <alpine.DEB.1.10.1007081214590.23489@uplift.swm.pp.se> <20100708104422.GA32564@cthulhu.home.robinhill.me.uk> <alpine.DEB.1.10.1007081259560.23489@uplift.swm.pp.se> <20100708232631.014a5ade@atak.bl.pg.gda.pl> <alpine.DEB.1.10.1007082348190.23489@uplift.swm.pp.se> <4C37FA32.8020008@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4C37FA32.8020008@wasp.net.au>
Sender: linux-ide-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Brad Campbell wrote:
> On 09/07/10 05:53, Mikael Abrahamsson wrote:
>
>> I never really had a huge problem figuring out with high probability
>> which drive it was, but I wanted to know if there was a 100% certain way
>> of doing it. Seems there is not, am I the only one who is looking for
>> this functionality? I would think this is a fairly common problem?
>
> Certainty would be nice, but in practice here I've always found that 
> ataX = sdX+1 and I've relied on that mapping to always be constant. 
> I've not yet found it otherwise, but I guess it's possible. I'd assume 
> the libata guys should be able to provide a definite comment on that.
>
> I've got no lights on my arrays, so it's even harder to identify which 
> drive is which when you need to swap one out live. I've resorted to 
> keeping a log of which serial number is in which physical slot, so I 
> can look up the serial number of the failing drive with hdparm and I 
> know I've got the right one. Again, it still hinges on the ata-sd 
> mapping being constant. (it also relies on me updating the log when I 
> swap a disk)
>
> Brad
Judging from my dmesg and lsscsi on a system with both scsi and SATA, 
ataX translates into scsi X:0:0:0

example dmesg output:
[    3.901035] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.937046] ata10.00: ATA-7: WDC WD7500AAKS-00RBA0, 30.04G30, max 
UDMA/133
[    3.948794] ata10.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 
31/32)
[    3.969065] ata10.00: configured for UDMA/133
[    3.980847] scsi 10:0:0:0: Direct-Access     ATA      WDC 
WD7500AAKS-0 30.0 PQ: 0 ANSI: 5
[    3.993120] sd 10:0:0:0: [sdf] 1465149168 512-byte hardware sectors: 
(750 GB/698 GiB)
[    4.005586] sd 10:0:0:0: [sdf] Write Protect is off
[    4.017936] sd 10:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    4.017959] sd 10:0:0:0: [sdf] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA

and the lsscsi output:
[0:2:0:0]    disk    LSI      MegaRAID 8344ELP 1.12  /dev/sda
[0:2:1:0]    disk    LSI      MegaRAID 8344ELP 1.12  /dev/sdb
[5:0:1:0]    cd/dvd  MATSHITA DVD-ROM UJDA780  1.50  /dev/sr0
[7:0:0:0]    disk    ATA      SAMSUNG HD154UI  1AG0  /dev/sdm
[8:0:0:0]    disk    ATA      SAMSUNG HD154UI  1AG0  /dev/sdl
[9:0:0:0]    disk    ATA      SAMSUNG HD154UI  1AG0  /dev/sdo
[10:0:0:0]   disk    ATA      SAMSUNG HD154UI  1AG0  /dev/sdn
[11:0:0:0]   disk    ATA      SAMSUNG HD103SJ  1AJ1  /dev/sdk
[12:0:0:0]   disk    ATA      Hitachi HDT72101 ST6O  /dev/sdh
[13:0:0:0]   disk    ATA      Hitachi HDT72101 ST6O  /dev/sdi
[14:0:0:0]   disk    ATA      Hitachi HDT72101 ST6O  /dev/sdj



Cheers,


Rudy
