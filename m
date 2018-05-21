From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 00/13] convert block layer to bioset_init()/mempool_init()
Date: Mon, 21 May 2018 08:36:46 -0600
Message-ID: <2bbeeb1a-8b99-b06a-eb9b-eb8523c16460@kernel.dk>
References: <20180520222558.7053-1-kent.overstreet@gmail.com>
 <20180521140348.GA19069@redhat.com>
 <686d7df6-c7d1-48a6-b7ff-48dc8aff6a62@kernel.dk>
 <20180521143132.GB19194@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180521143132.GB19194@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, hch@infradead.org, colyli@suse.de, darrick.wong@oracle.com, clm@fb.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids

On 5/21/18 8:31 AM, Mike Snitzer wrote:
> On Mon, May 21 2018 at 10:19am -0400,
> Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On 5/21/18 8:03 AM, Mike Snitzer wrote:
>>> On Sun, May 20 2018 at  6:25pm -0400,
>>> Kent Overstreet <kent.overstreet@gmail.com> wrote:
>>>
>>>> Jens - this series does the rest of the conversions that Christoph wanted, and
>>>> drops bioset_create().
>>>>
>>>> Only lightly tested, but the changes are pretty mechanical. Based on your
>>>> for-next tree.
>>>
>>> By switching 'mempool_t *' to 'mempool_t' and 'bio_set *' to 'bio_set'
>>> you've altered the alignment of members in data structures.  So I'll
>>> need to audit all the data structures you've modified in DM.
>>>
>>> Could we get the backstory on _why_ you're making this change?
>>> Would go a long way to helping me appreciate why this is a good use of
>>> anyone's time.
>>
>> Yeah, it's in the first series, it gets rid of a pointer indirection.
> 
> "Allows mempools to be embedded in other structs, getting rid of a
> pointer indirection from allocation fastpaths."
> 
> So this is about using contiguous memory or avoiding partial allocation
> failure?  Or both?
> 
> Or more to it?  Just trying to fully appreciate the theory behind the
> perceived associated benefit.

It's about avoiding a pointer indirection. Instead of having to
follow a pointer to get to that struct, it's simple offset math off
your main structure.

> I do think the increased risk of these embedded bio_set and mempool_t
> themselves crossing cachelines, or struct members that follow them doing
> so, really detracts from these types of changes.

Definitely something to look out for, though most of them should be
per-dev structures and not in-flight structures. That makes it a bit
less sensitive. But can't hurt to audit the layouts and adjust if
necessary. This is why it's posted for review :-)

-- 
Jens Axboe
