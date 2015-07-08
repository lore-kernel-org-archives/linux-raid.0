From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH V4 00/13] MD: a caching layer for raid5/6
Date: Wed, 8 Jul 2015 11:56:36 +1000
Message-ID: <20150708115636.6c972269@noble>
References: <cover.1435094582.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1435094582.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids


Hi,
 I made some time to look at these this morning - sorry for the delay.

 Having it all broken down with more complete comments helps a lot -
 thanks.

 Unfortunately ... it helps confirm that I really don't like this.  It
 seems much more complex that it should be.  There certainly are a lot
 of details that need to be carefully considered, but the result needs
 to be simpler.

 A big part of my concern is that you choose to avoid making proper use
 of the current stripe cache.  Your argument is that it is already
 too complex.  That is probably true but I don't think you decrease
 total complexity by adding extra bits on the side that themselves are
 complex in completely different ways.

 I would like to start small and keep it as simple as possible.  I
 think the minimum useful functionality is closing the write-hole.
 Anything else could be done outside raid5 (e.g. bcache), but the
 write-hole needs integration.  Once that is closed, it may make sense
 to add more functionality.

 To do that we need a log, and it was quite sensible for you to put
 that first in the list of patches.  So let's start with that.

 I would like to propose a single metadata block format.  This block
 includes the general RAID5 parameters (both 'old' and 'new' for when a
 reshape is happening), it includes linkage to find nearby metadata.
 It includes a list of the data written after the metadata.  And it
 includes a list of device-addresses of parity blocks which are now safe
 on the RAID and so any log content is now ignored.

 The general mechanism for writing to the log is:
   - collect a list of bios.  As each arrives update the metadata
     block with index information.
   - when ready (there are various triggers) write the metadata block
     with FLUSH/FUA and write all the data blocks normally.  This
     metadata block plus data/parity blocks is a 'transaction'.

 We never trigger a log transaction until all writes for the previous
 transaction have completed. This means that once the metadata block is
 safe, all previous data must also be safe.  If this imposes too much
 waiting we could allow a "double-buffer" approach were each metadata
 block completes the previous-but-one transaction.

 When all of the previous writes complete we trigger a new log write
 if there is an outstanding SYNC write, or maybe an outstanding
 FLUSH/FUA, but otherwise we wait until the metadata block is full, or
 some amount of time has passed.

 This one metadata block serves all of the purposes that you
 identified.  It records where data is, it commits previous writes, and
 records which stripes are being written to RAID and which have been
 fully committed.

 With that log in place, we add the code to "hijack ops_run_io" to
 write all dirty blocks from the stripe_head to the cache.  This
 includes the parity of course.  Immediately that data is safe the
 write requests can be returned and the data is written the the RAID
 devices.

 "Recovery" at boot time simply involves:
  1. find and load first metadata block
  2. load the "next" metadata block. If it doesn't exist, stop.
  3. For each parity/data block listed in current block, get the
     stripe_head and read the block in.
  4. For each completed stripe listed, find the stripe_head and
     invalidate it.
  5. Make the "next" metadata block the current block and goto 2
  6. Flush out all dirty data in stripe cache.


 I think that all of this *needs* to use the stripe_cache.
 Intercepting normal processing between party computation and writing
 to the RAID devices must involve the stripe_cache.

 So this is a "simple" start.   Once this is written and agreed and
 tested and debugged, then we can look at the latency-hiding side of
 the cache.  I think this should still use the stripe_cache - just
 schedule the writes to the log a bit earlier.
 If a case can be made for a separate cache then I'm not completely
 closed to the idea but I don't really want to think about it until the
 write-hole closing code is done.

