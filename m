From: Robert L Mathews <lists@tigertech.com>
Subject: Re: RAID 1 failure on single disk causes disk subsystem to lock up
Date: Mon, 31 Mar 2008 10:27:46 -0700
Message-ID: <47F11F12.7010309@tigertech.com>
References: <47F020C6.1060809@tigertech.com> <47F0281F.1070404@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47F0281F.1070404@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Maurice Hilarius wrote:

> How old are the controllers/motherboards?
> 
> Is the controller ON the motherboard?

They're SuperMicro 6013A-T servers with this motherboard:

  http://www.supermicro.com/products/motherboard/Xeon/E7501/X5DPA-TGM+.cfm

It appears to use an "Adaptec ICH5R SATA controller" on the motherboard 
(there's no separate SATA card or anything like that). Although that 
controller apparently has an optional RAID feature, I'm not using it; 
it's just in standard JBOD mode.


> What you describe sounds suspiciously like an IDE to SATA bridge chip.
> Or, in other words, ATA behaviour.

Here's part of the output from "lshw" on one of these machines:

  *-ide:1
         description: IDE interface
         product: 82801EB (ICH5) Serial ATA 150 Storage Controller
         vendor: Intel Corp.
         physical id: 1f.2
         bus info: pci@00:1f.2
         logical name: scsi0
         logical name: scsi1
         version: 02
         width: 32 bits
         clock: 66MHz
         capabilities: ide bus_master emulated scsi-host
         configuration: driver=ata_piix
         resources: ioport:ec00-ec07 ioport:e800-e803 ioport:e400-e407 
ioport:e000-e003 ioport:dc00-dc0f irq:185
     *-disk:0
         description: SCSI Disk
         product: Maxtor 7H500F0
         vendor: ATA
         physical id: 0
         bus info: scsi@0.0:0.0
         logical name: /dev/sda
         version: HA43
         size: 465GB
         configuration: ansiversion=5
     *-disk:1
         description: SCSI Disk
         product: SAMSUNG HD501LJ
         vendor: ATA
         physical id: 1
         bus info: scsi@1.0:0.0
         logical name: /dev/sdb
         version: CR10
         size: 465GB
         configuration: ansiversion=5

I do see that both disks are under "ide:1". Is that what you mean?


> This is not something from mdadm, anyway.
> Once the disk "dies" you are losing the disk bus, and that is "all she 
> wrote".

So mdadm can't protect against disk failures on these machines? Whenever 
a disk returns a write error, the machine will lock up?

-- 
Robert L Mathews

  "In the beginning, the universe was created. This has made a lot of
   people very angry and has been widely regarded as a bad move."
                                                    -- Douglas Adams
