From: Neil Brown <neilb@suse.de>
Subject: Re: Auto Rebuild on hot-plug
Date: Wed, 31 Mar 2010 15:53:49 +1100
Message-ID: <20100331155349.4268c379@notabene.brown>
References: <20100325113543.0e2124c5@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D11C510278@irsmsx503.ger.corp.intel.com>
	<e9c3a7c21003261737k1e753b08xc6f8eb45d0320be9@mail.gmail.com>
	<4BB0ED13.6020507@redhat.com>
	<e9c3a7c21003291436lb898278i21f988fd5f76bd53@mail.gmail.com>
	<4BB13830.8070709@redhat.com>
	<e9c3a7c21003291746o49191295r876c7fef50fe63a5@mail.gmail.com>
	<4BB2175C.7070201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB2175C.7070201@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

On Tue, 30 Mar 2010 11:23:08 -0400
Doug Ledford <dledford@redhat.com> wrote:

> As far as I can tell, we've reached a fairly decent consensus on things.
>  But, just to be clear, I'll reiterate that concensus here:
> 
> Add a new linetype: DOMAIN with options path= (must be specified at
> least once for any domain action other than none and incremental and
> must be something other than a global match for any action other than
> none and incremental) and metadata= (specifies the metadata type
> possible for this domain as one of imsm/ddf/md, and where for imsm or
> ddf types, we will verify that the path portions of the domain do not
> violate possible platform limitations) and action= (where action is
> none, incremental, readd, safe_use, force_use where action is specific
> to a hotplug when a degraded array in the domain exists and can possibly
> have slightly different meanings depending on whether the path specifies
> a whole disk device or specific partitions on a range of devices, and
> where there is the possibility of adding more options or a new option
> name for the case of adding a hotplug drive to a domain where no arrays
> are degraded, in which case issues such as boot sectors, partition
> tables, hot spare versus grow, etc. must be addressed).
> 
> Modify udev rules files to cover the following scenarios (it's
> unfortunate that we have to split things up like this, but in order to
> deal with either bare drives or drives that have things like lvm data
> and we are using force_use, we must trigger on *all* drive hotplug
> events, we must trigger early, and we must override other subsystem's
> possible hotplug actions, otherwise the force_use option will be a noop):
> 
> 1) plugging in a device that already has md raid metadata present
>    a) if the device has metadata corresponding to one of our arrays,
> attempt to do normal incremental add
>    b) if the device has metadata corresponding to one of our arrays, and
> the normal add failed and the options readd, safe_use, or force_use are
> present in the mdadm.conf file, reattempt to add using readd
>    c) if the device has metadata corresponding to one of our arrays, and
> the readd failed, and the options safe_use or force_use are present,
> then do a regular add of the device to the array (possibly with doing a
> preemptive zero-superblock on the device we are adding).  This should
> never fail.
>    d) if the device has metadata that does not correspond to any array
> in the system, and there is a degraded array, and the option force_use
> is present, then quite possibly repartition the device to make the
> partitions match the degraded devices, zero any superblocks, and add the
> device to the arrays.  BIG FAT WARNING: the force_use option will cause
> you to loose data if you plug in an array disk for another machine while
> this machine has degraded arrays.
> 
> 2) plugging in a device that doesn't already have md raid metadata
> present but is part of an md domain
>    a) if the device is bare and the option safe_use is present and we
> have degraded arrays, partition the device (if needed) and then add
> partitions to degraded arrays
>    b) if the device is not bare, and the option force_use is present and
> we have degraded arrays, (re)partition the device (if needed) and then
> add partitions to degraded arrays.  BIG FAT WARNING: if you enable this
> mode, and you hotplug say an LVM volume into your domain when you have a
> degraded array, kiss your LVM volume goodbye.
> 
> Modify udev rules files to deal with device removal.  Specifically, we
> need to watch for removal of devices that are part of raid arrays and if
> they weren't failed when they were removed, fail them, and then remove
> them from the array.  This is necessary for readd to work.  It also
> releases our hold on the scsi device so it can be fully released and the
> new device can be added back using the same device name.
> 
> Modify mdadm -I mode to read the mdadm.conf file for the DOMAIN lines on
> hotplug events and then modify the -I behavior to suit the situation.
> The majority of the hotplug changes mentioned above will actually be
> implemented as part of mdadm -I, we will simply add a few rules to call
> mdadm -I in a few new situations, then allow mdadm -I (which has
> unlimited smarts, where as udev rules get very convoluted very quickly
> if you try to make them smart) to actually make the decisions and do the
> right thing.  This means that effectively, we might just end up calling
> mdadm -I on every disk hot plug event whether there is md metadata or
> not, but only doing special things when the various conditions above are
> met.
> 
> Modify mdadm and the spare-group concept of ARRAY lines to coordinate
> spare-group assignments and DOMAIN assignments.  We need to know what to
> do in the event of a conflict between the two.  My guess is that this is
> unlikely, but in the end, I think we need to phase out spare-group
> entirely in favor of domain.  Since we can't have a conflict without
> someone adding domain lines to the config file, I would suggest that the
> domain assignments override spare-group assignments and we complain
> about the conflict.  That way, even though the user obviously intended
> something specific with spare-group, he also must have intended
> something specific with domain assignments, and as the domain keyword is
> the newest and latest thing, honor the latest wishes and warn about it
> in case they misentered something.
> 
> Modify mdadm/mdmon to enable spare migration between imsm containers in
> a domain.  Retain mdadm ability to move hot spares between native
> arrays, but make it based on domain now instead of spare-group, and in
> the config settings if someone has spare-group assignments and no domain
> assignments, then create internal domain entries that mimic the
> spare-group layout so that we can modify the core spare movement code to
> only be concerned with domain entries.
> 
> I think that covers it.  Do we have a consensus on the general work?
> Your thoughts Neil?
> 

