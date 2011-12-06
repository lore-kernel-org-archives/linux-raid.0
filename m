From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Possible changes to bio cloning and some related stuff
Date: Mon, 5 Dec 2011 21:11:01 -0800
Message-ID: <20111206051101.GA8171@dhcp-172-18-216-138.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: neilb-l3A5Bk7waGM@public.gmane.org, tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

So, I finally got around to debugging various bcache on md issues, and I
ran into a rather sticky problem:

bio_alloc() can fail if nr_iovecs > BIO_MAX_PAGES. That itself is not a
problem, but then when a bio is cloned it's always done by cloning the
_entire_ original bio vec, from 0 to max_vecs - not the range from
bi_idx to bi_vcnt.

Basically, whenever bcache generates some io internally it uses a single
bio to describe the entire io - regardless of whether or not the bio
would be too big for the underlying device; it then splits the bio as
many times as need be when it's actually submitted.

This works beautifully for dumb drivers - I'm actually planning on
making my code generic and integrating it with the block layer so that
the same approach could be easily used by other code that generates
bios, it would allow a _lot_ of code to be deleted from the kernel.

But for stacking drivers, the mere existence of a bio with max_vecs >
BIO_MAX_PAGES breaks things, regardless of how many pages are actually
being used in this bio.

So, IMO __bio_clone(), bio_clone_mddev(), and whatever other code ought
to be changed to only copy bi_idx to bi_vcnt from the original bio -
it'd make it consistent with how bios are used elsewhere. Thoughts? The
actual patches should be trivial, it'll mostly just be a matter of
grepping around and finding everything, I think.
