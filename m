From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: Proposed enhancements to MD
Date: Wed, 14 Jan 2004 09:52:59 -0600
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <200401140952.59447.kevcorry@us.ibm.com>
References: <40043C75.6040100@pobox.com> <400457E3.5030602@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <400457E3.5030602@adaptec.com>
Content-Disposition: inline
To: Scott Long <scott_long@adaptec.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

On Tuesday 13 January 2004 14:41, Scott Long wrote:
> A problem that we've encountered, though, is the following sequence:
>
> 1) md is inialized during boot
> 2) drives X Y and Z are probed during boot
> 3) root fs exists on array [X Y Z], but md didn't see them show up,
>     so it didn't auto-configure the array
>
> I'm not sure how this can be addressed by a userland daemon.  Remember
> that we are focused on providing RAID during boot; configuring a
> secondary array after boot is a much easier problem.

This can already be accomplished with an init-ramdisk (or initramfs in the 
future). These provide the ability to run user-space code before the real 
root filesystem is mounted.

> > I thought that raid0 was one of the few that actually did bio splitting
> > correctly?  Hum, maybe this is a 2.4-only issue.  Interesting, and
> > agreed, if so...
>
> This is definitely still a problem in 2.6.1

Device-Mapper does bio-splitting correctly, and already has a "stripe" module. 
It's pretty trivial to set up a raid0 device with DM.

> As for the question of DM vs. MD, I think that you have to consider that
> DM right now has no concept of storing configuration data on the disk
> (at least that I can find, please correct me if I'm wrong).  I think
> that DM will make a good LVM-like layer on top of MD, but I don't see it
> replacing MD right now.

The DM core has no knowledge of any metadata, but that doesn't mean its 
sub-modules ("targets" in DM-speak) can't. Example, the dm-snapshot target 
has to record enough on-disk metadata for its snapshots to be persistent 
across reboots. Same with the persistent dm-mirror target that Joe Thornber 
and co. have been working on. You could certainly write a raid5 target that 
recorded parity and other state information on disk.

The real key here is keeping the metadata that simply identifies the device 
separate from the metadata that keeps track of the device state. Using the 
snapshot example again, DM keeps a copy of the remapping table on disk, so an 
existing snapshot can be initialized when it's activated at boot-time. But 
this remapping table is completely separate from the metadata that identifies 
a device/volume as being a snapshot. In fact, EVMS and LVM2 have completely 
different ways of identifying snapshots (which is done in user-space), yet 
they both use the same kernel snapshot module.

-- 
Kevin Corry
kevcorry@us.ibm.com
http://evms.sourceforge.net/
