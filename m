From: "Jan Reiter" <The-Fallen@gmx.net>
Subject: Promise sx4100 (PDC20621) with sata_sx4
Date: Mon, 28 Nov 2005 04:49:16 +0100 (MET)
Message-ID: <25538.1133149756@www72.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, I have some trouble with my Promise fasttrak sx4100 SATA-RAID
Controller with 64MB ECC SDRAM and a PDC20621 PCI Controller Card.

First of all: The Hardware is okay! I tested it successfull under all RAID
modes with windows in exactly that system configuration.

But I'm using this machine as a server and therefor with debian 3.1 and
(originally) kernel 2.6.8-2-686. First I tried to use the partial source
code from the promise homepage. No-Go. So I updatet to kernel 2.6.14 and
when it still refused to work to 2.6.15-rc2. Same problem here. The driver
detects the hardware and then crashes with a kernel Ooooops.
After some playing around with that partial source I was able to trace the
problem to some of the export functions.

unsigned  long DeviceID = pOSDExtension->ControllerInfo.DeviceID;
unsigned  long SubDeviceID = pOSDExtension->ControllerInfo.SubDeviceID;
MEMORY_REQUIREMENT compRequirement;

IComp[CompIndex].COMP_GET_DMA_REQUIREMENT(DeviceID, SubDeviceID,
&compRequirement);

for example creates the following error:
Unable to handle kernel NULL pointer dereference at virtual address .... 
the function is defined as follows:
void (*COMP_GET_DMA_REQUIREMENT)(U32, U32, bpMEMORY_REQUIREMENT);

But some other exports like 
void (*COMP_GET_EXT_REQUIREMENT)(bpMEMORY_REQUIREMENT);
work just fine. I don't know what to make of it. 

After a lot of uncommenting and inserting fake-values I gave up on this one.

so I took a look at the sata_sx4 part of the libata. Just loadig didn't do
the job. The problem was obvious. It didb't recocnize my card. so I changed
the 0x6622 pci table entry in sata_sx4.c to 0x6624 to fit my board. (yes, I
know the risks of doing so) 
Everything seemed to work out fine at first. it detected the board, the
dimm, and the harddisks attached to it. but instead of one device, it shows
every single harddrive. sdc till sde. hm. so for testing I configured the
controller to hold all three disks as JBOD. Same picture (as expectet this
time), but there is always a command timeout when trying to communicate with
the harddrives. fdisk and parted crash wen trying to read the partition
table. Same thing when writing a new one. 

It runs into pdc_eng_timeout() with qc->tf.protocol set to ATA_PROT_DMA.

So, has anyone an idea how to get this controler work with linux??? Even as
JBOD would be okay for now. 

Thank You!

TheFallen

-- 
Telefonieren Sie schon oder sparen Sie noch?
NEU: GMX Phone_Flat http://www.gmx.net/de/go/telefonie
