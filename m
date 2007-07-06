From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 0/2] raid5: 65% sequential-write performance improvement, stripe-queue take2
Date: Thu, 5 Jul 2007 18:56:22 -0700
Message-ID: <e9c3a7c20707051856q71667367j2c5dbef08269d99d@mail.gmail.com>
References: <20070703231838.17500.34505.stgit@dwillia2-linux.ch.intel.com>
	 <p73wsxg2y6x.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <p73wsxg2y6x.fsf@bingen.suse.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: neilb@suse.de, raziebe@gmail.com, akpm@linux-foundation.org, davidsen@tmr.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04 Jul 2007 13:41:26 +0200, Andi Kleen <andi@firstfloor.org> wrote:
> Dan Williams <dan.j.williams@intel.com> writes:
>
> > The write performance numbers are better than I expected and would seem
> > to address the concerns raised in the thread "Odd (slow) RAID
> > performance"[2].  The read performance drop was not expected.  However,
> > the numbers suggest some additional changes to be made to the queuing
> > model.
>
> Have you considered supporting copy-xor in MD for non accelerated
> RAID? I've been looking at fixing the old dubious slow crufty x86 SSE
> XOR functions.
Copy-xor is something that Neil suggested at the beginning of the
acceleration work.  It was put on the back-burner, but now that the
implementation has settled it can be revisited.

> One thing I discovered is that it seems fairly
> pointless to make them slower with cache avoidance when most of the data is
> copied before anyways. I think much more advantage could be gotten by
> supporting copy-xor because XORing during a copy should be nearly
> free.
>
Yes, it does not make sense to have cache-avoidance mismatched copy
and xor operations in MD.  However, I think the memcpy should be
changed to a cache-avoiding memcpy rather than caching the xor data.
Then a copy-xor implementation will have a greater effect, or do you
see it differently?

> On the other hand ext3 write() also uses a cache avoiding copy now
> and for the XOR it would need to load the data from memory again.
> Perhaps this could be also optimized somehow (e.g. setting a flag
> somewhere and using a normal copy for the RAID-5 case)
>
The incoming async_memcpy call has a flags parameter where this could go...

One possible way to implement support for copy-xor (and xor-copy-xor
for that matter) would be to write a soft-dmaengine driver.  When a
memcpy is submitted it can hold off processing it to see if an xor
operation is attached to the chain.  Once the xor descriptor is
attached the implementation will know the location of all the incoming
data, all the existing stripe data and the destination for the xor.

> -Andi

Dan