Thoughts ... yes ... all over the place.  I won't try to group them, just a
random list:

"bare devices"
  To make sure we are on the same page, we should have a definition for this.
  How about "every byte in the first megabyte and last megabyte of the device
  is the same (e.g. 0x00 or 0x5a of 0xff) ??
  We would want a program (mdadm option?) to be able to make a device into a
  bare device.

Dan's "--activate-domains" option which creates a targeted udev rules file for
  "force_use" - I first I though "yuck, no", but then it grew on me.  I think
  I quite like the idea now.  We can put a rules file in /dev/.udev/rules.d/
  which targets just the path that we want to over-ride.
  I can see two approaches:
    1/ create the file during boot with something like "mdadm --activate-domins"
    2/ create a file whenever a device in an md-array is hot-removed which
       targets just that path and claims it immediately for md.
       Removing these after a timeout would be needed.

  The second feels elegant but could be racy.  The first is probably the
  better approach.

Your idea of only performing an action if there is a degraded array doesn't
  seem quite right.
  If I have a set of ports dedicated to raid and I plug in a bare device,
  I want to become a hot-spare whether there are degraded arrays that
  will use it immediately or not.
  You say the making it a hot spare doesn't actually "do" anything, but it
  does.  It makes available for recovery.

  If a device fails, then I plug in a spare I want it to recovery - so do you.
  If I plug in a spare and then a device fails, I want it to recover, but it
  seems you don't.  I cannot reconcile that difference.

  Yes, the admin might want to grow the array, but that is fine:  the spare
  is ready to be use for growth, or to replace a failure, or whatever is
  needed.