So:
  [PATCH V4 01/13] MD: add a new disk role to present cache device
    probably OK
  [PATCH V4 02/13] raid5: directly use mddev->queue
    OK
  [PATCH V4 03/13] raid5: cache log handling
    strip this down to a bare minimum.  It needs:
      -on-disk metadata block format
      -two or three active transactions which identify a list of bios
       that are currently in the stripe cache.  As the bio is added,
       its address info is added to the metadata block.
      -interface to "add a bio to a transaction" and "record a
       completed stripe".
      -timer flush the current transaction if previous one was not
       empty.

     I don't think there needs to be a separate superblock in the log.
     Each device in the array already has an 'md' superblock.  Use e.g
     the 'recovery_offset' field in there (which is per-device and
     meaningless for a log) to store the address of the most recent
     metadata blocks at the time the superblock was written.  Search
     forward and backward from there to find whole log.  Each metadata
     block holds everything else that might be useful.

  [PATCH V4 05/13] raid5: cache reclaim support
    Just want the "hijack ops_run_io" part of this so that when normal
    RAID5 processing wants to write a stripe, blocks get diverted to
    the log first and further processing of the stripe is delayed until
    those writes complete and the transaction is safe.

  [PATCH V4 08/13] raid5: cache recovery support
    Just load all the log into the stripe cache.


That should be much more manageable and would be a good start towards
getting all the functionality that you want.

Feel free to ask questions if I haven't explained things, or if you
want me to look over the metadata format or whatever.  I tend to answer
direct questions more quickly than I answer 100kB patchsets :-)

thanks,
NeilBrown


On Tue, 23 Jun 2015 14:37:50 -0700 Shaohua Li <shli@fb.com> wrote:

> Hi,
> 
> This is the V4 version of the raid5/6 caching layer patches. The patches add
> a caching layer for raid5/6. The caching layer uses a SSD as a cache for a raid
> 5/6. It works like the similar way of a hardware raid controller. The purpose
> is to improve raid performance (reduce read-modify-write) and fix write hole
> issue.
> 
> I split the patch to into smaller ones and hopefuly they are easier to
> understand. The splitted patches will not break bisect. Functions of main parts
> are divided well, though some data structures not.
> 
> I detached the multiple reclaim thread patch, the patch set is aimed to make
> basic logic ready, and we can improve performance later (as long as we can make
> sure current logic is flexible to have improvement space for performance).
> 
> Neil,
> 
> For the issue if flush_start block is required, I double checked it. You are
> right we don't really need it, the data/parity checksum stored in cache disk
> will guarantee data integrity, but we can't use a simple disk cache flush as
> there is ordering issue. So the flush_start block does increase overhead, but
> might not too much. I didn't delete it yet, but I'm open to do it.
> 
> Thanks,
> Shaohua
> 
> V4:
> -split patche into smaller ones
> -add more comments into code and some code cleanup
> -bug fixes in recovery code
> -fix the feature bit
> 
> V3:
> -make reclaim multi-thread
> -add statistics in sysfs
> -bug fixes
> 
> V2:
> -metadata write doesn't use FUA
> -discard request is only issued when necessary
> -bug fixes and cleanup
> 
> Shaohua Li (12):
>   raid5: directly use mddev->queue
>   raid5: cache log handling
>   raid5: cache part of raid5 cache
>   raid5: cache reclaim support
>   raid5: cache IO error handling
>   raid5: cache device quiesce support
>   raid5: cache recovery support
>   raid5: add some sysfs entries
>   raid5: don't allow resize/reshape with cache support
>   raid5: guarantee cache release stripes in correct way
>   raid5: enable cache for raid array with cache disk
>   raid5: skip resync if caching is enabled
> 
> Song Liu (1):
>   MD: add a new disk role to present cache device
> 
>  drivers/md/Makefile            |    2 +-
>  drivers/md/md.c                |   24 +-
>  drivers/md/md.h                |    4 +
>  drivers/md/raid5-cache.c       | 3755 ++++++++++++++++++++++++++++++++++++++++
>  drivers/md/raid5.c             |  176 +-
>  drivers/md/raid5.h             |   24 +
>  include/uapi/linux/raid/md_p.h |   79 +
>  7 files changed, 4016 insertions(+), 48 deletions(-)
>  create mode 100644 drivers/md/raid5-cache.c
> 

