From: "David Lethe" <david@santools.com>
Subject: RE: RAID halting
Date: Wed, 8 Apr 2009 09:30:27 -0500
Message-ID: <F2C688D6A021E34CB81C0E631EF4C093018652A1@34093-C4-EVS1.exchange.rackspace.com>
References: <F2C688D6A021E34CB81C0E631EF4C09301864D15@34093-C4-EVS1.exchange.rackspace.com> <20090408141756.SJCK26228.cdptpa-omta04.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20090408141756.SJCK26228.cdptpa-omta04.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Leslie Rhorer
> Sent: Wednesday, April 08, 2009 9:18 AM
> To: 'Linux RAID'
> Subject: RE: RAID halting
> 
> > There is also a SMART error log reporting mechanism.  The disks have
> > ability to report the last 5 commands that errored on each disk,
> which
> > includes timestamp, op code, input parameters and reason for error.
> 
> I pulled the logs from the drives.  Four showed no errors whatsoever,
> and
> three showed 1, 2, and 3 errors, respectively.  The others ranged from
> 408
> to 1871.  I then triggered a halt with a mv command, and checked the
> logs
> again.  The values all remain the same, with no new errors reported
> whatsoever.
> 
> > This runs instantly, and it is possible that just having these last
5
> > errors will tell you exactly what problem is. The errors are also
> 
> I presume a sector remapping would be caught by the log file, yes?  If
> so,
> bad sector mapping is pretty much completely eliminated as a cause for
> this
> issue.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

EXACTLY -- what are the errors .(Also a halt will not create an error in
the internal log of the disk.   Now, if you had cut power in middle of a
huge I/O, or read block n+1 on a disk that only had n blocks, then you
would create an error.


- David

