From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 00/13] imsm: new imsm metadata features
Date: Thu, 29 Apr 2010 17:57:09 -0700
Message-ID: <t2se9c3a7c21004291757w49c4697dic28f49245c85ba7a@mail.gmail.com>
References: <66C59AD0932712458090B447266D638CD405E3B1@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66C59AD0932712458090B447266D638CD405E3B1@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

First, thanks for going back and breaking out these patches it makes
it much easier to review.  Note that patch-9 never came through either
on the list, or direct to my intel.com address.

On Thu, Apr 22, 2010 at 3:10 PM, Hawrylewicz Czarnowski, Przemyslaw
<przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:
> The following series of patches adds two new functionalities to mdadm for
> Intel metadata: Volume Delete and Volume Rename.
> The patches makes Linux SW RAID implementation based on imsm metadata closer
> to Intel(R) Rapid Storage Technology for Windows(TM).
> Patches 1-6 contain fixes of bugs found during development and modifications
> of existing code making main features easier to implement.
> Patches 7-9 contain implementation of Volume Delete; ie. makes possible to
> remove only one volume from container while the other one keeps running.
> Patches 10-12 makes possible to change internal serial ID of volume leaving
> the rest of superblock data untouched.
> The last patch contains an update of manual page for above features.
>
> [PATCH 01/13] fix: memory leak in mdmon_pid()

Applied

> [PATCH 02/13] map file: Extract record update routine from map_update

I don't understand the benefit over the standard map_update() routine?

> [PATCH 03/13] Add mdstat_by_component

...already applied to Neil's hotunplug branch

> [PATCH 04/13] fix: possible segfault if current_vol does not match subarray

Klockwork seems to be missing that ->current_vol is always initialized
to a valid value.  If we ever call getinfo_super_imsm_volume() with an
invalid current_vol that is a real bug.  We should not silently return
invalid info.

> [PATCH 05/13] sysfs: simple write to sysfs file

I would prefer you just call sysfs_read(mdfd, 0, GET_VERSION); in the
locations where you want to make simple updates

> [PATCH 06/13] imsm: delete subarray metadata manipulation routine

For testing and future-proofing purposes this routine should handle N
raid subarrays rather than assume 2 in the num_raid_devs > 1 case.
This patch also says that delete active from an active container is
not allowed but the code does nothing to prevent it.  I know this
would require moving the command line changes up in the series, but I
think it is important to fully understand the ramifications of this
delete functionality before going forward with the rest of the series.

I want to rehash the main points of the off-list discussion with Neil
and bring up some other thoughts about the rename patches...

Volume delete and volume rename are fairly innocuous features of the
Windows driver, the primary issue with the Linux implementation is
that volume-delete may change the array UUID and volume-rename
definitely will.  Unlike name changes for native metadata which have
no effect on the UUID.  My main concern is user's getting surprised by
having an mdadm.conf file in the initrd that has an out of date UUID
after doing a simple name change.  Ideally there would be some
distribution notification infrastructure we could use to post an event
like "invalidate/rebuild initrd", but nothing like that exists to my
knowledge.

The other concern with volume rename is that it cannot take effect
until the next assembly, and may not even change the actual OS device
name / symlink if a conflicting name is in the configuration file.  So
at the very least we are violating the rule of least surprise by not
actually changing the name of the array as the OS sees it, only as the
metadata sees it... and invalidating all occurrences of the old UUID
in the process.

Can we mitigate that pain?  We can't really go the alternate route of
stop using volume-position and volume-name in the calculation of the
UUID because there isn't any 'static' identification data left.  The
status quo has the nice property of being robust, UUIDs never change
unless you blow away the entire superblock at which point I'm not so
concerned about the initrd and other references to the UUID because
the previous array is gone.

Basically I am looking for a distro person to say "I guess we can live
with this" or "no, this violates too many assumptions of our storage
management code".

--
Dan
