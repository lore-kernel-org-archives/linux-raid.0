From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/13] convert block layer to
	bioset_init()/mempool_init()
Date: Mon, 21 May 2018 10:31:35 -0400
Message-ID: <20180521143132.GB19194@redhat.com>
References: <20180520222558.7053-1-kent.overstreet@gmail.com>
	<20180521140348.GA19069@redhat.com>
	<686d7df6-c7d1-48a6-b7ff-48dc8aff6a62@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <686d7df6-c7d1-48a6-b7ff-48dc8aff6a62-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, colyli-l3A5Bk7waGM@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, neilb-IBi9RG/b67k@public.gmane.org, bacik-b10kYP2dOMg@public.gmane.org, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: linux-raid.ids

On Mon, May 21 2018 at 10:19am -0400,
Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org> wrote:

> On 5/21/18 8:03 AM, Mike Snitzer wrote:
> > On Sun, May 20 2018 at  6:25pm -0400,
> > Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > 
> >> Jens - this series does the rest of the conversions that Christoph wanted, and
> >> drops bioset_create().
> >>
> >> Only lightly tested, but the changes are pretty mechanical. Based on your
> >> for-next tree.
> > 
> > By switching 'mempool_t *' to 'mempool_t' and 'bio_set *' to 'bio_set'
> > you've altered the alignment of members in data structures.  So I'll
> > need to audit all the data structures you've modified in DM.
> > 
> > Could we get the backstory on _why_ you're making this change?
> > Would go a long way to helping me appreciate why this is a good use of
> > anyone's time.
> 
> Yeah, it's in the first series, it gets rid of a pointer indirection.

"Allows mempools to be embedded in other structs, getting rid of a
pointer indirection from allocation fastpaths."

So this is about using contiguous memory or avoiding partial allocation
failure?  Or both?

Or more to it?  Just trying to fully appreciate the theory behind the
perceived associated benefit.

I do think the increased risk of these embedded bio_set and mempool_t
themselves crossing cachelines, or struct members that follow them doing
so, really detracts from these types of changes.

Thanks,
Mike
