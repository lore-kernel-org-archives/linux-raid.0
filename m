From: Neil Brown <neilb@suse.de>
Subject: RE: RFC - device names and mdadm with some reference to udev.
Date: Tue, 28 Oct 2008 10:27:41 +1100
Message-ID: <18694.20077.985722.466221@notabene.brown>
References: <18692.62860.863118.727187@notabene.brown>
	<ac3eb2510810270541g2ac57bd1p5576f15959e849e@mail.gmail.com>
	<A20315AE59B5C34585629E258D76A97C026BB4B1@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Lethe on Monday October 27
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>, "martin f. krafft" <madduck@debian.org>, Michal Marek <mmarek@novell.com>
List-Id: linux-raid.ids

On Monday October 27, david@santools.com wrote:
> 
> I am with Kay here, never force automount.  
> I put that right up there with the bonehead MSFT rule of trying to write
> signatures on disk drives once they appear.  

By you wouldn't mind if something that looked like it might have once
been a raid1 started a resync as soon as you plugged it in?

> 
> Furthermore, don't just delete /dev/md names.   That would be even a greater
> mistake.  LINUX today has storage on SANs, clustering, multi-tasking, multi-pathing,
> SAN-management/monitoring software that will be using device paths that you want to
> delete.  

I don't understand.  If the md array has been explicitly stopped, why
not remove the names from /dev.  They have no meaning any more.  And
nothing can have them open.


> 
> I can't think of a simple fix, but can think of a complicated fix to make this play
> nice in such environments, when things are good .. and when things go bad.   My outside-
> the-box suggestion is to present md target devices as a SCSI RAID controller or
> processor device where you use ANSI-defined sense keys/ASC values to allow 
> apps that are running remotely or even
> locally to query immediate state.   If the md device is broken, then report the same sense
> information not ready, spun down, whatever ... that a physical disk would report for 
> various partition.
> More importantly, use EVPD Inquiry and log pages to query configuration information, of
> both the /dev/md device, AND all of the partitions, along with health and anything else.
> Enterprise management software wouldn't have to log into the LINUX host and run custom
> scripts to see what is going on. Use mode sense to send control/configuration change requests.
> 
> The ANSI provides a mechanism and options for defining a unique naming convention, and you can
> even add a UUID in the format you want as a Vendor-specific layout.   There is already a foundation
> for such work due to the iSCSI logic, but obviously much more work is required.
> 
> Yes, this not a simple & easy fix, but if you want to future-proof everything and make LINUX storage
> easy to integrate into heterogeneous environments, then let ANSI be your guide.

What I think you are suggesting is that md raid be exportable via
iSCSI (or FCOE or AOE or flavor-of-the-month) in such a way that
status-query commands 'do the right thing'.  Sounds like we want a
plug-in for iscsid (or whatever it is that support iscsi service).

Is that what you mean?

Thanks,
NeilBrown
