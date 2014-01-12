From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Why 4k native drives haven't arrived
Date: Sun, 12 Jan 2014 12:41:29 -0600
Message-ID: <52D2E1D9.3030303@hardwarefreak.com>
References: <38C8AAEB-811B-442F-BA80-1EFAF00BADB1@colorremedies.com>	<6AACF77C-5D54-4ABF-AA2D-FC3F4F1E141C@colorremedies.com> <yq1txd9nw2d.fsf@sermon.lab.mkp.net>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1txd9nw2d.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Murphy <lists@colorremedies.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/12/2014 7:55 AM, Martin K. Petersen wrote:
>>>>>> "Chris" == Chris Murphy <lists@colorremedies.com> writes:
> 
> Chris> Huh. Two more cases. All three involve USB enclosures. Bug or
> Chris> feature?  
> 
> Feature.
> 
> Chris> Is it possible the enclosure's bridge chipset is disabling the
> Chris> drive's 512-byte emulation?
> 
> There's nothing to disable. If the USB-SATA bridge exposes 4K logical
> blocks to the host all accesses will inevitably be aligned multiples of
> 4K. All the bridge needs to do is adjust LBA and transfer length. Not
> unlike how we handle 1/2/4Kn in the Linux SCSI disk driver given that
> the block layer always uses 512-byte sectors.
> 
> The two 4Kn USB drives I have both use 512e drives internally:
> 
> # sg_readcap -l /dev/sdd | grep Logical
>    Logical block length=4096 bytes
>    Logical blocks per physical block exponent=0
> # hdparm -I /dev/sdd | grep Sector 
>         Logical  Sector size:                   512 bytes
>         Physical Sector size:                  4096 bytes
>         Logical Sector-0 offset:                  0 bytes
> 
> It is conceivable that there are other USB drives out there that
> actually use 4Kn drives inside but I doubt it. All the 4Kn SATA drives I
> have in the lab are engineering samples...

The user reported 4096B logical sector size with the drive in the USB
enclosure.  He then directly connected to a mobo SATA port and saw 512B
logical sector size.

It seems pretty cut and dried that his USB-SATA bridge firmware was
incorrectly passing the 4096B physical sector size of a 512e drive, as
the logical sector size, to the host.

While this isn't the expected behavior, if the host OS can deal with
4096B sectors, as Linux can, it seems there may actually be some
advantage to this, as it would prevent 512B/RMW misalignment if
partitioning the drive.  As always, if one directly formats the drive
with a filesystem it makes no difference what sector size is reported.

-- 
Stan
