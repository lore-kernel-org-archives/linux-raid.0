From: Michael Barnwell <xterminate@xterminate.me.uk>
Subject: Re: Silent Corruption on RAID5
Date: Sun, 22 Jan 2006 20:58:15 +0000
Message-ID: <43D3F1E7.2090501@xterminate.me.uk>
References: <43D3B675.20804@xterminate.me.uk> <200601221342.15264.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200601221342.15264.mlaks@verizon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Mitchell Laks <mlaks@verizon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Mitchell Laks wrote:
> On Sunday 22 January 2006 11:44 am, Michael Barnwell wrote:
>> Hi,
>>
>> I'm experiencing silent data corruption on my RAID 5 set of four 400GB
>> SATA disks.
> 
>> dd bs=1024 count=10000k if=/dev/zero of=./10GB.tst
>> od -t x1 s0/10GB.tst
>>
>> These commands give me one row of zeros on my other RAID 5 set on the
> 
>> I'm running Debian sarge with a 2.6.15-1 kernel, it has an Athlon
>> XP2200, 1GB of RAM, Asus A7N8X-Deluxe motherboard, 2 Maxtor IDE
>> controllers, one Silicon Image 3114 PCI adapter, along with the on-board
>> Silicon Image 3112 controller - 2x 10GB IDE disks and a DVD ROM drive on
>> the on-board IDE controller, 3x 120GB Seagate hard disks on the PCI IDE
>> adapters, 2x 80GB Seagate disks on the on-board SilImg 3112 controller
>> and finally 4x 400GB disks on the SilImg 3114 PCI adapter.
>>
> 
> Dear Michael,
> 
> If you look at  my recent post and the response from David Greaves, I suspect 
> it is because  of the presence of multiple diffferent SATA controllers. 

I just tried disabling the on-board SATA controller via the jumper on 
the motherboard and then recreating the array and file system and the 
problem happened again.

> Could you make a try of running  your test with ONLY the SilImg 3114 adapter 
> populated with disks. Also I am not aware if the 3112 and 3114 use different 
> kernel modules, make sure the  other one is not loaded. 

They use the same module.

> I ran your test on my raid1 system with the debian SID 2.6.15 kernel and ran 
> the test on both motherboard sata_via and pci card sata_promise controlled 
> raid devices (i have raid1 though) and had no problem.
> 
> I could only run od -t x1 10GB.tst.
>  what is the "s0 " for? 
> I tried s0 or -s0 and the machine didnt accept that switch for od.
> 
> od -t x1 -s0 10GB.tst 
> "od: no type may be specified when dumping strings"

That was a copy and paste error, its just od -t x1 10GB.tst

> For what its worth, on my system the Promise controller wipes out the 
> via VT8237 onboard controller. You seem to have the opposite problem.

I tried a BIOS update this morning because it updated the SATA BIOS on 
the on-board card and allowed me to see both of them during the booting 
section (the PCI one finds drives and lets me access the SilImg BIOS 
then the on-board one does the same).

> I am afraid that SATA controllers may  not yet be stable enough for 
> production.

Are other chipsets better supported?

> Mitchell Laks
> 
<snip>

Thanks,

Michael Barnwell.
