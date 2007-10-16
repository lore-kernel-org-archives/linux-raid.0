From: Mike Accetta <maccetta@laurelnetworks.com>
Subject: Re: Software RAID when it works and when it doesn't
Date: Tue, 16 Oct 2007 17:57:13 -0400
Message-ID: <14526.1192571833@mdt.ecitele.com>
References: <1192341478.16416.298.camel@w100>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: Your message of "Sun, 14 Oct 2007 00:57:58 CDT."
             <1192341478.16416.298.camel@w100>
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Alonso <alberto@ggsys.net>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alberto Alonso writes:

> On Sun, 2007-10-14 at 08:50 +1000, Neil Brown wrote:
> > On Saturday October 13, alberto@ggsys.net wrote:
> > > Over the past several months I have encountered 3
> > > cases where the software RAID didn't work in keeping
> > > the servers up and running.
> > > 
> > > In all cases, the failure has been on a single drive,
> > > yet the whole md device and server become unresponsive.
> > > 
> > > (usb-storage)
> > > In one situation a RAID 0 across 2 USB drives failed
> > > when one of the drives accidentally got turned off.
> > 
> > RAID0 is not true RAID - there is no redundancy.  If one device in a
> > RAID0 fails, the whole array will fail.  This is expected.
> 
> Sorry, I meant RAID 1. Currently, we only use RAID 1 and RAID 5 on all
> our systems.
> 
> > 
> > > 
> > > (sata)
> > > A second case a disk started generating reports like:
> > > end_request: I/O error, dev sdb, sector 42644555
> > 
> > So the drive had errors - not uncommon.  What happened to the array?
> 
> The array never became degraded, it just made the system
> hang. I reported it back in May, but couldn't get it
> resolved. I replaced the system and unfortunately went
> to a non-RAID solution for that server.

Was the disk driver generating any low level errors or otherwise
indicating that it might be retrying operations on the bad drive at
the time (i.e. console diagnostics)?  As Neil mentioned later, the md layer
is at the mercy of the low level disk driver.  We've observed abysmal
RAID1 recovery times on failing SATA disks because all the time is
being spent in the driver retrying operations which will never succeed.
Also, read errors don't tend to fail the array so when the bad disk is
again accessed for some subsequent read the whole hopeless retry process
begins anew.

I posted a patch about 6 weeks ago which attempts to improve this situation
for RAID1 by telling the driver not to retry on failures and giving some
weight to read errors for failing the array.  Hopefully, Neil is still
mulling it over and it or something similar will eventually make it into
the main line kernel as a solution for this problem.
--
Mike Accetta

ECI Telecom Ltd.
Transport Networking Division, US (previously Laurel Networks)
