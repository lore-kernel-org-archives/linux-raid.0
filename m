From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: "Enhanced" MD code avaible for review
Date: Wed, 17 Mar 2004 11:14:21 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <459805408.1079547261@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
Cc: justin_gibbs@adaptec.com
List-Id: linux-raid.ids


[ I tried sending this last night from my Adaptec email address and have
  yet to see it on the list.  Sorry if this is dup for any of you. ]

For the past few months, Adaptec Inc, has been working to enhance MD.
The goals of this project are:

	o Allow fully pluggable meta-data modules
	o Add support for Adaptec ASR (aka HostRAID) and DDF
	  (Disk Data Format) meta-data types.  Both of these
	  formats are understood natively by certain vendor
	  BIOSes meaning that arrays can be booted from transparently.
	o Improve the ability of MD to auto-configure arrays.
	o Support multi-level arrays transparently yet allow
	  proper event notification across levels when the
	  topology is known to MD.
	o Create a more generic "work item" framework which is
	  used to support array initialization, rebuild, and
	  verify operations as well as miscellaneous tasks that
	  a meta-data or RAID personality may need to perform
	  from a thread context (e.g. spare activation where
	  meta-data records may need to be sequenced carefully).
	o Modify the MD ioctl interface to allow the creation
	  of management utilities that are meta-data format
	  agnostic.

A snapshot of this work is now available here:

	http://people.freebsd.org/~gibbs/linux/SRC/emd-0.7.0-tar.gz

This snapshot includes support for RAID0, RAID1, and the Adaptec
ASR and DDF meta-data formats.  Additional RAID personalities and
support for the Super90 and Super 1 meta-data formats will be added
in the coming weeks, the end goal being to provide a superset of
the functionality in the current MD.

A patch to fs/partitions/check.c is also required for this
release to function correctly:

	
http://people.freebsd.org/~gibbs/linux/SRC/md_announce_whole_device.diff

As the file name implies, this patch exposes not only partitions
on devices, but all "base" block devices to MD.  This is required
to support meta-data formats like ASR and DDF that typically operate
on the whole device.  Nothing in the implementation prevents any
meta-data format from being used on a partition, but BIOS boot
support is only available in the non-partitioned mode.

Since the current MD notification scheme does not allow MD to receive
notifications unless it is statically compiled into the kernel, we
would like to work with the community to develop a more generic
notification scheme to which modules, such as MD, can dynamically
register.  Until that occurs, these EMD snapshots will require at
least md.c to be a static component of the kernel.

For those wanting to test out this snapshot with an Adaptec HostRAID
U320 SCSI controller, you will need to update your kernel to use
version 2.0.8 of the aic79xx driver.  This driver defaults to
attaching to 790X controllers operating in HostRAID mode in addition
to those in direct SCSI mode.  This feature can be disabled using
a module or kernel command option.  Driver source and BK send patches
for this driver can be found here:

http://people.freebsd.org/~gibbs/linux/SRC/aic79xx-linux-2.6-20040316-tar.gz
http://people.freebsd.org/~gibbs/linux/SRC/aic79xx-linux-2.6-20040316.bksend.gz

Architectural Notes
===================
The major areas of change in "EMD" can be categorized into:

1) "Object Oriented" Data structure changes 

	These changes are the basis for allowing RAID personalities
	to transparently operate on "disks" or "arrays" as member
	objects.  While it has always been possible to create
	multi-level arrays in MD using block layer stacking, our
	approach allows MD to also stack internally.  Once a given
	RAID or meta-data personality is converted to the new
	structures, this "feature" comes at no cost.  The benefit
	to stacking internally, which requires a meta-data format
	that supports this, is that array state can propagate up
	and down the topology without the loss of information
	inherent in using the block layer to traverse levels of an
	array.

2) Opcode based interfaces.

	Rather than add additional method vectors to either the
	RAID personality or meta-data personality objects, the new
	code uses only a few methods that are parameterized.  This
	has allowed us to create a fairly rich interface between
	the core and the personalities without overly bloating
	personality "classes".
	
