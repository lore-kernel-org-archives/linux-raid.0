From: Joe Landman <joe.landman@gmail.com>
Subject: Re: md road-map: 2011
Date: Wed, 16 Feb 2011 12:20:32 -0500
Message-ID: <4D5C0760.4090304@gmail.com>
References: <20110216212751.51a294aa@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110216212751.51a294aa@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/16/2011 05:27 AM, NeilBrown wrote:
>
> I all,
>   I wrote this today and posted it at
> http://neil.brown.name/blog/20110216044002
>
> I thought it might be worth posting it here too...

Another request would be an incremental on-demand build of the RAID. 
That is, when we set up a RAID6, that it only computes the blocks as 
they are allocated and used.  This helps with things like thin 
provisioning on remote target devices (among other nice things).

>
> NeilBrown
>
>
> -------------------------
>
>
> It is about 2 years since I last published a road-map[1] for md/raid
> so I thought it was time for another one.  Unfortunately quite a few
> things on the previous list remain undone, but there has been some
> progress.
>
> I think one of the problems with some to-do lists is that they aren't
> detailed enough.  High-level design, low level design, implementation,
> and testing are all very different sorts of tasks that seem to require
> different styles of thinking and so are best done separately.  As
> writing up a road-map is a high-level design task it makes sense to do
> the full high-level design at that point so that the tasks are
> detailed enough to be addressed individually with little reference to
> the other tasks in the list (except what is explicit in the road map).
>
> A particular need I am finding for this road map is to make explicit
> the required ordering and interdependence of certain tasks.  Hopefully
> that will make it easier to address them in an appropriate order, and
> mean that I waste less time saying "this is too hard, I might go read
> some email instead".
>
> So the following is a detailed road-map for md raid for the coming
> months.
>
> [1] http://neil.brown.name/blog/20090129234603
>
> Bad Block Log
> -------------
>
> As devices grow in capacity, the chance of finding a bad block
> increases, and the time taken to recover to a spare also increases.
> So the practice of ejecting a device from the array as soon as a
> write-error is detected is getting more and more problematic.
>
> For some time we have avoided ejecting devices for read errors, by
> computing the expected data from elsewhere and writing back to the
> device - hopefully fixing the read error.  However this cannot help
> degraded arrays and they will still eject a device (and hence fail the
> whole array) on a single read error.  This is not good.
>
> A particular problem is that when a device does fail and we need to
> recover the data, we typically read all of the other blocks on all
> arrays.  If we are going to hit any read errors, this is the most
> likely time, and also this is the worst possible time and it will mean
> that the recovery doesn't complete and the array gets stuck in a
> degraded state and is very susceptible to substantial loss if another
> failure happens.
>
> Part of the answer to this is to implement a "bad block log".  This is
> a record of blocks that are known to be bad.  i.e. either a read or a
> write has recently failed.  Doing this allows us to just eject that
> block from the array rather than the whole devices.  Similarly instead
> of failing the whole array, we can fail just one stripe.  Certainly
> this can mean data loss, but the loss of a few K is much less
> traumatic than the loss of a terabyte.
>
> But using a bad block list isn't just about keeping the data loss
> small, it can be about keeping it to zero.  If we get a write error on
> a block in a non-degraded array, then recording the bad block means we
> lose redundancy in just that stripe rather than losing it across the
> whole array.  If we then lose a different block on a different drive,
> the ability to record the bad block means that we can continue without
> data loss.  Had we needed to eject both whole drives from the array we
> would have lost access to all of our data.
>
> The bad block list must be recorded to stable storage to be useful, so
> it really needs to be on the same drives that store the data.  The
> bad-block list for a particular device is only of any interest to that
> device.  Keeping information about one device on another is pointless.
> So we don't have a bad block list for the whole array, we keep
> multiple lists, one for each device.
>
> It would be best to keep at least two copies of the bad block list so
> that if the place where the list goes bad we can keep working with the
> device.  The same logic applies to other metadata which currently
> cannot be duplicated.  So implementing this feature will not address
> metadata redundancy.  A separate feature should address metadata
> redundancy and it can duplicate the bad block list as well as other
> metadata.
>
> There are doubtlessly lots of ways that the bad block list could be
> stored, but we need to settle on one.  For externally managed metadata
> we need to make the list accessible via sysfs in a generic way so that
> a user-space program can store is as appropriate.
>
> So: for v0.90 we choose not to store a bad block list.  There isn't
> anywhere convenient to store it and new installations of v0.90 are not
> really encouraged.
>
> For v1.x metadata we record in the metadata an offset (from the
> superblock) and a size for a table, and a 'shift' value which can be
> used to shift from sector addresses to block numbers.  Thus the unit
> that is failed when an error is detected can be larger than one
> sector.
>
> Each entry in the table is 64bits in little-endian.   The most
> significant 55 bits store a block number which allows for 16 exbibytes
> with 512byte blocks, or more if a larger shift size is used.  The
> remaining 9 bits store a length of the bad range which can range from
> 1 to 512.  As bad blocks can often be consecutive, this is expected to
> allow the list to be quite efficient.  A value of all 1's cannot
> correctly identify a bad range of blocks and so it is used to pad out
> the tail of the list.
>
> The bad block list is exposed through sysfs via a directory called
> 'badblocks' containing several attribute files.
>
> "shift" stores the 'shift' number described above and can be set as
> long as the bad block list is empty.
>
> "all" and "unacknowledged" each contains a list of bad ranges, the
> start (in blocks, not sectors) and the length (1-512).  Each can also
> be written to with a string of the same format as is read out.  This
> can be used to add bad blocks to the list or to acknowledge bad
> blocks.  Writing effectively say "this bad range is securely recorded
> on stable storage".
>
> All bad blocks appear in the "badblocks/all" file.  Only "acknowledged"
> bad blocks appear in "badblocks/unacknowledged".  These are ranges
> which appear to be bad but are not known to be stored on stable
> storage.
>
> When md detects a write error or a read error which it cannot correct
> it added the block and marks the range that it was part of as
> 'unacknowledged'.  Any write that depends on this block is then
> blocked until the range is acknowledged.  This ensures that an
> application isn't told that a write has succeeded until the data
> really is safe.
>
> If the bad block list is being managed by v1.x metadata internally,
> then the bad block list will be written out and the ranges will be
> acknowledged and writes unblocked automatically.
>
> If the bad block list is being managed externally, then the bad ranges
> will be reported in "unacknowledged_bad_blocks".  The metadata handler
> should read this, update the on-disk metadata and write the range back
> to "bad_blocks".  This completes the acknowledgment handshake and
> writes can continue.
>
> RAID1, RAID10 and RAID456 should all support bad blocks.  Every read
> or write should perform a lookup of the bad block list.  If a read
> finds a bad block, that device should be treated as failed for that
> read.  This includes reads that are part of resync or recovery.
>
> If a write finds a bad block there are two possible responses.  Either
> the block can be ignored as with reads, or we can try to write the
> data in the hope that it will fix the error.  Always taking the second
> action would seem best as it allows blocks to be removed from the
> bad-block list, but as a failing write can take a long time, there are
> plenty of cases where it would not be good.
>
> To choose between these we make the simple decision that once we see a
> write error we never try to write to bad blocks on that device again.
> This may not always be the perfect strategy, but it will effectively
> address common scenarios.  So if a bad block is marked bad due to a
> read error when the array was degraded, then a write (presumably from
> the filesystem) will have the opportunity to correct the error.
> However if it was marked bad due to a write error we don't risk paying
> the penalty of more write errors.
>
> This 'have seen a write error' status is not stored in the array
> metadata.  So when restarting an array with some bad blocks, each
> device will have one chance to prove that it can correctly handle
> writes to a bad block.  If it can, the bad block will be removed from
> the list and the data is that little bit safer.  If it cannot, no
> further writes to bad blocks will be tried on the device until the
> next array restart.
>
>
> Hot Replace
> -----------
>
> "Hot replace" is my name for the process of replacing one device in an
> array by another one without first failing the one device.  Thus there
> can be two devices in an array filling the same 'role'.  One device
> will contain all of the data, the other device will only contain some
> of it and will be undergoing a 'recovery' process.  Once the second
> device is fully recovered it is expected that the first device will be
> removed from the array.
>
> This can be useful whenever you want to replace a working device with
> another device, without letting the array go degraded.  Two obvious
> cases are:
>   1/ when you want to replace a smaller device with a larger device
>   2/ when you have a device with a number of bad blocks and want to
>      replace it with a more reliable device.
>
> For '2' to be realised, the bad block log described above must be
> implemented, so it should be completed before this feature.
>
> Hot replace is really only needed for RAID10 and RAID456.  For RAID1,
> simply increasing the number of devices in the array while the new
> device recovers, then failing the old device and decreasing the number
> of devices in the array is sufficient.
>
> For RAID0 or LINEAR it would be sufficient to:
>   - stop the array
>   - make a RAID1 without superblocks for the old and new device
>   - re-assemble the array using the RAID1 in place of the old device.
>
> This is certainly not as convenient but is sufficient for a case that
> is not likely to be commonly needed.
>
> So for both the RAID10 and RAID456 modules we need:
>   - the ability to add a device as a hot-replace device for a specific
>     slot
>   - the ability to record hot-spare status in the metadata.
>   - a 'recovery' process to rebuild a device, preferably only reading
>     from the device to be replaced, though reading from elsewhere when
>     needed
>   - writes to go to both primary and secondary device.
>   - Reads to come from either if the second has recovered far enough.
>   - to promote a secondary device to primary when the primary device
>     (that has a hot-replace device) fails.
>
> It is not clear whether the primary should be automatically failed
> when the rebuild of the secondary completes.  Commonly this would be
> ideal, but if the secondary experienced any write errors (that were
> recorded in the bad block log) then it would be best to leave both in
> place until the sysadmin resolves the situation.   So in the first
> implementation this failing should not be automatic.
>
> The identification of a spare as a 'hot-replace' device is achieved
> through the 'md/dev-XXXX/slot' sysfs attribute.  This is usually
> 'none' or a small integer identifying which slot in the array is
> filled by this device.  A number followed by a plus (e.g. '1+') is
> written, then the device takes the role of a hot-spare.  This syntax
> requires there be at most one hot spare per slot.  This is a
> deliberate decision to manage complexity in the code.  Allowing more
> would be of minimal value but require substantial extra complexity.
>
> v0.90 metadata is not supported.  v1.x sets a 'feature bit' on the
> superblock of any 'hot-replace' device and naturally records in
> 'recover_offset' how far recovery has progressed.  Externally managed
> metadata can support this, or not, as they choose.
>
>
> Reversible Reshape
> ------------------
>
> It is possible to start a reshape that cannot be reversed until the
> reshape has completed.  This is occasionally problematic.  While we
> might hope that users would never make errors, we should try to be as
> forgiving as possible.
>
> Reversing a reshape that changes the number of data-devices is
> possible as we support both growing and shrinking and these happen in
> opposite directions so one is the reverse of the other.  Thus at worst,
> such a reshape can be reversed by:
>   - stopping the array
>   - re-writing the metadata so it looks like the change is going in the
>     other direction
>   - restarting the array.
>
> However for a reshape that doesn't change the number of data devices,
> such as a RAID5->RAID6 conversion or a change of chunk-size, reversal
> is currently not possible as the change always goes in the same
> direction.
>
> This is currently only meaningful for RAID456, though at some later
> date it might be relevant for RAID10.
>
> A future change will make it possible to move the data_offset while
> performing a reshape, and that will sometimes require the reshape to
> progress in a certain direction.  It is only when the data_offset is
> unchanged and the number of data disks is unchanged that there is any
> doubt about direction.  In that case it needs to be explicitly stated.
>
> We need:
>   - some way to record in the metadata the direction of the reshape
>   - some way to ask for a reshape to be started in the reverse
>     direction
>   - some way to reverse a reshape that is currently happening.
>
> We have a new sysfs attribute "reshape_direction" which is
> "low-to-high" or "high-to-low".  This defaults to "low-to-high" but
> will be force to "high-to-low" if the particular reshape requires it,
> or can be explicity set by a 'write' before the reshape commences.
>
> Once the reshape has commenced, writing a new value to this field can
> flip the reshape causing it to be reverted.
>
> In both v0.90 and v1.x metadata we record a reversing reshape by
> setting the most significant bit in reshape_position.  For v0.90 we
> also increase the minor number to 91.  For v1.x we set a feature bit
> as well.
>
>
> Change data offset during reshape
> ---------------------------------
>
> One of the biggest problems with reshape currently is the need for the
> backup file.  This is a management problem as it cannot easily be
> found at restart, and it is a performance problem as the extra writing
> is expensive.
>
> In some cases we can avoid the need for a backup file completely by
> changing the data-offset.  i.e. the location on the devices where the
> array data starts.
>
> For reshapes that increase the number of devices, only a single backup
> is required at the start.  If the data_offset is moved just one chunk
> earlier we can do without a separate backup.  This obviously requires
> that space was left when the array was first created.  Recent versions
> of mdadm do leave some space with the default metadata, though more
> would probably be good.
>
> For reshapes that decrease the number of device, only a small backup
> is required right at the end of the process (at the beginning of the
> devices).  If we move the data_offset forward by one chunk that backup
> too can be avoided.  As we are normally reducing the size of the array
> in this process, we just need to reduce it a little bit more.
>
> For reshapes that neither increase of decrease the number of devices a
> somewhat larger change in data_offset is needed to get reasonable
> performance.  A single chunk (of the larger chunk size) would work,
> but would require updating the metadata after each chunk which would
> be prohibitively slow unless chunks were very large.  A few megabytes
> is probably sufficient for reasonable performance, though testing
> would be helpful to be sure.  Current mdadm leaves no space at the
> start of 1.0, and about 1Meg at the start of 1.1 and 1.2 arrays.
>
> This will generally not be enough space.  In these cases it will
> probably be best to perform the reshape in the reverse direction
> (helped by the previous feature).  This will probably require
> shrinking the filesystem and the array slightly first.  Future
> versions of mdadm should aim to leave a few metabytes free at start
> and end to make these reshapes work better.
>
> Moving the data offset is not possible for 0.90 metadata as it does
> not record a data offset.
>
> For 1.x metadata it is possible to have a different data_offset on
> each device.  However for simplicity we will only support changing the
> data offset by the same amount on each device.  This amount will be
> stored in currently-unused space in the 1.x metadata.  There will be a
> sysfs attribute "delta_data_offset" which can be set to a number of
> sectors - positive or negative - to request a change in the data
> offset and thus avoid the need for a backup file.
>
>
> Bitmap of non-sync regions.
> ---------------------------
>
> There are a couple of reasons for having regions of an array that are known
> not to contain important data and are known to not necessarily be
> in-sync.
>
> 1/ When an array is first created it normally contains no valid data.
>     The normal process of a 'resync' to make all parity/copies correct
>     is largely a waste of time.
> 2/ When the filesystem uses a "discard" command to report that a
>     region of the device is no-longer used it would be good to be able
>     to pass this down to the underlying devices.  To do this safely we
>     need to record at the md level that the region is unused so we
>     don't complain about inconsistencies and don't try to re-sync the
>     region after a crash.
>
> If we record which regions are not in-sync in a bitmap then we can meet
> both of these needs.
>
> A read to a non-in-sync region would always return 0s.
> A 'write' to a non-in-sync region should cause that region to be
> resynced.  Writing zeros would in some sense be ideal, but to do that
> we would have to block the write, which would be unfortunate.  As the
> fs should not be reading from that area anyway, it shouldn't really
> matter.
>
> The granularity of the bit is probably quite hard to get right.
> Having it match the block size would mean that no resync would be
> needed and that every discard request could be handled exactly.
> However it could result in a very large bitmap - 30 Megabytes for a 1
> terabyte device with a 4K block size.  This would need to be kept in
> memory and looked up for every access, which could be problematic.
>
> Having a very coarse granularity would make storage and lookups more
> efficient.  If we make sure the bitmap would fit in 4K, we would have
> about 32 megabytes for bit.  This would mean that each time we
> triggered a resync it would resync for a second or two which is
> probably a reasonable time as it wouldn't happen very often.  But it
> would also mean that we can only service a 'discard' request if it
> covers whole blocks of 32 megabytes, and I really don't know how
> likely that is.  Actually I'm not sure if anyone knows, the jury seems
> to still be out on how 'discard' will work long-term.
>
> So probably aiming for a few K to a few hundred K seems reasonable.
> That means that the in-memory representation will have to be a
> two-level array.  A page of pointers to other pages can cover (on a
> 64bit system) 512 pages or 2Meg of bitmap space which should be
> enough.
>
> As always we need a way to:
>   - record the location and size of the bitmap in the metadata
>   - allow the granularity to be set via sysfs
>   - allow bits to be set via sysfs, and allow the current bitmap to
>     be read via sysfs.
>
> For v0.90 metadata we won't support this as there is no room.  We
> could possibly store about 32 bytes directly in the superblock
> allowing for 4Gig sections but this is unlikely to be really useful.
>
> For v1.x metadata we use 8 bytes from the 'array state info'.  4 bytes
> give an offset from the metadata of the start of the bitmap, 2 bytes
> give the space reserved for the bitmap (max 32Meg) and 2 bytes give a
> shift value from sectors to in-sync chunks.  The actual size of the
> bitmap must be computed from the known size of the array and the size
> of the chunks.
>
> We present the bitmap in sysfs similar to the way we present the bad
> block list.  A file 'non-sync/regions' contains start and size of regions
> (measured in sectors) that are known to not be in-sync.  A file
> 'non-sync/now-in-sync' lists ranges that actually are in sync but have not been
> recorded in non-in-sync yet.  User-space reads now-in-sync', updates
> the metadata, and write to 'regions'.
>
> Another file 'non-sync/to-discard' lists ranges for a which a discard
> request has been made.  These need to be recorded in the metadata.
> They are then written back to the file which allows the discard
> request to complete.
>
> The granularity can be set via sysfs by writing to
> 'non-sync/chunksize'.
>
>
> Assume-clean when increasing array --size
> -----------------------------------------
>
> When a RAID1 is created, --assume-clean can be given so that the
> largely-unnecessary initial resync can be avoided.  When extending the
> size of an array with --grow --size=, there is no way to specify
> --assume-clean.
>
> If a non-sync bitmap (see above) is configured this doesn't matter
> that the extra space will simply be marked as non-in-sync.
> However if a non-sync bitmap is not supported by the metadata or is
> not configured it would be good if md/raid1 can be told not to sync
> the extra space - to assume that it is in-sync.
>
> So when a non-sync bitmap is not configured (the chunk-size is zero),
> writing to the non-sync/regions file tells md that we don't care about the
> region being in-sync.  So the sequence:
>   - freeze sync_action
>   - update size
>   - write range to non-sync/regions
>   - unfreeze sync_action
>
> will effect a "--grow --size=bigger --assume-clean" reshape.
>
>
> Enable 'reshape' to also perform 'recovery'.
> --------------------------------------------
>
> As a 'reshape' re-writes all the data in the array it can quite easily
> be used to recover to a spare device.  Normally these two operations
> would happen separately.  However if a device fails during a reshape
> and a spare is available it makes sense to combine them.
>
> Currently if a device fails during a reshape (leaving the array
> degraded but functional) the reshape will continue and complete.  Then
> if a spare is available it will be recovered.  This means a longer
> total time until the array is optimal.
>
> When the device fails, the reshape actually aborts, and the restarts
> from where it left off.  If instead we allow spares to be added
> between the abort and the restart, and cause the 'reshape' to actually
> do a recovery until it reaches the point where it was already up to,
> then we minimise the time to getting an optimal array.
>
>
> When reshaping an array to fewer devices, allow 'size' to be increased
> --------------------------------------------------------------------
>
> The 'size' of an array is the amount of space on each device which is
> used by the array.  Normally the 'size' of an array cannot be set
> beyond the amount of space available on the smallest device.
>
> However when reshaping an array to have fewer devices it can be useful
> to be able to set the 'size' to be the smallest of the remaining
> devices - those that will still be in use after the reshape.
>
> Normally reshaping an array to have fewer devices will make the array
> size smaller.  However if we can simultaneously increase the size of
> the remaining devices, the array size can stay unchanged or even grow.
>
> This can be used after replacing (ideally using hot-replace) a few
> devices in the array with larger devices.  The net result will be a
> similar amount of storage using few drives, each larger than before.
>
> This should simply be a case of allowing size to be set larger when
> delta_disks is negative.  It also requires that when converting the
> excess device to spares, we fail them if they are smaller than the new
> size.
>
> As a reshape can be reversed, we must make sure to revert the size
> change when reversing a reshape.
>
> Allow write-intent-bitmap to be added to an array during reshape/recovery.
> --------------------------------------------------------------------------
>
> Currently it is not possible to add a write-intent-bitmap to an array
> that is being reshaped/resynced/recovered.  There is no real
> justification for this, it was just easier at the time.
>
> Implementing this requires a review of all code relating to the
> bitmap, checking that a bitmap appearing - or disappearing - during
> these processes will not be a problem.  As the array is quiescent when
> the bitmap is added, no IO will actually be happening so it *should*
> be safe.
>
> This should also allow a reshape to be started while a bitmap is
> present, as long as the reshape doesn't change the implied size of the
> bitmap.
>
> Support resizing of write-intent-bitmap prior to reshape
> --------------------------------------------------------
>
> When we increase the 'size' of an array (the amount of the device
> used), that implies a change in size of the bitmap.  However the
> kernel cannot unilaterally resize the bitmap as there may not be room.
>
> Rather, mdadm needs to be able to resize the bitmap first.  This
> requires the sysfs interface to expose the size of the bitmap - which
> is currently implicit.
>
> Whether the bitmap coverage is increased by increasing the number of
> bits or increasing the chunk size, some updating of the bitmap storage
> will be necessary (particularly in the second case).
>
> So it makes sense to allow user-space to remove the bitmap then add a
> new bitmap with a different configuration.  If there is concern about
> a crash between these two, writes could be suspended for the (short)
> duration.
>
> Currently the 'sync_size' stored in the bitmap superblock is not used.
> We could stop updating that, and could allow the bitmap to
> automatically extend up to that boundary.
>
> So: we have a well defined 'sync_size' which can be set via the
> superblock or via sysfs.  A resize is permitted as long as there is no
> bitmap, or the existing bitmap has a sufficiently large sync_size.
>
> Support reshape of RAID10 arrays.
> ---------------------------------
>
> RAID10 arrays currently cannot be reshaped at all.  It is possible to
> convert a 'near' mode RAID10 to RAID0, but that is about all.   Some
> real reshape is possible and should be implemented.
>
> 1/ A 'near' or 'offset' layout can have the device size changed quite
>     easily.
>
> 2/ Device size of 'far' arrays cannot be changed easily.  Increasing device
>     size of 'far' would require re-laying out a lot of data.  We would
>     need to record the 'old' and 'new' sizes which metadata doesn't
>     currently allow.  If we spent 8 bytes on this we could possibly
>     manage a 'reverse reshape' style conversion here.
>
> 3/ Increasing the number of devices is much the same for all layouts.
>     The data needs to be copied to the new location.  As we currently
>     block IO while recovery is actually happening, we could just do
>     that for reshape as well, and make sure reshape happens in whole
>     chunks at a time (or whatever turns out to be the minimum
>     recordable unit).  We switch to 'clean' before doing any reshape so
>     a write will switch to 'dirty' and update the metadata.
>
> 4/ decreasing the number of devices is very much the reverse of
>     increasing..
>     Here is a weird thought:  We have introduced the idea that we can
>     increase the size of remaining devices when we decrease the number
>     of devices in the array.  For 'raid10-far', the re-layout for
>     increasing the device size is very much like that for decreasing
>     the number of devices - just that the number doesn't actually
>     decrease.
>
> 5/ changing layouts between 'near' and 'offset' should be manageable
>     providing enough 'backup' space is available.  We simply copy
>     a few chunks worth of data and move reshape_position.
>
> 6/ changing layout to or from 'far' is nearly impossible...
>     With a change in data_offset it might be possible to move one
>     stripe at a time, always into the place just vacated.
>     However keeping track of where we are and were it is safe to read
>     from would be a major headache - unless it feel out with some
>     really neat maths, which I don't think it does.
>     So this option will be left out.
>
>
> So the only 'instant' conversion possible is to increase the device
> size for 'near' and 'offset' array.
>
> 'reshape' conversions can modify chunk size, increase/decrease number of
> devices and swap between 'near' and 'offset' layout providing a
> suitable number of chunks of backup space is available.
>
> The device-size of a 'far' layout can also be changed by a reshape
> providing the number of devices in not increased.
>
>
> Better reporting of inconsistencies.
> ------------------------------------
>
> When a 'check' finds a data inconsistency it would be useful if it
> was reported.   That would allow a sysadmin to try to understand the
> cause and possibly fix it.
>
> One simple approach would be to simply log all inconsistencies through
> the kernel logs.  This would have to be limited to 'check' and
> possibly 'repair' passed as logging a 'sync' pass (which also find
> inconsistencies) can be expected to be very noisy.
>
> Another approach is to use a sysfs file to export a list of
> addresses.  This would place some upper limit on the number of
> addresses that could be listed, but if there are more inconsistencies
> than that limit, then the details probably aren't all that important.
>
> It makes sense to follow both of these paths.
>   - some easy-to-parse logging of inconsistencies found.
>   - a sysfs file that lists as many inconsistencies as possible.
>
> Each inconsistency is listed as a simple sector offset.  For RAID1 and
> RAID4/5/6, it is an offset from the start of data on the individual devices.  For
> RAID1 and RAID10 it is an offset from the start of the array.  So this
> can only be interpreted with a full understanding of the array layout.
>
> The actual inconsistency may be in some sector immediately following
> the given sector as md performs checks in blocks larger than one
> sector and doesn't both refining.   So an process that uses this
> information should read forward from the address to make sure it has
> found all of the inconsistency.  For striped array, at most 1 chunk
> need be examined.  For non-striped (i.e. RAID1) the window size is
> currently 64K.  The actual size can be found by dividing
> 'mismatch_cnt' by the number of entries in the mismatch list.
>
> This has no dependencies on other features.  It relates slightly to
> the bad-block list as one way of dealing with an inconsistency is to
> tell md that a selected block in the stripe is 'bad'.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

