From: Gordon Henderson <gordon@drogon.net>
Subject: Re: 4 questions. Chieftec chassis case CA-01B, resync times, selecting
 ide driver module loading,  raid5 :2 drives on same ide channel
Date: Sun, 16 Jan 2005 17:53:15 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0501161739170.21510@lion.drogon.net>
References: <crmt7e$8d6$1@sea.gmane.org> <Pine.LNX.4.56.0501101634250.17714@lion.drogon.net>
 <200501101810.49798.maarten@ultratux.net> <200501161119.41349.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501161119.41349.mlaks@verizon.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 16 Jan 2005, Mitchell Laks wrote:

> 3) Also, i have a module driver question.
> I use a asus K8V-X motherboard. It has sata and parallel ide channels. I use
> the sata for my system and use the  parallel for data storage on ide raid.
> I am using  combining the 2 motherboard IDE cable channels with highpoint
> rocket133 cards to provide 2 more ide ata channels.
>
> I installed debian and it defaulted to using the hpt366 modules for the
> rocket133 controllers.

I've just been down this road myself... Debian Woody, kernels 2.4 and 2.6
and a Highpoint rocket133 controller...

> I suspect (correct me if I am wrong) that the hpt302 on the highpoint website
> is the RIGHT module to use (I notice for instance that when I compare the
> hdparm settings on the western digital drives on the motherboard ide channels
> are set with more advanced dma settings "turned on" than   on the rocket133
> controllers. Perhaps this is because it is using the 'incorrect hpt366'
> module?

Using the module off their web site worked for me with kernel 2.4.28 - but
it turned my IDE drives into SCSI drives! No real issue, but the smart
drive termperature program stopped working...

The driver wouldn't compile with 2.6.10, but the hpt366 driver did work
under 2.6.10 and seems to work very well - and the drives still look like
IDE drives and hddtemp still works.

> Of course I would prefer to use the hpt302 module (after i compile
> it...). So

Would you? The 366 driver in 2.6.10 recognises that it's a 302 card and
seems to work well... dmesg output:

HPT302: IDE controller at PCI slot 0000:00:0a.0
HPT302: chipset revision 1
HPT37X: using 33MHz PCI clock
HPT302: 100% native mode on irq 18
    ide2: BM-DMA at 0x9800-0x9807, BIOS settings: hde:DMA, hdf:pio
    ide3: BM-DMA at 0x9808-0x980f, BIOS settings: hdg:DMA, hdh:pio
Probing IDE interface ide2...
hde: Maxtor 6Y080L0, ATA DISK drive
ide2 at 0xb000-0xb007,0xa802 on irq 18
Probing IDE interface ide3...
hdg: Maxtor 6Y080L0, ATA DISK drive
ide3 at 0xa400-0xa407,0xa002 on irq 18

I have it compiled into the kernel here too - not a module. (personal
choice, I never have modules unless I can avoid it)


> how do I get to insure that the system will use the hpt302 over the hpt366
> that it seems to be chosing. If I
> 1) compile the module hpt302 from source
> 2) dump it in the /lib/modules/2.6.9-1-386/kernel/drivers/ide/pci directory
> 3) put a line hpt302 in the /etc/modules file (maybe at the top?)
> 4) put a line hpt302 at  the top of the file /etc/mkinitd/modules.
> 5) run mkinitrd to generate the new initrd.img

The easiest way would be to compile a custom kernel yourself. Just leave
out the Highpoint drivers and then compile and load the hpt302 module at
boot time by listing it in the /etc/modules file.

> 4) Maarten mentioned that he had a problem with 2 different drives on
> the same channel for raid5. What was the problem exactly with that.

It's possible that a failing IDE drive will crowbar the bus and take out
the other drive with it - not neccessarily damage any data on the drive,
but prevent it being seen by the OS. I've experienced this myself. In a
RIAD-5 situation, you'd lose 2 drives which would not be a good thing..

Gordon
