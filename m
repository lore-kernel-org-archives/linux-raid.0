From: Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 0/7] evacuate struct page from the block layer
Date: Tue, 24 Mar 2015 12:57:51 -0400
Message-ID: <5511978F.6050100@redhat.com>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com> <20150318132650.3336261c58829f49a9af8675@linux-foundation.org> <20150319134313.GF4003@linux.intel.com> <550C490E.1080708@redhat.com> <550EE4FE.1070009@plexistor.com> <55102EEB.2090401@redhat.com> <55113151.7090304@plexistor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55113151.7090304@plexistor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>, Matthew Wilcox <willy@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, axboe@kernel.dk, linux-nvdimm@ml01.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-raid@vger.kernel.org, mgorman@suse.de, hch@infradead.org, linux-fsdevel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
List-Id: linux-raid.ids

On 03/24/2015 05:41 AM, Boaz Harrosh wrote:
> On 03/23/2015 05:19 PM, Rik van Riel wrote:

>> There are two things going on here:
>>
>> 1) You want to keep using struct page for now, while there are
>>    subsystems that require it. This is perfectly legitimate.
>>
>> 2) Matthew and Dan are changing over some subsystems to no longer
>>    require struct page. This is perfectly legitimate.
>>
> 
> How is this legitimate when you need to Interface the [1] subsystems
> under the [2] subsystem? A subsystem that expects pages is now not
> usable by [2].
> 
> Today *All* the Kernel subsystems are [1] Period.

That's not true. In the graphics subsystem it is very normal to
mmap graphics memory without ever using a struct page. There are
other callers of remap_pfn_range() too.

In these cases, refcounting is done by keeping a refcount on the
entire object, not on individual pages (since we have none).

> How does it become
> legitimate to now start *two* competing, do the same differently, abstraction,
> in our kernel. We have two much diversity not to little.

We are already able to refcount either the whole object, or an
individual page.

One issue is that not every subsystem can do the whole object
refcounting, and that it would be nice to have the refcounting
done by one single interface.

If we want the code to be the same everywhere, we could achieve
that just as well with an abstraction as with a single data
structure.

Maybe even something as simplistic as these, with the internals
automatically taking and releasing a refcount on the proper object:

get_reference(file, memory_address)

put_reference(file, memory_address)

-- 
All rights reversed
