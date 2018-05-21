From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH 00/13] convert block layer to
	bioset_init()/mempool_init()
Date: Mon, 21 May 2018 08:52:10 -0600
Message-ID: <4b343aef-e11c-73ba-1d88-7e73ca838cad@kernel.dk>
References: <20180520222558.7053-1-kent.overstreet@gmail.com>
	<20180521140348.GA19069@redhat.com>
	<686d7df6-c7d1-48a6-b7ff-48dc8aff6a62@kernel.dk>
	<20180521143132.GB19194@redhat.com>
	<2bbeeb1a-8b99-b06a-eb9b-eb8523c16460@kernel.dk>
	<20180521144703.GA19303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <20180521144703.GA19303-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, colyli-l3A5Bk7waGM@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, neilb-IBi9RG/b67k@public.gmane.org, bacik-b10kYP2dOMg@public.gmane.org, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: linux-raid.ids

On 5/21/18 8:47 AM, Mike Snitzer wrote:
> On Mon, May 21 2018 at 10:36am -0400,
> Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org> wrote:
> 
>> On 5/21/18 8:31 AM, Mike Snitzer wrote:
>>> On Mon, May 21 2018 at 10:19am -0400,
>>> Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org> wrote:
>>>
>>>> On 5/21/18 8:03 AM, Mike Snitzer wrote:
>>>>> On Sun, May 20 2018 at  6:25pm -0400,
>>>>> Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>>
>>>>>> Jens - this series does the rest of the conversions that Christoph wanted, and
>>>>>> drops bioset_create().
>>>>>>
>>>>>> Only lightly tested, but the changes are pretty mechanical. Based on your
>>>>>> for-next tree.
>>>>>
>>>>> By switching 'mempool_t *' to 'mempool_t' and 'bio_set *' to 'bio_set'
>>>>> you've altered the alignment of members in data structures.  So I'll
>>>>> need to audit all the data structures you've modified in DM.
>>>>>
>>>>> Could we get the backstory on _why_ you're making this change?
>>>>> Would go a long way to helping me appreciate why this is a good use of
>>>>> anyone's time.
>>>>
>>>> Yeah, it's in the first series, it gets rid of a pointer indirection.
>>>
>>> "Allows mempools to be embedded in other structs, getting rid of a
>>> pointer indirection from allocation fastpaths."
>>>
>>> So this is about using contiguous memory or avoiding partial allocation
>>> failure?  Or both?
>>>
>>> Or more to it?  Just trying to fully appreciate the theory behind the
>>> perceived associated benefit.
>>
>> It's about avoiding a pointer indirection. Instead of having to
>> follow a pointer to get to that struct, it's simple offset math off
>> your main structure.
>>
>>> I do think the increased risk of these embedded bio_set and mempool_t
>>> themselves crossing cachelines, or struct members that follow them doing
>>> so, really detracts from these types of changes.
>>
>> Definitely something to look out for, though most of them should be
>> per-dev structures and not in-flight structures. That makes it a bit
>> less sensitive. But can't hurt to audit the layouts and adjust if
>> necessary. This is why it's posted for review :-)
> 
> This isn't something that is easily caught upfront.  Yes we can all be
> busy little beavers with pahole to audit alignment.  But chances are
> most people won't do it.
> 
> Reality is there is potential for a regression due to false sharing to
> creep in if a hot struct member suddenly starts straddling a cacheline.
> That type of NUMA performance killer is pretty insidious and somewhat
> tedious to hunt down even when looking for it with specialized tools:
> https://joemario.github.io/blog/2016/09/01/c2c-blog/

IMHO you're making a big deal out of something that should not be.
If the dm bits are that sensitive and cache line honed to perfection
already due to previous regressions in that area, then it might
not be a bad idea to have some compile checks for false cacheline
sharing between sensitive members, or spilling of a sub-struct
into multiple cachelines.

It's not like this was pushed behind your back. It's posted for
review. It's quite possible the net change is a win for dm. Let's
focus on getting it reviewed, rather than pontificate on what
could potentially go all wrong with this.

-- 
Jens Axboe
