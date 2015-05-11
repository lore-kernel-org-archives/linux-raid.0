From: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH 0/5] a caching layer for raid 5/6
Date: Mon, 11 May 2015 09:03:51 -0700
Message-ID: <20150511160349.GA545551@devbig257.prn2.facebook.com>
References: <cover.1430954848.git.shli@fb.com>
 <20150511122347.GA5082@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150511122347.GA5082@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

On Mon, May 11, 2015 at 05:23:47AM -0700, Christoph Hellwig wrote:
> Hi Shaohua,
>=20
> here are a couple of notes from reading through the code in a bit mor=
e
> detail:
>=20

Thanks for your time.
> Error retries:
>   - What is the reason for retry_bio_list?  If a driver returns an
>     I/O error to the higher levels it already has retried and came
>     to the conclusion this is a permanent error.

The retry_bio_list is to handle io to cache disk. If IO to cache disk
has error, it's not a permanent error here. The cache disk is a cache,
We can still dispatch the IO to its final destination, the raid disks.

> Flushes:
>   - no need to allocate a task here
>   - no real need to clone the bio either

clone the bio makes the IO retry easier.

> Tasks:
>   - the completion argument passed to r5l_queue_bio is always the sam=
e,
>     the code would be a lot simpler by removing this abstraction.
>   - that would also allow allocating the task embedded in the range
>     and cut down on memory allocations

Yep, my original idea is the stuff handling caching (r5c*) doesn't need
to know the detail of log device. I'll look this again to check if this
is a over-design.
>   - we're not really manipulating the bio payload, so shouldn't a
>     _fast cone be fine here?
>     In fact why do we clone the bio at all?

The cache disk drive might manipulate the bio payload. The problem is
really why we clone the bio. You are right we don't need to clone the
bio at normal case. The exception is IO error. IO to the cache disk can
fail. In that case, we will try to skip cache disk and dispatch IO to
raid disks directly, which is the retry. Since cache disk driver might
already manipulate the bio, cloning a bio makes retry easier.

>   - r5l_queue_task should probably be split into two helpers
>     for data vs parity
>   - r5l_queue_bio and r5c_copy_bio should probably use bvec iterators
>   - r5l_run_task does very different things for data vs metadata,
>     it's proably better it.

I'll check these.
>=20
> Allocations:
>   - most metadata pages are allocated as highmem leading to
>     constant kmap/kunmap.  Maybe just allocate them as GFP_KERNEL
>     to simplify things?

Sounds good.
> Misc:
>   - where does the ioctl in r5l_ioctl an=D1=95 associated functions c=
ome
>     from?  There are not ioctls handler here so the naming seems
>     rather confusing.

Ah, it manages an io really, I'll change a name.

Thanks,
Shaohua
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
