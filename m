From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 07/12] dm: convert to
	bioset_init()/mempool_init()
Date: Wed, 30 May 2018 15:27:48 -0400
Message-ID: <20180530192747.GA6568@redhat.com>
References: <20180520222558.7053-1-kent.overstreet@gmail.com>
	<20180520222558.7053-8-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180520222558.7053-8-kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, colyli-l3A5Bk7waGM@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, neilb-IBi9RG/b67k@public.gmane.org, bacik-b10kYP2dOMg@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: linux-raid.ids

On Sun, May 20 2018 at  6:25pm -0400,
Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Signed-off-by: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/md/dm-bio-prison-v1.c      | 13 ++++---
>  drivers/md/dm-bio-prison-v2.c      | 13 ++++---
>  drivers/md/dm-cache-target.c       | 25 ++++++-------
>  drivers/md/dm-core.h               |  4 +-
>  drivers/md/dm-crypt.c              | 60 ++++++++++++++----------------
>  drivers/md/dm-integrity.c          | 15 ++++----
>  drivers/md/dm-io.c                 | 29 ++++++++-------
>  drivers/md/dm-kcopyd.c             | 22 ++++++-----
>  drivers/md/dm-log-userspace-base.c | 19 +++++-----
>  drivers/md/dm-region-hash.c        | 23 ++++++------
>  drivers/md/dm-rq.c                 |  2 +-
>  drivers/md/dm-snap.c               | 17 ++++-----
>  drivers/md/dm-thin.c               | 32 ++++++++--------
>  drivers/md/dm-verity-fec.c         | 55 +++++++++++++--------------
>  drivers/md/dm-verity-fec.h         |  8 ++--
>  drivers/md/dm-zoned-target.c       | 13 +++----
>  drivers/md/dm.c                    | 53 ++++++++++++--------------
>  17 files changed, 197 insertions(+), 206 deletions(-)

In general I think each of these driver patches in the series needs a
one-line summary in the description, e.g.:
Embed bioset and mempool_t to avoid pointer indirection in the fast IO path.

But that aside, on a code level, I had to double check bioset_exit() is
safe to call even if bioset_init() failed.  AFter confirming it is (and
double checking by chatting with Kent) I like how the code is simpler
(not having to check if the bioset is set before calling it).

Nice job Kent, like you said: mostly mechnical.  But even the changes
that weren't purely mechnical (e.g. passing r to ERR_PTR, rather than
using old hardcode) were fixed up nicely.

Acked-by: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
