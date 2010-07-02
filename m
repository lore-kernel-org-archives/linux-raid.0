From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [mdadm GIT PULL] rebuild checkpoints, incremental assembly,
 volume delete/rename, and fixes
Date: Thu, 01 Jul 2010 17:56:51 -0700
Message-ID: <1278032211.2179.24.camel@dwillia2-linux>
References: <1274921452.17973.253.camel@dwillia2-linux>
	 <20100531113710.29e12d97@notabene.brown>
	 <AANLkTimgVuEIkB2s9rra5QS11YMUSpvSkBOcbzza44LX@mail.gmail.com>
	 <20100616163343.2c57de59@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100616163343.2c57de59@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, Doug Ledford <dledford@redhat.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, linux-raid <linux-raid@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>
List-Id: linux-raid.ids

On Tue, 2010-06-15 at 23:33 -0700, Neil Brown wrote:
> On Thu, 10 Jun 2010 23:42:16 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
> 
> > > I've merged and pushed out the other bits which all seem OK.  
> > 
> > Ok, there was one more you didn't comment on and didn't cherry-pick [2]
> > 
> > Dave Jiang (1):
> >       create: Check with OROM limit before setting default chunk size
> > 
> > Thanks,
> > Dan
> 
> I don't remember seeing that before - sorry.
> It looks OK.  It might be nice to combine it with the ->default_layout
> setting somehow, but that isn't necessary in the first instance.
> 
> Include it in the next pull request and I'll take it.
> 

Here is the updated pull request:

The following changes since commit b3b4e8a7a229cccca915421329a5319f996b0842:
  NeilBrown (1):
        Avoid skipping devices where removing all faulty/detached devices.

are available in the git repository at:

  git://github.com/djbw/mdadm.git master

Dan Williams (10):
      mdmon: periodically checkpoint recovery
      Kill subarray v2
      imsm: dump each disk's view of the slot state
      mdmon: record sync_completed directly to the metadata
      Remove 'checkpointing' side effect of --wait-clean
      Always assume SKIP_GONE_DEVS behaviour and kill the flag
      Rename subarray v2
      mdmon: prevent allocations due to late binding
      Merge branch 'subarray' into for-neil
      Merge branch 'fixes' into for-neil

Dave Jiang (1):
      create: Check with OROM limit before setting default chunk size

Changes since the last request:
1/ pushed down killsubarray and rename subarray restrictions (changing
uuid of active arrays) into super-intel.c

2/ Updated rebuild checkpointing to directly record sync_completed in
the metadata.  Monitoring sync_completed is urgently needed to fix
address a known hang triggered by ignoring sync_completed events.

3/ Made SKIP_GONE_DEVS the default to address any remaining sigsevs from
not expecting the return value of sysfs_read to be null (Dave triggered
one in Incremental.c)

4/ A fixlet for a theoretical problem of the monitor thread doing late
binding at the wrong time.  Also happens to workaround the glibc tls
problem that causes mdmon to intermittently fail to load.  Still waiting
for feedback from the glibc folks on whether they can provide a helper
or automatically set up their expected tls area when an app does not
specify the CLONE_SETTLS flag to clone(2).

The per topic branch names are 'checkpoint', 'fixes', and 'subarray' if
you want to take these piecemeal.

 Create.c         |    8 +-
 Grow.c           |   20 ++-
 Incremental.c    |    5 +
 Kill.c           |   78 +++++++++++++
 Makefile         |    3 +-
 Manage.c         |   53 +++++++++
 ReadMe.c         |    2 +
 managemon.c      |    3 +-
 mapfile.c        |    5 +-
 mdadm.8.in       |   47 +++++++-
 mdadm.c          |   47 ++++++++-
 mdadm.h          |   18 +++-
 mdmon.c          |   28 +----
 mdmon.h          |    9 ++
 monitor.c        |   37 ++++++
 platform-intel.h |   49 ++++++++
 super-ddf.c      |   33 ++++--
 super-intel.c    |  333 ++++++++++++++++++++++++++++++++++++++++++++++++------
 sysfs.c          |   23 ++---
 util.c           |  137 ++++++++++++++++++++++
 20 files changed, 831 insertions(+), 107 deletions(-)

commit d19e3cfb6627c40e3a28454ebc2098c0e19b9a77
Merge: 8cfc801 23eb475
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Jul 1 17:36:11 2010 -0700

    Merge branch 'fixes' into for-neil

commit 8cfc801c72f079618b39d04c2e0fe32adbc2474e
Merge: 6a0ee6a aa53467
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Jul 1 17:36:05 2010 -0700

    Merge branch 'subarray' into for-neil
    
    Conflicts:
    	mdadm.h
    	super-intel.c