3) WorkItems

	Workitems provide a generic framework for queuing work to
	a thread context.  Workitems include a "control" method as
	well as a "handler" method.  This separation allows, for
	example, a RAID personality to use the generic sync handler
	while trapping the "open", "close", and "free" of any sync
	workitems.  Since both handlers can be tailored to the
	individual workitem that is queued, this removes the need
	to overload one or more interfaces in the personalities.
	It also means that any code in MD can make use of this
	framework - it is not tied to particular objects or modules
	in the system.

4) "Syncable Volume" Support

	All of the transaction accounting necessary to support
	redundant arrays has been abstracted out into a few inline
	functions.  With the inclusion of a "sync support" structure
	in a RAID personality's private data structure area and the
	use of these functions, the generic sync framework is fully
	available.  The sync algorithm is also now more like that
	in 2.4.X - with some updates to improve performance.  Two
	contiguous sync ranges are employed so that sync I/O can
	be pending while the lock range is extended and new sync
	I/O is stalled waiting for normal I/O writes that might
	conflict with the new range complete.  The syncer updates
	its stats more frequently than in the past so that it can
	more quickly react to changes in the normal I/O load.  Syncer
	backoff is also disabled anytime there is pending I/O blocked
	on the syncer's locked region.  RAID personalities have
	full control over the size of the sync windows used so that
	they can be optimized based on RAID layout policy.

5) IOCTL Interface

	"EMD" now performs all of its configuration via an "mdctl"
	character device.  Since one of our goals is to remove any
	knowledge of meta-data type in the user control programs,
	initial meta-data stamping and configuration validation
	occurs in the kernel.  In general, the meta-data modules
	already need this validation code in order to support
	auto-configuration, so adding this capability adds little
	to the overall size of EMD.  It does, however, require a
	few additional ioctls to support things like querying the
	maximum "coerced" size of a disk targeted for a new array,
	or enumerating the names of installed meta-data modules,
	etc.
	
	This area of EMD is still in very active development and we expect
	to provide a drop of an "emdadm" utility later this week.   

6) Meta-data and Topology State

	To support pluggable meta-data modules which may have diverse
	policies, all embedded knowledge of the MD SuperBlock formats
	has been removed.  In general, the meta-data modules "bid"
	on incoming devices that they can manage.  The high bidder
	is then asked to configure the disk into a reasonable
	topology that can be managed by a RAID personality and the
	MD core.  The bidding process allows a more "native" meta-data
	module to outbid a module that can handle the same format
	in "compatibility" mode.  It also allows the user to load
	a meta-data module update during install scenarios even if
	an older module is compiled statically into the kernel.

	Once the topology is created, all information needed for
	normal operation is available to the MD core and/or RAID
	personalities via direct variable access (at times protected
	by locks or atomic ops of course).  Array or member state
	changes occur via calling into the meta-data personality
	associated with that object.  The meta-data personality is
	then responsible for changing the state visible to the rest
	of the code and notifying interested parties.  This async
	design means that a RAID module noticing an I/O failure on
	one member and posting that event to one meta-data module,
	may cause a chain of notifications all the way to the
	top-level array object owned by another RAID/meta-data
	personality.

	The entire topology is reference counted such that objects
	will only disappear from the topology once they have
	transitioned to the FAILED state and all I/O (each I/O holds
	a reference) ceases.

7) Correction of RAID0 Transform

	The RAID0 transform's "merge function" assumes that the
	incoming bio's starting sector is the same as what will be
	presented to its make_request function.  In the case of a
	partitioned MD device, the starting sector is shifted by
	the partition offset for the target offset.  Unfortunately,
	the merge functions are not notified of the partition
	transform, so RAID0 would often reject requests that span
	"chunk" boundaries once shifted.  The fix employed here is
	to determine if a partition transform will occur and take
	this into account in the merge function.

Adaptec is currently validating EMD through formal testing while
continuing the build-out of new features.  Our hope is to gather
feedback from the Linux community and adjust our approach to satisfy
the community's requirements.  We look forward to your comments,
suggestions, and review of this project.

--
Justin


