From: "David Lethe" <david@santools.com>
Subject: RE: RFC - device names and mdadm with some reference to udev.
Date: Mon, 27 Oct 2008 18:48:13 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C026BBE86@34093-C3-EVS3.exchange.rackspace.com>
References: <18692.62860.863118.727187@notabene.brown><ac3eb2510810270541g2ac57bd1p5576f15959e849e@mail.gmail.com><A20315AE59B5C34585629E258D76A97C026BB4B1@34093-C3-EVS3.exchange.rackspace.com> <18694.20077.985722.466221@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <18694.20077.985722.466221@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>, "martin f. krafft" <madduck@debian.org>, Michal Marek <mmarek@novell.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de]
> Sent: Monday, October 27, 2008 6:28 PM
> To: David Lethe
> Cc: Kay Sievers; linux-raid@vger.kernel.org; Doug Ledford; martin f.
> krafft; Michal Marek
> Subject: RE: RFC - device names and mdadm with some reference to udev.
> 
> On Monday October 27, david@santools.com wrote:
> >
> > I am with Kay here, never force automount.
> > I put that right up there with the bonehead MSFT rule of trying to
> write
> > signatures on disk drives once they appear.
> 
> By you wouldn't mind if something that looked like it might have once
> been a raid1 started a resync as soon as you plugged it in?
> 

This could be addressed via EVPD pages.  The application that cares what
raid1 is
at any instant in time, or what might have been can ask it.
Furthermore, benny
of doing this is those applications don't have to have access to the
LINUX machine
or O/S in any way to get the info, and would be O/S, shell, and hardware
-agnostic.

> >
> > Furthermore, don't just delete /dev/md names.   That would be even a
> greater
> > mistake.  LINUX today has storage on SANs, clustering,
multi-tasking,
> multi-pathing,
> > SAN-management/monitoring software that will be using device paths
> that you want to
> > delete.
> 
> I don't understand.  If the md array has been explicitly stopped, why
> not remove the names from /dev.  They have no meaning any more.  And
> nothing can have them open.
> 

They have no meaning to mdadm and the programs that explicitly know that
md was stopped.  What if /dev/mdX was opened by another app and in use?
I do
not know for sure, but I bet there are corner cases where you wouldn't
be
able to remove device names even if you wanted to.  But, just educated
guess
on this item, but I suggest some people experienced with clustering,
infiniband-
connected nodes and such have the opportunity to put their opinion on
this one.


> >
> > I can't think of a simple fix, but can think of a complicated fix to
> make this play
> > nice in such environments, when things are good .. and when things
go
> bad.   My outside-
> > the-box suggestion is to present md target devices as a SCSI RAID
> controller or
> > processor device where you use ANSI-defined sense keys/ASC values to
> allow
> > apps that are running remotely or even
> > locally to query immediate state.   If the md device is broken, then
> report the same sense
> > information not ready, spun down, whatever ... that a physical disk
> would report for
> > various partition.
> > More importantly, use EVPD Inquiry and log pages to query
> configuration information, of
> > both the /dev/md device, AND all of the partitions, along with
health
> and anything else.
> > Enterprise management software wouldn't have to log into the LINUX


> host and run custom
> > scripts to see what is going on. Use mode sense to send
> control/configuration change requests.
> >
> > The ANSI provides a mechanism and options for defining a unique
> naming convention, and you can
> > even add a UUID in the format you want as a Vendor-specific layout.
> There is already a foundation
> > for such work due to the iSCSI logic, but obviously much more work
is
> required.
> >
> > Yes, this not a simple & easy fix, but if you want to future-proof
> everything and make LINUX storage
> > easy to integrate into heterogeneous environments, then let ANSI be
> your guide.
> 
> What I think you are suggesting is that md raid be exportable via
> iSCSI (or FCOE or AOE or flavor-of-the-month) in such a way that
> status-query commands 'do the right thing'.  Sounds like we want a
> plug-in for iscsid (or whatever it is that support iscsi service).
> 
> Is that what you mean?
> 
> Thanks,
> NeilBrown

iSCSI would be easier, but as long as you asked for suggestions ... I
prefer
that somebody magically write all of that code which will allow one to
add true
physical-port target devices so if you had a SAS, SCSI, or FC card then
you could
hook up multiple hosts, or switche. 
Then you would have foundation for multiple-concurrent
host connectivity on md-based volumes in addition to individual disks.
Instant SAN.
But iSCSI would effectively solve problem of having appropriate method
for communicating 
health and state across a SAN or WAN, and you wouldn't even have to
write code to export
the md device as a SCSI device type 0 (i.e, disk drive).   

(Hey, you asked for suggestions ... so consider this my letter to Santa)



