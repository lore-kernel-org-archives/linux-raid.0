From: Boaz Harrosh <boaz@plexistor.com>
Subject: Re: [Linux-nvdimm] [RFC PATCH 0/7] evacuate struct page from the
 block layer
Date: Sun, 22 Mar 2015 13:53:21 +0200
Message-ID: <550EAD31.8030505@plexistor.com>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com> <550957B9.5050803@gmail.com> <20150318130641.GD4003@linux.intel.com> <55098DFE.8080502@plexistor.com> <550C4318.8010200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <550C4318.8010200@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Rik van Riel <riel@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Boaz Harrosh <openosd@gmail.com>
Cc: axboe@kernel.dk, linux-arch@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@ml01.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, hch@infradead.org, Linus Torvalds <torvalds@osdl.org>, Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, mgorman@suse.de
List-Id: linux-raid.ids

On 03/20/2015 05:56 PM, Rik van Riel wrote:
> On 03/18/2015 10:38 AM, Boaz Harrosh wrote:
>> On 03/18/2015 03:06 PM, Matthew Wilcox wrote:
> 
>>>> I'm not the one afraid of hard work, if it was for a good cause, but for what?
>>>> really for what? The block layer, and RDMA, and networking, and spline, and what
>>>> ever the heck any one wants to imagine to do with pmem, already works perfectly
>>>> stable. right now!
>>>
>>> The overhead.  Allocating a struct page for every 4k page in a 400GB DIMM
>>> (the current capacity available from one NV-DIMM vendor) occupies 6.4GB.
>>> That's an unacceptable amount of overhead.
>>>
>>
>> So lets fix the stacks to work nice with 2M pages. That said we can
>> allocate the struct page also from pmem if we need to. The fact remains
>> that we need state down the different stacks and this is the current
>> design over all.
> 
> Fixing the stack to work with 2M pages will be just as invasive,
> and just as much work as making it work without a struct page.
> 
> What state do you need, exactly?
> 

It is not me that needs state it is the Kernel. Let me show you
what I can do now that uses state (and pages).

block layer sends a bio via iscsi, in turn it goes around and
sends it via networking stack. Here page-ref is used as well
as all kind of page based management. (This is half the Kernel
converted right here)
Same thing but iser & RDMA. Same thing to a null-target, via
the target stack, maybe via path-threw.

Another big example:
  At user-mode application I mmap a portion of pmem, I then
use the libvirt API to designate a named shared-memory object.
At vm I use the same API to retrieve a pointer to that pmem
region and boom, I'm persistent. (Same can be done between
two VMs)

mmap(pmem) send it to network, to encryption, direct_io
RDMA, anything copyless.

So many subsystem use page_lock page->lru page-ref and are
written to receive and manage pages. I do not like to be
excluded from these systems, and I would very much hate
to re-write them. block layer is an example.

> The struct page in the VM is mostly used for two things:
> 1) to get a memory address of the data
> 2) refcounting, to make sure the page does not go away
>    during an IO operation, copy, etc...
> 
> Persistent memory cannot be paged out so (2) is not a concern, as
> long as we ensure the object the page belongs to does not go away.
> There are no seek times, so moving it around may not be necessary
> either, making (1) not a concern.
> 

I lost you sorry. I'm not sure what you meant here?
Yes kmap/kunmap is mute. I do not see any use for highmem and
any 32bitness with this thing.

refcounting is used sure, even with pmem see above. Actually
relaying on refcounting existence can solve us some stuff at
the pmem management level, which exist today. (RDMA while truncate)

> The only case where (1) would be a concern is if we wanted to move
> data in persistent memory around for better NUMA locality. However,
> persistent memory DIMMs are on their way to being too large to move
> the memory, anyway - all we can usefully do is detect where programs
> are accessing memory, and move the programs there.
> 

So actually I have hands on experience with this very problem.
We have observed that NUMA kills us. Now going through memory_add_physaddr_to_nid()
loop for every 4k operation was a pain, but caching it on page_to_nid()
(As part of flags in 64bit) is very nice optimization, we do NUMA aware block
allocation and it preforms much better. (Never like a single node but magnitude
better then without)

> What state do you need that is not already represented?
> 

Most of these subsystem you guys are focused on it is mostly read-only
state. Except page-ref. But never the less the page has added information
describing the pfn. Like nid mapping->ops flags etc ...

And it is also a stop gap of translation.
give me a page I now the pfn and vaddr, give me a pfn I know page
give me a vaddr I know the page. So I can move between all these domains.

Now I am sure that in hindsight we might have devised better structures
and abstractions that could carry all this information in a more abstract
and convenient way, throughout the Kernel. But for now this basic object
is a page and is passed around like in a relay-race. Each subsystem with
its own page based meta-structure. The only real global token is
page-struct.

You are saying: "not already represented" ? I'm saying exactly, sir
it is already represented as a page-struct. Anything else is in the
far far future. (if at all)

> 1.5% overhead isn't a whole lot, but it appears to be unnecessary.
> 

unnecessary, in a theoretical future with every single Kernel
subsystem changed (maybe for the better I'm not saying). And this
future is not even at all clear what it is.

But for current code structure it is very much necessary. For the
very long present days, it is not 1.5% with or without. It is
need-to-copy or direct(-1.5%)

[For me it is not even the performance of a memcpy which exacly halves
 my pmem performance, it is the latency and the extra nightmare locking
 and management to keep in sync two copies of the same thing]

> If you have a convincing argument as to why we need a struct page,
> you might want to articulate it in order to convince us.
> 

The must simple convincing argument there is. "Existing code". Apparently
page was needed, maybe we can all think of much better constructs. But
for now this is what the Kernel is based on. Until such time that we
better it it is there.

Since when we refrain from new technologies and new fixtures because
"A major cleanup is needed". I'm all for all the great 
"change-every-file in Kernel" ideas some guys have, but while at it
also change the small patch I added to support pmem.

For me pmem is now, at clients systems. and I chose direct(-1.5%)
over need-to-copy. Because it gives me the performance, and most
important, latency that sales my products. What is your timetable?

Cheers
Boaz

