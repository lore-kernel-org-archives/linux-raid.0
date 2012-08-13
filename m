From: Jonathan Tripathy <jonnyt@abpni.co.uk>
Subject: Re: Disk Order
Date: Mon, 13 Aug 2012 01:04:37 +0100
Message-ID: <50284495.2030004@abpni.co.uk>
References: <50281BB1.6030309@abpni.co.uk> <502842D7.40005@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <502842D7.40005@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> No, MD uses the order they were specified in the "--create" operation,
> and records that in metadata on each device.  Re-assembly can specify
> them in any order--MD will put them into the correct role.
>
>
Thanks for this. So basically, the naming of the device is only 
important at the time of creating the array (as that defines the 
layout). As soon as I create the array, mdadm puts it's own metadata on 
the drive so it can identify them afterwards? That sounds very good indeed.


Now, onto the topic of PCIe adapter. I was looking at this: 
http://www.cclonline.com/product/42541/PEXSAT32/IDE-SATA-SCSI-Cards/StarTech-2-Port-SATA-6-Gbps-PCI-Express-SATA-Controller-Card/CNT1075/

Is that a bad model? Seems a little on the cheap side? Can anyone 
suggest a good model?

Many Thanks for all the help
