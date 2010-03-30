From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: RE: Auto Rebuild on hot-plug
Date: Tue, 30 Mar 2010 18:47:33 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D11C584DD2@irsmsx503.ger.corp.intel.com>
References: <20100325113543.0e2124c5@notabene.brown>
	 <905EDD02F158D948B186911EB64DB3D11C510278@irsmsx503.ger.corp.intel.com>
	 <e9c3a7c21003261737k1e753b08xc6f8eb45d0320be9@mail.gmail.com>
	 <4BB0ED13.6020507@redhat.com>
	 <e9c3a7c21003291436lb898278i21f988fd5f76bd53@mail.gmail.com>
	 <4BB13830.8070709@redhat.com>
 <e9c3a7c21003291746o49191295r876c7fef50fe63a5@mail.gmail.com>
 <4BB2175C.7070201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB2175C.7070201@redhat.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

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
I understand that there are following defaults:
- Platform/metadata limitations create default domains
- metadata handler deliver default actions 
The equivalent configuration line for imsm is:
DOMAIN path="any" metadata=imsm action=none
User could additionally split default domains using spare groups and path keyword.
For instance for imsm, the default domain area is platform controller. 
If any metadata is server by multiple controllers, each of them creates its own domain.
If we allow for "any" for the path keyword, a user could simply override metadata defaults for all his controllers by:
DOMAIN path="any" metadata=imsm action=safe_use

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
I think that implementation can be something like that:
We shall set cookie to store the path of disk which is removed from the md device. Later if the new device is re-plugged in the port, it can be used for rebuild. 
We shall set timer when cookies shall expire. I propose to clean them on start-up (mdadm -monitor can be a candidate; default action shall be cookies clean-up).

[ .. ]

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
Enable spare disk sharing between containers if they belong to the same domain and have not conflicting spare group assignment. This will allow for spare sharing by default.
Additionally, we can consult metadata handlers before moving spares between containers. We can do that by adding another metadata handler function which shall test metadata and controller dependencies (I can imagine that user can define metadata stored domains of spare sharing; controllers (OROM) dependent constrains shall be handled in this function, too).  
Thanks,
Marcin Labun
