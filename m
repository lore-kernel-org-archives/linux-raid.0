From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Determining which spindle is out of order
Date: Wed, 03 Nov 2010 14:43:03 +0000
Message-ID: <4CD174F7.6070904@anonymous.org.uk>
References: <loom.20101103T115828-494@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20101103T115828-494@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Nat Makarevitch <Shelso@makarevitch.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/11/2010 14:13, Nat Makarevitch wrote:
> Hi,
>
> After a spindle (physical hard disk, a "drive") failure in a "md" RAID array,
> how can we know which spindle must be replaced?
>
> We want to avoid extracting a working spindle by mistakenly thinking it is the
> faulty one...
>
> To solve this problem we put on each spindle a physical label (a tag, not a
> partition/disk label) showing its device name (sda, sdb...).
>
> To do so: on an otherwise unused system and sane RAID array we ran "dd" for each
> each spindle (individual device) in order to read on it, lighting up its LED.
>
> Then we simulated a crash by physically removing two spindles. Upon reboot the
> devices names changed (?!) and our labels weren't right anymore albeit we are
> pretty sure they were.
>
> Context: raid10, 10 spindles (8 active + 2 spare), layout : near=1, offset=3. On
> the integrated controller + a LSI MPT on-board controller.

That's right, drive letters sda sdb etc are allocated in the order 
they're discovered at boot time, so if you remove what used to be sdc 
and reboot, sdc will now refer to what used to be sdd, sdd to the old 
sde etc.

Have a look at /dev/disk/by-path, in there you'll find symlinks which 
will always have the same names, or indeed be missing, which point to 
sda, sdb etc. In my case I have SATA discs on an ICH10R controller, the 
controller is pci-0000:00:1f.2, it appears as up to 6 SCSI controllers 
numbered 0-5, and the discs appear as HBA 0, device 0, lun 0, along with 
their partitions, as follows:

pci-0000:00:1f.2-scsi-0:0:0:0 -> ../../sda
pci-0000:00:1f.2-scsi-0:0:0:0-part1 -> ../../sda1
pci-0000:00:1f.2-scsi-0:0:0:0-part2 -> ../../sda2
pci-0000:00:1f.2-scsi-1:0:0:0 -> ../../sdb
pci-0000:00:1f.2-scsi-1:0:0:0-part1 -> ../../sdb1
pci-0000:00:1f.2-scsi-1:0:0:0-part2 -> ../../sdb2
pci-0000:00:1f.2-scsi-2:0:0:0 -> ../../sdc
pci-0000:00:1f.2-scsi-2:0:0:0-part1 -> ../../sdc1
pci-0000:00:1f.2-scsi-2:0:0:0-part2 -> ../../sdc2
pci-0000:03:00.0-scsi-0:0:0:0 -> ../../scd0

Oh and the last one is a CD ROM drive on a pata_marvell IDE controller.

You might want to relabel your drives according to what you find in 
/dev/disk/by-path.

Cheers,

John.

