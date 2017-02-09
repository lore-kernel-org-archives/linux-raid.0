From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH v3 5/9] raid5-ppl: Partial Parity Log write logging
 implementation
Date: Thu, 9 Feb 2017 16:35:34 +0100
Message-ID: <232777f2-d8e9-3d86-cb84-7285c90e5a6f@intel.com>
References: <20170130185953.30428-1-artur.paszkiewicz@intel.com>
 <20170130185953.30428-6-artur.paszkiewicz@intel.com>
 <20170207214225.3jenvleiz3tldzlx@kernel.org>
 <43b52cb7-b9d6-f615-d7c0-d78fdbb9a0cd@intel.com>
 <20170208053444.b4yfmahmlrjgvv7x@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170208053444.b4yfmahmlrjgvv7x@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com, jes.sorensen@gmail.com
List-Id: linux-raid.ids

On 02/08/2017 06:34 AM, Shaohua Li wrote:
> On Wed, Feb 08, 2017 at 12:58:42PM +0100, Artur Paszkiewicz wrote:
>> On 02/07/2017 10:42 PM, Shaohua Li wrote:
>>> On Mon, Jan 30, 2017 at 07:59:49PM +0100, Artur Paszkiewicz wrote:
>>>> This implements the PPL write logging functionality, using the
>>>> raid5-cache policy logic introduced in previous patches. The description
>>>> of PPL is added to the documentation. More details can be found in the
>>>> comments in raid5-ppl.c.
>>>>
>>>> Put the PPL metadata structures to md_p.h because userspace tools
>>>> (mdadm) will also need to read/write PPL.
>>>>
>>>> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
>>>> ---
>>>>  Documentation/admin-guide/md.rst |  53 ++++
>>>>  drivers/md/Makefile              |   2 +-
>>>>  drivers/md/raid5-cache.c         |  13 +-
>>>>  drivers/md/raid5-cache.h         |   8 +
>>>>  drivers/md/raid5-ppl.c           | 551 +++++++++++++++++++++++++++++++++++++++
>>>>  drivers/md/raid5.c               |  15 +-
>>>>  include/uapi/linux/raid/md_p.h   |  26 ++
>>>>  7 files changed, 661 insertions(+), 7 deletions(-)
>>>>  create mode 100644 drivers/md/raid5-ppl.c
>>>>
>>>> diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-guide/md.rst
>>>> index e449fb5f277c..7104ef757e73 100644
>>>> --- a/Documentation/admin-guide/md.rst
>>>> +++ b/Documentation/admin-guide/md.rst
>>>> @@ -86,6 +86,9 @@ superblock can be autodetected and run at boot time.
>>>>  The kernel parameter ``raid=partitionable`` (or ``raid=part``) means
>>>>  that all auto-detected arrays are assembled as partitionable.
>>>>  
>>>> +
>>>> +.. _dirty_degraded_boot:
>>>> +
>>>>  Boot time assembly of degraded/dirty arrays
>>>>  -------------------------------------------
>>>>  
>>>> @@ -176,6 +179,56 @@ and its role in the array.
>>>>  Once started with RUN_ARRAY, uninitialized spares can be added with
>>>>  HOT_ADD_DISK.
>>>>  
>>>> +.. _ppl:
>>>> +
>>>> +Partial Parity Log
>>>> +------------------
>>> Please put this part to a separate file under Documentation/md. The admin-guide
>>> is supposed to serve as a doc for user. The Documentation/md files will server
>>> as a doc for developer.
>>
>> OK, I will move it.
>>
>>>> +Partial Parity Log (PPL) is a feature available for RAID5 arrays. The issue
>>>> +addressed by PPL is that after a dirty shutdown, parity of a particular stripe
>>>> +may become inconsistent with data on other member disks. If the array is also
>>>> +in degraded state, there is no way to recalculate parity, because one of the
>>>> +disks is missing. This can lead to silent data corruption when rebuilding the
>>>> +array or using it is as degraded - data calculated from parity for array blocks
>>>> +that have not been touched by a write request during the unclean shutdown can
>>>> +be incorrect. Such condition is known as the ``RAID5 Write Hole``. Because of
>>>> +this, md by default does not allow starting a dirty degraded array, see
>>>> +:ref:`dirty_degraded_boot`.
>>>> +
>>>> +Partial parity for a write operation is the XOR of stripe data chunks not
>>>> +modified by this write. It is just enough data needed for recovering from the
>>>> +write hole. XORing partial parity with the modified chunks produces parity for
>>>> +the stripe, consistent with its state before the write operation, regardless of
>>>> +which chunk writes have completed. If one of the not modified data disks of
>>>> +this stripe is missing, this updated parity can be used to recover its
>>>> +contents. PPL recovery is also performed when starting an array after an
>>>> +unclean shutdown and all disks are available, eliminating the need to resync
>>>> +the array. Because of this, using write-intent bitmap and PPL together is not
>>>> +supported.
>>>> +
>>>> +When handling a write request PPL writes partial parity before new data and
>>>> +parity are dispatched to disks. PPL is a distributed log - it is stored on
>>>> +array member drives in the metadata area, on the parity drive of a particular
>>>> +stripe.  It does not require a dedicated journaling drive. Write performance is
>>>> +reduced by up to 30%-40% but it scales with the number of drives in the array
>>>> +and the journaling drive does not become a bottleneck or a single point of
>>>> +failure.
>>>> +
>>>> +Unlike raid5-cache, the other solution in md for closing the write hole, PPL is
>>>> +not a true journal. It does not protect from losing in-flight data, only from
>>>> +silent data corruption. If a dirty disk of a stripe is lost, no PPL recovery is
>>>> +performed for this stripe (parity is not updated). So it is possible to have
>>>> +arbitrary data in the written part of a stripe if that disk is lost. In such
>>>> +case the behavior is the same as in plain raid5.
>>>> +
>>>> +PPL is available for md version-1 metadata and external (specifically IMSM)
>>>> +metadata arrays. It can be enabled using mdadm option
>>>> +``--consistency-policy=ppl``.
>>>> +
>>>> +Currently, volatile write-back cache should be disabled on all member drives
>>>> +when using PPL. Otherwise it cannot guarantee consistency in case of power
>>>> +failure.
>>>
>>> The limitation is weird and dumb. Is this an implementation limitation which
>>> can be fixed later or a design limitation?
>>
>> This can be fixed later and I'm planning to do this. The limitation
>> results from the fact that partial parity is the xor of "old" data.
>> During recovery we xor it with "new" data and that produces valid
>> parity, assuming the "old" data has not changed after dirty shutdown.
>> But it's not necessarily true, since the "old" data might have been only
>> in cache and not on persistent storage. So fixing this will require
>> making sure the old data is on persistent media before writing PPL.
> 
> so it's the implementation which doesn't flush disk cache before writting new
> data to disks, right? That makes sense then. I think we should fix this soon.
> Don't think people will (or remember to) disable write-back cache before using
> ppl.
> 
>>>> diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
>>>> new file mode 100644
>>>> index 000000000000..6bc246c80f6b
>>>> --- /dev/null
>>>> +++ b/drivers/md/raid5-ppl.c
>>>> @@ -0,0 +1,551 @@
>>>> +/*
>>>> + * Partial Parity Log for closing the RAID5 write hole
>>>> + * Copyright (c) 2017, Intel Corporation.
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or modify it
>>>> + * under the terms and conditions of the GNU General Public License,
>>>> + * version 2, as published by the Free Software Foundation.
>>>> + *
>>>> + * This program is distributed in the hope it will be useful, but WITHOUT
>>>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>>>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>>>> + * more details.
>>>> + */
>>>> +
>>>> +#include <linux/kernel.h>
>>>> +#include <linux/blkdev.h>
>>>> +#include <linux/slab.h>
>>>> +#include <linux/crc32c.h>
>>>> +#include <linux/raid/md_p.h>
>>>> +#include "md.h"
>>>> +#include "raid5.h"
>>>> +#include "raid5-cache.h"
>>>> +
>>>> +/*
>>>> + * PPL consists of a 4KB header (struct ppl_header) and at least 128KB for
>>>> + * partial parity data. The header contains an array of entries
>>>> + * (struct ppl_header_entry) which describe the logged write requests.
>>>> + * Partial parity for the entries comes after the header, written in the same
>>>> + * sequence as the entries:
>>>> + *
>>>> + * Header
>>>> + *   entry0
>>>> + *   ...
>>>> + *   entryN
>>>> + * PP data
>>>> + *   PP for entry0
>>>> + *   ...
>>>> + *   PP for entryN
>>>> + *
>>>> + * Every entry holds a checksum of its partial parity, the header also has a
>>>> + * checksum of the header itself. Entries for full stripes writes contain no
>>>> + * partial parity, they only mark the stripes for which parity should be
>>>> + * recalculated after an unclean shutdown.
>>>> + *
>>>> + * A write request is always logged to the PPL instance stored on the parity
>>>> + * disk of the corresponding stripe. For each member disk there is one r5l_log
>>>> + * used to handle logging for this disk, independently from others. They are
>>>> + * grouped in child_logs array in struct ppl_conf, which is assigned to a
>>>> + * common parent r5l_log. This parent log serves as a proxy and is used in
>>>> + * raid5 personality code - it is assigned as _the_ log in r5conf->log.
>>>> + *
>>>> + * r5l_io_unit represents a full PPL write, meta_page contains the ppl_header.
>>>> + * PPL entries for logged stripes are added in ppl_log_stripe(). A stripe can
>>>> + * be appended to the last entry if the chunks to write are the same, otherwise
>>>> + * a new entry is added. Checksums of entries are calculated incrementally as
>>>> + * stripes containing partial parity are being added to entries.
>>>> + * ppl_submit_iounit() calculates the checksum of the header and submits a bio
>>>> + * containing the meta_page (ppl_header) and partial parity pages (sh->ppl_page)
>>>> + * for all stripes of the io_unit. When the PPL write completes, the stripes
>>>> + * associated with the io_unit are released and raid5d starts writing their data
>>>> + * and parity. When all stripes are written, the io_unit is freed and the next
>>>> + * can be submitted.
>>>> + *
>>>> + * An io_unit is used to gather stripes until it is submitted or becomes full
>>>> + * (if the maximum number of entries or size of PPL is reached). Another io_unit
>>>> + * can't be submitted until the previous has completed (PPL and stripe
>>>> + * data+parity is written). The log->running_ios list tracks all io_units of
>>>> + * a log (for a single member disk). New io_units are added to the end of the
>>>> + * list and the first io_unit is submitted, if it is not submitted already.
>>>> + * The current io_unit accepting new stripes is always the last on the list.
>>>> + */
>>>
>>> I don't like the way that io_unit and r5l_log are reused here. The code below
>>> shares very little with raid5-cache. There are a lot of fields in the data
>>> structures which are not used by ppl. It's not a good practice to share data
>>> structure like this way, so please define ppl its own data structure. The
>>> workflow between raid5 cache and ppl might be similar, but what we really need
>>> to share is the hooks to raid5 core.
>>
>> Reusing the structures seemed like a good idea at first, but now I must
>> admit you are right, especially since the structures were extended to
>> support write-back caching. One instance of r5l_log will still be
>> necessary though, to use for the hooks. Its private field will be used
>> for holding the ppl structures. Is that ok?
> 
> I'd prefer adding a 'void *log_private' in struct r5conf. raid5-cache and ppl
> can store whatever data in the log_private. And convert all callbacks to use a
> 'struct r5conf' parameter. This way raid5 cache and ppl don't need to share the
> data structure.

This way also 'struct r5l_policy *policy' will have to be moved from
r5l_log to r5conf. Maybe it will be better if instead of adding
log_private and moving this 'policy' field we add a dedicated field for
ppl in r5conf, something like 'struct ppl_conf *ppl', and eliminate
r5l_policy? From raid5 core we could just call corresponding functions
depending on which pointer is set (log or ppl). This way raid5-cache.c
won't have to be changed at all. It seems appropriate to separate
raid5-cache and ppl if they won't be sharing any data structures.

Thanks,
Artur