Native metadata: on partitions or on whole device.
  We need to make sure we understand the distinctions between these two
  scenarios.
  If a whole-device array is present, we probably include the device in that
  array, writing metadata if necessary.  Maybe we also copy everything between
  the start of the device and the data_offset incase something useful was
  placed there.
  If partitions are present then we probably want to call out to a script
  which is given the name of the new device and the names of the other
  devices present in the domain.  A supplied script would copy the partition
  table if they all had the same partition table, and make sure the
  boot block was copied as well.
  If this created new partitions, that would be a new set of hot-plug
  events(?).
  I think this is a situation where we at first want to only support very
  simple configurations where all devices are partitioned the same and all
  arrays are across a set of aligned partitions (/dev/sd?2), but allow
  script writers to do whatever they like.
  Maybe the 'action' word could be a script (did you suggest that already?)
  if it doesn't match a builtin action.

  This relates to the issue John raised about domains that identify
  partitions and tie actions to partitions.  You seem to have a difficulty
  with that which I don't understand yet.
  If the whole-device action results in partitions being created then maybe
  it ends there.  The partitions will appear via hot-plug and to act of them
  accordingly.
  Each partition might inherit an action from the whole-device, or might have
  it's own explicit action.

  Here is a related question:  Do we want the spare migration functionality
  to be able to re-partition a device.  I think not.  I think we need to
  assume that groups of related devices have the same partitioning, at least
  in the first implementation.

Multiple metadatas in a domain
  I think this should be supported as far as it makes sense.
  I'm not sure migrating spares between different metadata's makes a lot of
  sense, at least as a default.  Does it?
  When a bare device is plugged into a domain we need to know what sort of
  metadata to use on it (imsm, ddf, 0.90, 1.x, partitioned ?).  That would
  be one use for having a metadata= tag on a domain line.

Overlapping / nested domains
  Does this make sense?  Should it be allowed?
  Your suggestion of a top-level wildcard domain suggests that domains
  can be nested, and that feels like the right thing to do, though there
  aren't very many cases where you would want to specify different values at
  different levels of the nesting.  Maybe just 2 level?  At least 3 for
  global / devices / partitions (if we allow domains to contain parititons).

  But can domains overlap but not nest?  If they did you would need a strict
  over-ride policy: which action over-rides which.
  I cannot think of a use-case for this and think we should probably
  explicitly disallow it.

Patterns
  Are domain patterns globs or regexp or prefix or some combination?
  Prefix-only meets a lot of needs, but would allow partitions to match the
  whole device.
  globs are quite good with fixed-sized-fields which is largely what we have
  with paths, but you cannot do multi-digit numerical ranges. (08..12)
  Regex is more than I want I think.

  You can do numerical ranges with multiple domains:
     DOMAIN path=foo-0[89]-bar  action=thing
     DOMAIN path=foo-1[012]-bar action=thing

  That would say something about the concept of 'domain boundaries', as there
  should be no sense that there is a boundary between these two.
  Which leads me to...

spare-group
  I don't think I agree with your approach to spare-groups.
  You seem to be tying them back to domains.  I think I want domains to
  (optionally) provide spare-group tags.

  A spare-group (currently) is a label attach to some arrays (containers, not
  members, when that makes a difference) which by implication is attached to
  every device in the array.  Some times these are whole devices, some times
  partitions.

  A spare device tagged for a particular spare-group can be moved to any
  array tagged with the same spare-group.

  I see domains as (optionally) adding spare-group tags to a set of devices
  and, by implication, any array which contains those devices.

  I a domain implicitly defined a new spare-group, that would reduce your
  flexibility for defining domains using globs, as noted above.

  So a device can receive a spare-group from multiple sources.  I'm not sure
  how they interact.  It certainly could work for a device to be in multiple
  spare-groups

  domains don't implicitly define a spare-group (though a 'platform' domain
  might I guess).. Though Dan's idea of encoding 'platform' requirements
  explicitly by having mdadm generate them for inclusion in mdadm.conf might
  work.

  What has this to do with domain boundaries?  I don't think such a concept
  should exist.  The domain line associates a bunch of tags with a bunch of
  devices but does not imply a line between those inside and those outside.
  Where such a line is needed, it comes from devices sharing a particular
  tag, or not.
  So the set of all devices that have a particular spare-group tag form a set
  for the purposes of spare migration and devices cannot leave or join that
  set.

  I'm not sure how the spare-group for a domain translates to partitions on
  devices in that domain.  Maybe they get -partN appended.  Maybe
  you need a 
   DOMAIN path=foo*-partX spare-group=bar
  to assign spare-groups to partitions.
  I think I would support both
  

Thanks all I can think of for now.
In summary: I think there is lots of agreement, but there a still a few
details that need to be ironed out.

Thanks,
NeilBrown
