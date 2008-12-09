From: "David Lethe" <david@santools.com>
Subject: RE: status of raid 4/5 disk reduce
Date: Tue, 9 Dec 2008 15:33:17 -0600
Message-ID: <A20315AE59B5C34585629E258D76A97C02F476F7@34093-C3-EVS3.exchange.rackspace.com>
References: <493D8A95.2020700@mikebrancato.com> <493EDF02.5090500@redwax.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <493EDF02.5090500@redwax.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Alex Lilley <alex@redwax.co.uk>, Michael Brancato <mike@mikebrancato.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Alex Lilley
> Sent: Tuesday, December 09, 2008 3:12 PM
> To: Michael Brancato
> Cc: linux-raid@vger.kernel.org
> Subject: Re: status of raid 4/5 disk reduce
> 
> Hi Michael
> 
> I posed this a few weeks back but haven't seen any activity on it yet
> or
> any suggestion as to when this might be possible.
> 
> For reference, my thread started here:
> http://marc.info/?l=linux-raid&m=122753511309332&w=2
> 
> Cross fingers for this because I think it is a real killer feature.
> 
> Regards
> 
> Alex
> 
> Michael Brancato wrote:
> > I'm curious as to the status of the ability to reduce the number of
> > disks in a RAID 4/5 array.  I would like the ability to reshape a 4
> > disk raid4/5 to a 3 disk raid4/5 for flexibility.
> >
> > here is what I want to do....
> > $ sudo mdadm /dev/md0 --fail /dev/disk4 --remove /dev/disk4
> > mdadm: set /dev/disk4 faulty in /dev/md0
> > mdadm: hot removed /dev/disk4
> > $ sudo mdadm --grow /dev/md0 -n3
> > mdadm: /dev/md0: Cannot reduce number of data disks (yet).
> >
> > I know this capability is missing in the md driver.  What is needed
> to
> > make it work and is anyone currently working on it?
> >
> > Regards,
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

This is a lot to ask for in terms of development, and creates extreme
risk of data loss.
First, you degrade /dev/md0, so any bad blocks or drive failures will
cause catastrophic
data loss, unless /dev/disk4 is used for mirroring in the interim.

Secondly, by removing that disk (for sake of argument, say each disk is
1TB. You go from 3TB usable data
to 2TB.  Most likely, you need to resize the file system in place so it
fits into 2TB.  You're probably booted
onto md0 also, which makes it difficult.  Resizing a hot filesystem
without scratch space??  If your file system
can't be dynamically reduced, then no point worrying about md raid. 

I don't see it happening .. ever.  Even if somebody wrote the logic, I
can't imagine the code being tested enough
to be safe for live data.  

