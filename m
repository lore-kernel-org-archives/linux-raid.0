From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Why 4k native drives haven't arrived
Date: Sun, 12 Jan 2014 08:55:54 -0500
Message-ID: <yq1txd9nw2d.fsf@sermon.lab.mkp.net>
References: <38C8AAEB-811B-442F-BA80-1EFAF00BADB1@colorremedies.com>
	<6AACF77C-5D54-4ABF-AA2D-FC3F4F1E141C@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6AACF77C-5D54-4ABF-AA2D-FC3F4F1E141C@colorremedies.com> (Chris
	Murphy's message of "Sat, 11 Jan 2014 21:01:02 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Chris" == Chris Murphy <lists@colorremedies.com> writes:

Chris> Huh. Two more cases. All three involve USB enclosures. Bug or
Chris> feature?  

Feature.

Chris> Is it possible the enclosure's bridge chipset is disabling the
Chris> drive's 512-byte emulation?

There's nothing to disable. If the USB-SATA bridge exposes 4K logical
blocks to the host all accesses will inevitably be aligned multiples of
4K. All the bridge needs to do is adjust LBA and transfer length. Not
unlike how we handle 1/2/4Kn in the Linux SCSI disk driver given that
the block layer always uses 512-byte sectors.

The two 4Kn USB drives I have both use 512e drives internally:

# sg_readcap -l /dev/sdd | grep Logical
   Logical block length=4096 bytes
   Logical blocks per physical block exponent=0
# hdparm -I /dev/sdd | grep Sector 
        Logical  Sector size:                   512 bytes
        Physical Sector size:                  4096 bytes
        Logical Sector-0 offset:                  0 bytes

It is conceivable that there are other USB drives out there that
actually use 4Kn drives inside but I doubt it. All the 4Kn SATA drives I
have in the lab are engineering samples...

-- 
Martin K. Petersen	Oracle Linux Engineering
