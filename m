From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/13] convert block layer to
	bioset_init()/mempool_init()
Date: Mon, 21 May 2018 14:24:32 -0400
Message-ID: <20180521182427.GA20013@redhat.com>
References: <20180521143132.GB19194@redhat.com>
	<2bbeeb1a-8b99-b06a-eb9b-eb8523c16460@kernel.dk>
	<20180521144703.GA19303@redhat.com>
	<4b343aef-e11c-73ba-1d88-7e73ca838cad@kernel.dk>
	<20180521150439.GA19379@redhat.com>
	<61e30dcf-a01c-f47d-087a-12930caf9aef@kernel.dk>
	<20180521151817.GA19454@redhat.com>
	<d01a150a-7752-f6ce-78f2-17a65c1e6fa5@kernel.dk>
	<20180521160907.GA19553@redhat.com>
	<20180521173724.GG11495@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180521173724.GG11495@kmo-pixel>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, colyli-l3A5Bk7waGM@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, neilb-IBi9RG/b67k@public.gmane.org, bacik-b10kYP2dOMg@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: linux-raid.ids

On Mon, May 21 2018 at  1:37pm -0400,
Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 
> Uh, you came across as upset and paranoid to me too. Chalk it up to email? :)

Awesome.  See how easy it is to make someone with purely constructive
questions and feedback come off as upset and paranoid?

The tipping point occurs when bait is set with:
"It's not like <insert complete non sequitur>".
Then:
"Let's focus on getting it reviewed, rather than pontificate on what
could potentially go all wrong with this."

Message received: less pontificating, more doing!

And here I thought that focusing on what could go wrong (across all code
touched) was review.  But OK, I'm the one that made this all weird ;)

It is what it is at this point.

> I personally don't care, I have no horse in this race. This particular patch
> series wasn't my idea, Christoph wanted all these conversions done so
> bioset_create() could be deleted. If you want us to hold off on the dm patch for
> awhile until someone can get around to testing it or whatever (since I don't
> have tests for everything I pushed) that would be perfectly fine by me.

As I clarified already: this isn't about DM.

Every single data structure change in this series should be reviewed for
unforeseen alignment consequences.  Jens seemed to say that is
worthwhile.  Not sure if he'll do it or we divide it up.  If we divide
it up a temp topic branch should be published for others to inspect.

Could be alignment hasn't been a historic concern for a bunch of the
data structures changed in this series.. if so then all we can do is fix
up any obvious potential for false sharing.

Mike
