From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Veliciraptor HDD 3.0gbps but UDMA/100 on PCI-e controller?
Date: Thu, 03 Jul 2008 11:19:20 -0500
Message-ID: <486CFC08.3000004@gmail.com>
References: <alpine.DEB.1.10.0807030447040.12072@p34.internal.lan> <486CCB12.7040205@garzik.org> <alpine.DEB.1.10.0807030941510.30458@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0807030941510.30458@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> 
> 
> On Thu, 3 Jul 2008, Jeff Garzik wrote:
> 
>> Justin Piszcz wrote:
> 
>> You need to show us the full dmesg.  We cannot see which controller is 
>> applying limits here.
>>
>> You need to look at the controller's maximum, as that controls the 
>> drive maximum (pasted from my personal workstation):
>>
>> scsi0 : ahci
>> scsi1 : ahci
>> scsi2 : ahci
>> scsi3 : ahci
>> ata1: SATA max UDMA/133 abar m1024@0x90404000 port 0x90404100 irq 507
>> ata2: SATA max UDMA/133 abar m1024@0x90404000 port 0x90404180 irq 507
>> ata3: SATA max UDMA/133 abar m1024@0x90404000 port 0x90404200 irq 507
>> ata4: SATA max UDMA/133 abar m1024@0x90404000 port 0x90404280 irq 507
>>
>>
>> scsi4 : sata_sil
>> scsi5 : sata_sil
>> scsi6 : sata_sil
>> scsi7 : sata_sil
>> ata5: SATA max UDMA/100 mmio m1024@0x9000c800 tf 0x9000c880 irq 17
>> ata6: SATA max UDMA/100 mmio m1024@0x9000c800 tf 0x9000c8c0 irq 17
>> ata7: SATA max UDMA/100 mmio m1024@0x9000c800 tf 0x9000ca80 irq 17
>> ata8: SATA max UDMA/100 mmio m1024@0x9000c800 tf 0x9000cac0 irq 17
>>
>>
>> See the UDMA difference?
>>
>>     Jeff
>>
> 
> So they are supposedly 3.0gbps SATA cards etc but why do they only have
> a maxiumum negotiated rate of UDMA/100?
> 
> [    9.623682] scsi8 : sata_sil24
> [    9.625622] scsi9 : sata_sil24
> [    9.626608] ata9: SATA max UDMA/100 host m128@0xe0204000 port 
> 0xe0200000 irq 19
> [    9.627539] ata10: SATA max UDMA/100 host m128@0xe0204000 port 
> 0xe0202000 irq 19
> 
> Also, another question:
> How come I can dd if=/dev/sda of=/dev/null (for pretty much all 6 HDD on 
> the
> mainboard itself (115MiB/s+) per drive.
> 
> But when I stop those and do the same thing for the other 6 drives on PCI-e
> x1 controllers (as shown in dmesg/previous lspci output) it does not
> give that great of speed?
> 
> Example:
> 
> (one veliciraptor)
> 
> p34:~# dd if=/dev/sdi of=/dev/null bs=1M
> procs -----------memory---------- ---swap-- -----io---- -system-- 
> ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy 
> id wa
>  0  1    160  45796 472120 5764072    0    0   249  1445  123   37  1  2 
> 95  2
>  0  1    160  47616 581944 5650376    0    0 109824     0  460 1705  0  
> 4 74 22
>  0  1    160  46236 692280 5540896    0    0 110336     0  555 2719  0  
> 4 74 22
>  0  1    160  46256 802616 5429316    0    0 110336    28  559 1961  0  
> 3 75 22
> 
> (two veliciraptors)
> p34:~# dd if=/dev/sdi of=/dev/null bs=1M
> p34:~# dd if=/dev/sdj of=/dev/null bs=1M
> 
> procs -----------memory---------- ---swap-- -----io---- -system-- 
> ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy 
> id wa
>  1  2    160  44664 2829936 3399360    0    0 141568     0  581 1925  0  
> 5 74 21
>  0  2    160  45748 2970480 3258068    0    0 140544     0  563 2155  0  
> 5 74 22
>  0  2    160  47308 3110512 3116780    0    0 140032    68  717 2440  0  
> 5 73 22
>  0  2    160  45976 3251568 2976972    0    0 141056     0  559 1837  0  
> 5 74 21
>  0  2    160  46860 3392624 2835240    0    0 141056     0  615 2452  0  
> 5 74 22
> 
> Is this a PCI-e bandwidth issue, a card issue or driver issue?
> 
> Each card has 2 ports on it and I can only get ~140MiB/s using two DDs.
> 
> -----------------
> 
> And the motherboard itself:
> 
> war@p34:~$ vmstat 1
> procs -----------memory---------- ---swap-- -----io---- -system-- 
> ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy 
> id wa
>  0  1    160  47820 4021464 2219716    0    0   262  1442  122   37  1  
> 2 95  2
>  0  1    160  43520 4144600 2102228    0    0 123136     0  490 1759  0  
> 4 74 22
>  0  1    160  47244 4259032 1985600    0    0 114432     0  514 2293  0  
> 3 74 23
>  0  1    160  43696 4383348 1866868    0    0 124416     0  512 1707  0  
> 4 74 22
> 
> Two veliciraptors:
>  0  2    160  59988 5229656 1016484    0    0 125184     0 2041 2220  0  
> 5 49 46
>  0  3    160 273784 5371840 665372    0    0 142184     0 1946 2316  0  
> 6 49 46
>  1  3    160  45364 5612864 647376    0    0 241024     0 2422 3719  0  
> 7 50 43
>  1  1    160  45536 5858476 402584    0    0 245632     0 2199 3205  0  
> 9 53 39
>  1  1    160  45192 6034316 227940    0    0 220928    32 1485 4095  0  
> 7 72 21
> 
> Three veliciraptors:
>  2  2    160  44900 6168900 144008    0    0 364032     0 1448 4349  0 
> 14 66 20
>  1  2    160  46488 6206828 112312    0    0 369152     0 1457 4776  0 
> 14 67 19
>  1  3    160  44700 6226924 101916    0    0 337920    65 1420 4099  0 
> 12 68 20
>  0  3    160  47664 6232840 101776    0    0 363520     0 1425 4507  0 
> 14 67 20
> 
> .. and so on ..
> 
> Why do I get such poor performance when utilizing more than 1 drive on a 
> PCI-e
> x1 card, it cannot even achieve more ~150MiB/s when two drives are being
> read con-currently?
> 
> Ideas?
> 

Well, given that pcie x1 is max 250MB/second, and a number of pcie cards are not 
native (they have a pcie to pci converter between them), "dmidecode -vvv" will 
give you more details on the actual layout of things, and given that I have seen 
several devices actually run slower by having the ability to oversubscribe the 
bandwidth that is available and seemingly actually run slower because of this 
ability, that may have some bearing,    Ie 2 slower disks may be faster than 2 
fast disks on the pcie just because they don't oversubscribe the interfere. And 
given that if there is a pci converter that may lower the overall bandwidth even 
more, and cause the issue.   If this was old style ethernet I would have though 
collisions, but it must just come down to the arbitration setups not being 
carefully designed for high utilization, and high interference between devices.

                                Roger

