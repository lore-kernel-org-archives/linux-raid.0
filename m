From: "David Lethe" <david@santools.com>
Subject: RE: Data integrity and RAID
Date: Tue, 9 Dec 2008 09:05:41 -0600
Message-ID: <A20315AE59B5C34585629E258D76A97C02F4710D@34093-C3-EVS3.exchange.rackspace.com>
References: <20841008.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20841008.post@talk.nabble.com>
Sender: linux-raid-owner@vger.kernel.org
To: "peter.stevens" <Peter.Stevens@gtech.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of peter.stevens
> Sent: Tuesday, December 09, 2008 8:03 AM
> To: linux-raid@vger.kernel.org
> Subject: Data integrity and RAID
> 
> 
> I'm looking for a software solution to help replace my existing raid
> hardware
> setup. The hardware mimics RAID-1 (in that it has 3 mirrors), except
> for the
> fact that on read all 3 mirrors are compared and possibly error
> corrected
> before data is returned. I don't neccessarily need a RAID-1 solution,
> it
> just seems closer to what I already have and also that it also can
> recover
> from 2 simulateous disk failures.
> 
> So far I've played with a software RAID-1 array of USB flash drives.
My
> issue is that software RAID-1 does not check for or recover from data
> corruption unless a read or write to disk actually fails. Integrity is
> a
> major concern for me, I need to know that all data going to and from
> disk is
> correct at all times.
> 
> All advice and comments are welcomed.
> --
> View this message in context:
http://www.nabble.com/Data-integrity-and-
> RAID-tp20841008p20841008.html
> Sent from the linux-raid mailing list archive at Nabble.com.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

A few things come to mind ...
1) Use Solaris w/ZFS instead of LINUX.   You can even put on target-mode
drivers and make this a SAN appliance or NAS box. Obviously this won't
work for you if you have application software you want to run on the
same machine, but just throwing it out.  ZFS supports n-Way mirroring.
2) Use disks that support BGMS.  This means late-generation Seagate SAS
disks (or SCSI or FC, just not SATA).  Then you can get software
(shameless plug here, but we have such a product for $90.) that runs
background media scans and repairs bad blocks 24x7 with near zero host
overhead.  Blocks that can't auto-repair will be reported, so you can
kick off a consistency repair once they are detected.  Many of the SATA
disks do have error detection/correction firmware, but their ability to
report specifics of problem and auto repair are extremely limited due to
fewer ECC bits and less sophisticated algorithms in the firmware).

Regards
David
david@santools.com







