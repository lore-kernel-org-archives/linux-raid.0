From: Rik van Riel <riel@redhat.com>
Subject: Re: [Linux-nvdimm] [RFC PATCH 0/7] evacuate struct page from the
 block layer
Date: Fri, 20 Mar 2015 11:56:08 -0400
Message-ID: <550C4318.8010200@redhat.com>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com> <550957B9.5050803@gmail.com> <20150318130641.GD4003@linux.intel.com> <55098DFE.8080502@plexistor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55098DFE.8080502@plexistor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>, Matthew Wilcox <willy@linux.intel.com>, Boaz Harrosh <openosd@gmail.com>
Cc: axboe@kernel.dk, linux-arch@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@ml01.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, hch@infradead.org, Linus Torvalds <torvalds@osdl.org>, Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, mgorman@suse.de
List-Id: linux-raid.ids

On 03/18/2015 10:38 AM, Boaz Harrosh wrote:
> On 03/18/2015 03:06 PM, Matthew Wilcox wrote:

>>> I'm not the one afraid of hard work, if it was for a good cause, but for what?
>>> really for what? The block layer, and RDMA, and networking, and spline, and what
>>> ever the heck any one wants to imagine to do with pmem, already works perfectly
>>> stable. right now!
>>
>> The overhead.  Allocating a struct page for every 4k page in a 400GB DIMM
>> (the current capacity available from one NV-DIMM vendor) occupies 6.4GB.
>> That's an unacceptable amount of overhead.
>>
> 
> So lets fix the stacks to work nice with 2M pages. That said we can
> allocate the struct page also from pmem if we need to. The fact remains
> that we need state down the different stacks and this is the current
> design over all.

Fixing the stack to work with 2M pages will be just as invasive,
and just as much work as making it work without a struct page.

What state do you need, exactly?

The struct page in the VM is mostly used for two things:
1) to get a memory address of the data
2) refcounting, to make sure the page does not go away
   during an IO operation, copy, etc...

Persistent memory cannot be paged out so (2) is not a concern, as
long as we ensure the object the page belongs to does not go away.
There are no seek times, so moving it around may not be necessary
either, making (1) not a concern.

The only case where (1) would be a concern is if we wanted to move
data in persistent memory around for better NUMA locality. However,
persistent memory DIMMs are on their way to being too large to move
the memory, anyway - all we can usefully do is detect where programs
are accessing memory, and move the programs there.

What state do you need that is not already represented?

1.5% overhead isn't a whole lot, but it appears to be unnecessary.

If you have a convincing argument as to why we need a struct page,
you might want to articulate it in order to convince us.

-- 
All rights reversed
