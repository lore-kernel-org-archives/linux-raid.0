From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC] md: make queue limits depending on limits of RAID members
Date: Thu, 30 Nov 2017 11:08:16 -0500
Message-ID: <yq1d13zg367.fsf@oracle.com>
References: <20171115102512.18269-1-mariusz.dabrowski@intel.com>
        <20171117184054.jmk6lks7dzxyyxgu@kernel.org>
        <0a8abe98-e24a-420d-e673-9bbbb47972b4@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <0a8abe98-e24a-420d-e673-9bbbb47972b4@intel.com> (Mariusz
        Dabrowski's message of "Wed, 22 Nov 2017 09:12:39 +0100")
Sender: linux-block-owner@vger.kernel.org
To: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Cc: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, martin.petersen@oracle.com, linux-block@vger.kernel.org
List-Id: linux-raid.ids


Mariusz,

>>> One potential solution for that is to change type of some queue limits
>>> (at least discard_granularity and discard_alignment, maybe more, like
>>> max_discard_sectors?) from 32 bits to 64 bits.

You're still restricted by the max bio size which is 32 bits on 32-bit
platforms.

> Let me give you an example with io_min (it works also for other params):
> We've got RAID 0 with 2 disks and 32KiB chunk size. Each member disk
> reports io_min=64KiB. blk_stack_limits takes max value from set of chunk
> size and members io_min
> 	t->io_min = max(t->io_min, b->io_min);
> so new array's io_min will be equal to 64KiB. Such request will be split
> for both array members, each device will get 32KiB request and it is not
> enough for them to meet minimum io size requirement.

When this was written, there was a clear benefit giving priority to the
MD/DM topology over any values reported by the hardware.

I.e. the performance was much better when honoring the MD stripe chunk
and stripe size over any values reported by the underlying devices. This
was true for both disk drives and RAID devices that reported the
relevant issues.

That's why the stacking works the way it does.

For your particular example, I'd say that if your device reports an
io_min of 64KB, then it's a user error to create an MD device with a
stripe chunk of 32KB. mdadm should discourage creating such a
configuration.

-- 
Martin K. Petersen	Oracle Linux Engineering