commit 23eb475a96b1b0cf7f8feaeb7b32355b80e8faa7
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Jul 1 17:28:14 2010 -0700

    mdmon: prevent allocations due to late binding
    
    Current versions of glibc do not provide a useable interface to clone(2) as it
    inflicts hidden dependencies on setting up a glibc specific tls
    descriptor.  The dynamic linker trips this dependency and causes mdmon
    to intermittently fail to load.  Resolving all dynamic linking prior to
    starting the monitor thread appears to mitigate the issue but there is no
    guarantee that another tls dependency will bite us later.
    
    However, while the debate continues with the glibc maintainers it seems
    prudent to keep this change.  It ensures that we do not get into a
    situation where the monitor thread needs to make a late allocation to
    resolve a symbol.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit aa534678baad80689a642ba1bd602a00a267ac03
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Jun 22 16:30:59 2010 -0700

    Rename subarray v2
    
    Allow the name of the array stored in the metadata to be updated.  In
    some cases the metadata format may not be able to support this rename
    without modifying the UUID.  In these cases the request will be blocked.
    Otherwise we allow the rename to take place, even for active arrays.
    This assumes that the user understands the difference between the kernel
    node name, the device node symlink name, and the metadata specific name.
    
    Anticipating further need to modify subarrays in-place, introduce the
    ->update_subarray() superswitch method.  A future potential use
    case is setting storage pool (spare-group) identifiers.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit b526e52dc7cbdde98db9c9f8765be28ba6d71d78
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Jun 16 17:26:04 2010 -0700

    Always assume SKIP_GONE_DEVS behaviour and kill the flag
    
    ...i.e. GET_DEVS == (GET_DEVS|SKIP_GONE_DEVS)
    
    A null pointer dereference in Incremental.c can be triggered by
    replugging a disk while the old name is in use.  When mdadm -I is called
    on the new disk we fail the call to sysfs_read().  I audited all the
    locations that use GET_DEVS and it appears they can tolerate missing a
    drive.  So just make SKIP_GONE_DEVS the default behaviour.
    
    Also fix up remaining unchecked usages of the sysfs_read() return value.
    
    Reported-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 6a0ee6a0770e8b2ae2a2bbe79896d4ecb083e218
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Jun 15 18:41:57 2010 -0700

    Remove 'checkpointing' side effect of --wait-clean
    
    Now that mdmon records periodic checkpoints, and checkpoints every
    ->set_array_state() event we no longer need to 'idle' sync_action from
    --wait-clean.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 4f0a7acc9a0a93d39b66b29e374f9a5edd173047
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Jun 15 18:41:57 2010 -0700

    mdmon: record sync_completed directly to the metadata
    
    When sync_action is idle mdmon takes the latest value of md/resync_start
    or md/<dev>/recovery_start to record the resync/rebuild checkpoint in
    the metadata.  However, now that mdmon is reading sync_completed there
    is no longer a need to wait for, or force an idle event to take a
    checkpoint.
    
    Simply update the forward progress of ->last_checkpoint at every wakeup
    event and force it to be recorded at least every 1/16th array-size
    interval.  It may be recorded more frequently if a ->set_array_state()
    event occurs.
    
    This also cleans up some confusion in handling the dual-rebuild case.
    If more than one spare has been activated the kernel starts the rebuild
    at the lowest recovery offset, so we do not need to worry about
    min_recovery_start().
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0d80bb2f97e876379fb0ba732e8e97894ebe3de9
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Jun 15 18:41:57 2010 -0700

    imsm: dump each disk's view of the slot state
    
    Allow --examine to determine which disk might have a stale view of the
    per-disk out-of-sync state.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0bd16cf2173695726f1ed2f9372c613003d80f9a
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Tue Jun 15 18:41:53 2010 -0700

    create: Check with OROM limit before setting default chunk size
    
    Make create check with the appropriate meta data handler and see what the
    largest chunk size is supported. The current 512K default is not supported
    by existing imsm OROM.
    
    [dan.j.williams@intel.com: trim the upper limit to 512k for future oroms]
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 33414a0182ae193150f65f7bca97a7e4d818a49e
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Jun 15 17:55:41 2010 -0700

    Kill subarray v2
    
    Support for deleting a subarray out of a container.  When all subarrays
    are deleted the component devices are converted back into spares, a
    --zero-superblock is still needed to kill the remaining metadata at this
    point.  This operation is blocked when the subarray is active and may
    also be blocked by the metadata handler when deleting the subarray might
    change the uuid of other active subarrays.  For example, with imsm,
    deleting subarray 'n' may change the uuid of subarrays with indexes > n.
    
    Deleting a subarray needs to be a container wide event to ensure
    disks that record the modified subarray list perceive other disks that
    did not receive this change as out of date.
    
    Notes:
    The st->subarray parsing in super-intel.c and super-ddf.c is updated to
    be more strict now that we are reading user supplied subarray values.
    
    Offline container modification shares actions that mdmon typically
    handles so promote is_container_member() and version_to_superswitch()
    (formerly find_metadata_methods()) to generic utility functions for the
    cases where mdadm performs the operation.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 484240d8a3facde992009efd81bfa4cc0c79287d
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri May 14 17:42:49 2010 -0700

    mdmon: periodically checkpoint recovery
    
    The kernel updates and notifies md/sync_completed when it is time to
    take a checkpoint.  When this occurs (at 1/16 array size intervals)
    write 'idle' to md/sync_action to have the current recovery position
    updated in recovery_start and resync_start.
    
    Requires the metadata handler to reset ->last_checkpoint when it has
    determined that recovery has ended.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>


