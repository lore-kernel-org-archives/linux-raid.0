From: "Cal Webster" <cwebster@ec.rr.com>
Subject: RE: Move md raid5 from intel to sparc?
Date: Wed, 11 Jun 2003 14:24:02 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <NDBBIAKEEKGGEIKCBKNAOELLDIAA.cwebster@ec.rr.com>
References: <3EE74472.9010505@geodev.com>
Reply-To: <cwebster@ec.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EE74472.9010505@geodev.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'd be interested in how to get RAID5 to "swing both ways", from Sparc to
Intel and back to Sparc with minimal disruption in service.

I've got an Ultra II running Aurora Linux which was recently raised from the
dead after a case of heat stroke. During the time it was down I attempted to
connect it to an Intel machine running RedHat Linux, both running 2.4
kernels. As expected, it came up with errors.

The logs showed that the raid superblock didn't match the device names on
the new system (i.e /dev/sda1 became /dev/sdd1). To fix this I knew I'd have
to edit the RAID table using "mdadm". I was sure I could do this since I've
done it before when I setup the raid. What I wasn't sure about was whether
the Intel kernel could read the Sun disk labels and use them as is. Since I
wasn't able to get a good backup of the RAID prior to the failure, I didn't
want to chance corrupting the disk labels.

Now that our Sparc is back on-line, I'd like to get a procedure in place to
allow connecting the RAID to an Intel Linux machine in case our Sparc is
stricken with another case of SIDS (Sudden Information Denial Syndrome).

--Cal Webster
Network Manager
NavAir TSD ISEO CPNC
cwebster@ec.rr.com

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org]On Behalf Of Matthew Mitchell
> Sent: Wednesday, June 11, 2003 10:02 AM
> To: linux-raid@vger.kernel.org
> Subject: Move md raid5 from intel to sparc?
>
>
> Hello everyone,
>
> In the interest of keeping around some otherwise-functional Sparcs, I
> was asked if it would be possible to move a linux md raid set from an
> Intel box to a Sun box.  I said, "Sure," and then immediately wondered
> about byte ordering -- will this work?  Take the SCSI box off of the
> intel, plug it into the sparc, and try to run the array...
>
> Then my next thought was that someone here would know the answer. :)
>
> Thanks!
>
> --
> Matthew Mitchell
> Systems Programmer/Administrator            matthew@geodev.com
> Geophysical Development Corporation         phone 713 782 1234
> 1 Riverway Suite 2100, Houston, TX  77056     fax 713 782 1829
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

