From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 2/7] block: convert bio_vec.bv_page to bv_pfn
Date: Tue, 17 Mar 2015 08:53:11 -0700
Message-ID: <CAPcyv4h=M19-ugydj0VN8RbNYyyMwYGLySujZXxUnef3J+_ftg@mail.gmail.com>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150316202537.33102.12944.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150316230533.GH29656@ZenIV.linux.org.uk>
	<20150317130254.GC4003@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150317130254.GC4003@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, riel@redhat.com, linux-nvdimm <linux-nvdimm@ml01.01.org>, Dave Hansen <dave.hansen@linux.intel.com>, linux-raid <linux-raid@vger.kernel.org>, mgorman@suse.de, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Mar 17, 2015 at 6:02 AM, Matthew Wilcox <willy@linux.intel.com> wrote:
> On Mon, Mar 16, 2015 at 11:05:33PM +0000, Al Viro wrote:
>> > diff --git a/mm/iov_iter.c b/mm/iov_iter.c
>> > index 827732047da1..be9a7c5b8703 100644
>> > --- a/mm/iov_iter.c
>> > +++ b/mm/iov_iter.c
>> > @@ -61,7 +61,7 @@
>> >     __p = i->bvec;                                  \
>> >     __v.bv_len = min_t(size_t, n, __p->bv_len - skip);      \
>> >     if (likely(__v.bv_len)) {                       \
>> > -           __v.bv_page = __p->bv_page;             \
>> > +           __v.bv_pfn = __p->bv_pfn;               \
>> >             __v.bv_offset = __p->bv_offset + skip;  \
>> >             (void)(STEP);                           \
>> >             skip += __v.bv_len;                     \
>> > @@ -72,7 +72,7 @@
>> >             __v.bv_len = min_t(size_t, n, __p->bv_len);     \
>> >             if (unlikely(!__v.bv_len))              \
>> >                     continue;                       \
>> > -           __v.bv_page = __p->bv_page;             \
>> > +           __v.bv_pfn = __p->bv_pfn;               \
>> >             __v.bv_offset = __p->bv_offset;         \
>> >             (void)(STEP);                           \
>> >             skip = __v.bv_len;                      \
>> > @@ -369,7 +369,7 @@ size_t copy_to_iter(void *addr, size_t bytes, struct iov_iter *i)
>> >     iterate_and_advance(i, bytes, v,
>> >             __copy_to_user(v.iov_base, (from += v.iov_len) - v.iov_len,
>> >                            v.iov_len),
>> > -           memcpy_to_page(v.bv_page, v.bv_offset,
>> > +           memcpy_to_page(bvec_page(&v), v.bv_offset,
>>
>> How had memcpy_to_page(NULL, ...) worked for you?
>
>  static inline struct page *bvec_page(const struct bio_vec *bvec)
>  {
> -       return bvec->bv_page;
> +       return pfn_to_page(bvec->bv_pfn.pfn);
>  }
>
> (yes, more work to be done here to make copy_to_iter work to a bvec that
> is actually targetting a page-less address, but these are RFC patches
> showing the direction we're heading in while keeping current code working)
>

Right, the next item to tackle is kmap() and kmap_atomic() before we
can start converting paths to be "native" pfn-only.
