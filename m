From: "NeilBrown" <neilb@suse.de>
Subject: Re: Kernel bug?
Date: Sun, 5 Apr 2009 08:40:04 +1000 (EST)
Message-ID: <b4d41c1ac8bd783b1a62b73b4efc4200.squirrel@neil.brown.name>
References: <49D777BC.4090009@tozzi.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49D777BC.4090009@tozzi.eu>
Sender: linux-raid-owner@vger.kernel.org
To: Gabriele Tozzi <gabriele@tozzi.eu>
Cc: linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-raid.ids

On Sun, April 5, 2009 1:07 am, Gabriele Tozzi wrote:
> Hello,
>
> I guess I've found a kernel bug: I get an oops when rebuilding a raid1
> array (/dev/md5) on an SMP system. The md5_resync process then hangs.

Yes, it appears you have found a bug.  Thanks for reporting it.

It looks like an alloc_page failed in r1buf_pool_alloc and when trying
to clean up we tried to free pages that had never been allocated.

The code in raid1.c assumes that newly allocated 'bios' have their
bvec initialised to NULLs, but that apparently changed recently
with commit d3f761104b097738932afcc310fbbbbfb007ef92

I'll post a patch after the weekend.

Thanks,

NeilBrown

