From: =?ISO-8859-1?Q?Johan_Sch=F6n?= <johan.schon@visiarc.com>
Subject: Re: Disks keep disapearing
Date: Sat, 10 May 2003 18:47:40 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EBD2D2C.1050900@visiarc.com>
References: <Pine.GSO.4.30.0305091654350.23888-100000@multivac.sdsc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.30.0305091654350.23888-100000@multivac.sdsc.edu>
To: "Peter L. Ashford" <ashford@sdsc.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter L. Ashford wrote:
> WD has had problems similar to this with many of their drives.  It ju=
st
> decides to 'go away'.  There is a fix available on their web site for=
 the
> 180GB and 200GB drives (and a better description of the problem), but=
 the
> problem is NOT limited to those drives.

How do these problem appear in log files?

I have a machine with two Promise Ultra100 TX2 cards, and five
WD2000JB 200 GB drives in RAID-5. In a month, i've had a few disk "fail=
ures"
that typically looks like this in the logs:

|hdg: dma_intr: status=3D0x63 { DriveReady DeviceFault Index Error }
|hdg: dma_intr: error=3D0x04 { DriveStatusError }
|hdg: DMA disabled
|hdh: DMA disabled
|PDC202XX: Secondary channel reset.
|ide3: reset: success
|hdg: irq timeout: status=3D0xd2 { Busy }
|
|PDC202XX: Secondary channel reset.
|ide3: reset: success
|hdg: irq timeout: status=3D0xd2 { Busy }
|
|end_request: I/O error, dev 22:00 (hdg), sector 280277504
|raid5: Disk failure on hdg, disabling device. Operation continuing on =
4 devices
|hdg: status timeout: status=3D0xd2 { Busy }
|
|PDC202XX: Secondary channel reset.
|hdg: drive not ready for command
|md: updating md0 RAID superblock on device
|md: hdh [events: 00000007]<6>(write) hdh's sb offset: 195360896
|md: recovery thread got woken up ...
|md0: no spare disk to reconstruct array! -- continuing in degraded mod=
e
|ide3: reset: success
|md: (skipping faulty hdg )
|md: hdf [events: 00000007]<6>(write) hdf's sb offset: 195360896
|md: hde [events: 00000007]<6>(write) hde's sb offset: 195360896
|md: hdb [events: 00000007]<6>(write) hdb's sb offset: 195360896
|hdg: irq timeout: status=3D0xd2 { Busy }

The disk itself doesn't appear to know about any failures
(using smartctl), and it works again when hotadded to the raidset. I've
also had a multiple drive "failure" twice, both times with two drives
using the same IDE channel.

I'm not sure if these problems are caused by buggy Promise ATA drivers
in my kernel (RH9, 2.4.20) or the WDC problem with 180/200 GB drives.
 From WDC's description of the problem, I got the impression that it
only happened when the drives were connected to hardware RAID cards
like 3Ware IDE raid controllers.

Can anyone advise?

  // Johan

--=20
Johan Sch=F6n                             www.visiarc.com
VISIARC AB                         Cell: +46-708-343002

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
