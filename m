From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/7] bcache: md conversion
Date: Mon, 14 May 2012 16:15:38 -0700
Message-ID: <20120514231537.GA17653@google.com>
References: <20120511194327.25770.79292.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120511194327.25770.79292.stgit-p8uTFz9XbKgaePuBGzJMJzMJUdESFZ8XQQ4Iyu8u01E@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: neilb-l3A5Bk7waGM@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

On Fri, May 11, 2012 at 12:46:11PM -0700, Dan Williams wrote:
> The consensus from LSF was that bcache need not invent a new interface
> when md and dm can both do the job.  As mentioned in patch 7 this series
> aims to be a minimal conversion.  Other refactoring items like
> deprecating register_lock for mddev->reconfig_mutex are deferred.

Awesome! I just applied the first 6 - the lockdep fix especially was
exactly what I'd been looking for. I need to dig in to the patch that
does the actual md conversion more and play with it... also need to
look at how refcounting works.

> This supports assembly of an already established cache array:
> 
> 	mdadm -A /dev/md/bcache /dev/sd[ab]
> 
> ...will create the /dev/md/bcache container and a subarray representing
> the cache volume.  "Flash-only", or backing-device only volumes were not
> tested.  "Create" support and hot-add/hot-remove come later.
> 
> Note:
> * When attempting to test with small loopback devices (100MB), assembly
>   soft locks in bcache_journal_read().  That hang went away with larger
>   devices, so there seems to be minimum component device size that needs
>   to be considered in the tooling.

Curious. I normally use a 256 mb cache for vm testing and I haven't seen
anything like that in ages, wonder what you found. Will investigate.
