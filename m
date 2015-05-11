From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/5] a caching layer for raid 5/6
Date: Mon, 11 May 2015 05:23:47 -0700
Message-ID: <20150511122347.GA5082@infradead.org>
References: <cover.1430954848.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1430954848.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Hi Shaohua,

here are a couple of notes from reading through the code in a bit more
detail:


Error retries:
  - What is the reason for retry_bio_list?  If a driver returns an
    I/O error to the higher levels it already has retried and came
    to the conclusion this is a permanent error.

=46lushes:
  - no need to allocate a task here
  - no real need to clone the bio either

Tasks:
  - the completion argument passed to r5l_queue_bio is always the same,
    the code would be a lot simpler by removing this abstraction.
  - that would also allow allocating the task embedded in the range
    and cut down on memory allocations
  - we're not really manipulating the bio payload, so shouldn't a
    _fast cone be fine here?
    In fact why do we clone the bio at all?
  - r5l_queue_task should probably be split into two helpers
    for data vs parity
  - r5l_queue_bio and r5c_copy_bio should probably use bvec iterators
  - r5l_run_task does very different things for data vs metadata,
    it's proably better it.

Allocations:
  - most metadata pages are allocated as highmem leading to
    constant kmap/kunmap.  Maybe just allocate them as GFP_KERNEL
    to simplify things?

Misc:
  - where does the ioctl in r5l_ioctl an=D1=95 associated functions com=
e
    from?  There are not ioctls handler here so the naming seems
    rather confusing.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
