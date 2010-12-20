From: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Subject: RE: [PATCH 00/29] OLCE, migrations and raid10 takeover
Date: Mon, 20 Dec 2010 08:27:38 +0000
Message-ID: <BE2BFE91933D1B4089447C644860408066B84342@irsmsx503.ger.corp.intel.com>
References: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
 <20101216222058.03132812@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101216222058.03132812@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

Neil,

How we can help you to speed up your work?

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Neil Brown
> Sent: Thursday, December 16, 2010 12:21 PM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: Re: [PATCH 00/29] OLCE, migrations and raid10 takeover
>
> On Thu, 09 Dec 2010 16:18:38 +0100 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
>
> > This series for mdadm and introduces features (after some rework):
> > - Online Capacity Expansion (OLCE): patches 0001 to 0015
>
> I've been making slow work through these.  I'm up to about '0011'.
> A number of the patches needed very substantial re-work to fit the
> model that
> I posted earlier and to remove unnecessary complexity and to fit the
> requirements of mdmon (where e.g. the monitor is not allowed to
> allocate
> memory).
>
> As it is all now fresh in my mind again I took the opportunity to write
> a
> document describing some of the design philosophy of mdadm, and also
> updated
> the external-reshape-design.txt document.
>
> Both of these can be found in the devel-3.2 branch of my git tree, but
> I'll
> include them here as well.
>
> Hopefully I'll make some more progress tomorrow.
>
> NeilBrown
>
>
> mdmon-design.txt
> ================
>
>
> When managing a RAID1 array which uses metadata other than the
> "native" metadata understood by the kernel, mdadm makes use of a
> partner program named 'mdmon' to manage some aspects of updating
> that metadata and synchronising the metadata with the array state.
>
> This document provides some details on how mdmon works.
>
> Containers
> ----------
>
> As background: mdadm makes a distinction between an 'array' and a
> 'container'.  Other sources sometimes use the term 'volume' or
> 'device' for an 'array', and may use the term 'array' for a
> 'container'.
>
> For our purposes:
>  - a 'container' is a collection of devices which are described by a
>    single set of metadata.  The metadata may be stored equally
>    on all devices, or different devices may have quite different
>    subsets of the total metadata.  But there is conceptually one set
>    of metadata that unifies the devices.
>
>  - an 'array' is a set of datablock from various devices which
>    together are used to present the abstraction of a single linear
>    sequence of block, which may provide data redundancy or enhanced
>    performance.
>
> So a container has some metadata and provides a number of arrays which
> are described by that metadata.
>
> Sometimes this model doesn't work perfectly.  For example, global
> spares may have their own metadata which is quite different from the
> metadata from any device that participates in one or more arrays.
> Such a global spare might still need to belong to some container so
> that it is available to be used should a failure arise.  In that case
> we consider the 'metadata' to be the union of the metadata on the
> active devices which describes the arrays, and the metadata on the
> global spares which only describes the spares.  In this case different
> devices in the one container will have quite different metadata.
>
>
> Purpose
> -------
>
> The main purpose of mdmon is to update the metadata in response to
> changes to the array which need to be reflected in the metadata before
> futures writes to the array can safely be performed.
> These include:
>  - transitions from 'clean' to 'dirty'.
>  - recording the devices have failed.
>  - recording the progress of a 'reshape'
>
> This requires mdmon to be running at any time that the array is
> writable (a read-only array does not require mdmon to be running).
>
> Because mdmon must be able to process these metadata updates at any
> time, it must (when running) have exclusive write access to the
> metadata.  Any other changes (e.g. reconfiguration of the array) must
> go through mdmon.
>
> A secondary role for mdmon is to activate spares when a device fails.
> This role is much less time-critical than the other metadata updates,
> so it could be performed by a separate process, possibly
> "mdadm --monitor" which has a related role of moving devices between
> arrays.  A main reason for including this functionality in mdmon is
> that in the native-metadata case this function is handled in the
> kernel, and mdmon's reason for existence to provide functionality
> which is otherwise handled by the kernel.
>
>
> Design overview
> ---------------
>
> mdmon is structured as two threads with a common address space and
> common data structures.  These threads are know as the 'monitor' and
> the 'manager'.
>
> The 'monitor' has the primary role of monitoring the array for
> important state changes and updating the metadata accordingly.  As
> writes to the array can be blocked until 'monitor' completes and
> acknowledges the update, it much be very careful not to block itself.
> In particular it must not block waiting for any write to complete else
> it could deadlock.  This means that it must not allocate memory as
> doing this can require dirty memory to be written out and if the
> system choose to write to the array that mdmon is monitoring, the
> memory allocation could deadlock.
>
> So 'monitor' must never allocate memory and must limit the number of
> other system call it performs. It may:
>  - use select (or poll) to wait for activity on a file descriptor
>  - read from a sysfs file descriptor
>  - write to a sysfs file descriptor
>  - write the metadata out to the block devices using O_DIRECT
>  - send a signal (kill) to the manager thread
>
> It must not e.g. open files or do anything similar that might allocate
> resources.
>
> The 'manager' thread does everything else that is needed.  If any
> files are to be opened (e.g. because a device has been added to the
> array), the manager does that.  If any memory needs to be allocated
> (e.g. to hold data about a new array as can happen when one set of
> metadata describes several arrays), the manager performs that
> allocation.
>
> The 'manager' is also responsible for communicating with mdadm and
> assigning spares to replace failed devices.
>
>
> Handling metadata updates
> -------------------------
>
> There are a number of cases in which mdadm needs to update the
> metdata which mdmon is managing.  These include:
>  - creating a new array in an active container
>  - adding a device to a container
>  - reconfiguring an array
> etc.
>
> To complete these updates, mdadm must send a message to mdmon which
> will merge the update into the metadata as it is at that moment.
>
> To achieve this, mdmon creates a Unix Domain Socket which the manager
> thread listens on.  mdadm sends a message over this socket.  The
> manager thread examines the message to see if it will require
> allocating any memory and allocates it.  This is done in the
> 'prepare_update' metadata method.
>
> The update message is then queued for handling by the monitor thread
> which it will do when convenient.  The monitor thread calls
> ->process_update which should atomically make the required changes to
> the metadata, making use of the pre-allocate memory as required.  Any
> memory the is no-longer needed can be placed back in the request and
> the manager thread will free it.
>
> The exact format of a metadata update is up to the implementer of the
> metadata handlers.  It will simply describe a change that needs to be
> made.  It will sometimes contain fragments of the metadata to be
> copied in to place.  However the ->process_update routine must make
> sure not to over-write any field that the monitor thread might have
> updated, such as a 'device failed' or 'array is dirty' state.
>
> When the monitor thread has completed the update and written it to the
> devices, an acknowledgement message is sent back over the socket so
> that mdadm knows it is complete.
>
>
> =======================================================================
> ==========
>
> External Reshape
>
> 1 Problem statement
>
> External (third-party metadata) reshape differs from native-metadata
> reshape in three key ways:
>
> 1.1 Format specific constraints
>
> In the native case reshape is limited by what is implemented in the
> generic reshape routine (Grow_reshape()) and what is supported by the
> kernel.  There are exceptional cases where Grow_reshape() may block
> operations when it knows that the kernel implementation is broken, but
> otherwise the kernel is relied upon to be the final arbiter of what
> reshape operations are supported.
>
> In the external case the kernel, and the generic checks in
> Grow_reshape(), become the super-set of what reshapes are possible.
> The
> metadata format may not support, or have yet to implement a given
> reshape type.  The implication for Grow_reshape() is that it must query
> the metadata handler and effect changes in the metadata before the new
> geometry is posted to the kernel.  The ->reshape_super method allows
> Grow_reshape() to validate the requested operation and post the
> metadata
> update.
>
> 1.2 Scope of reshape
>
> Native metadata reshape is always performed at the array scope (no
> metadata relationship with sibling arrays on the same disks).  External
> reshape, depending on the format, may not allow the number of member
> disks to be changed in a subarray unless the change is simultaneously
> applied to all subarrays in the container.  For example the imsm format
> requires all member disks to be a member of all subarrays, so a 4-disk
> raid5 in a container that also houses a 4-disk raid10 array could not
> be
> reshaped to 5 disks as the imsm format does not support a 5-disk raid10
> representation.  This requires the ->reshape_super method to check the
> contents of the array and ask the user to run the reshape at container
> scope (if all subarrays are agreeable to the change), or report an
> error in the case where one subarray cannot support the change.
>
> 1.3 Monitoring / checkpointing
>
> Reshape, unlike rebuild/resync, requires strict checkpointing to
> survive
> interrupted reshape operations.  For example when expanding a raid5
> array the first few stripes of the array will be overwritten in a
> destructive manner.  When restarting the reshape process we need to
> know
> the exact location of the last successfully written stripe, and we need
> to restore the data in any partially overwritten stripe.  Native
> metadata stores this backup data in the unused portion of spares that
> are being promoted to array members, or in an external backup file
> (located on a non-involved block device).
>
> The kernel is in charge of recording checkpoints of reshape progress,
> but mdadm is delegated the task of managing the backup space which
> involves:
> 1/ Identifying what data will be overwritten in the next unit of
> reshape
>    operation
> 2/ Suspending access to that region so that a snapshot of the data can
>    be transferred to the backup space.
> 3/ Allowing the kernel to reshape the saved region and setting the
>    boundary for the next backup.
>
> In the external reshape case we want to preserve this mdadm
> 'reshape-manager' arrangement, but have a third actor, mdmon, to
> consider.  It is tempting to give the role of managing reshape to
> mdmon,
> but that is counter to its role as a monitor, and conflicts with the
> existing capabilities and role of mdadm to manage the progress of
> reshape.  For clarity the external reshape implementation maintains the
> role of mdmon as a (mostly) passive recorder of raid events, and mdadm
> treats it as it would the kernel in the native reshape case (modulo
> needing to send explicit metadata update messages and checking that
> mdmon took the expected action).
>
> External reshape can use the generic md backup file as a fallback, but
> in the
> optimal/firmware-compatible case the reshape-manager will use the
> metadata
> specific areas for managing reshape.  The implementation also needs to
> spawn a
> reshape-manager per subarray when the reshape is being carried out at
> the
> container level.  For these two reasons the ->manage_reshape() method
> is
> introduced.  This method in addition to base tasks mentioned above:
> 1/ Processed each subarray one at a time in series - where appropriate.
> 2/ Uses either generic routines in Grow.c for md-style backup file
>    support, or uses the metadata-format specific location for storing
>    recovery data.
> This aims to avoid a "midlayer mistake"[1] and lets the metadata
> handler
> optionally take advantage of generic infrastructure in Grow.c
>
> 2 Details for specific reshape requests
>
> There are quite a few moving pieces spread out across md, mdadm, and
> mdmon for
> the support of external reshape, and there are several different types
> of
> reshape that need to be comprehended by the implementation.  A rundown
> of
> these details follows.
>
> 2.0 General provisions:
>
> Obtain an exclusive open on the container to make sure we are not
> running concurrently with a Create() event.
>
> 2.1 Freezing sync_action
>
>    Before making any attempt at a reshape we 'freeze' every array in
>    the container to ensure no spare assignment or recovery happens.
>    This involves writing 'frozen' to sync_action and changing the '/'
>    after 'external:' in metadata_version to a '-'. mdmon knows that
>    this means not to perform any management.
>
>    Before doing this we check that all sync_actions are 'idle', which
>    is racy but still useful.
>    Afterwards we check that all member arrays have no spares
>    or partial spares (recovery_start != 'none') which would indicate a
>    race.  If they do, we unfreeze again.
>
>    Once this completes we know all the arrays are stable.  They may
>    still have failed devices as devices can fail at any time.  However
>    we treat those like failures that happen during the reshape.
>
> 2.2 Reshape size
>
>    1/ mdadm::Grow_reshape(): checks if mdmon is running and optionally
>       initializes st->update_tail
>    2/ mdadm::Grow_reshape() calls ->reshape_super() to check that the
> size change
>       is allowed (being performed at subarray scope / enough room)
> prepares a
>       metadata update
>    3/ mdadm::Grow_reshape(): flushes the metadata update (via
>       flush_metadata_update(), or ->sync_metadata())
>    4/ mdadm::Grow_reshape(): post the new size to the kernel
>
>
> 2.3 Reshape level (simple-takeover)
>
> "simple-takeover" implies the level change can be satisfied without
> touching
> sync_action
>
>     1/ mdadm::Grow_reshape(): checks if mdmon is running and optionally
>        initializes st->update_tail
>     2/ mdadm::Grow_reshape() calls ->reshape_super() to check that the
> level change
>        is allowed (being performed at subarray scope) prepares a
>        metadata update
>        2a/ raid10 --> raid0: degrade all mirror legs prior to calling
>            ->reshape_super
>     3/ mdadm::Grow_reshape(): flushes the metadata update (via
>        flush_metadata_update(), or ->sync_metadata())
>     4/ mdadm::Grow_reshape(): post the new level to the kernel
>
> 2.4 Reshape chunk, layout
>
> 2.5 Reshape raid disks (grow)
>
>     1/ mdadm::Grow_reshape(): unconditionally initializes st-
> >update_tail
>        because only redundant raid levels can modify the number of raid
> disks
>     2/ mdadm::Grow_reshape(): calls ->reshape_super() to check that the
> level
>        change is allowed (being performed at proper scope / permissible
>        geometry / proper spares available in the container), chooses
>        the spares to use, and prepares a metadata update.
>     3/ mdadm::Grow_reshape(): Converts each subarray in the container
> to the
>        raid level that can perform the reshape and starts mdmon.
>     4/ mdadm::Grow_reshape(): Pushes the update to mdmon.
>     5/ mdadm::Grow_reshape(): uses container_content to find details of
>        the spares and passes them to the kernel.
>     6/ mdadm::Grow_reshape(): gives raid_disks update to the kernel,
>        sets sync_max, sync_min, suspend_lo, suspend_hi all to zero,
>        and starts the reshape by writing 'reshape' to sync_action.
>     7/ mdmon::monitor notices the sync_action change and tells
>        managemon to check for new devices.  managemon notices the new
>        devices, opens relevant sysfs file, and passes them all to
>        monitor.
>     8/ mdadm::Grow_reshape() calls ->manage_reshape to oversee the
>        rest of the reshape.
>
>     9/ mdadm::<format>->manage_reshape(): saves data that will be
> overwritten by
>        the kernel to either the backup file or the metadata specific
> location,
>        advances sync_max, waits for reshape, ping mdmon, repeat.
>        Meanwhile mdmon::read_and_act(): records checkpoints.
>        Specifically.
>
>        9a/ if the 'next' stripe to be reshaped will over-write
>            itself during reshape then:
>       9a.1/ increase suspend_hi to cover a suitable number of
>            stripes.
>       9a.2/ backup those stripes safely.
>       9a.3/ advance sync_max to allow those stripes to be backed up
>       9a.4/ when sync_completed indicates that those stripes have
>            been reshaped, manage_reshape must ping_manager
>       9a.5/ when mdmon notices that sync_completed has been updated,
>            it records the new checkpoint in the metadata
>       9a.6/ after the ping_manager, manage_reshape will increase
>            suspend_lo to allow access to those stripes again
>
>        9b/ if the 'next' stripe to be reshaped will over-write unused
>            space during reshape then we apply same process as above,
>          except that there is no need to back anything up.
>          Note that we *do* need to keep suspend_hi progressing as
>          it is not safe to write to the area-under-reshape.  For
>          kernel-managed-metadata this protection is provided by
>          ->reshape_safe, but that does not protect us in the case
>          of user-space-managed-metadata.
>
>    10/ mdadm::<format>->manage_reshape(): Once reshape completes
> changes the raid
>        level back to the nominal raid level (if necessary)
>
>        FIXME: native metadata does not have the capability to record
> the original
>        raid level in reshape-restart case because the kernel always
> records current
>        raid level to the metadata, whereas external metadata can
> masquerade at an
>        alternate level based on the reshape state.
>
> 2.6 Reshape raid disks (shrink)
>
> 3 TODO
>
> ...
>
> [1]: Linux kernel design patterns - part 3, Neil Brown
> http://lwn.net/Articles/336262/
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
